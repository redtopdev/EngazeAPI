/***************************************
c# Object:  StoredProcedure [dbo].[ws_spGetUserCountryCode] to get User Country code .    
CreatedBy : Shyam
CreatedOn : 2015-10-18
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetUserCountryCode]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetUserCountryCode'
   DROP PROCEDURE [dbo].ws_spGetUserCountryCode
END
GO

PRINT 'Creating PROCEDURE ws_spGetUserCountryCode'
GO

CREATE Procedure [dbo].ws_spGetUserCountryCode
(
	@userId uniqueidentifier
)
AS
BEGIN 
        
	SELECT CountryCode FROM ws_UserProfile WHERE UserId = @userId   
END

GO
PRINT 'PROCEDURE ws_spGetUserCountryCode created.'
GO


