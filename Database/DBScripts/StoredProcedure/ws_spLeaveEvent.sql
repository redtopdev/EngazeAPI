/***************************************
# Object:  StoredProcedure [dbo].[ws_spLeaveEvent] for Participant to Leave an Event .    
CreatedBy : Shyam
CreatedOn : 2015-12-15
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spLeaveEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spLeaveEvent'
   DROP PROCEDURE [dbo].ws_spLeaveEvent
END
GO

PRINT 'Creating PROCEDURE ws_spLeaveEvent'
GO

CREATE Procedure [dbo].ws_spLeaveEvent
(
	@eventRequest XML
)
AS
BEGIN 
    DECLARE @eventId UNIQUEIDENTIFIER
    DECLARE @requestorId UNIQUEIDENTIFIER
    
    SET @eventId = (SELECT data.value('data(EventId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))		
    SET @requestorId = (SELECT data.value('data(RequestorId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))		
	
	IF EXISTS(SELECT 1 FROM [dbo].[ws_UserEvent] ue INNER JOIN [dbo].[ws_Event] e on e.EventId = ue.EventId  
	WHERE ue.EventId = @eventId AND ue.UserId = @requestorId AND e.EventStateId <> 3 AND e.InitiatorId <> @requestorId 	AND e.IsDeleted = 0)
	BEGIN
	--Update Duration and End Time
	 UPDATE [dbo].[ws_UserEvent]
	 SET
		[ModifiedOn]=GETUTCDATE(),
		[UserEventStateId] = 3,
		[EventAcceptanceStateId]=0,
		[TrackingEndTime]=GETUTCDATE()
     FROM @eventRequest.nodes('EventRequest') AS ref(data)   
     WHERE [EventId] = @eventId AND [UserId] = @requestorId	 AND IsDeleted = 0
	
    SELECT 1;
    RETURN;	 
	END	  
    --print 'Event End Time extended'
	
	SELECT 0;
   
END

GO
PRINT 'PROCEDURE ws_spLeaveEvent created.'
GO


