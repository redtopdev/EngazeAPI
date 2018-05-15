/***************************************
# Object:  StoredProcedure [dbo].[ws_spUpdateUserGroup] to Update a UserGroup.    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUpdateUserGroup]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUpdateUserGroup'
   DROP PROCEDURE [dbo].ws_spUpdateUserGroup
END
GO

PRINT 'Creating PROCEDURE ws_spUpdateUserGroup'
GO

CREATE Procedure [dbo].ws_spUpdateUserGroup
(
	@userGroup XML
)
AS
BEGIN 		
	
	DECLARE @groupId UNIQUEIDENTIFIER
    SET @groupId = (SELECT data.value('data(UserGroupId)[1]', 'uniqueidentifier')  FROM @userGroup.nodes('UserGroup') AS ref(data))

	UPDATE [dbo].[ws_UserGroup]
    SET    [UserGroupName] = data.value('data(UserGroupName)[1]', 'NVARCHAR(100)') ,
			[ModifiedBy] = data.value('data(ModifiedBy)[1]','UNIQUEIDENTIFIER'),
			[ModifiedOn] = GETUTCDATE() ,
			[IsDeleted] = data.value('data(IsDeleted)[1]','BIT') ,
			[GroupImageUrl] = data.value('data(GroupImageUrl)[1]','NVARCHAR(MAX)') 
    FROM @userGroup.nodes('UserGroup') AS ref(data)
    WHERE UserGroupId = @groupId
      
END

GO
PRINT 'PROCEDURE ws_spUpdateUserGroup created.'
GO


