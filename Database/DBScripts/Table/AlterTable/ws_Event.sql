--Adding Colummns to table
PRINT 'Adding column IsRecurring for the table ws_Event...'
IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_Event' and type='U')
BEGIN
	IF  NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_Event]') AND name='IsRecurring')
	Begin
		ALTER TABLE ws_Event
		ADD IsRecurring bit NOT NULL
		DEFAULT ((0))
		PRINT 'Added column <[IsRecurring]> for the table <ws_Event>'	
	End
	Else
		PRINT 'Column <[IsRecurring]> already exists  for the table <ws_Event>'
END
ELSE
	PRINT 'Table <ws_Event> not exists'
GO

PRINT 'Adding column RecurrenceFrequencyTypeId for the table ws_Event...'
IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_Event' and type='U')
BEGIN
	IF  NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_Event]') AND name='RecurrenceFrequencyTypeId')
	Begin
		ALTER TABLE ws_Event
		ADD RecurrenceFrequencyTypeId int NULL
		PRINT 'Added column <[RecurrenceFrequencyTypeId]> for the table <ws_Event>'	
	End
	Else
		PRINT 'Column <[RecurrenceFrequencyTypeId]>  already exists for the table <ws_Event>'
END
ELSE
	PRINT 'Table <ws_Event> not exists'
GO

PRINT 'Adding column RecurrenceCount for the table ws_Event...'
IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_Event' and type='U')
BEGIN
	IF  NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_Event]') AND name='RecurrenceCount')
	Begin
		ALTER TABLE ws_Event
		ADD RecurrenceCount int NULL
		PRINT 'Added column <[RecurrenceCount]> for the table <ws_Event>'	
	End
	Else
		PRINT 'Column <[RecurrenceCount]>  already exists for the table <ws_Event>'
END
ELSE
	PRINT 'Table <ws_Event> not exists'
GO


PRINT 'Adding column RecurrenceFrequency for the table ws_Event...'
IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_Event' and type='U')
BEGIN
	IF  NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_Event]') AND name='RecurrenceFrequency')
	Begin
		ALTER TABLE ws_Event
		ADD RecurrenceFrequency int NULL
		PRINT 'Added column <[RecurrenceFrequency]> for the table <ws_Event>'	
	End
	Else
		PRINT 'Column <[RecurrenceFrequency]>  already exists for the table <ws_Event>'
END
ELSE
	PRINT 'Table <ws_Event> not exists'
GO

PRINT 'Adding column RecurrenceDaysOfWeek for the table ws_Event...'
IF EXISTS(SELECT 1 FROM SYS.OBJECTS WHERE name='ws_Event' and type='U')
BEGIN
	IF  NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ws_Event]') AND name='RecurrenceDaysOfWeek')
	Begin
		ALTER TABLE ws_Event
		ADD RecurrenceDaysOfWeek NVARCHAR(50) NULL
		PRINT 'Added column <[RecurrenceDaysOfWeek]> for the table <ws_Event>'	
	End
	Else
		PRINT 'Column <[RecurrenceDaysOfWeek]>  already exists for the table <ws_Event>'
END
ELSE
	PRINT 'Table <ws_Event> not exists'
GO