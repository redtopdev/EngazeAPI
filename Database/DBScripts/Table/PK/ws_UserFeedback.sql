-- Adding Primary Key Constraint pk_ws_UserFeedback for the table ws_UserFeedback 
PRINT 'Adding Primary Key Constraint pk_ws_UserFeedback for the table ws_UserFeedback'
GO

IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='ws_UserFeedback' AND TYPE='U')
BEGIN
     
      IF NOT EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE NAME='pk_ws_UserFeedback' and TYPE='PK')
      BEGIN
			ALTER TABLE ws_UserFeedback
			ADD CONSTRAINT pk_ws_UserFeedback 
			PRIMARY KEY (UserFeedbackId)
			PRINT 'Added Primary Key Constraint pk_ws_UserFeedback for the table ws_UserFeedback'
	  END
	  ELSE
			PRINT 'Already Primary Key Constraint pk_ws_UserFeedback for the table ws_UserFeedback Exists'
	  
	  END
ELSE

PRINT 'Table ws_UserFeedback Not Found'

GO
