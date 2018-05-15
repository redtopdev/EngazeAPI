/***************************************
# Object:  Add Primary key for Table ws_RecurrenceFrequencyLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2016-03-19
**************************************************/

-- Adding Primary Key Constraint pk_ws_RecurrenceFrequencyLookup for the table ws_RecurrenceFrequencyLookup 
PRINT 'Adding Primary Key Constraint pk_ws_RecurrenceFrequencyLookup for the table ws_RecurrenceFrequencyLookup'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_RecurrenceFrequencyLookup' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_RecurrenceFrequencyLookup' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_RecurrenceFrequencyLookup
			ADD CONSTRAINT pk_ws_RecurrenceFrequencyLookup 
			PRIMARY KEY (RecurrenceFrequencyTypeId)
			PRINT 'Added Primary Key Constraint pk_ws_RecurrenceFrequencyLookup for the table ws_RecurrenceFrequencyLookup'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_RecurrenceFrequencyLookup for the table ws_RecurrenceFrequencyLookup Exists'
	  
	  END
ELSE

PRINT 'Table ws_RecurrenceFrequencyLookup Not Found'

GO
