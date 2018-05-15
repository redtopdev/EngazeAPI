/***************************************
# Object:  Add Primary key for Table ws_TrackingStateLookup   
CreatedBy : Shyam Sunder
CreatedOn : 2015-06-14
**************************************************/

-- Adding Primary Key Constraint pk_ws_TrackingStateLookup for the table ws_TrackingStateLookup 
PRINT 'Adding Primary Key Constraint pk_ws_TrackingStateLookup for the table ws_TrackingStateLookup'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_TrackingStateLookup' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_TrackingStateLookup' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_TrackingStateLookup
			ADD CONSTRAINT pk_ws_TrackingStateLookup 
			PRIMARY KEY (TrackingStateId)
			PRINT 'Added Primary Key Constraint pk_ws_TrackingStateLookup for the table ws_TrackingStateLookup'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_TrackingStateLookup for the table ws_TrackingStateLookup Exists'
	  
	  END
ELSE

PRINT 'Table ws_TrackingStateLookup Not Found'

GO
