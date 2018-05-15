/***************************************
# Object:  StoredProcedure [dbo].[ws_spUpdateEvent] to insert Update Event Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-09
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUpdateEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUpdateEvent'
   DROP PROCEDURE [dbo].ws_spUpdateEvent
END
GO

PRINT 'Creating PROCEDURE ws_spUpdateEvent'
GO

CREATE Procedure [dbo].ws_spUpdateEvent
(
	@event XML
)
AS
BEGIN 
	DECLARE @startTime DateTime
	DECLARE @endTime DateTime
	DECLARE @duration INT
    DECLARE @eventId UNIQUEIDENTIFIER
    DECLARE @requestorId UNIQUEIDENTIFIER
    DECLARE @updateParticipantsOnly BIT
    
    SET @eventId = (SELECT data.value('data(EventId)[1]','uniqueidentifier') FROM @event.nodes('Event') AS ref(data))
    SET @requestorId = (SELECT data.value('data(RequestorId)[1]','uniqueidentifier') FROM @event.nodes('Event') AS ref(data))
    
	SET @updateParticipantsOnly = (SELECT data.value('data(UpdateParticipantsOnly)[1]','BIT') FROM @event.nodes('Event') AS ref(data))
		
	IF EXISTS(SELECT 1 FROM ws_Event WHERE EventId = @eventId AND InitiatorId = @requestorId) --only initiator is allowed to edit.
	BEGIN
		
		IF @updateParticipantsOnly = 0
		BEGIN 	
			SET @startTime = (SELECT data.value('data(StartTime)[1]','DateTime') FROM @event.nodes('Event') AS ref(data))
			--SET @endTime = (SELECT data.value('data(EndTime)[1]','DateTime') FROM @event.nodes('Event') AS ref(data))
			SET @duration = (SELECT data.value('data(Duration)[1]','INT') FROM @event.nodes('Event') AS ref(data))
			
			
			IF @startTime < GETUTCDATE() 
			BEGIN
				SET @startTime = GETUTCDATE()
			END
			SET @endTime = DATEADD(minute,@duration, @startTime)

			BEGIN TRY
			
				BEGIN TRAN    
				UPDATE [dbo].[ws_Event]
				 SET
	 				[Name] = data.value('data(Name)[1]', 'VARCHAR(200)'),
					[EventTypeId] = data.value('data(EventTypeId)[1]', 'int') ,
					[Description] = data.value('data(Description)[1]','nvarchar(max)') ,
					[StartTime]=@startTime ,
					[EndTime]=@endTime,
					[Duration]=@duration ,			
					[EventStateId]=data.value('data(EventStateId)[1]','int') ,
					[TrackingStateId]=data.value('data(TrackingStateId)[1]','int') ,
					[TrackingStopTime]=NULL ,			
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
					[ReminderTypeId] = data.value('data(ReminderTypeId)[1]', 'INT'),
					[ReminderOffset]=data.value('data(ReminderOffset)[1]', 'INT') ,
					[IsTrackingRequired]=data.value('data(IsTrackingRequired)[1]', 'BIT') ,
					[TrackingStartOffset]=data.value('data(TrackingStartOffset )[1]', 'INT'), 
					[ModifiedBy]=data.value('data(RequestorId )[1]', 'uniqueidentifier'),
					[ModifiedOn]=GETUTCDATE()  
			   FROM @event.nodes('Event') AS ref(data)   
			   WHERE [EventId]= @eventId
		   
		   print 'event updated . starting to update participants'
   			--PRINT CONVERT(nvarchar(max),@event)
			EXEC ws_spSyncEventParticipants @event
			
		   COMMIT TRAN
		   		  
		   --print 'Event updated'
		   SELECT 1;  
	   END TRY
	   BEGIN CATCH
			PRINT 'Error occurred'
 			ROLLBACK TRAN
 			SELECT 0;
	   END CATCH
	 
	 END
	 ELSE
	 BEGIN


		BEGIN TRY
			
				BEGIN TRAN    
					UPDATE [dbo].[ws_Event]
					SET [ModifiedBy]=data.value('data(RequestorId )[1]', 'uniqueidentifier'),
					[ModifiedOn]=GETUTCDATE()  
					FROM @event.nodes('Event') AS ref(data)   
					WHERE [EventId]= @eventId

					print 'event updated . starting to update participants'
					--PRINT CONVERT(nvarchar(max),@event)
					EXEC ws_spSyncEventParticipants @event		
	 			COMMIT TRAN
		   		  
		   --print 'Event updated'
		   SELECT 1;  
		END TRY
	   BEGIN CATCH
			PRINT 'Error occurred'
 			ROLLBACK TRAN
 			SELECT 0;
	   END CATCH

	  
	 END  
	   
	END
	ELSE
	BEGIN
		SELECT 0; --only initiator is allowed to edit.
	END
   
END

GO
PRINT 'PROCEDURE ws_spUpdateEvent created.'
GO


