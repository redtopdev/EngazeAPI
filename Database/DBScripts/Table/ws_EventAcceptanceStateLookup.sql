/***************************************
# Object:  Create Table ws_EventAcceptanceStateLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-04-18
**************************************************/

print 'Creating Table ws_EventAcceptanceStateLookup'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_EventAcceptanceStateLookup]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_EventAcceptanceStateLookup]
	(  
         EventAcceptanceStateId int NOT NULL,
         EventAcceptanceState VARCHAR(20) NOT NULL ,
         IsDeleted bit NOT NULL, 
         CreatedBy UNIQUEIDENTIFIER NOT NULL,
         CreatedOn DateTime NOT NULL,
         ModifiedBy UNIQUEIDENTIFIER NULL,
         ModifiedOn DateTime NULL
     )  

	print 'ws_EventAcceptanceStateLookup table is Created'
END
ELSE BEGIN
	print 'ws_EventAcceptanceStateLookup table already exists'
END
GO