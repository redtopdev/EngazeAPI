/***************************************
# Object:  Add Primary key for Table ws_UserEventStateLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-06-14
**************************************************/

-- Adding Primary Key Constraint pk_ws_UserEventStateLookup for the table ws_UserEventStateLookup 
PRINT 'Adding Primary Key Constraint pk_ws_UserEventStateLookup for the table ws_UserEventStateLookup'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_UserEventStateLookup' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_UserEventStateLookup' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_UserEventStateLookup
			ADD CONSTRAINT pk_ws_UserEventStateLookup 
			PRIMARY KEY (UserEventStateId)
			PRINT 'Added Primary Key Constraint pk_ws_UserEventStateLookup for the table ws_UserEventStateLookup'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_UserEventStateLookup for the table ws_UserEventStateLookup Exists'
	  
	  END
ELSE

PRINT 'Table ws_UserEventStateLookup Not Found'

GO
