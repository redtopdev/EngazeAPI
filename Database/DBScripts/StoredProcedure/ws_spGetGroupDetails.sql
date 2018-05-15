/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetGroupDetails] to Add a member to UserGroup.    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetGroupDetails]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetGroupDetails'
   DROP PROCEDURE [dbo].ws_spGetGroupDetails
END
GO

PRINT 'Creating PROCEDURE ws_spGetGroupDetails'
GO

CREATE Procedure [dbo].ws_spGetGroupDetails
(
	@userGroupMember XML
)
AS
BEGIN 		
	
	DECLARE @xmlc XML
	
	DECLARE @userGroupId UNIQUEIDENTIFIER
    SET @userGroupId = (SELECT data.value('data(UserGroupId)[1]', 'uniqueidentifier')  FROM @userGroupMember.nodes('UserGroupMember') AS ref(data))


	SELECT @xmlc = ( SELECT (
		SELECT  ug.UserGroupId, ug.UserGroupName, ug.GroupImageUrl, ( SELECT ugm.UserId, up.ProfileName, up.ImageUrl
              FROM [dbo].[ws_UserGroupMember] ugm INNER JOIN ws_UserProfile up ON up.UserId = ugm.UserId              
              WHERE ugm.UserGroupId = @userGroupId FOR XML PATH('UserGroupMember'),TYPE ) AS 'UserGroupMemberList'
		FROM [dbo].[ws_UserGroup] ug
		WHERE ug.UserGroupId = @userGroupId 
		AND ug.IsDeleted = 0 
	  FOR XML PATH(''), ROOT('UserGroup')
	)   )
	
	
	SELECT @xmlc   
END

GO
PRINT 'PROCEDURE ws_spGetGroupDetails created.'
GO


