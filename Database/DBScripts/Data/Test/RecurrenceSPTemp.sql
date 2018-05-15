--select * from ws_EventTypeLookup

--SELECT DATEDIFF(DAY, '2016-03-20 00:50:34.097', GETUTCDATE())

--SELECT GETUTCDATE()

DECLARE @duration int
DECLARE @startTime datetime
DECLARE @diff int
DECLARE @recurrenceCount int
DECLARE @nextStartTime datetime
DECLARE @endTime datetime
DECLARE @tempTime datetime
DECLARE @finalEndTime datetime

SET @duration = 60
SET @recurrenceCount = 5
set @startTime = '2016-03-12 15:43:10.800'
SET @endTime = DATEADD(minute,@duration, @startTime)



SET @tempTime = DATEADD(DAY, 1,  @endTime)
SET @finalEndTime = DATEADD(DAY, @recurrenceCount,  @endTime)


		IF(@endTime < GETUTCDATE() AND @endTime < @finalEndTime)		 
	      BEGIN
	      SET @nextStartTime = DATEADD(day,(1+(@diff/24)) , @startTime) 
	      END
	      
	      PRINT getutcdate()
	      PRINT @endTime
	      PRINT @diff
	      PRINT @nextStartTime
	      
	      
	      
	      select GETUTCDATE()
	      select datediff(week, GETUTCDATE(),'Mar 22 2016  4:43PM'  )
	      
	      SELECT DATEADD(month,1, 'Feb 21 2016  4:43PM')