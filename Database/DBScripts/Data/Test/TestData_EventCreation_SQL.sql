select * from ws_event
select * from ws_UserProfile where userid = '64a64c5d-da01-47f4-b077-bf2abb2e26d4'
select * from ws_UserEvent where eventid = '6e9eb6fe-a4c7-42e3-8525-ff44bfc0a07b'
select * from ws_event where EventId = '7DC3D9D0-C7AE-4EEC-8F3F-D9F964A4A33A'
delete from ws_UserEvent where EventId not IN ( 'AD655427-3EFA-4790-A2C2-1C5781B71A42', 'BDB3F49B-686B-42A8-A459-77CEB7D5F4DF')


exec ws_spAddEvent '<?xml version="1.0" ?>
<Event xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">  
<Name>tennis</Name>  
<EventTypeId>1</EventTypeId>  
<Description>tennis</Description>  
<StartTime>2015-06-20T05:37:09.2</StartTime>  
<EndTime>1980-06-20T06:37:09.2</EndTime>  
<Duration>1800.0</Duration>  
<UserList>    
<UserEvent>      
<EventId>00000000-0000-0000-0000-000000000000</EventId>      
<UserId>f679e4c0-6c20-4140-905e-950b8a381576</UserId>      
<IsEventAccepted>false</IsEventAccepted>      
<IsTrackingAccepted>false</IsTrackingAccepted>      
<TrackingStartTime>0001-01-01T00:00:00</TrackingStartTime>      
<TrackingEndTime>0001-01-01T00:00:00</TrackingEndTime>      
<TrackingEndReason>0</TrackingEndReason>      
<IsTrackingActive>false</IsTrackingActive>      
<UserEventEndTime>0001-01-01T00:00:00</UserEventEndTime>    
</UserEvent>    
<UserEvent>      
<EventId>00000000-0000-0000-0000-000000000000</EventId>      
<UserId>66bed9fa-2db6-4307-ad34-932701aa1f3f</UserId>      
<IsEventAccepted>false</IsEventAccepted>      
<IsTrackingAccepted>false</IsTrackingAccepted>      
<TrackingStartTime>0001-01-01T00:00:00</TrackingStartTime>      
<TrackingEndTime>0001-01-01T00:00:00</TrackingEndTime>      
<TrackingEndReason>0</TrackingEndReason>      
<IsTrackingActive>false</IsTrackingActive>      
<UserEventEndTime>0001-01-01T00:00:00</UserEventEndTime>    
</UserEvent>  
</UserList>  
<InitiatorId>7dc3d9d0-c7ae-4eec-8f3f-d9f964a4a33a</InitiatorId>  
<EventStateId>1</EventStateId> 
 <TrackingStateId>1</TrackingStateId>  
<DestinationLatitude/>  
<DestinationLongitude/>  
<DestinationName>Office</DestinationName>  
<IsTrackingRequired>true</IsTrackingRequired>  
<ReminderOffset>1800</ReminderOffset> 
 <TrackingStartOffset>1800</TrackingStartOffset>  
 <TrackingStopTime/>  
 <RequestorId/>  
 <HasRequestorAcceptedEvent>false</HasRequestorAcceptedEvent>  
 <HasRequestorAcceptedTracking>false</HasRequestorAcceptedTracking>
 <NewEventIdHolder>$eventid$</NewEventIdHolder>
 </Event>'
 