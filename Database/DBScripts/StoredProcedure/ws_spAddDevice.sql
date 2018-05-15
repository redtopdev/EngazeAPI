/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddDevice] to insert Device Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddDevice]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddDevice'
   DROP PROCEDURE [dbo].ws_spAddDevice
END
GO

PRINT 'Creating PROCEDURE ws_spAddDevice'
GO

CREATE Procedure [dbo].ws_spAddDevice
(
	@device XML
)
AS
BEGIN 

	INSERT INTO [dbo].[ws_Device]
           (
			[DeviceId],[ClientAuthenticationCode],[IMEINumber],[MobileNumber],[IsDeleted]
			,[CreatedOn],[CreatedBy],[ModifiedOn],[ModifiedBy]
           )

     SELECT
			NEWID(),
			data.value('data(ClientAuthenticationCode)[1]', 'varchar(max)') ,
			data.value('data(IMEINumber)[1]','varchar(20)') ,
			data.value('data(MobileNumber)[1]','varchar(20)') ,
			data.value('data(IsDeleted)[1]','bit'),
			GETUTCDATE() ,
			data.value('data(CreatedBy)[1]', 'VARCHAR(200)') ,
			GETUTCDATE() ,
			data.value('data(ModifiedBy)[1]', 'VARCHAR(200)') ) 
   FROM @device.nodes('Device') AS ref(data)
   
   SELECT SCOPE_IDENTITY()  AS 'Id'		 
   
END

GO
PRINT 'PROCEDURE ws_spAddDevice created.'
GO


