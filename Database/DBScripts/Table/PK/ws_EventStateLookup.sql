/***************************************
# Object:  Add Primary key for Table ws_EventStateLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-06-14
**************************************************/

-- Adding Primary Key Constraint pk_ws_EventStateLookup for the table ws_EventStateLookup 
PRINT 'Adding Primary Key Constraint pk_ws_EventStateLookup for the table ws_EventStateLookup'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_EventStateLookup' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_EventStateLookup' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_EventStateLookup
			ADD CONSTRAINT pk_ws_EventStateLookup 
			PRIMARY KEY (EventStateId)
			PRINT 'Added Primary Key Constraint pk_ws_EventStateLookup for the table ws_EventStateLookup'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_EventStateLookup for the table ws_EventStateLookup Exists'
	  
	  END
ELSE

PRINT 'Table ws_EventStateLookup Not Found'

GO
