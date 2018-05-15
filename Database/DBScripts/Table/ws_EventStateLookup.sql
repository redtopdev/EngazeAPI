/***************************************
# Object:  Create Table ws_EventStateLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-04-18
**************************************************/

print 'Creating Table ws_EventStateLookup'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_EventStateLookup]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_EventStateLookup]
	(  
         EventStateId int NOT NULL,
         EventState VARCHAR(20) NOT NULL ,
         IsDeleted bit NOT NULL, 
         CreatedBy UNIQUEIDENTIFIER NOT NULL,
         CreatedOn DateTime NOT NULL,
         ModifiedBy UNIQUEIDENTIFIER NULL,
         ModifiedOn DateTime NULL
     )  

	print 'ws_EventStateLookup table is Created'
END
ELSE BEGIN
	print 'ws_EventStateLookup table already exists'
END
GO