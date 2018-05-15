IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_UserAuthentication' and type='U') 
BEGIN
		PRINT 'Adding Foreign Key Constraint fk_ws_UserAuthentication_ws_UserProfile for the table ws_UserAuthentication...'	 
		IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_UserProfile' and type='U')
		BEGIN
			IF  EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserProfile]') AND name='UserId')
			Begin
				IF  EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserAuthentication]') AND name='UserId')
				Begin
					IF Not EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='fk_ws_UserAuthentication_ws_UserProfile' and type='F')
					BEGIN
						ALTER TABLE [dbo].[ws_UserAuthentication]
						ADD CONSTRAINT [fk_ws_UserAuthentication_ws_UserProfile]
						FOREIGN KEY (UserID) REFERENCES [dbo].[ws_UserProfile] (UserID)
						PRINT 'Added Foreign Key  Constraint fk_ws_UserAuthentication_ws_UserProfile for the table ws_UserAuthentication'
					END
					ELSE
						PRINT 'Already Foreign Key Constraint fk_ws_UserAuthentication_ws_UserProfile for the table ws_UserAuthentication is exists'
				END
				ELSE
					PRINT 'Column UserID for the table ws_UserAuthentication not exists'
			END
			ELSE
				PRINT 'Column UserID for the table ws_UserProfile not exists'
		END
		ELSE
			PRINT 'Table ws_UserProfile does not exist'
END
ELSE
	  PRINT 'Table ws_UserAuthentication not found'
GO
