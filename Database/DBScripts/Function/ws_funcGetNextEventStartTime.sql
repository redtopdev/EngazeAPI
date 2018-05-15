
/****** Object:  UserDefinedFunction [dbo].[ws_funcGetNextEventStartTime]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_funcGetNextEventStartTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
print 'dropping function [ws_funcGetNextEventStartTime] '
DROP FUNCTION [dbo].[ws_funcGetNextEventStartTime]
END
GO
/****** Object:  UserDefinedFunction [dbo].[ws_funcGetNextEventStartTime]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

print 'creating function [ws_funcGetNextEventStartTime]'
GO
 
-- ===============================================================================    
-- Author:  Shyam 
-- Create date: Mar 19th 2016    
-- Description: Returns the next meeting sart time for recurring meetings
    
-- ===============================================================================    
CREATE FUNCTION ws_funcGetNextEventStartTime

   (@startTime datetime, 
    @duration datetime, 
    @isRecurring bit,
	@recurrenceFrequencyTypeId int,
	@recurrenceCount int
	)
RETURNS datetime
AS
BEGIN
   DECLARE @nextStartTime datetime
   DECLARE @nempStartTime datetime
   DECLARE @diff datetime
   DECLARE @endTime datetime
   DECLARE @divisor int
      
   SET @nextStartTime = @startTime
   SET @endTime = DATEADD(minute,@duration, @startTime)
   
   IF(@isRecurring = 1)
   BEGIN   	
	   CASE WHEN @recurrenceFrequencyTypeId = 1  --RecurrenceFrequencyType is Days
	   THEN BEGIN		
			SET @diff = DATEDIFF(HOUR, @endTime, GETUTCDATE())
			SET @divisor = 24			      
			IF(@endTime < GETUTCDATE() AND @diff < (@recurrenceCount*@divisor))		 
			BEGIN
				SET @nextStartTime = DATEADD(day,(1+(@diff/@divisor)) , @startTime) 
			END

	   END
	   CASE WHEN @RecurrenceFrequencyTypeId = 2
	   THEN BEGIN
			SET @diff = DATEDIFF(WEEK, @endTime, GETUTCDATE())
			SET @divisor = 24			      
			IF(@endTime < GETUTCDATE() AND @diff < (@recurrenceCount*@divisor))		 
			BEGIN
				SET @nextStartTime = DATEADD(day,(1+(@diff/24)) , @startTime) 
			END
	      	    
	   END		
	   
	      
      PRINT @endTime
      PRINT @diff
      PRINT @nextStartTime
	      	   
	   
   END
   	
   RETURN @NextStartTime
END
GO

print 'function [ws_funcGetNextEventStartTime] created successfully'
GO

