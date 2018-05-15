/***************************************
# Object:  StoredProcedure [dbo].[ws_spUpdateUserAuthentication] to Update UserAuth Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUpdateUserAuthentication]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUpdateUserAuthentication'
   DROP PROCEDURE [dbo].ws_spUpdateUserAuthentication
END
GO

PRINT 'Creating PROCEDURE ws_spUpdateUserAuthentication'
GO

CREATE Procedure [dbo].ws_spUpdateUserAuthentication
(
	@userAuthentication XML
)
AS
BEGIN 
	UPDATE [dbo].[ws_UserAuthentication]
    SET    Token = data.value('data(Token)[1]', 'varchar(200)') ,
			Salt = data.value('data(Salt)[1]','varchar(200)') ,
			LastAccessedOn = GETUTCDATE() ,
			data.value('data(LastAccessedOn)[1]','datetime') 
   FROM @userAuthentication.nodes('UserAuthentication') AS ref(data)
   WHERE UserId = (SELECT data.value('data(UserId)[1]', 'uniqueidentifier')   FROM @userAuthentication.nodes('UserAuthentication') AS ref(data))
   
END

GO
PRINT 'PROCEDURE ws_spUpdateUserAuthentication created.'
GO


