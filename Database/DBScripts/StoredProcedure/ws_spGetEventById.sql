/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetEventById] to Fetch Event Info.    
CreatedBy : Shyam
CreatedOn : 2015-05-10
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetEventById]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetEventById'
   DROP PROCEDURE [dbo].ws_spGetEventById
END
GO

PRINT 'Creating PROCEDURE ws_spGetEventById'
GO

CREATE Procedure [dbo].ws_spGetEventById
(
	@getEventRequest XML
)
AS
BEGIN 

	DECLARE @requestorId UNIQUEIDENTIFIER
    SET @requestorId = (SELECT data.value('data(RequestorId)[1]', 'uniqueidentifier')  FROM @getEventRequest.nodes('GetEventRequest') AS ref(data))

	DECLARE @eventId UNIQUEIDENTIFIER
    SET @eventId = (SELECT data.value('data(EventId)[1]', 'uniqueidentifier')  FROM @getEventRequest.nodes('GetEventRequest') AS ref(data))


	SELECT e.*, @requestorId as RequestorId, ue.IsEventAccepted as HasRequestorAcceptedEvent,
	ue.IsTrackingAccepted as HasRequestorAcceptedTracking 
	from ws_Event e inner join ws_UserEvent ue on ue.EventId = e.EventId 
    WHERE ue.UserId = @requestorId and e.EventId = @eventId
    
   
END

GO
PRINT 'PROCEDURE ws_spGetEventById created.'
GO


