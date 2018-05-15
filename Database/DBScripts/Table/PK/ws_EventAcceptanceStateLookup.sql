/***************************************
# Object:  Add Primary key for Table ws_EventAcceptanceStateLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-06-14
**************************************************/

-- Adding Primary Key Constraint pk_ws_EventAcceptanceStateLookup for the table ws_EventAcceptanceStateLookup 
PRINT 'Adding Primary Key Constraint pk_ws_EventAcceptanceStateLookup for the table ws_EventAcceptanceStateLookup'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_EventAcceptanceStateLookup' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_EventAcceptanceStateLookup' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_EventAcceptanceStateLookup
			ADD CONSTRAINT pk_ws_EventAcceptanceStateLookup 
			PRIMARY KEY (EventAcceptanceStateId)
			PRINT 'Added Primary Key Constraint pk_ws_EventAcceptanceStateLookup for the table ws_EventAcceptanceStateLookup'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_EventAcceptanceStateLookup for the table ws_EventAcceptanceStateLookup Exists'
	  
	  END
ELSE

PRINT 'Table ws_EventAcceptanceStateLookup Not Found'

GO
