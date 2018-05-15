/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddUserAuthentication] to insert userAuth Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddUserAuthentication]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddUserAuthentication'
   DROP PROCEDURE [dbo].ws_spAddUserAuthentication
END
GO

PRINT 'Creating PROCEDURE ws_spAddUserAuthentication'
GO

CREATE Procedure [dbo].ws_spAddUserAuthentication
(
	@userAuthentication XML
)
AS
BEGIN 
	INSERT INTO [dbo].[ws_UserAuthentication]
           (
			[UserAuthenticationID],[UserID],[Token],[Salt],[IsDeleted],[CreatedOn],[LastAccessedOn]
           )
     SELECT
			NEWID(),
			data.value('data(UserID )[1]', 'uniqueidentifier'),
			data.value('data(Token)[1]', 'varchar(200)') ,
			data.value('data(Salt)[1]','varchar(200)') ,
			data.value('data(IsDeleted)[1]', 'BIT') ,
			data.value('data(CreatedOn)[1]','datetime') ,
			GETUTCDATE()
   FROM @userAuthentication.nodes('Event') AS ref(data)
   
   SELECT SCOPE_IDENTITY()  AS 'Id'		 
   
END

GO
PRINT 'PROCEDURE ws_spAddUserAuthentication created.'
GO


