/***************************************
# Object:  Create Table ws_RecurrenceFrequencyLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2016-03-19
**************************************************/

print 'Creating Table ws_RecurrenceFrequencyLookup'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_RecurrenceFrequencyLookup]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_RecurrenceFrequencyLookup]
	(  
         RecurrenceFrequencyTypeId int NOT NULL,
         RecurrenceFrequencyType VARCHAR(20) NOT NULL ,
         Description NVARCHAR(MAX) ,
         IsDeleted bit NOT NULL, 
         CreatedBy UNIQUEIDENTIFIER NOT NULL,
         CreatedOn DateTime NOT NULL,
         ModifiedBy UNIQUEIDENTIFIER NULL,
         ModifiedOn DateTime NULL
     )  

	print 'ws_RecurrenceFrequencyLookup table is Created'
END
ELSE BEGIN
	print 'ws_RecurrenceFrequencyLookup table already exists'
END
GO