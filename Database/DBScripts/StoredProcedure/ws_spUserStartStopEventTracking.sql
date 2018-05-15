/***************************************
# Object:  StoredProcedure [dbo].[ws_spUserStartStopEventTracking] to Start or Stop Tracking for a User related to Event.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUserStartStopEventTracking]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUserStartStopEventTracking'
   DROP PROCEDURE [dbo].ws_spUserStartStopEventTracking
END
GO

PRINT 'Creating PROCEDURE ws_spUserStartStopEventTracking'
GO

CREATE Procedure [dbo].ws_spUserStartStopEventTracking
(
	@userEvent XML
)
AS
BEGIN 		

    DECLARE @UserId nvarchar(max)
    DECLARE @EventId nvarchar(max)
    DECLARE @IsTrackingActive bit
    
    SET @UserId = (SELECT data.value('data(UserId)[1]', 'nvarchar(max)')  FROM @userEvent.nodes('UserEvent') AS ref(data))
    SET @EventId = (SELECT data.value('data(EventId)[1]', 'nvarchar(max)')  FROM @userEvent.nodes('UserEvent') AS ref(data))
    SET @IsTrackingActive = (SELECT data.value('data(IsTrackingActive)[1]', 'bit')  FROM @userEvent.nodes('UserEvent') AS ref(data))
    
    IF @IsTrackingActive = 1
    BEGIN 
	UPDATE [dbo].[ws_UserEvent]
    SET
		TrackingStartTime = GETUTCDATE() ,
		IsTrackingActive = 1
		FROM @userEvent.nodes('UserEvent') AS ref(data)
   WHERE UserId = @UserId AND EventId = @EventId   
   END
   ELSE
   BEGIN 
	UPDATE [dbo].[ws_UserEvent]
    SET
		TrackingEndTime = GETUTCDATE() ,
		TrackingEndReason = (SELECT data.value('data(TrackingEndReason)[1]', 'int')  FROM @userEvent.nodes('UserEvent') AS ref(data)),
		IsTrackingActive = 0
		FROM @userEvent.nodes('UserEvent') AS ref(data)
   WHERE UserId = @UserId AND EventId = @EventId   

   END
   
END

GO
PRINT 'PROCEDURE ws_spUserStartStopEventTracking created.'
GO


