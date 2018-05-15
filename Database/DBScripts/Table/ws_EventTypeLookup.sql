/***************************************
# Object:  Create Table ws_EventTypeLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-06-14
**************************************************/

print 'Creating Table ws_EventTypeLookup'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_EventTypeLookup]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_EventTypeLookup]
	(  
         EventTypeId int NOT NULL,
         EventType VARCHAR(20) NOT NULL ,
         Description NVARCHAR(MAX) ,
         IsDeleted bit NOT NULL, 
         CreatedBy UNIQUEIDENTIFIER NOT NULL,
         CreatedOn DateTime NOT NULL,
         ModifiedBy UNIQUEIDENTIFIER NULL,
         ModifiedOn DateTime NULL
     )  

	print 'ws_EventTypeLookup table is Created'
END
ELSE BEGIN
	print 'ws_EventTypeLookup table already exists'
END
GO