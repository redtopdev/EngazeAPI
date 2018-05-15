/***************************************
# Object:  StoredProcedure [dbo].[ws_spLeaveUserGroup] to Leave from UserGroup.    
CreatedBy : Shyam
CreatedOn : 2015-05-26
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spLeaveUserGroup]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spLeaveUserGroup'
   DROP PROCEDURE [dbo].ws_spLeaveUserGroup
END
GO

PRINT 'Creating PROCEDURE ws_spLeaveUserGroup'
GO

CREATE Procedure [dbo].ws_spLeaveUserGroup
(
	@userGroupRequest XML
)
AS
BEGIN 		
	
	DECLARE @groupId UNIQUEIDENTIFIER
    SET @groupId = (SELECT data.value('data(UserGroupId)[1]', 'uniqueidentifier')  FROM @userGroupRequest.nodes('UserGroupRequest') AS ref(data))

	--DECLARE @userId UNIQUEIDENTIFIER
 --   SET @userId = (SELECT data.value('data(UserId)[1]', 'uniqueidentifier')  FROM @userGroupMember.nodes('UserGroupMember') AS ref(data))

	DECLARE @requestorId UNIQUEIDENTIFIER
    SET @requestorId = (SELECT data.value('data(RequestorId)[1]', 'uniqueidentifier')  FROM @userGroupRequest.nodes('UserGroupRequest') AS ref(data))


		IF EXISTS (SELECT 1 FROM [dbo].[ws_UserGroupMember] WHERE UserGroupId = @groupId AND IsAdmin = 1 AND UserId <> @requestorId)
		BEGIN
			UPDATE [dbo].[ws_UserGroupMember]
			SET    [IsDeleted] = 1 ,
				   [IsAdmin] = 0 ,
				   [ModifiedBy] = @requestorId ,
				   [ModifiedOn] = GETUTCDATE()	    
			WHERE  UserGroupId = @groupId AND UserId = @requestorId	
			SELECT 'SUCCESS' as Result
		END
		ELSE
		BEGIN 
			SELECT 'No other admin than the current user and hence request denied. Please mark another user admin before deleting the only admin.' as Result
		END 

END

GO
PRINT 'PROCEDURE ws_spLeaveUserGroup created.'
GO


