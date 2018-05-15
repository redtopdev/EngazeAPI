-- Create Table ws_UserProfile
print 'Creating Table ws_UserProfile'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserProfile]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_UserProfile]
	(
        UserId UNIQUEIDENTIFIER NOT NULL,
        GCMClientId NVARCHAR(MAX),
        ProfileName VARCHAR(100) NOT NULL, 
        ImageUrl VARCHAR(MAX),
        DeviceId NVARCHAR(100), --IMEI Number
        CountryCode NVARCHAR(10),
        MobileNumber NVARCHAR(20),
        IsDeleted BIT NOT NULL,
        CreatedOn DATETIME NOT NULL,
        ModifiedOn DATETIME,
        IsUserTemporary BIT NOT NULL DEFAULT 0
        --FirstName VARCHAR(100), 
        --LastName VARCHAR(100),
        --Email VARCHAR(100) NOT NULL, 
        --DateOfBirth DATETIME, 

    )
	print 'ws_UserProfile table is Created'
END
ELSE BEGIN
	print 'ws_UserProfile table already exists'
END
GO