/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddUserEvent] to insert UserEvent Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddUserEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddUserEvent'
   DROP PROCEDURE [dbo].ws_spAddUserEvent
END
GO

PRINT 'Creating PROCEDURE ws_spAddUserEvent'
GO

CREATE Procedure [dbo].ws_spAddUserEvent
(
	@userEvent XML
)
AS
BEGIN 		
	INSERT INTO [dbo].[ws_UserEvent]
           (
			[EventId],[UserId],[GroupId],[RequestAcceptanceState],[IsTrackingAccepted],[TrackingStartTime],[TrackingEndTime],
            [TrackingEndReason],[IsTrackingActive],[IsEventActive],[UserEventEndTime]
           )
     SELECT			
			data.value('data(EventId)[1]', 'uniqueidentifier') ,
			data.value('data(UserId)[1]','uniqueidentifier') ,
			data.value('data(GroupId)[1]','uniqueidentifier') ,
			ISNULL(data.value('data(RequestAcceptanceState)[1]','int') ,0),
			ISNULL(data.value('data(IsTrackingAccepted)[1]','bit'), 0),
			data.value('data(TrackingStartTime)[1]','datetime') ,
			data.value('data(TrackingEndTime)[1]','datetime') ,
			data.value('data(TrackingEndReason)[1]','int') ,
			ISNULL(data.value('data(IsTrackingActive)[1]','bit'), 0) ,
			ISNULL(data.value('data(IsEventActive)[1]','bit'), 0) ,
			NULL
   FROM @userEvent.nodes('UserEvent') AS ref(data)
   
   SELECT SCOPE_IDENTITY()  AS 'Id'		 
   
END

GO
PRINT 'PROCEDURE ws_spAddUserEvent created.'
GO


