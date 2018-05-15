/***************************************
# Object:  Add Primary key for Table ws_EventTypeLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-06-14
**************************************************/

-- Adding Primary Key Constraint pk_ws_EventTypeLookup for the table ws_EventTypeLookup 
PRINT 'Adding Primary Key Constraint pk_ws_EventTypeLookup for the table ws_EventTypeLookup'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_EventTypeLookup' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_EventTypeLookup' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_EventTypeLookup
			ADD CONSTRAINT pk_ws_EventTypeLookup 
			PRIMARY KEY (EventTypeId)
			PRINT 'Added Primary Key Constraint pk_ws_EventTypeLookup for the table ws_EventTypeLookup'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_EventTypeLookup for the table ws_EventTypeLookup Exists'
	  
	  END
ELSE

PRINT 'Table ws_EventTypeLookup Not Found'

GO
