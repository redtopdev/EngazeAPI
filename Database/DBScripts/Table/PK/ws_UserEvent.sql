-- Adding Primary Key Constraint pk_ws_UserEvent for the table ws_UserEvent 
PRINT 'Adding Primary Key Constraint pk_ws_UserEvent for the table ws_UserEvent'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_UserEvent' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_UserEvent' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_UserEvent
			ADD CONSTRAINT pk_ws_UserEvent 
			PRIMARY KEY (EventId,UserId)
			PRINT 'Added Primary Key Constraint pk_ws_UserEvent for the table ws_UserEvent'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_UserEvent for the table ws_UserEvent Exists'
	  
	  END
ELSE

PRINT 'Table ws_UserEvent Not Found'

GO
