/***************************************
# Object:  StoredProcedure [dbo].[ws_spAddUserLocation] to insert UserLocation Info.    
CreatedBy : Atul Sagar
CreatedOn : 2015-04-04
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spAddUserLocation]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spAddUserLocation'
   DROP PROCEDURE [dbo].ws_spAddUserLocation
END
GO

PRINT 'Creating PROCEDURE ws_spAddUserLocation'
GO

CREATE Procedure [dbo].ws_spAddUserLocation
(
	@userLocation XML
)
AS
BEGIN 
    DECLARE @userLocationId nvarchar(max)
    DECLARE @userId nvarchar(max)
    
    SET @userId = (SELECT data.value('data(UserId)[1]', 'nvarchar(max)')  FROM @userLocation.nodes('UserLocation') AS ref(data))    
    
        
    IF NOT EXISTS (SELECT 1 FROM [dbo].[ws_UserLocation] WHERE UserId = @userId)
    BEGIN
    		SET @userLocationId = NEWID()
			INSERT INTO [dbo].[ws_UserLocation]
		           (
					[UserLocationId],[UserId],[Latitude],[Longitude],[LocationAddress],[IsDeleted],[CreatedOn],[ETA],[ArrivalStatus]
		           )
		     SELECT
					@userLocationId,
					data.value('data(UserId)[1]', 'nvarchar(max)'),
					data.value('data(Latitude)[1]', 'DECIMAL(9,6)') ,
					data.value('data(Longitude)[1]','DECIMAL(9,6)') ,
					data.value('data(LocationAddress)[1]','NVARCHAR(MAX)') ,
					0 ,
					GETUTCDATE(),
					data.value('data(ETA)[1]','decimal(5,2)') ,
					data.value('data(ArrivalStatus)[1]','INT')
		   FROM @userLocation.nodes('UserLocation') AS ref(data)
   END
   
   ELSE
      BEGIN
		SELECT TOP 1 @userLocationId = UserLocationId FROM [dbo].[ws_UserLocation] WHERE UserId = @userId
		
		UPDATE [dbo].[ws_UserLocation]
		SET  Latitude = data.value('data(Latitude)[1]', 'DECIMAL(9,6)') ,
			 Longitude = data.value('data(Longitude)[1]','DECIMAL(9,6)') ,
			 LocationAddress = data.value('data(LocationAddress)[1]','NVARCHAR(MAX)') ,
			 IsDeleted = 0,
			 CreatedOn = GETUTCDATE(),
			 ETA = data.value('data(ETA)[1]','decimal(5,2)') ,
			 ArrivalStatus = data.value('data(ArrivalStatus)[1]','INT')
	    FROM @userLocation.nodes('UserLocation') AS ref(data)   
		WHERE UserId = @userId
		
	END

	SELECT @userLocationId  AS 'Id'		 
		
END
GO
PRINT 'PROCEDURE ws_spAddUserLocation created.'
GO


