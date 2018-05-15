-- Create Table ws_UserEvent
print 'Creating Table ws_UserEvent'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserEvent]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_UserEvent]
	(
		UserEventId UNIQUEIDENTIFIER NOT NULL,
		EventId UNIQUEIDENTIFIER NOT NULL,
		UserId UNIQUEIDENTIFIER NULL,
		UserGroupId UNIQUEIDENTIFIER NULL,
		RequestAcceptanceState INT NOT NULL DEFAULT 0,
		IsTrackingAccepted BIT NOT NULL DEFAULT 0,
		TrackingStartTime DATETIME,
		TrackingEndTime DATETIME,
		TrackingEndReason INT,
		IsTrackingActive BIT NOT NULL DEFAULT 0,
		IsEventActive BIT NOT NULL DEFAULT 0,
		UserEventEndTime DATETIME NULL,
		IsDeleted BIT NOT NULL,
		UserEventStateId INT NOT NULL DEFAULT 1,
		IsUserLocationShared BIT NOT NULL DEFAULT 1,
    )
	print 'ws_UserEvent table is Created'
END
ELSE BEGIN
	print 'ws_UserEvent table already exists'
END
GO
