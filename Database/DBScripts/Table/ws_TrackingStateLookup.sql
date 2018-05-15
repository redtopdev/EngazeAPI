/***************************************
# Object:  Create Table ws_TrackingStateLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-04-18
**************************************************/

print 'Creating Table ws_TrackingStateLookup'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_TrackingStateLookup]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_TrackingStateLookup]
	(  
         TrackingStateId int NOT NULL,
         TrackingState VARCHAR(20) NOT NULL ,
         IsDeleted bit NOT NULL, 
         CreatedBy UNIQUEIDENTIFIER NOT NULL,
         CreatedOn DateTime NOT NULL,
         ModifiedBy UNIQUEIDENTIFIER NULL,
         ModifiedOn DateTime NULL
     )  

	print 'ws_TrackingStateLookup table is Created'
END
ELSE BEGIN
	print 'ws_TrackingStateLookup table already exists'
END
GO