/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddUserFeedback] to store user feedback.    
CreatedBy : Shyam
CreatedOn : 2015-04-17
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddUserFeedback]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddUserFeedback'
   DROP PROCEDURE [dbo].ws_spAddUserFeedback
END
GO

PRINT 'Creating PROCEDURE ws_spAddUserFeedback'
GO

CREATE Procedure [dbo].ws_spAddUserFeedback
(
	@userFeedback XML
)
AS
BEGIN 

	DECLARE @userId NVARCHAR(100)
	DECLARE @userEmailId NVARCHAR(100)
	
	
	SELECT @userId = data.value('data(RequestorId)[1]','NVARCHAR(100)') FROM @userFeedback.nodes('UserFeedback') AS ref(data)
	SELECT @userEmailId = Email FROM [dbo].[ws_UserProfile] WHERE UserId = @userId
	
	
	IF  (@userEmailId is not null)
	BEGIN 
		
		INSERT INTO [dbo].[ws_UserFeedback]
			   (
				[UserFeedbackId], [UserId],[Feedback],[FeedbackCategory],[CreatedOn],[UserEmailId]
			   )
		 SELECT
				newid(),
				@userId,
				data.value('data(Feedback)[1]','VARCHAR(MAX)') ,			
				data.value('data(FeedbackCategory)[1]','VARCHAR(20)') ,
				GETUTCDATE() ,
				@userEmailId
	   FROM @userFeedback.nodes('UserFeedback') AS ref(data)
	   SELECT 1;
   END
   ELSE
   BEGIN
	   SELECT 0;
   END
   
END

GO
PRINT 'PROCEDURE ws_spAddUserFeedback created.'
GO


