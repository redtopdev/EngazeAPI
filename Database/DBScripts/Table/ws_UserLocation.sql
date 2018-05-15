-- Create Table ws_UserLocation
print 'Creating Table ws_UserLocation'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserLocation]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_UserLocation]
	(
        UserLocationId UNIQUEIDENTIFIER NOT NULL,
        UserId UNIQUEIDENTIFIER NOT NULL,
        Latitude DECIMAL(9,6)NOT NULL,
        Longitude DECIMAL(9,6)NOT NULL,
        LocationAddress NVARCHAR(MAX), 
		IsDeleted BIT NOT NULL,
        CreatedOn  DATETIME NOT NULL,-- //Time at which location was tracked.
        ETA DECIMAL(5,2) NULL,
		ArrivalStatus INT--  // On time, ahead, delayed
)  

	print 'ws_UserLocation table is Created'
END
ELSE BEGIN
	print 'ws_UserLocation table already exists'
END
GO
