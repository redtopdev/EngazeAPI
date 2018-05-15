-- Create Table ws_UserGroupMember
print 'Creating Table ws_UserGroupMember'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserGroupMember]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_UserGroupMember]
	(
		UserGroupId UNIQUEIDENTIFIER NOT NULL,
        UserId UNIQUEIDENTIFIER NOT NULL,
        IsAdmin BIT NOT NULL,
        CreatedBy UNIQUEIDENTIFIER NOT NULL, 
        CreatedOn DATETIME NOT NULL,
        ModifiedBy UNIQUEIDENTIFIER , 
        ModifiedOn DATETIME ,        
        IsDeleted BIT NOT NULL
    )
	print 'ws_UserGroupMember table is Created'
END
ELSE BEGIN
	print 'ws_UserGroupMember table already exists'
END
GO
