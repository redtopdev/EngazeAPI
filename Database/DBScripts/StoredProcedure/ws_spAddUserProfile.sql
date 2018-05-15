/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddUserProfile] to insert/register UserProfile Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddUserProfile]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddUserProfile'
   DROP PROCEDURE [dbo].ws_spAddUserProfile
END
GO

PRINT 'Creating PROCEDURE ws_spAddUserProfile'
GO

CREATE Procedure [dbo].ws_spAddUserProfile
(
	@userProfile XML
)
AS
BEGIN 

	DECLARE @userId UNIQUEIDENTIFIER
	SET @userId = NEWID()
	
	DECLARE @MobileNumber NVARCHAR(20)
	DECLARE @CountryCode NVARCHAR(10)
	SELECT @MobileNumber = data.value('data(MobileNumber)[1]','NVARCHAR(20)') FROM @userProfile.nodes('UserProfile') AS ref(data)
	SELECT @CountryCode = data.value('data(CountryCode)[1]','NVARCHAR(10)') FROM @userProfile.nodes('UserProfile') AS ref(data)
	
	
	IF EXISTS (SELECT 1 FROM [dbo].[ws_UserProfile] WHERE 
	MobileNumber = @MobileNumber AND CountryCode = @CountryCode)
	BEGIN 
		SELECT @userId = UserId FROM [dbo].[ws_UserProfile] WHERE 
		MobileNumber = @MobileNumber AND CountryCode = @CountryCode
		
		SET @userProfile.modify('
		  replace value of (/UserProfile/UserId[1]/text())[1]
		  with  sql:variable("@userId")
		');
		
		  SET @userProfile.modify('
		  replace value of (/UserProfile/IsDeleted[1]/text())[1]
		  with  0
		');
		
		EXEC ws_spUpdateUserProfile @userProfile
		
	END
	ELSE
	BEGIN	
	INSERT INTO [dbo].[ws_UserProfile]
           (
			[UserId],[GCMClientId],[ProfileName],[ImageUrl],[DeviceId]
			,[CountryCode],[MobileNumber],[IsDeleted],[CreatedOn],[ModifiedOn],[Email]
			--,[DateOfBirth],[FirstName],[LastName]
           )
     SELECT
			@userId,
			data.value('data(GCMClientId)[1]','NVARCHAR(MAX)'),
			data.value('data(ProfileName)[1]','VARCHAR(100)') ,			
			data.value('data(ImageUrl)[1]','VARCHAR(MAX)') ,
			data.value('data(DeviceId)[1]','NVARCHAR(100)') ,
			data.value('data(CountryCode)[1]','NVARCHAR(10)') ,
			data.value('data(MobileNumber)[1]','NVARCHAR(20)') ,
			0 , --IsDeleted by default is False
			GETUTCDATE() ,
			GETUTCDATE() ,
			data.value('data(Email)[1]','VARCHAR(100)') 
			--data.value('data(DateOfBirth)[1]','DATETIME'),
			--data.value('data(FirstName)[1]', 'VARCHAR(100)'),
			--data.value('data(LastName)[1]', 'VARCHAR(100)') ,
   FROM @userProfile.nodes('UserProfile') AS ref(data)
   
   END
   SELECT @userId  AS 'UserId'		 
   
END

GO
PRINT 'PROCEDURE ws_spAddUserProfile created.'
GO


