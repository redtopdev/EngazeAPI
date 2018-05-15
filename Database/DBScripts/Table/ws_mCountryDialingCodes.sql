-- Create Table ws_mCountryDialingCodes
print 'Creating Table ws_mCountryDialingCodes'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_mCountryDialingCodes]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_mCountryDialingCodes]
	(
        Code VARCHAR(10) NOT NULL,
        Name VARCHAR(100) NOT NULL, 
        IsDeleted BIT NOT NULL,
        CreatedOn DATETIME NOT NULL,
        CreatedBy VARCHAR(200) NOT NULL, 
        ModifiedOn DATETIME NOT NULL,
        ModifiedBy VARCHAR(200) NOT NULL
    )
	print 'ws_mCountryDialingCodes table is Created'
END
ELSE BEGIN
	print 'ws_mCountryDialingCodes table already exists'
END
GO