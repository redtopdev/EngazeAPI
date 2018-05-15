IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_Event' and type='U') 
BEGIN
		PRINT 'Adding Foreign Key Constraint fk_ws_Event_ws_UserProfile for the table ws_Event...'	 
		IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_UserProfile' and type='U')
		BEGIN
			IF  EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserProfile]') AND name='UserId')
			Begin
				IF  EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_Event]') AND name='InitiatorId')
				Begin
					IF Not EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='fk_ws_Event_ws_UserProfile' and type='F')
					BEGIN
						ALTER TABLE [dbo].[ws_Event]
						ADD CONSTRAINT [fk_ws_Event_ws_UserProfile]
						FOREIGN KEY (InitiatorId) REFERENCES [dbo].[ws_UserProfile] (UserID)
						PRINT 'Added Foreign Key  Constraint fk_ws_Event_ws_UserProfile for the table ws_Event'
					END
					ELSE
						PRINT 'Already Foreign Key Constraint fk_ws_Event_ws_UserProfile for the table ws_Event is exists'
				END
				ELSE
					PRINT 'Column InitiatorId for the table ws_Event not exists'
			END
			ELSE
				PRINT 'Column UserId for the table ws_UserProfile not exists'
		END
		ELSE
			PRINT 'Table ws_UserProfile does not exist'
END
ELSE
	  PRINT 'Table ws_Event not found'
GO
