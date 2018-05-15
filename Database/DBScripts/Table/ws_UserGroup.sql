-- Create Table ws_UserGroup
print 'Creating Table ws_UserGroup'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserGroup]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_UserGroup]
	(
		UserGroupId UNIQUEIDENTIFIER NOT NULL,
        UserGroupName NVARCHAR(100) NOT NULL,
        CreatedBy UNIQUEIDENTIFIER NOT NULL, 
        CreatedOn DATETIME NOT NULL,
        ModifiedBy UNIQUEIDENTIFIER, 
        ModifiedOn DATETIME,
        IsDeleted BIT NOT NULL,
        GroupImageUrl NVARCHAR(MAX)
    )
	print 'ws_UserGroup table is Created'
END
ELSE BEGIN
	print 'ws_UserGroup table already exists'
END
GO
