/***************************************
# Object:  StoredProcedure [dbo].[ws_spDeleteUserGroup] to Delete a UserGroup.    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spDeleteUserGroup]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spDeleteUserGroup'
   DROP PROCEDURE [dbo].ws_spDeleteUserGroup
END
GO

PRINT 'Creating PROCEDURE ws_spDeleteUserGroup'
GO

CREATE Procedure [dbo].ws_spDeleteUserGroup
(
	@userGroup XML
)
AS
BEGIN 		
	
	DECLARE @groupId UNIQUEIDENTIFIER
    SET @groupId = (SELECT data.value('data(UserGroupId)[1]', 'uniqueidentifier')  FROM @userGroup.nodes('UserGroup') AS ref(data))

	UPDATE [dbo].[ws_UserGroup]
    SET     [ModifiedBy] = data.value('data(ModifiedBy)[1]','UNIQUEIDENTIFIER'),
			[ModifiedOn] = GETUTCDATE() ,
			[IsDeleted] = 1
    FROM @userGroup.nodes('UserGroup') AS ref(data)
    WHERE UserGroupId = @groupId
    
	UPDATE [dbo].[ws_UserGroupMember]
    SET     [ModifiedBy] = data.value('data(ModifiedBy)[1]','UNIQUEIDENTIFIER'),
			[ModifiedOn] = GETUTCDATE() ,
			[IsDeleted] = 1
    FROM @userGroup.nodes('UserGroup') AS ref(data)
    WHERE UserGroupId = @groupId
    
      
END

GO
PRINT 'PROCEDURE ws_spDeleteUserGroup created.'
GO


