/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetGcmClientIdForMobile] to get UserGcmClientId based on Mobilenumber and country code.    
CreatedBy : Shyam
CreatedOn : 2015-12-29
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetGcmClientIdForMobile]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetGcmClientIdForMobile'
   DROP PROCEDURE [dbo].ws_spGetGcmClientIdForMobile
END
GO

PRINT 'Creating PROCEDURE ws_spGetGcmClientIdForMobile'
GO

CREATE Procedure [dbo].ws_spGetGcmClientIdForMobile
(
	@gcmClientIdRequest XML
)
AS
BEGIN 
        
    DECLARE @mobileNumber NVARCHAR(20)
    DECLARE @countryCode NVARCHAR(10)
    SET @mobileNumber = (SELECT data.value('data(MobileNumber)[1]', 'NVARCHAR(20)')  FROM @gcmClientIdRequest.nodes('GcmClientIdRequest') AS ref(data));
    SET @countryCode = (SELECT data.value('data(CountryCode)[1]', 'NVARCHAR(10)')  FROM @gcmClientIdRequest.nodes('GcmClientIdRequest') AS ref(data));

    
	SELECT TOP 1 GCMClientId from ws_UserProfile where MobileNumber = @mobileNumber and CountryCode = @countryCode AND IsDeleted = 0
   
END

GO
PRINT 'PROCEDURE ws_spGetGcmClientIdForMobile created.'
GO


