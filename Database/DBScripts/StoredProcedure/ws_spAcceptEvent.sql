/***************************************
# Object:  StoredProcedure [dbo].[ws_spAcceptEvent] User  accepting  Event and Tracking by User.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAcceptEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAcceptEvent'
   DROP PROCEDURE [dbo].ws_spAcceptEvent
END
GO

PRINT 'Creating PROCEDURE ws_spAcceptEvent'
GO

CREATE Procedure [dbo].ws_spAcceptEvent
(
	@eventRequest XML
)
AS
BEGIN 		
    DECLARE @RequestorId nvarchar(MAX)
    DECLARE @EventId nvarchar(MAX)
    DECLARE @IsEventAccepted BIT
    DECLARE @IsTrackingAccepted BIT
    
    SET @RequestorId = (SELECT data.value('data(RequestorId)[1]', 'nvarchar(MAX)')  FROM @eventRequest.nodes('EventRequest') AS ref(data))
    SET @EventId = (SELECT data.value('data(EventId)[1]', 'nvarchar(MAX)')  FROM @eventRequest.nodes('EventRequest') AS ref(data))
    SET @IsEventAccepted = (SELECT data.value('data(EventAccepted)[1]', 'bit')  FROM @eventRequest.nodes('EventRequest') AS ref(data))
    SET @IsTrackingAccepted = (SELECT data.value('data(TrackingAccepted)[1]', 'bit')  FROM @eventRequest.nodes('EventRequest') AS ref(data))
    
    IF @IsEventAccepted = 0
    BEGIN
		SET @IsTrackingAccepted = 0
    END
    
	UPDATE [dbo].[ws_UserEvent]
    SET
		IsEventAccepted = @IsEventAccepted ,
		IsTrackingAccepted = @IsTrackingAccepted
    WHERE UserId = @RequestorId AND EventId = @EventId   
   
END

GO
PRINT 'PROCEDURE ws_spAcceptEvent created.'
GO


