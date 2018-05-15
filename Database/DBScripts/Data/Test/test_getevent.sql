exec ws_spGetAllEventsForUser
'<?xml version="1.0" encoding="utf-8"?>
<EventRequest xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <RequestorId>35B2141E-1531-4B4F-9F80-081363B69ED8</RequestorId>  
</EventRequest>'
select CONVERT(varchar(50), starttime, 21),starttime from ws_event
select * from ws_UserEvent
select GETUTCDATE()
exec ws_spGetAllEventsForUser
'<?xml version="1.0" encoding="utf-8"?>
<EventRequest xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <RequestorId>F679E4C0-6C20-4140-905E-950B8A381576</RequestorId>
  <EventAccepted>false</EventAccepted>
  <TrackingAccepted>false</TrackingAccepted>
</EventRequest>'


select * from ws_event
update ws_event
set ReminderOffset = 60, TrackingStartOffset = 30

select * from ws_EventStateLookup
select * from ws_userevent
select * from ws_userprofile