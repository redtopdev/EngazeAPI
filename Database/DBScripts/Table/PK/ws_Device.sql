-- Adding Primary Key Constraint pk_ws_Device for the table ws_Device 
PRINT 'Adding Primary Key Constraint pk_ws_Device for the table ws_Device'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_Device' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_Device' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_Device
			ADD CONSTRAINT pk_ws_Device 
			PRIMARY KEY (DeviceId)
			PRINT 'Added Primary Key Constraint pk_ws_Device for the table ws_Device'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_Device for the table ws_Device Exists'
	  
	  END
ELSE

PRINT 'Table ws_Device Not Found'

GO
