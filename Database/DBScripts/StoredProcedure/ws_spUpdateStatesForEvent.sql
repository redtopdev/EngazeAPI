/***************************************
# Object:  StoredProcedure [dbo].[ws_spUpdateStatesForEvent] to check if tracking is active.    
CreatedBy : Shyam
CreatedOn : 2015-10-10
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUpdateStatesForEvent]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUpdateStatesForEvent'
   DROP PROCEDURE [dbo].ws_spUpdateStatesForEvent
END
GO

PRINT 'Creating PROCEDURE ws_spUpdateStatesForEvent'
GO

CREATE Procedure [dbo].ws_spUpdateStatesForEvent
(
	@eventId UNIQUEIDENTIFIER	
)
AS
BEGIN 
        
   	DECLARE @xmlc XML
   	IF EXISTS(
	SELECT 1 FROM ws_Event WHERE EventId = @eventId
	AND (  IsQuickEvent = 1  
		  AND (EndTime > GETUTCDATE()) 
		  AND EventStateId <> 3 AND IsDeleted = 0)
	    ) 
	BEGIN
		UPDATE ws_Event 
		SET EventStateId = 2 
		WHERE EventId = @eventId AND EventStateId NOT IN (2,3) AND IsDeleted = 0
		
		UPDATE ws_Event 
		SET TrackingStateId = 2 
		WHERE EventId = @eventId AND EventStateId = 2 AND TrackingStateId NOT IN (2,3) AND IsTrackingRequired = 1 AND IsDeleted = 0
		
		RETURN 1
	END
	ELSE IF  EXISTS(
	SELECT 1 FROM ws_Event WHERE EventId = @eventId
	AND (  (StartTime < GETUTCDATE())
		  AND (EndTime > GETUTCDATE()) 
		  AND EventStateId <> 3 AND IsDeleted = 0)
	    ) 
	BEGIN
		UPDATE ws_Event 
		SET EventStateId = 2 
		WHERE EventId = @eventId AND EventStateId NOT IN (2,3) AND IsDeleted = 0
		
		UPDATE ws_Event 
		SET TrackingStateId = 2 
		WHERE EventId = @eventId AND EventStateId = 2 AND TrackingStateId NOT IN (2,3) AND IsTrackingRequired = 1 AND IsDeleted = 0
		
		RETURN 1
	END
	ELSE IF EXISTS(
	SELECT 1 FROM ws_Event WHERE EventId = @eventId
	AND ( EndTime < GETUTCDATE() AND EventStateId <> 3 AND IsDeleted = 0
	     ))
	BEGIN
		UPDATE ws_Event 
		SET EventStateId = 3 
		WHERE EventId = @eventId AND EventStateId NOT IN (3) AND IsDeleted = 0
		
		UPDATE ws_Event 
		SET TrackingStateId = 3 
		WHERE EventId = @eventId AND EventStateId = 3 AND TrackingStateId NOT IN (3) AND IsTrackingRequired = 1 AND IsDeleted = 0
		
		RETURN 0
	END
	ELSE
	BEGIN 
		RETURN 0
	END
	
		
	--ADD logic to further filter based on authorized requestor ids
   
END

GO
PRINT 'PROCEDURE ws_spUpdateStatesForEvent created.'
GO


