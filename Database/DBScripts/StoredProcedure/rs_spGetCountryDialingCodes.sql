/***************************************
# Object:  StoredProcedure [dbo].[rs_spGetCountryDialingCodes] to insert Approach Road Info.    
CreatedBy : Atul Sagar
CreatedOn : 2015-04-04
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rs_spGetCountryDialingCodes]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE rs_spGetCountryDialingCodes'
   DROP PROCEDURE [dbo].rs_spGetCountryDialingCodes
END
GO

PRINT 'Creating PROCEDURE rs_spGetCountryDialingCodes'
GO

CREATE Procedure [dbo].rs_spGetCountryDialingCodes
AS
BEGIN 

	SELECT  Name, Code
	FROM ws_mCountryDialingCodes
	WHERE IsDeleted =0
END

GO
PRINT 'PROCEDURE rs_spGetCountryDialingCodes created.'
GO


