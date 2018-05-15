/***************************************
# Object:  StoredProcedure [dbo].[ws_spSyncEventParticipants] to synchronize participant list for event.    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spSyncEventParticipants]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spSyncEventParticipants'
   DROP PROCEDURE [dbo].ws_spSyncEventParticipants
END
GO

PRINT 'Creating PROCEDURE ws_spSyncEventParticipants'
GO

CREATE Procedure [dbo].ws_spSyncEventParticipants
(
	@event XML
)
AS
BEGIN 		
	
	DECLARE @eventId UNIQUEIDENTIFIER
	DECLARE @eventIdStr nvarchar(100)
	DECLARE @participantUpdateAction int --1->Sync, 2->Add, 3->Remove
	DECLARE @eventTypeId int
	
	--SET @eventId = (SELECT data.value('data(NewEventIdHolder)[1]', 'nvarchar(max)')  FROM @event.nodes('Event') AS ref(data))
	SET @eventId = (SELECT data.value('data(EventId)[1]', 'UNIQUEIDENTIFIER')  FROM @event.nodes('Event') AS ref(data))
	SET @eventIdStr = CAST(@eventId AS NVARCHAR(100))
	SET @eventTypeId = (SELECT data.value('data(EventTypeId)[1]','INT') FROM @event.nodes('Event') AS ref(data))
	
	SET @participantUpdateAction = (SELECT data.value('data(ParticipantUpdateAction)[1]', 'int')  FROM @event.nodes('Event') AS ref(data))
	IF @participantUpdateAction NOT IN (1,2,3)
	BEGIN
	 SET @participantUpdateAction = 1;
	END
	
	IF ( @eventIdStr is null  OR @eventIdStr = '')
	BEGIN	
		return 'Event Id Missing the input data for SyncEventParticipants.'
	END
	
	--PRINT '@eventId'+ @eventId
	
	--DECLARE @RequestorId UNIQUEIDENTIFIER
	--SET @RequestorId = (SELECT data.value('data(RequestorId)[1]', 'uniqueidentifier')  FROM @event.nodes('Event') AS ref(data))

    -- first insert all records to temp table
	SELECT DISTINCT @eventId as EventId,
	T.Item.value('data(UserId)[1]','uniqueidentifier') as UserId,
--	ISNULL(T.Item.value('data(EventAcceptanceStateId)[1]','int'),0)  as EventAcceptanceStateId,
--	ISNULL(T.Item.value('data(IsTrackingAccepted)[1]','bit'),0) as IsTrackingAccepted,
--	T.Item.value('data(TrackingStartTime)[1]','datetime') as TrackingStartTime,
--	T.Item.value('data(TrackingEndTime)[1]','datetime') as TrackingEndTime,
--	T.Item.value('data(TrackingEndReason)[1]','int') as TrackingEndReason,
--	ISNULL(T.Item.value('data(IsTrackingActive)[1]','bit'),0) as IsTrackingActive,
--	T.Item.value('data(UserEventEndTime)[1]', 'datetime') as UserEventEndTime,	
    T.Item.value('data(IsUserLocationShared)[1]', 'BIT') as IsUserLocationShared,	
	0 as IsDeleted
	INTO #tmpUserEvent
	FROM @event.nodes('Event/UserList/EventParticipant')  T(Item) 

	IF @eventTypeId NOT IN (2,3)
	BEGIN
		UPDATE #tmpUserEvent SET IsUserLocationShared = 1
	END
	
	IF @participantUpdateAction = 1
	BEGIN
	--delete additional users in ws_UserEvent table if action is sync 
		UPDATE [dbo].[ws_UserEvent]
		SET IsDeleted = 1, ModifiedOn=GETUTCDATE()
		WHERE EventId = @eventId AND IsDeleted = 0
		AND UserId NOT IN (
		SELECT  UserId FROM #tmpUserEvent 	
		UNION SELECT InitiatorId from ws_Event WHERE EventId = @eventId)	
	END	
	ELSE IF @participantUpdateAction = 3
	BEGIN
	--delete given users if action is delete 
		UPDATE [dbo].[ws_UserEvent]
		SET IsDeleted = 1, ModifiedOn=GETUTCDATE()
		WHERE EventId = @eventId AND IsDeleted = 0
		AND UserId IN (
		SELECT  UserId FROM #tmpUserEvent)
		AND UserId NOT IN (SELECT InitiatorId from ws_Event WHERE EventId = @eventId)	
	END
		
	--Updating user event may not be required
	--UPDATE [dbo].[ws_UserEvent]
	--SET IsAdmin = T.Item.value('IsAdmin[1]', 'bit') ,
	--ModifiedBy = @ModifiedBy,
	--ModifiedOn = GETDATE()
	--WHERE UserGroupId = @eventId 
	--AND UserId = T.Item.value('UserId[1]', 'uniqueidentifier') 	
	--FROM @event.nodes('UserGroup/UserList/UserGroupMember')  T(Item) 	
	
	IF @participantUpdateAction in (1,2)
	BEGIN	
		--Write code to insert new users
		INSERT INTO [dbo].[ws_UserEvent]
		(EventId, UserId, EventAcceptanceStateId, IsDeleted, CreatedOn, IsUserLocationShared)
		SELECT EventId,
		UserId,
		-1 ,
	--	IsTrackingAccepted,
	--	TrackingStartTime,
	--	TrackingEndTime,
	--	TrackingEndReason,
	--	IsTrackingActive,
	--	UserEventEndTime,	
		0,
		GETUTCDATE(),
		IsUserLocationShared
		FROM #tmpUserEvent
		WHERE  UserId NOT IN (SELECT UserId FROM [dbo].[ws_UserEvent] 
								WHERE EventId = @eventId AND IsDeleted = 0)
	     
	END
	           
END

GO
PRINT 'PROCEDURE ws_spSyncEventParticipants created.'
GO


