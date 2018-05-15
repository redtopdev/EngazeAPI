exec ws_spAdminCleanupData '<?xml version="1.0" encoding="utf-8"?>
<CleanupRequest xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
 <RequestorId>F09C7105-ADFB-4CC7-9F09-D21F50909A77</RequestorId> </CleanupRequest>'
 
 
 select * from ws_AdminUsers
 
 SELECT 1 FROM ws_AdminUsers WHERE UserId = 'F09C7105-ADFB-4CC7-9F09-D21F50909A77' AND IsDeleted = 0
 
 
 