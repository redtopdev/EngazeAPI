IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_UserEvent' and type='U') 
BEGIN
		PRINT 'Adding Foreign Key Constraint fk_ws_UserEvent_ws_UserProfile for the table ws_UserEvent...'	 
		IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_UserProfile' and type='U')
		BEGIN
			IF  EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserProfile]') AND name='UserId')
			Begin
				IF  EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserEvent]') AND name='UserId')
				Begin
					IF Not EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='fk_ws_UserEvent_ws_UserProfile' and type='F')
					BEGIN
						ALTER TABLE [dbo].[ws_UserEvent]
						ADD CONSTRAINT [fk_ws_UserEvent_ws_UserProfile]
						FOREIGN KEY (UserId) REFERENCES [dbo].[ws_UserProfile] (UserID)
						PRINT 'Added Foreign Key  Constraint fk_ws_UserEvent_ws_UserProfile for the table ws_UserEvent'
					END
					ELSE
						PRINT 'Already Foreign Key Constraint fk_ws_UserEvent_ws_UserProfile for the table ws_UserEvent is exists'
				END
				ELSE
					PRINT 'Column UserId for the table ws_UserEvent not exists'
			END
			ELSE
				PRINT 'Column UserId for the table ws_UserProfile not exists'
		END
		ELSE
			PRINT 'Table ws_UserProfile does not exist'
			
			
		IF  EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_Event]') AND name='EventId')
			Begin
				IF  EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserEvent]') AND name='EventId')
				Begin
					IF Not EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='fk_ws_UserEvent_ws_Event' and type='F')
					BEGIN
						ALTER TABLE [dbo].[ws_UserEvent]
						ADD CONSTRAINT [fk_ws_UserEvent_ws_Event]
						FOREIGN KEY (EventId) REFERENCES [dbo].[ws_Event] (EventId)
						PRINT 'Added Foreign Key  Constraint fk_ws_UserEvent_ws_Event for the table ws_UserEvent'
					END
					ELSE
						PRINT 'Already Foreign Key Constraint fk_ws_UserEvent_ws_Event for the table ws_UserEvent is exists'
				
				END
				ELSE
					PRINT 'Column EventId for the table ws_UserEvent not exists'
			END
			ELSE
				PRINT 'Column EventId for the table ws_Event not exists'
	
END
ELSE
	  PRINT 'Table ws_UserEvent not found'
GO
