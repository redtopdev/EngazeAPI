  
CREATE Procedure [dbo].ws_spGetRegisteredContacts  
(  
 @contactsRequest XML  
)  
AS  
BEGIN       
 DECLARE @RequestorId UNIQUEIDENTIFIER  
 SET @RequestorId = (SELECT data.value('data(RequestorId)[1]', 'uniqueidentifier')  FROM @contactsRequest.nodes('ContactsRequest') AS ref(data))  
  
    -- first insert all records to temp table  
 SELECT  T.Item.value('.','nvarchar(20)') as MobileNumberStoredInRequestorPhone,  
 (CASE WHEN ( LEN(T.Item.value('.','NVARCHAR(20)'))<=11 )  
 THEN  
    'requestor_countrycode'  
 ELSE  
      LEFT(T.Item.value('.','nvarchar(20)'), LEN(T.Item.value('.','nvarchar(20)'))-10)  
 END) as CountryCode,  
 RIGHT(T.Item.value('.','nvarchar(20)'),10) as MobileNumber   
 INTO #tmpContactList  
 FROM @contactsRequest.nodes('ContactsRequest/ContactList/string')  T(Item)   
  
 --Update country code to country code of Requestor wherever the PhoneNumber does not have specific Country code mentioned  
 UPDATE #tmpContactList  
 SET CountryCode = (SELECT TOP 1 CountryCode FROM ws_UserProfile WHERE UserId = @RequestorId)  
 WHERE CountryCode = 'requestor_countrycode'  
   
 --select PhoneNumbers which are already registered   
 DECLARE @xmlc XML  
 SELECT @xmlc = ( SELECT (  
 SELECT DISTINCT up.UserId, up.CountryCode, up.MobileNumber, t.MobileNumberStoredInRequestorPhone   
 FROM [dbo].[ws_UserProfile] up INNER JOIN  #tmpContactList t   
 on t.MobileNumber = up.MobileNumber and t.CountryCode = up.CountryCode  
 WHERE up.IsDeleted = 0   
    FOR XML PATH('PhoneContact'), ROOT('ArrayOfPhoneContact')  
 )   )  
   
   
 SELECT @xmlc     
  
               
END  
  