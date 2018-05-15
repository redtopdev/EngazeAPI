DECLARE @XML xml
SET @XML = N'<UserGroup>
<UserGroupId>305C1B0C-23B3-4FEE-AC07-B307E8EEC9AE</UserGroupId>
<UserList>
<UserGroupMember>
	<UserId>F679E4C0-6C20-4140-905E-950B8A381576</UserId>
   <IsAdmin>False</IsAdmin>
</UserGroupMember>
<UserGroupMember>
	<UserId>7DC3D9D0-C7AE-4EEC-8F3F-D9F964A4A33A</UserId>
  <IsAdmin>False</IsAdmin>
</UserGroupMember>
</UserList>
</UserGroup>'

--(SELECT *  FROM @XML.nodes('UserList\UserGroupMember') AS ref(data))

--SELECT [UserId]    = T.Item.value('@UserId', 'uniqueidentifier'),
--[IsAdmin]    = T.Item.value('@IsAdmin', 'bit')
--FROM   @XML.nodes('UserList/UserGroupMember') T(Item)

--SELECT  T.Item.value('UserId[1]', 'uniqueidentifier') as UserId,
-- T.Item.value('IsAdmin[1]', 'bit') as IsAdmin
-- FROM @XML.nodes('/UserGroup/UserList/UserGroupMember')  T(Item)

--FROM   @XML.nodes('UserList/UserGroupMember') T(Item)

 
--select * 
--into #temp
--from ws_UserGroupMember

	--select * from #temp
	
	DECLARE @docHandle int;
	EXEC sp_xml_preparedocument @docHandle OUTPUT, @XML;
	
	-- UPDATE #temp
 -- SET 
 --  #temp.IsAdmin = XMLProdTable.IsAdmin,
 --  #temp.ModifiedOn = getdate()
 SELECT XMLProdTable.IsAdmin,XMLProdTable.UserId 
 FROM OPENXML(@docHandle, N'/UserGroup/UserList/UserGroupMember')   
       WITH (
				UserId uniqueidentifier,
                IsAdmin bit                 
            ) XMLProdTable
--WHERE    #temp.UserId = XMLProdTable.UserId 
--AND #temp.UserGroupId = '305C1B0C-23B3-4FEE-AC07-B307E8EEC9AE' 
	
	--UPDATE #temp
	--SET IsAdmin = T.Item.value('IsAdmin[1]', 'bit') ,
	--ModifiedBy = '7DC3D9D0-C7AE-4EEC-8F3F-D9F964A4A33A',
	--ModifiedOn = GETDATE()
	--FROM @XML.nodes('UserGroup/UserList/UserGroupMember')  T(Item) 
	--WHERE UserGroupId = '305C1B0C-23B3-4FEE-AC07-B307E8EEC9AE' 
	--AND UserId = SELECT T.Item.value('UserId[1]', 'uniqueidentifier') 	
	--FROM @XML.nodes('UserGroup/UserList/UserGroupMember')  T(Item) 
	
	select * from #temp
	-- Remove the internal representation of the XML document.
	EXEC sp_xml_removedocument @docHandle; 

	
	--drop table #temp