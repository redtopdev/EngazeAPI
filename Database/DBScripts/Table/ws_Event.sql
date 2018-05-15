-- Create Table ws_Event
print 'Creating Table ws_Event'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_Event]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_Event]
	(  
         EventId UNIQUEIDENTIFIER NOT NULL,
         NAME VARCHAR(100) NOT NULL ,
         EventTypeId INT NOT NULL, 
         Description NVARCHAR(MAX) NULL,
         StartTime DateTime NOT NULL,
         EndTime DateTime NULL,
         Duration INT DEFAULT 60,
         InitiatorId UNIQUEIDENTIFIER NOT NULL,
         EventStateId INT NOT NULL, 
         TrackingStateId INT NOT NULL,
         TrackingStopTime DateTime NOT NULL, 
         DestinationLatitude DECIMAL(9,6),
         DestinationLongitude DECIMAL(9,6), 
         DestinationName VARCHAR(100) NULL, 
         DestinationAddress NVARCHAR(500) NULL, 
         IsTrackingRequired BIT,
         ReminderTypeId INT NOT NULL,
         ReminderOffset  DECIMAL(9,2), --Interval prior to The Start Time at which Reminder has to be shown
         TrackingStartOffset  DECIMAL(9,2), -- Interval prior to The Start Time at which Tracking has to be started
         IsRecurring BIT NOT NULL,
         RecurrenceFrequencyTypeId INT NULL,
         RecurrenceCount INT NULL,        
         RecurrenceFrequency INT NULL,  
         RecurrenceDaysOfWeek NVARCHAR(50) NULL, 
         IsDeleted BIT NOT NULL,
         CreatedOn DateTime NOT NULL,
         ModifiedBy UNIQUEIDENTIFIER NULL,
         ModifiedOn DateTime NULL
     )  

	print 'ws_Event table is Created'
END
ELSE BEGIN
	print 'ws_Event table already exists'
END
GO