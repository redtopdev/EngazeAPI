/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddEvent] to insert Event Info.    
CreatedBy : Atul Sagar
CreatedOn : 2015-04-04
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddEvent'
   DROP PROCEDURE [dbo].ws_spAddEvent
END
GO

PRINT 'Creating PROCEDURE ws_spAddEvent'
GO

CREATE Procedure [dbo].ws_spAddEvent
(
	@event XML
)
AS
BEGIN 
	DECLARE @startTime DateTime
	DECLARE @endTime DateTime
	DECLARE @duration INT
	DECLARE @isQuickEvent BIT
	DECLARE @isRecurring BIT
	DECLARE @recurrenceFrequencyTypeId int
	DECLARE @recurrenceCount int
	DECLARE @recurrenceFrequency int
	DECLARE @recurrenceDaysOfWeek NVARCHAR(50)
	DECLARE @recurrenceDaysOfWeekCount int
	DECLARE @eventTypeId int

	SET @startTime = (SELECT data.value('data(StartTime)[1]','DateTime') FROM @event.nodes('Event') AS ref(data))
	--SET @endTime = (SELECT data.value('data(EndTime)[1]','DateTime') FROM @event.nodes('Event') AS ref(data))
	SET @duration = (SELECT data.value('data(Duration)[1]','INT') FROM @event.nodes('Event') AS ref(data))
	SET @eventTypeId = (SELECT data.value('data(EventTypeId)[1]','INT') FROM @event.nodes('Event') AS ref(data))

	--SET @endTime = DATEADD(minute,@duration, @startTime)
	SET @isQuickEvent = (SELECT data.value('data(IsQuickEvent)[1]','BIT') FROM @event.nodes('Event') AS ref(data))
	SET @isRecurring = (SELECT data.value('data(IsRecurring)[1]','BIT') FROM @event.nodes('Event') AS ref(data))
	if(@isRecurring is null)
	BEGIN
		SET @isRecurring = 0
	END
	SET @recurrenceFrequencyTypeId = (SELECT data.value('data(RecurrenceFrequencyTypeId)[1]','INT') FROM @event.nodes('Event') AS ref(data))
	SET @recurrenceCount = (SELECT data.value('data(RecurrenceCount)[1]','INT') FROM @event.nodes('Event') AS ref(data))
	SET @recurrenceFrequency = (SELECT data.value('data(RecurrenceFrequency)[1]','INT') FROM @event.nodes('Event') AS ref(data))
	SET @recurrenceDaysOfWeek = (SELECT data.value('data(RecurrenceDaysOfWeek)[1]','NVARCHAR(50)') FROM @event.nodes('Event') AS ref(data))
	--print 'days of week'
	--print @recurrenceDaysOfWeek
	
	--SELECT @recurrenceDaysOfWeekCount = LEN(@recurrenceDaysOfWeek)- LEN(REPLACE(@recurrenceDaysOfWeek,',',''));
	SELECT @recurrenceDaysOfWeekCount =  LEN(REPLACE(@recurrenceDaysOfWeek,',',''));
	
	if(@recurrenceDaysOfWeekCount=0)
	BEGIN
		SET @recurrenceDaysOfWeekCount=1; 
	END
	
	--print 'days of week count'
	--print @recurrenceDaysOfWeekCount	

	IF @startTime < GETUTCDATE() OR @endTime < GETUTCDATE() OR @isQuickEvent = 1
	BEGIN
		SET @startTime = GETUTCDATE()	
	END
	
	SET @endTime = DATEADD(minute,@duration, @startTime)
	
	IF (@isRecurring = 1)
	BEGIN
		IF ((@recurrenceFrequency is null) OR (@recurrenceFrequency=0))
		BEGIN
			SET @recurrenceFrequency = 1
		END	
	
	   If (@recurrenceFrequencyTypeId = 1)  --RecurrenceFrequencyType is Daily
	   BEGIN		
			SET @endTime = DATEADD(day, @recurrenceFrequency*(@recurrenceCount-1) , @endTime) 
	   END
	   If (@RecurrenceFrequencyTypeId = 2)  --RecurrenceFrequencyType is Weekly
	   BEGIN
			
			--SELECT LEFT(@str,CHARINDEX(',',@str)-1) 			
			
			DECLARE @weeksCount int
			DECLARE @additionalDaysCount int
			SET @weeksCount = (@recurrenceCount/@recurrenceDaysOfWeekCount);
			SET @additionalDaysCount = (@recurrenceCount % @recurrenceDaysOfWeekCount)+1;
						
			DECLARE @ctr int
			DECLARE @tempStr NVARCHAR(50)
			DECLARE @val NVARCHAR(5)

			SET @ctr = 0
			SET @tempStr = @recurrenceDaysOfWeek

			--WHILE (@ctr < (@recurrenceCount % @recurrenceDaysOfWeekCount))
			--BEGIN
			--	SET @additionalDaysCount = SUBSTRING(@tempStr,1, Charindex(',',@tempStr)-1)
			--	SET @tempStr = Substring(@tempStr,Charindex(',',@tempStr)+1,len(@tempStr))
			--	SET @ctr = @ctr + 1
				
			--END									
						
	      	SET @endTime = DATEADD(WEEK, @weeksCount*@recurrenceFrequency , @endTime)   
	      	--if(@additionalDaysCount > 0)
	      	--BEGIN
	      	--	SET @endTime = DATEADD(DAY, @additionalDaysCount-(DATEPART(dw,@endTime)) , @endTime)   
	      	--END
	      	
	      	--print 'data'
	      	--print @recurrenceDaysOfWeekCount
	      	--print 'start time'
	      	--print @startTime
	      	--print 'end time'
	      	--print @endTime
	      	--print 'weeks count'
	      	--print @weeksCount
	      	--print 'additional days'
	      	--print @additionalDaysCount
	      	
	      	--return;
	   END		
	   If (@RecurrenceFrequencyTypeId = 3) --RecurrenceFrequencyType is Monthly
	   BEGIN
	      	SET @endTime = DATEADD(month, @recurrenceFrequency*(@recurrenceCount-1) , @endTime)    
	   END		
	END
	

    DECLARE @eventId UNIQUEIDENTIFIER
    SET @eventId = NEWID()    
    DECLARE @userId UNIQUEIDENTIFIER
    SET @userId = (SELECT data.value('data(InitiatorId)[1]','uniqueidentifier') FROM @event.nodes('Event') AS ref(data))
    --select    @eventId
    --select    @userId 
   BEGIN TRY
   BEGIN TRAN    
	INSERT INTO [dbo].[ws_Event]
           (
   			[EventId],[NAME],[EventTypeId],[Description],[StartTime],[EndTime],[Duration],[InitiatorId],[EventStateId],[TrackingStateId]
           ,[TrackingStopTime],[DestinationLatitude],[DestinationLongitude],[DestinationName],[DestinationAddress], [IsTrackingRequired]
           ,[ReminderTypeId],[ReminderOffset],[TrackingStartOffset],[IsDeleted],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsQuickEvent],
           [IsRecurring],[RecurrenceFrequencyTypeId],[RecurrenceCount],[RecurrenceFrequency],[RecurrenceDaysOfWeek]
           )
     SELECT
			@eventId,
			data.value('data(Name)[1]', 'VARCHAR(100)'),
			data.value('data(EventTypeId)[1]', 'INT') ,
			data.value('data(Description)[1]','NVARCHAR(MAX)') ,
			@startTime ,
			@endTime,
			data.value('data(Duration)[1]','INT') ,
			data.value('data(InitiatorId)[1]','UNIQUEIDENTIFIER') ,
			data.value('data(EventStateId)[1]','INT') ,
			data.value('data(TrackingStateId)[1]','INT') ,
			NULL ,
			CASE WHEN (data.value('data(DestinationLatitude)[1]','NVARCHAR(100)') IS NOT NULL AND data.value('data(DestinationLatitude)[1]','NVARCHAR(100)') <> '')
			THEN
				data.value('data(DestinationLatitude)[1]','DECIMAL(9,6)')
			ELSE
			   NULL
			END
			,
			CASE WHEN (data.value('data(DestinationLongitude)[1]','NVARCHAR(100)') IS NOT NULL AND data.value('data(DestinationLongitude)[1]','NVARCHAR(100)') <> '')
			THEN
				data.value('data(DestinationLongitude)[1]','DECIMAL(9,6)')
			ELSE
			   NULL
			END
			,
			data.value('data(DestinationName)[1]', 'NVARCHAR(100)'),
			data.value('data(DestinationAddress)[1]', 'NVARCHAR(500)'),
			data.value('data(IsTrackingRequired)[1]', 'BIT'),	
			data.value('data(ReminderTypeId)[1]', 'INT'),
			data.value('data(ReminderOffset)[1]', 'INT') ,
			data.value('data(TrackingStartOffset )[1]', 'INT'),
			0,
			GETUTCDATE(),
			NULL,
			NULL,
			@isQuickEvent,
			@isRecurring,
			@recurrenceFrequencyTypeId,
			@recurrenceCount,
			@recurrenceFrequency, 
			@recurrenceDaysOfWeek
   FROM @event.nodes('Event') AS ref(data)
   
   print 'event created'
   
   DECLARE @isUserLocationShared BIT
   SET @isUserLocationShared = 1
   IF @eventTypeId = 200  --For Normal(1-6) /Track me(100) @isUserLocationShared = 1, For TrackBuddy(200) @isUserLocationShared = 0
   BEGIN 
	SET @isUserLocationShared = 0
   END
   --Adding Initiator of the event as default participant
   INSERT INTO [dbo].[ws_UserEvent]
           (
			[EventId],[UserId],[EventAcceptanceStateId],[IsTrackingAccepted],[TrackingStartTime],[TrackingEndTime],
            [TrackingEndReason],[IsTrackingActive],[UserEventEndTime],[IsDeleted],[CreatedOn],[IsUserLocationShared]
           )
    SELECT @eventId, @userId, 1, 1, NULL, NULL, NULL, 0,  NULL , 0, GETUTCDATE(), @isUserLocationShared
   
   print 'initiator inserted'
	--Insert other participants
        --Update eventid field with new eventid		
		SET @event.modify('
		  replace value of (/Event/EventId[1]/text())[1]
		  with  sql:variable("@eventId")
		');				
	--DECLARE @str NVARCHAR(MAX)
	--SET @str = CONVERT(nvarchar(max),@event)
	--SET @event = convert(XML, REPLACE(@str,'$eventId$',@eventId ))
	
	--PRINT CONVERT(nvarchar(max),@event)
	EXEC ws_spSyncEventParticipants @event

	  COMMIT TRAN
	  
	  print 'Event Created'
	SELECT @eventId  AS 'EventId'		 
  
   END TRY
   BEGIN CATCH
        PRINT 'Error occurred'
        PRINT ERROR_MESSAGE()
 		ROLLBACK TRAN
 END CATCH
   
   
END

GO
PRINT 'PROCEDURE ws_spAddEvent created.'
GO


