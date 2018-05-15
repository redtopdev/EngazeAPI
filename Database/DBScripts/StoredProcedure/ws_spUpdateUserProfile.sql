/***************************************
# Object:  StoredProcedure [dbo].[ws_spUpdateUserProfile] to update userprofile Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUpdateUserProfile]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUpdateUserProfile'
   DROP PROCEDURE [dbo].ws_spUpdateUserProfile
END
GO

PRINT 'Creating PROCEDURE ws_spUpdateUserProfile'
GO

CREATE Procedure [dbo].ws_spUpdateUserProfile
(
	@userProfile XML
)
AS
BEGIN 
	DECLARE @IsDeleted BIT
	SELECT @IsDeleted = data.value('data(IsDeleted)[1]','BIT') FROM @userProfile.nodes('UserProfile') AS ref(data)
	SET @IsDeleted = ISNULL(@IsDeleted,0)
	
	UPDATE [dbo].[ws_UserProfile]
    SET
			GCMClientId = data.value('data(GCMClientId)[1]','NVARCHAR(MAX)'),
			ProfileName = data.value('data(ProfileName)[1]','NVARCHAR(100)') ,
			ImageUrl = ISNULL(data.value('data(ImageUrl)[1]','NVARCHAR(MAX)'),ImageUrl) ,
			DeviceId = ISNULL(data.value('data(DeviceId)[1]','NVARCHAR(100)'),DeviceId) ,
			CountryCode = data.value('data(CountryCode)[1]','NVARCHAR(10)') ,
			MobileNumber = data.value('data(MobileNumber)[1]','NVARCHAR(20)') ,
			IsDeleted = @IsDeleted,
			ModifiedOn = GETUTCDATE(),
			--FirstName = data.value('data(FirstName)[1]', 'VARCHAR(100)'),
			--LastName = data.value('data(LastName)[1]', 'VARCHAR(100)') ,
			Email = data.value('data(Email)[1]','VARCHAR(100)') 
			--DateOfBirth = data.value('data(DateOfBirth)[1]','datetime'),

   FROM @userProfile.nodes('UserProfile') AS ref(data)
   WHERE UserId = (SELECT data.value('data(UserId)[1]', 'uniqueidentifier')   FROM @userProfile.nodes('UserProfile') AS ref(data))
   
END

GO
PRINT 'PROCEDURE ws_spUpdateUserProfile created.'
GO


