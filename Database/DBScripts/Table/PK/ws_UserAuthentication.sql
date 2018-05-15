-- Adding Primary Key Constraint pk_ws_UserAuthentication for the table ws_UserAuthentication 
PRINT 'Adding Primary Key Constraint pk_ws_UserAuthentication for the table ws_UserAuthentication'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_UserAuthentication' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_UserAuthentication' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_UserAuthentication
			ADD CONSTRAINT pk_ws_UserAuthentication 
			PRIMARY KEY (UserAuthenticationID)
			PRINT 'Added Primary Key Constraint pk_ws_UserAuthentication for the table ws_UserAuthentication'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_UserAuthentication for the table ws_UserAuthentication Exists'
	  
	  END
ELSE

PRINT 'Table ws_UserAuthentication Not Found'

GO
