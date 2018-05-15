-- Create Table ws_UserAuthentication
print 'Creating Table ws_UserAuthentication'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserAuthentication]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_UserAuthentication]
	(
        UserAuthenticationId UNIQUEIDENTIFIER NOT NULL,
        UserId UNIQUEIDENTIFIER NOT NULL,
		Token VARCHAR(200) NULL,
		Salt VARCHAR(200)NULL,
        IsDeleted BIT NOT NULL,
        CreatedOn DATETIME NOT NULL,
        LastAccessedOn BIT NULL
    )  

	print 'ws_UserAuthentication table is Created'
END
ELSE BEGIN
	print 'ws_UserAuthentication table already exists'
END
GO
