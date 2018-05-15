/***************************************
# Object:  StoredProcedure [dbo].[ws_spRespondToEventInvite] User accepting  or rejetcing Event and Tracking by User.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spRespondToEventInvite]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spRespondToEventInvite'
   DROP PROCEDURE [dbo].ws_spRespondToEventInvite
END
GO

PRINT 'Creating PROCEDURE ws_spRespondToEventInvite'
GO

CREATE Procedure [dbo].ws_spRespondToEventInvite
(
	@eventRequest XML
)
AS
BEGIN 		
    DECLARE @RequestorId nvarchar(MAX)
    DECLARE @EventId nvarchar(MAX)
    DECLARE @EventAcceptanceStateId INT
    DECLARE @IsTrackingAccepted BIT
    
    SET @RequestorId = (SELECT data.value('data(RequestorId)[1]', 'nvarchar(MAX)')  FROM @eventRequest.nodes('EventRequest') AS ref(data))
    SET @EventId = (SELECT data.value('data(EventId)[1]', 'nvarchar(MAX)')  FROM @eventRequest.nodes('EventRequest') AS ref(data))
    SET @EventAcceptanceStateId = (SELECT data.value('data(EventAcceptanceStateId)[1]', 'int')  FROM @eventRequest.nodes('EventRequest') AS ref(data))
    SET @IsTrackingAccepted = (SELECT data.value('data(TrackingAccepted)[1]', 'bit')  FROM @eventRequest.nodes('EventRequest') AS ref(data))
    
    IF @EventAcceptanceStateId = -1
    BEGIN
		SET @IsTrackingAccepted = 0
    END
    
	IF EXISTS(SELECT 1 FROM [dbo].[ws_Event] WHERE [EventId] = @EventId  AND [EventStateId] <> 3 AND IsDeleted = 0 )
	BEGIN
		    
		UPDATE ue
		SET
			ue.EventAcceptanceStateId = @EventAcceptanceStateId ,
			ue.IsTrackingAccepted = @IsTrackingAccepted,
			ue.ModifiedOn = GETUTCDATE()
		FROM [dbo].[ws_UserEvent] ue
		inner join [dbo].[ws_Event] ev on ev.EventId = ue.EventId
		WHERE ue.UserId = @RequestorId AND ue.EventId = @EventId AND ue.IsDeleted = 0 AND ev.IsDeleted = 0   
		
		SELECT 1;
	END
	ELSE
	BEGIN
		SELECT 0;
	END   
END

GO
PRINT 'PROCEDURE ws_spRespondToEventInvite created.'
GO


