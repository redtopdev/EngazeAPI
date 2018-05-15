/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddUserGroup] to Create a UserGroup.    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddUserGroup]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddUserGroup'
   DROP PROCEDURE [dbo].ws_spAddUserGroup
END
GO

PRINT 'Creating PROCEDURE ws_spAddUserGroup'
GO

CREATE Procedure [dbo].ws_spAddUserGroup
(
	@userGroup XML
)
AS
BEGIN 		
	
	DECLARE @groupId UNIQUEIDENTIFIER
    SET @groupId = NEWID()

	DECLARE @userId UNIQUEIDENTIFIER
	SET @userId = (SELECT data.value('data(RequestorId)[1]','UNIQUEIDENTIFIER') FROM @userGroup.nodes('UserGroup') AS ref(data))
	
	INSERT INTO [dbo].[ws_UserGroup]
           (
			[UserGroupId],[UserGroupName],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn],[IsDeleted],[GroupImageUrl]
           )
     SELECT
			@groupId,
			data.value('data(UserGroupName)[1]', 'NVARCHAR(100)') ,
			@userId ,
			GETUTCDATE() ,
			NULL, --modifiedby
			NULL , --modifiedon
			0,
			data.value('data(GroupImageUrl)[1]','NVARCHAR(MAX)') 
   FROM @userGroup.nodes('UserGroup') AS ref(data)
   
   --insert creator as default member to group
   DECLARE @xmlc XML
   SELECT @xmlc = ( SELECT @groupId AS 'UserGroupId', @userId AS 'UserId', 1 AS 'IsAdmin' ,
					 @userId AS 'RequestorId' FOR XML PATH('UserGroupMember'),TYPE )   
   EXEC ws_spAddOrUpdateUserGroupMember  @xmlc
   
   	--Insert other members
	SET @userGroup.modify('
	  replace value of (/UserGroup/UserGroupId[1]/text())[1]
	  with  sql:variable("@groupId")
	');
		   	
	--DECLARE @str NVARCHAR(MAX)
	--SET @str = CONVERT(nvarchar(max),@userGroup)
	--SET @userGroup = convert(XML, REPLACE(@str,'$userGroupId$',@groupId ))
   EXEC ws_spSyncUserGroupMember @userGroup
   
   SELECT @groupId  AS 'Id'		 
   
END

GO
PRINT 'PROCEDURE ws_spAddUserGroup created.'
GO


