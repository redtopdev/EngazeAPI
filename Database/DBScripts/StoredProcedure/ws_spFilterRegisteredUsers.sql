/***************************************
# Object:  StoredProcedure [dbo].[ws_spFilterRegisteredUsers] to filter registered users from a list of Phone numbers.    
CreatedBy : Shyam
CreatedOn : 2015-06-30
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spFilterRegisteredUsers]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spFilterRegisteredUsers'
   DROP PROCEDURE [dbo].ws_spFilterRegisteredUsers
END
GO

PRINT 'Creating PROCEDURE ws_spFilterRegisteredUsers'
GO

CREATE Procedure [dbo].ws_spFilterRegisteredUsers
(
	@userProfiles XML
)
AS
BEGIN 
	
	SELECT UserId from ws_UserProfile where PhoneNumber in(	
	SELECT  T.Item.value('PhoneNumber[1]', 'uniqueidentifier') as PhoneNumber
	FROM @userProfiles.nodes('UserProfiles/UserProfile')  T(Item) )	
	   
   
END

GO
PRINT 'PROCEDURE ws_spFilterRegisteredUsers created.'
GO


