/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetAllEventsForUser] to Fetch Event Info for user.    
CreatedBy : Shyam
CreatedOn : 2015-05-10
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetAllEventsForUser]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetAllEventsForUser'
   DROP PROCEDURE [dbo].ws_spGetAllEventsForUser
END
GO

PRINT 'Creating PROCEDURE ws_spGetAllEventsForUser'
GO

CREATE Procedure [dbo].ws_spGetAllEventsForUser
(
	@eventRequest XML
)
AS
BEGIN 
	
	DECLARE @eventId nvarchar(max)
	SET @eventId = (SELECT data.value('data(EventId)[1]', 'nvarchar(max)')  FROM @EventRequest.nodes('EventRequest') AS ref(data))
		
	
	DECLARE @requestorId nvarchar(max)
    SET @requestorId = (SELECT data.value('data(RequestorId)[1]', 'nvarchar(max)')  FROM @EventRequest.nodes('EventRequest') AS ref(data))

	DECLARE @xmlc XML

	IF (@eventId is null)
	BEGIN 
	  SELECT @xmlc = (  		
						SELECT ( SELECT  ev.EventId, ev.Name , ev.Description , 
						ev.EventTypeId, ev.StartTime, ev.EndTime, ev.Duration,ev.InitiatorId,upr.ProfileName as InitiatorName,
						--upr.GCMClientId as InitiatorGCMClientId,
						ev.EventStateId,ev.TrackingStateId, ev.DestinationName, 
						ev.DestinationAddress, ev.DestinationLatitude, ev.DestinationLongitude, ev.IsTrackingRequired, 
						 ev.ReminderOffset, ev.TrackingStartOffset, ev.IsQuickEvent, ev.IsDeleted ,	
						 ev.IsRecurring, ev.RecurrenceFrequencyTypeId, ev.RecurrenceCount,ev.RecurrenceFrequency, ev.RecurrenceDaysOfWeek,							
						 ( SELECT ue.UserId , up.ProfileName, up.CountryCode, up.MobileNumber , --up.GCMClientId, 
						 ue.EventAcceptanceStateId, ue.IsTrackingAccepted, ue.UserEventStateId, ue.IsUserLocationShared
							  FROM [dbo].[ws_Userevent] ue INNER JOIN ws_UserProfile up ON up.UserId = ue.UserId              
							  WHERE ue.EventId = ev.EventId AND ue.IsDeleted = 0 FOR XML PATH('EventParticipant'),TYPE ) AS 'UserList'
						FROM [dbo].[ws_Event] ev
						inner join ws_UserEvent ue on ue.EventId = ev.EventId 
						inner join ws_UserProfile upr on upr.UserId = ev.InitiatorId
						WHERE ue.UserId = @requestorId AND ue.IsDeleted = 0 AND ev.EventStateId <> 3 AND ev.IsDeleted = 0 AND ev.EndTime > GETUTCDATE()
					  FOR XML PATH('Event'), ROOT('ArrayOfEvent')
					 )  
			        )

    END
    ELSE
    BEGIN
	 EXEC ws_spUpdateStatesForEvent @EventId;	
    
	  SELECT @xmlc = ( SELECT (
		SELECT  ev.EventId, ev.Name , ev.Description , 
		ev.EventTypeId, ev.StartTime, ev.EndTime, ev.Duration,ev.InitiatorId, upr.ProfileName as InitiatorName,
		--upr.GCMClientId as InitiatorGCMClientId, 
		ev.EventStateId,ev.TrackingStateId,ev.DestinationName, 
		ev.DestinationAddress, ev.DestinationLatitude, ev.DestinationLongitude, ev.IsTrackingRequired, 
		 ev.ReminderOffset, ev.TrackingStartOffset,	ev.IsQuickEvent, ev.IsDeleted ,	
		 ev.IsRecurring, ev.RecurrenceFrequencyTypeId, ev.RecurrenceCount, ev.RecurrenceFrequency, ev.RecurrenceDaysOfWeek,									
		 ( SELECT ue.UserId , up.ProfileName, up.CountryCode, up.MobileNumber ,--up.GCMClientId, 
		 ue.EventAcceptanceStateId , ue.IsTrackingAccepted, ue.UserEventStateId, ue.IsUserLocationShared 
              FROM [dbo].[ws_Userevent] ue INNER JOIN ws_UserProfile up ON up.UserId = ue.UserId              
              WHERE ue.EventId = ev.EventId AND ue.IsDeleted = 0 FOR XML PATH('EventParticipant'),TYPE ) AS 'UserList'
		FROM [dbo].[ws_Event] ev
		inner join ws_UserEvent ue on ue.EventId = ev.EventId 
		inner join ws_UserProfile upr on upr.UserId = ev.InitiatorId
		WHERE ue.UserId = @requestorId AND ue.IsDeleted = 0  AND ev.EventId = @eventId AND ev.EventStateId <> 3 AND ev.IsDeleted = 0 AND ev.EndTime > GETUTCDATE()
	  FOR XML PATH('Event'), ROOT('ArrayOfEvent')
	 )   )
    END

	SELECT @xmlc  
   
END

GO
PRINT 'PROCEDURE ws_spGetAllEventsForUser created.'
GO


