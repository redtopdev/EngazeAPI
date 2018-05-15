-- Adding Primary Key Constraint pk_ws_UserProfile for the table ws_UserProfile 
PRINT 'Adding Primary Key Constraint pk_ws_UserProfile for the table ws_UserProfile'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_UserProfile' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_UserProfile' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_UserProfile
			ADD CONSTRAINT pk_ws_UserProfile 
			PRIMARY KEY (UserId)
			PRINT 'Added Primary Key Constraint pk_ws_UserProfile for the table ws_UserProfile'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_UserProfile for the table ws_UserProfile Exists'
	  
	  END
ELSE

PRINT 'Table ws_UserProfile Not Found'

GO
