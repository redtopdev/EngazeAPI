-- Adding Primary Key Constraint pk_ws_UserGroupMember for the table ws_UserGroupMember 
PRINT 'Adding Primary Key Constraint pk_ws_UserGroupMember for the table ws_UserGroupMember'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_UserGroupMember' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_UserGroupMember' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_UserGroupMember
			ADD CONSTRAINT pk_ws_UserGroupMember 
			PRIMARY KEY (UserGroupId,UserId)
			PRINT 'Added Primary Key Constraint pk_ws_UserGroupMember for the table ws_UserGroupMember'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_UserGroupMember for the table ws_UserGroupMember Exists'
	  
	  END
ELSE

PRINT 'Table ws_UserGroupMember Not Found'

GO
