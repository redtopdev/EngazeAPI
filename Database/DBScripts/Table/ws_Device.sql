-- Create Table ws_Device
print 'Creating Table ws_Device'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_Device]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_Device]
	(
        DeviceId UNIQUEIDENTIFIER NOT NULL,
		ClientAuthenticationCode VARCHAR(MAX) NOT NULL,
		IMEINumber VARCHAR(20) NOT NULL,
		MobileNumber VARCHAR(20) NOT NULL,
        IsDeleted BIT NULL,
		CreatedOn DateTime NOT NULL,
		CreatedBy VARCHAR(200) NOT NULL,
		ModifiedOn DateTime NOT NULL,
		ModifiedBy VARCHAR(200) NOT NULL
    )
	print 'ws_Device table is Created'
END
ELSE BEGIN
	print 'ws_Device table already exists'
END
GO