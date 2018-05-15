/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetGroupsForUser] to Add a member to UserGroup.    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetGroupsForUser]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetGroupsForUser'
   DROP PROCEDURE [dbo].ws_spGetGroupsForUser
END
GO

PRINT 'Creating PROCEDURE ws_spGetGroupsForUser'
GO

CREATE Procedure [dbo].ws_spGetGroupsForUser
(
	@userGroupMember XML
)
AS
BEGIN 		
	
	DECLARE @userId UNIQUEIDENTIFIER
    SET @userId = (SELECT data.value('data(UserId)[1]', 'uniqueidentifier')  FROM @userGroupMember.nodes('UserGroupMember') AS ref(data))

	SELECT ug.UserGroupId, ug.UserGroupName, ug.GroupImageUrl 
	FROM [dbo].[ws_UserGroupMember] ugm
	INNER JOIN [dbo].[ws_UserGroup] ug on ug.UserGroupId = ugm.UserGroupId
	WHERE ugm.UserId = @userId AND ugm.IsDeleted = 0 AND ug.IsDeleted = 0
   
END

GO
PRINT 'PROCEDURE ws_spGetGroupsForUser created.'
GO


