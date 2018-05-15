/***************************************
# Object:  StoredProcedure [dbo].[ws_spAdminCleanupData] to cleanup old data[location, event, userevent].    
CreatedBy : Shyam
CreatedOn : 2016-01-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAdminCleanupData]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAdminCleanupData'
   DROP PROCEDURE [dbo].ws_spAdminCleanupData
END
GO

PRINT 'Creating PROCEDURE ws_spAdminCleanupData'
GO

CREATE Procedure [dbo].ws_spAdminCleanupData
(
	@cleanupRequest XML
)
AS
BEGIN 

	DECLARE @requestorId UNIQUEIDENTIFIER    
	SET @requestorId = (SELECT data.value('data(RequestorId)[1]','uniqueidentifier') FROM @cleanupRequest.nodes('CleanupRequest') AS ref(data))
	
	IF EXISTS(SELECT 1 FROM ws_AdminUsers WHERE UserId = @requestorId AND IsDeleted = 0)
	BEGIN	

		BEGIN TRY
		
			BEGIN TRAN
			    
				--UPDATE Events
				UPDATE ws_Event Set EventStateId = 3, TrackingStateId = 3
				WHERE EndTime < DATEADD(MINUTE,-300, GETUTCDATE()) AND EventStateId <> 3 AND IsDeleted = 0

				UPDATE ws_Event Set IsDeleted = 1
				WHERE CreatedOn <  DATEADD(day,-91, GETUTCDATE()) AND EventStateId = 3 AND IsDeleted = 0

				--UPDATE Event Participants
				UPDATE ws_userEvent 
				SET IsDeleted = 1	
				WHERE IsDeleted = 0 AND CreatedOn <  DATEADD(day,-92, GETUTCDATE())
				AND EventId in (SELECT EventId from ws_Event where IsDeleted = 1 AND EventStateId = 3)
				
				--Delete user event
				DELETE FROM ws_userEvent WHERE 			
				CreatedOn <  DATEADD(day,-181, GETUTCDATE()) AND IsDeleted = 1

				--Delete user event
				DELETE FROM ws_Event WHERE 			
				CreatedOn <  DATEADD(day,-181, GETUTCDATE()) AND IsDeleted = 1

				--Mark Location for Deletion
				UPDATE ws_userLocation 
				SET IsDeleted = 1	
				WHERE CreatedOn <  DATEADD(day,-7, GETUTCDATE()) AND IsDeleted = 0
				
				--delete location
				DELETE FROM ws_userLocation WHERE CreatedOn <  DATEADD(day,-31, GETUTCDATE()) AND IsDeleted = 1

				
					
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

GO
PRINT 'PROCEDURE ws_spAdminCleanupData created.'
GO


