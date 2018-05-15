/***************************************
# Object:  StoredProcedure [dbo].[ws_spSyncUserGroupMember] to Synchronize member list to a UserGroup.[Add,Update,Delete]    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spSyncUserGroupMember]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spSyncUserGroupMember'
   DROP PROCEDURE [dbo].ws_spSyncUserGroupMember
END
GO

PRINT 'Creating PROCEDURE ws_spSyncUserGroupMember'
GO

CREATE Procedure [dbo].ws_spSyncUserGroupMember
(
	@userGroup XML
)
AS
BEGIN 		
	
	
	DECLARE @UserGroupId UNIQUEIDENTIFIER
	DECLARE @UserGroupIdStr NVARCHAR(100)
	--SET @UserGroupId = (SELECT data.value('data(UserGroupId)[1]', 'uniqueidentifier')  FROM @userGroup.nodes('UserGroup') AS ref(data))
	SET @UserGroupId = (SELECT data.value('data(UserGroupId)[1]', 'uniqueidentifier')  FROM @userGroup.nodes('UserGroup') AS ref(data))
	SET @UserGroupIdStr = CAST(@UserGroupId AS NVARCHAR(100))
		

	IF ( (@UserGroupIdStr is null) OR  (@UserGroupIdStr = '') )
	BEGIN	
		return 'Group Id Missing the input data SyncUserGroupMember.'
	END

	DECLARE @RequestorId UNIQUEIDENTIFIER
	SET @RequestorId = (SELECT data.value('data(RequestorId)[1]', 'uniqueidentifier')  FROM @userGroup.nodes('UserGroup') AS ref(data))

	-- first insert all records to temp table
	SELECT @UserGroupId as UserGroupId,
	T.Item.value('UserId[1]', 'uniqueidentifier') as UserId,
	T.Item.value('IsAdmin[1]', 'bit') as IsAdmin,
	@RequestorId as CreatedBy,
	GETUTCDATE() as CreatedOn,
	@RequestorId as ModifiedBy,
	GETUTCDATE() as ModifiedOn,
	0 as IsDeleted
	INTO #tmpGroupMember
	FROM @userGroup.nodes('UserGroup/UserList/UserGroupMember')  T(Item) 
	
	--Write code to first delete additional users
	UPDATE [dbo].[ws_UserGroupMember]
	SET IsDeleted = 1, 
	ModifiedBy = @RequestorId,
	ModifiedOn = GETUTCDATE()
	WHERE UserGroupId = @UserGroupId AND IsDeleted = 0
	AND UserId NOT IN ( SELECT  UserId FROM #tmpGroupMember UNION  select CreatedBy from ws_UserGroupMember where UserGroupId = @UserGroupId)
	
		
	--Write code to update existing users
	UPDATE [dbo].[ws_UserGroupMember]
	SET IsAdmin = t.IsAdmin ,
	ModifiedBy = @RequestorId,
	ModifiedOn = GETUTCDATE()
	FROM #tmpGroupMember t 
	INNER JOIN ws_UserGroupMember ugm on ugm.UserId = t.userid and ugm.UserGroupId = t.UserGroupId 
	
	--Write code to insert new members

	--insert new members
	INSERT INTO [dbo].[ws_UserGroupMember]
	(UserGroupId, UserId, IsAdmin, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, IsDeleted)
	SELECT UserGroupId,
	UserId,
	IsAdmin,
	CreatedBy,
	CreatedOn,
	NULL,
	NULL,
	IsDeleted
	FROM #tmpGroupMember
	WHERE UserId NOT IN (SELECT UserId FROM [dbo].[ws_UserGroupMember]
						WHERE UserGroupId = @UserGroupId)
	
   
END

GO
PRINT 'PROCEDURE ws_spSyncUserGroupMember created.'
GO


