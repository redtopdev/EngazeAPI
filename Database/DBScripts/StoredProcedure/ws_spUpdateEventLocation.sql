/***************************************
# Object:  StoredProcedure [dbo].[ws_spUpdateEventLocation] to update Event location.    
CreatedBy : Shyam
CreatedOn : 2016-01-16
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUpdateEventLocation]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUpdateEventLocation'
   DROP PROCEDURE [dbo].ws_spUpdateEventLocation
END
GO

PRINT 'Creating PROCEDURE ws_spUpdateEventLocation'
GO

CREATE Procedure [dbo].ws_spUpdateEventLocation
(
	@eventRequest XML
)
AS
BEGIN 
    DECLARE @eventId UNIQUEIDENTIFIER
    DECLARE @requestorId UNIQUEIDENTIFIER
 
    SET @eventId = (SELECT data.value('data(EventId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))		
    SET @requestorId = (SELECT data.value('data(RequestorId)[1]','uniqueidentifier') FROM @eventRequest.nodes('EventRequest') AS ref(data))		
		
	
	IF EXISTS (SELECT 1 FROM [dbo].[ws_Event] WHERE [EventId]= @eventId AND [InitiatorId] = @requestorId AND EndTime > GETUTCDATE() AND IsDeleted = 0)
	BEGIN
	
	--Update Duration and End Time
	 UPDATE [dbo].[ws_Event]
	 SET
		[DestinationLatitude] = 
							CASE WHEN (data.value('data(DestinationLatitude)[1]','NVARCHAR(100)') IS NOT NULL AND data.value('data(DestinationLatitude)[1]','NVARCHAR(100)') <> '')
							THEN data.value('data(DestinationLatitude)[1]','DECIMAL(9,6)')
							ELSE
							   NULL
							END
		,			
			[DestinationLongitude]= 
							CASE WHEN (data.value('data(DestinationLongitude)[1]','NVARCHAR(100)') IS NOT NULL AND data.value('data(DestinationLongitude)[1]','NVARCHAR(100)') <> '')
							THEN 
							   data.value('data(DestinationLongitude)[1]','DECIMAL(9,6)')
							ELSE
							   NULL
							END
		,
		[DestinationName]=data.value('data(DestinationName)[1]', 'VARCHAR(100)') ,
		[DestinationAddress]=data.value('data(DestinationAddress)[1]', 'NVARCHAR(500)') ,		
		[ModifiedBy]=data.value('data(RequestorId )[1]', 'uniqueidentifier'),
		[ModifiedOn]=GETUTCDATE()  
    FROM @eventRequest.nodes('EventRequest') AS ref(data)   
    WHERE [EventId]= @eventId AND [InitiatorId] = @requestorId	AND IsDeleted = 0
	   
	--Update the state of the event   
	EXEC ws_spUpdateStatesForEvent @eventId;		
		  
    --print 'Event location changed'
    SELECT 1;
    RETURN;
	END
	
	--print 'Event location not changed'
	SELECT 0;	
   
END

GO
PRINT 'PROCEDURE ws_spUpdateEventLocation created.'
GO


