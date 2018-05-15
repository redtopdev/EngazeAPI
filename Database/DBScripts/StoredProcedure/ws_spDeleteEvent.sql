/***************************************
# Object:  StoredProcedure [dbo].[ws_spDeleteEvent] to insert Delete Event Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-09
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spDeleteEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spDeleteEvent'
   DROP PROCEDURE [dbo].ws_spDeleteEvent
END
GO

PRINT 'Creating PROCEDURE ws_spDeleteEvent'
GO

CREATE Procedure [dbo].ws_spDeleteEvent
(
	 @eventRequest XML
)
AS
BEGIN 

  DECLARE @eventId UNIQUEIDENTIFIER
    SET @eventId = (SELECT data.value('data(EventId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))

  DECLARE @RequestorId UNIQUEIDENTIFIER
    SET @RequestorId = (SELECT data.value('data(RequestorId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))

   IF EXISTS (SELECT 1 FROM [dbo].[ws_Event] WHERE [EventId]= @eventId AND [InitiatorId] = @RequestorId AND IsDeleted = 0)
   BEGIN

   UPDATE [dbo].[ws_Event]
   SET      [IsDeleted]=1,
            --[EventStateId]= (Select top 1 EventStateId from ws_EventStateLookup where EventState = 'DELETED'),
			--[TrackingStateId]= (Select top 1 TrackingStateId from ws_TrackingStateLookup where TrackingState = 'STOPPED'),
			[ModifiedBy]=@RequestorId,
			[ModifiedOn]=GETUTCDATE() 
   WHERE [EventId]= @eventId
	SELECT 1;
   END
   ELSE
   BEGIN
	SELECT 0;
   END
   
END

GO
PRINT 'PROCEDURE ws_spDeleteEvent created.'
GO


