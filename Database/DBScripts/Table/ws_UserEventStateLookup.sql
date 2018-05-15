/***************************************
# Object:  Create Table ws_UserEventStateLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-04-18
**************************************************/

print 'Creating Table ws_UserEventStateLookup'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserEventStateLookup]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_UserEventStateLookup]
	(  
         UserEventStateId int NOT NULL,
         UserEventState VARCHAR(20) NOT NULL ,
         IsDeleted bit NOT NULL, 
         CreatedBy UNIQUEIDENTIFIER NOT NULL,
         CreatedOn DateTime NOT NULL,
         ModifiedBy UNIQUEIDENTIFIER NULL,
         ModifiedOn DateTime NULL
     )  

	print 'ws_UserEventStateLookup table is Created'
END
ELSE BEGIN
	print 'ws_UserEventStateLookup table already exists'
END
GO