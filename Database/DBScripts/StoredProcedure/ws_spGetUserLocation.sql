/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetUserLocation] to insert UserLocation Info.    
CreatedBy : Shyam
CreatedOn : 2015-05-22
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetUserLocation]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetUserLocation'
   DROP PROCEDURE [dbo].ws_spGetUserLocation
END
GO

PRINT 'Creating PROCEDURE ws_spGetUserLocation'
GO

CREATE Procedure [dbo].ws_spGetUserLocation
(
	@eventLocationRequest XML
)
AS
BEGIN 
        
    DECLARE @RequestorId uniqueidentifier
    DECLARE @EventId uniqueidentifier
   	DECLARE @IsEventInValidState BIT
   	DECLARE @xmlc XML
   	DECLARE @dateOffset INT --temporary offset to show
   	SET @dateOffset = 330;
   	
   	
    SET @RequestorId = (SELECT data.value('data(RequestorId)[1]', 'uniqueidentifier')  FROM @eventLocationRequest.nodes('EventLocationRequest') AS ref(data));
    SET @EventId = (SELECT data.value('data(EventId)[1]', 'uniqueidentifier')  FROM @eventLocationRequest.nodes('EventLocationRequest') AS ref(data));
    
    IF EXISTS(SELECT 1 FROM ws_UserEvent WHERE EventId = @EventId AND UserId = @RequestorId AND EventAcceptanceStateId = 1 AND IsTrackingAccepted = 1 AND UserEventStateId <> 3)
    BEGIN    
    
    EXEC @IsEventInValidState = ws_spUpdateStatesForEvent @EventId;
    IF  (@IsEventInValidState = 0)
    BEGIN
      SELECT '';
    END;
    
		WITH records
		 AS (    
				SELECT  ul.[UserId], up.ProfileName , up.MobileNumber, ul.[Latitude],ul.[Longitude],ul.LocationAddress,
				ul.[IsDeleted],ul.[CreatedOn],ul.[ETA],ul.[ArrivalStatus], e.EventId, e.StartTime, e.EndTime, e.Duration, e.IsRecurring, 
				e.RecurrenceFrequencyTypeId, e.RecurrenceCount, e.RecurrenceFrequency, e.RecurrenceDaysOfWeek,
				ROW_NUMBER() 
				  OVER ( partition BY ul.[UserId] 
						ORDER BY ul.[CreatedOn] DESC ) rownum 
				FROM [ws_UserLocation] ul   
				INNER JOIN [ws_UserEvent] ue on ue.UserId = ul.UserId
				INNER JOIN [ws_UserProfile] up on up.UserId = ul.UserId
				INNER JOIN [ws_Event] e on e.EventId = ue.EventId
				WHERE ue.EventId = @EventId AND ul.IsDeleted = 0 AND e.TrackingStateId = 2 
				AND ue.EventAcceptanceStateId = 1 AND ue.IsTrackingAccepted = 1 AND ue.UserEventStateId <> 3
				AND e.EventStateId = 2 AND ul.CreatedOn > (DATEADD(minute,(-1 * e.TrackingStartOffset), e.StartTime)))

				--AND (EventStateId = 2 
				--OR
				--	(TrackingStateId = 2 
				--OR  
				--(   (StartTime < DATEADD(minute,@dateOffset, GETUTCDATE()))
				--AND (EndTime > DATEADD(minute,@dateOffset, GETUTCDATE())) 
				--AND EventStateId <> 3
				--)))
				
		--SELECT  UserId, ProfileName , MobileNumber, Latitude, Longitude,
		--		IsDeleted,CreatedOn,ETA,ArrivalStatus
		--FROM records
		--WHERE rownum = 1
		SELECT @xmlc = (  		
						SELECT ( SELECT  UserId, ProfileName , MobileNumber, Latitude, Longitude, LocationAddress,
						IsDeleted,CreatedOn,ETA,ArrivalStatus, EventId, StartTime, EndTime, Duration, IsRecurring,
						RecurrenceFrequencyTypeId, RecurrenceCount, RecurrenceFrequency, RecurrenceDaysOfWeek   FROM records						
						WHERE rownum = 1
						FOR XML PATH('UserLocation'), ROOT('ArrayOfUserLocation')
	 				           )  
		               )
		SELECT @xmlc 
	END
	ELSE
	BEGIN
		SELECT ''
	END
		
	--ADD logic to further filter based on authorized requestor ids
   
END

GO
PRINT 'PROCEDURE ws_spGetUserLocation created.'
GO


