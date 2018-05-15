/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetUserGcmClientId] to get UserGcmClientId.    
CreatedBy : Shyam
CreatedOn : 2015-12-29
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetUserGcmClientId]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetUserGcmClientId'
   DROP PROCEDURE [dbo].ws_spGetUserGcmClientId
END
GO

PRINT 'Creating PROCEDURE ws_spGetUserGcmClientId'
GO

CREATE Procedure [dbo].ws_spGetUserGcmClientId
(
	@userId UNIQUEIDENTIFIER
)
AS
BEGIN 
        
	SELECT TOP 1 GCMClientId from ws_UserProfile where UserId = @userId and IsDeleted = 0
   
END

GO
PRINT 'PROCEDURE ws_spGetUserGcmClientId created.'
GO


