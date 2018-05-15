-- Adding Primary Key Constraint pk_ws_UserLocation for the table ws_UserLocation 
PRINT 'Adding Primary Key Constraint pk_ws_UserLocation for the table ws_UserLocation'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_UserLocation' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_UserLocation' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_UserLocation
			ADD CONSTRAINT pk_ws_UserLocation 
			PRIMARY KEY (UserLocationId)
			PRINT 'Added Primary Key Constraint pk_ws_UserLocation for the table ws_UserLocation'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_UserLocation for the table ws_UserLocation Exists'
	  
	  END
ELSE

PRINT 'Table ws_UserLocation Not Found'

GO
