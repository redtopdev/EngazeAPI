/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddOrUpdateUserGroupMember] to Add a member to UserGroup.    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddOrUpdateUserGroupMember]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddOrUpdateUserGroupMember'
   DROP PROCEDURE [dbo].ws_spAddOrUpdateUserGroupMember
END
GO

PRINT 'Creating PROCEDURE ws_spAddOrUpdateUserGroupMember'
GO

CREATE Procedure [dbo].ws_spAddOrUpdateUserGroupMember
(
	@userGroupMember XML
)
AS
BEGIN 		
	
	DECLARE @groupId UNIQUEIDENTIFIER
    SET @groupId = (SELECT data.value('data(UserGroupId)[1]', 'uniqueidentifier')  FROM @userGroupMember.nodes('UserGroupMember') AS ref(data))

	DECLARE @userId UNIQUEIDENTIFIER
    SET @userId = (SELECT data.value('data(UserId)[1]', 'uniqueidentifier')  FROM @userGroupMember.nodes('UserGroupMember') AS ref(data))

	IF NOT EXISTS (SELECT 1 FROM [dbo].[ws_UserGroupMember] WHERE UserGroupId = @groupId AND UserId = @userId)
	BEGIN
	
		INSERT INTO [dbo].[ws_UserGroupMember]
			   (
				[UserGroupId],[UserId],[IsAdmin],[CreatedBy],[CreatedOn],[IsDeleted]
			   )
		 SELECT
				@groupId,
				@userId ,
				data.value('data(IsAdmin)[1]','BIT') ,
				data.value('data(RequestorId)[1]','UNIQUEIDENTIFIER') ,
				GETUTCDATE(),--data.value('data(CreatedOn)[1]','DATETIME'),
				0 --data.value('data(IsDeleted)[1]','BIT')  
	   FROM @userGroupMember.nodes('UserGroupMember') AS ref(data)
	END
	ELSE
	BEGIN
		UPDATE [dbo].[ws_UserGroupMember]
		SET    [IsAdmin] = data.value('data(IsAdmin)[1]','BIT') ,
			   [IsDeleted] = 0 ,
			   [ModifiedBy] = data.value('data(RequestorId)[1]','UNIQUEIDENTIFIER') ,
			   [ModifiedOn] = GETUTCDATE()
			   FROM @userGroupMember.nodes('UserGroupMember') AS ref(data)
		WHERE  UserGroupId = @groupId AND UserId = @userId	
		
	END 	 
   
END

GO
PRINT 'PROCEDURE ws_spAddOrUpdateUserGroupMember created.'
GO


