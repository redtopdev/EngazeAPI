/***************************************
# Object:  StoredProcedure [dbo].[ws_spUpdateUserEvent] to Update UserEvent Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUpdateUserEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUpdateUserEvent'
   DROP PROCEDURE [dbo].ws_spUpdateUserEvent
END
GO

PRINT 'Creating PROCEDURE ws_spUpdateUserEvent'
GO

CREATE Procedure [dbo].ws_spUpdateUserEvent
(
	@userEvent XML
)
AS
BEGIN 		

    DECLARE @UserId uniqueidentifier
    DECLARE @EventId uniqueidentifier
    
    SET @UserId = (SELECT data.value('data(UserId)[1]', 'uniqueidentifier')  FROM @userEvent.nodes('UserEvent') AS ref(data))
    SET @EventId = (SELECT data.value('data(EventId)[1]', 'uniqueidentifier')  FROM @userEvent.nodes('UserEvent') AS ref(data))
    
	UPDATE [dbo].[ws_UserEvent]
    SET
		IsEventAccepted = data.value('data(IsEventAccepted)[1]','bit') ,
		IsTrackingAccepted = data.value('data(IsTrackingAccepted)[1]','bit'),
		TrackingStartTime = data.value('data(TrackingStartTime)[1]','datetime') ,
		TrackingEndTime = data.value('data(TrackingEndTime)[1]','datetime') ,
		TrackingEndReason = data.value('data(TrackingEndReason)[1]','int') ,
		IsTrackingActive = data.value('data(IsTrackingActive)[1]','bit') ,
		IsEventActive = data.value('data(IsEventActive)[1]','bit') ,
		UserEventEndTime = data.value('data(UserEventEndTime)[1]', 'datetime') 
		FROM @userEvent.nodes('UserEvent') AS ref(data)
   WHERE UserId = @UserId AND EventId = @EventId   
   
END

GO
PRINT 'PROCEDURE ws_spUpdateUserEvent created.'
GO


