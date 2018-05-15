/***************************************
# Object:  StoredProcedure [dbo].[ws_spGetRegisteredContacts] to check registered contacts from given list of phonenumbers.    
CreatedBy : Shyam
CreatedOn : 2015-08-05
**************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ws_spGetRegisteredContacts]') 
    AND type in (N'P', N'PC'))
BEGIN
   PRINT 'DROPPING PROCEDURE ws_spGetRegisteredContacts'
   DROP PROCEDURE [dbo].ws_spGetRegisteredContacts
END
GO

PRINT 'Creating PROCEDURE ws_spGetRegisteredContacts'
GO

CREATE Procedure [dbo].ws_spGetRegisteredContacts
(
	@contactsRequest XML
)
AS
BEGIN 				
	DECLARE @RequestorId UNIQUEIDENTIFIER
	SET @RequestorId = (SELECT data.value('data(RequestorId)[1]', 'uniqueidentifier')  FROM @contactsRequest.nodes('ContactsRequest') AS ref(data))

    -- first insert all records to temp table
	--SELECT 	T.Item.value('.','NVARCHAR(25)') as MobileNumberStoredInRequestorPhone,
	--(CASE WHEN ( charindex('+', T.Item.value('.','NVARCHAR(25)')) <= 0  )
	--THEN
	--			'requestor_countrycode'
	--ELSE
	--		   LEFT(T.Item.value('.','NVARCHAR(25)'), LEN(T.Item.value('.','NVARCHAR(25)'))-10)
	--END) as CountryCode,
	--RIGHT(T.Item.value('.','NVARCHAR(25)'),10) as MobileNumber	
	--INTO #tmpContactList
	--FROM @contactsRequest.nodes('ContactsRequest/ContactList/string')  T(Item) 

	--SELECT 	T.Item.value('data(MobileNumberStoredInRequestorPhone)[1]','NVARCHAR(25)') as MobileNumberStoredInRequestorPhone,
	--T.Item.value('data(CountryCode)[1]','NVARCHAR(25)') as CountryCode,
	--T.Item.value('data(MobileNumber)[1]','NVARCHAR(25)') as MobileNumber	
	--INTO #tmpContactList
	--FROM @contactsRequest.nodes('ContactsRequest/ContactListFormatted/PhoneContact')  T(Item) 

	CREATE TABLE #TempXml (   
			xmlData XML)  
	
	INSERT  INTO #TempXml   
		VALUES (@contactsRequest)
		
	--Update country code to country code of Requestor wherever the PhoneNumber does not have specific Country code mentioned
	--UPDATE #tmpContactList
	--SET CountryCode = (SELECT TOP 1 CountryCode FROM ws_UserProfile WHERE UserId = @RequestorId)
	--WHERE CountryCode = 'requestor_countrycode'
	
	--select PhoneNumbers which are already registered	
	--DECLARE @xmlc XML
	--SELECT @xmlc = ( SELECT (
	--SELECT DISTINCT up.UserId, up.CountryCode, up.MobileNumber, t.MobileNumberStoredInRequestorPhone 
	--FROM [dbo].[ws_UserProfile] up INNER JOIN  #tmpContactList t 
	--on t.MobileNumber = up.MobileNumber and t.CountryCode = up.CountryCode
	--WHERE up.IsDeleted = 0 
 --   FOR XML PATH('PhoneContact'), ROOT('ArrayOfPhoneContact')
	--)   )
	
	DECLARE @xmlc XML
	SELECT @xmlc = ( SELECT (
	SELECT DISTINCT  up.UserId, up.CountryCode, up.MobileNumber, R.node.value('./MobileNumberStoredInRequestorPhone[1]','varchar(20)')  as MobileNumberStoredInRequestorPhone
	FROM #TempXml  CROSS APPLY xmlData.nodes('/ContactsRequest/ContactListFormatted/PhoneContact') R(node)  		
	INNER JOIN ws_userprofile up ON up.MobileNumber=  R.node.value('./MobileNumber[1]','varchar(20)')   
	AND up.CountryCode=  R.node.value('./CountryCode[1]','varchar(20)') 
	FOR XML PATH('PhoneContact'), ROOT('ArrayOfPhoneContact')
	)   )
			
	IF(@xmlc is null)
	BEGIN
		print 'yes it is null' 
		SET @xmlc = '<ArrayOfPhoneContact>			  
					</ArrayOfPhoneContact>'
	END
	--<PhoneContact/>
	SELECT @xmlc   

	DROP TABLE #TempXml
		           
END

GO
PRINT 'PROCEDURE ws_spGetRegisteredContacts created.'
GO


