/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetUserEmailId] to get UserEmailId.    
CreatedBy : Shyam
CreatedOn : 2015-12-29
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetUserEmailId]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetUserEmailId'
   DROP PROCEDURE [dbo].ws_spGetUserEmailId
END
GO

PRINT 'Creating PROCEDURE ws_spGetUserEmailId'
GO

CREATE Procedure [dbo].ws_spGetUserEmailId
(
	@userId UNIQUEIDENTIFIER
)
AS
BEGIN 
        
	SELECT TOP 1 Email from ws_UserProfile where UserId = @userId and IsDeleted = 0
   
END

GO
PRINT 'PROCEDURE ws_spGetUserEmailId created.'
GO


