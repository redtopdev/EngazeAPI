/***************************************
# Object:  StoredProcedure [dbo].[ws_spUpdateDevice] to update Device Info.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spUpdateDevice]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spUpdateDevice'
   DROP PROCEDURE [dbo].ws_spUpdateDevice
END
GO

PRINT 'Creating PROCEDURE ws_spUpdateDevice'
GO

CREATE Procedure [dbo].ws_spUpdateDevice
(
	@device XML
)
AS
BEGIN 

	UPDATE [ws_Device]
    SET			
			ClientAuthenticationCode = data.value('data(ClientAuthenticationCode)[1]', 'varchar(max)') ,
			IMEINumber = data.value('data(IMEINumber)[1]','varchar(20)') ,
			MobileNumber = data.value('data(MobileNumber)[1]','varchar(20)') ,
			ModifiedOn = GETUTCDATE() ,
			ModifiedBy = data.value('data(ModifiedBy)[1]', 'VARCHAR(200)') 
   FROM @device.nodes('Device') AS ref(data)
   WHERE DeviceId = (SELECT data.value('data(DeviceId)[1]', 'uniqueidentifier')   FROM @device.nodes('Device') AS ref(data))
   
   
END

GO
PRINT 'PROCEDURE ws_spUpdateDevice created.'
GO


