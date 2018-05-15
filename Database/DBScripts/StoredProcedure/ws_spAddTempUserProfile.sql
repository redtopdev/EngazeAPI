/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddTempUserProfile] to insert/register UserProfile Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddTempUserProfile]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddTempUserProfile'
   DROP PROCEDURE [dbo].ws_spAddTempUserProfile
END
GO

PRINT 'Creating PROCEDURE ws_spAddTempUserProfile'
GO

CREATE Procedure [dbo].ws_spAddTempUserProfile
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
		
		--SET @userProfile.modify('
		--  replace value of (/UserProfile/UserId[1]/text())[1]
		--  with  sql:variable("@userId")
		--');
		
		--  SET @userProfile.modify('
		--  replace value of (/UserProfile/IsDeleted[1]/text())[1]
		--  with  0
		--');
		
		--EXEC ws_spUpdateUserProfile @userProfile
		
	END
	ELSE
	BEGIN	
	INSERT INTO [dbo].[ws_UserProfile]
           (
			[UserId],[GCMClientId],[ProfileName],[ImageUrl],[DeviceId]
			,[CountryCode],[MobileNumber],[IsDeleted],[CreatedOn],[ModifiedOn],[Email], IsUserTemporary
			--,[DateOfBirth],[FirstName],[LastName]
           )
     SELECT
			@userId,
			'temp',
			@CountryCode+@MobileNumber ,			
			NULL ,
			NULL ,
			@CountryCode ,
			@MobileNumber ,
			0 , --IsDeleted by default is False
			GETUTCDATE() ,
			GETUTCDATE() ,
			'temp' ,
			1         
			--data.value('data(DateOfBirth)[1]','DATETIME'),
			--data.value('data(FirstName)[1]', 'VARCHAR(100)'),
			--data.value('data(LastName)[1]', 'VARCHAR(100)') ,
   FROM @userProfile.nodes('UserProfile') AS ref(data)
   
   END
   SELECT @userId  AS 'UserId'		 
   
END

GO
PRINT 'PROCEDURE ws_spAddTempUserProfile created.'
GO


