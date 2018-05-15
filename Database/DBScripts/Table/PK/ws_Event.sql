-- Adding Primary Key Constraint pk_ws_Event for the table ws_Event 
PRINT 'Adding Primary Key Constraint pk_ws_Event for the table ws_Event'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_Event' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_Event' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_Event
			ADD CONSTRAINT pk_ws_Event 
			PRIMARY KEY (EventId)
			PRINT 'Added Primary Key Constraint pk_ws_Event for the table ws_Event'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_Event for the table ws_Event Exists'
	  
	  END
ELSE

PRINT 'Table ws_Event Not Found'

GO
