-- Create Table ws_UserFeedback
print 'Creating Table ws_UserFeedback'
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_UserFeedback]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ws_UserFeedback]
	(
        UserFeedbackId UNIQUEIDENTIFIER NOT NULL,
        UserId UNIQUEIDENTIFIER NOT NULL,
        UserEmailId VARCHAR(100) NOT NULL, 
        Feedback NVARCHAR(MAX) NOT NULL,
        FeedbackCategory NVARCHAR(20),
        CreatedOn DATETIME NOT NULL
    )
	print 'ws_UserFeedback table is Created'
END
ELSE BEGIN
	print 'ws_UserFeedback table already exists'
END
GO