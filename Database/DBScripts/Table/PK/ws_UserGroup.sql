-- Adding Primary Key Constraint pk_ws_UserGroup for the table ws_UserGroup 
PRINT 'Adding Primary Key Constraint pk_ws_UserGroup for the table ws_UserGroup'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_UserGroup' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_UserGroup' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_UserGroup
			ADD CONSTRAINT pk_ws_UserGroup 
			PRIMARY KEY (UserGroupId)
			PRINT 'Added Primary Key Constraint pk_ws_UserGroup for the table ws_UserGroup'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_UserGroup for the table ws_UserGroup Exists'
	  
	  END
ELSE

PRINT 'Table ws_UserGroup Not Found'

GO
