/***************************************
# Object:  StoredProcedure [dbo].[ws_spEndEvent] to End Event.    
CreatedBy : Shyam
CreatedOn : 2015-12-15
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spEndEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spEndEvent'
   DROP PROCEDURE [dbo].ws_spEndEvent
END
GO

PRINT 'Creating PROCEDURE ws_spEndEvent'
GO

CREATE Procedure [dbo].ws_spEndEvent
(
	@eventRequest XML
)
AS
BEGIN 
    DECLARE @eventId UNIQUEIDENTIFIER
    DECLARE @requestorId UNIQUEIDENTIFIER
    
    SET @eventId = (SELECT data.value('data(EventId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))		
    SET @requestorId = (SELECT data.value('data(RequestorId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))		
	
	IF EXISTS(SELECT 1 FROM [dbo].[ws_Event] WHERE [EventId] = @eventId AND [InitiatorId] = @requestorId AND [EventStateId] <> 3 AND IsDeleted = 0 )
	BEGIN
		
	--Update Duration and End Time
	 UPDATE [dbo].[ws_Event]
	 SET
		[EndTime]=GETUTCDATE(),
		[ModifiedBy]=data.value('data(RequestorId)[1]', 'uniqueidentifier'),
		[ModifiedOn]=GETUTCDATE(),
		[EventStateId] = 3,
		[TrackingStateId] = 3		  
    FROM @eventRequest.nodes('EventRequest') AS ref(data)   
    WHERE [EventId] = @eventId AND [InitiatorId] = @requestorId AND IsDeleted = 0
		  
  	SELECT 1;
  	RETURN;	 
	END	  
    --print 'Event End Time extended'
	
	SELECT 0;
   
END

GO
PRINT 'PROCEDURE ws_spEndEvent created.'
GO


