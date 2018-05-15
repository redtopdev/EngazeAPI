/***************************************
# Object:  StoredProcedure [dbo].[ws_spExtendEvent] to extend Event end time.    
CreatedBy : Shyam
CreatedOn : 2015-12-07
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spExtendEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spExtendEvent'
   DROP PROCEDURE [dbo].ws_spExtendEvent
END
GO

PRINT 'Creating PROCEDURE ws_spExtendEvent'
GO

CREATE Procedure [dbo].ws_spExtendEvent
(
	@eventRequest XML
)
AS
BEGIN 
	DECLARE @endTime DateTime
	DECLARE @endBufferTime DateTime
    DECLARE @eventId UNIQUEIDENTIFIER
    DECLARE @duration INT
    DECLARE @extendDuration INT
    DECLARE @requestorId UNIQUEIDENTIFIER
 
    SET @eventId = (SELECT data.value('data(EventId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))		
	SET @extendDuration = (SELECT data.value('data(ExtendEventDuration)[1]','INT') FROM @eventRequest.nodes('EventRequest') AS ref(data))
	SELECT @endTime = EndTime,@duration=Duration  FROM ws_Event where EventId = @eventId
    SET @requestorId = (SELECT data.value('data(RequestorId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))		
	
	--SET @endBufferTime = DATEADD(minute,60, @endTime)
	SET @endTime = DATEADD(minute,@extendDuration, @endTime)
	SET @duration = @duration + @extendDuration
	
	
	IF EXISTS (SELECT 1 FROM [dbo].[ws_Event] WHERE [EventId]= @eventId AND [InitiatorId] = @requestorId AND @endTime > GETUTCDATE() AND IsDeleted = 0)
	BEGIN
	
	--Update Duration and End Time
	 UPDATE [dbo].[ws_Event]
	 SET
		[EndTime]=@endTime,
		[EventStateId]=2,
		[TrackingStateId]=2,
		[Duration]=@duration,
		[ModifiedBy]=data.value('data(RequestorId )[1]', 'uniqueidentifier'),
		[ModifiedOn]=GETUTCDATE()  
    FROM @eventRequest.nodes('EventRequest') AS ref(data)   
    WHERE [EventId]= @eventId AND [InitiatorId] = @requestorId	AND IsDeleted = 0
	   
	--Update the state of the event   
	EXEC ws_spUpdateStatesForEvent @eventId;		
		  
    --print 'Event End Time extended'
    SELECT 1;
    RETURN;
	END
	
	--print 'Event End Time not extended'
	SELECT 0;	
   
END

GO
PRINT 'PROCEDURE ws_spExtendEvent created.'
GO


