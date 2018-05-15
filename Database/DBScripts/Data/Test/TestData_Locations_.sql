select * from ws_userprofile

select top 10 * from ws_userlocation

select * from ws_event where name like '%rittos%'

delete from ws_UserEvent where
EventId = '423BA418-CE61-4D09-A378-D8412ADDE6DD' and
UserId in ('231F73C2-3933-4075-A0F7-1DD5AEDB4424','106B87B7-C0BB-4E02-980C-DDC486E36153')

update ws_event 
set DestinationLatitude = '15.545787', DestinationLongitude = '73.756953'
where eventid = 
'423BA418-CE61-4D09-A378-D8412ADDE6DD'


select * from ws_userevent where eventid = 
'423BA418-CE61-4D09-A378-D8412ADDE6DD'

update ws_UserEvent set IsDeleted = 1 where UserId = 'F09C7105-ADFB-4CC7-9F09-D21F50909A77' and eventid = 
'423BA418-CE61-4D09-A378-D8412ADDE6DD'



insert into ws_userlocation
values(NEWID(), 'F0809FBC-85B1-482F-A42C-3BCD224F6E53', '15.541959', '73.7586067', 0, GETUTCDATE(),'1.00',0)

insert into ws_userlocation
values(NEWID(), 'E6E3A478-C389-49CB-A5B1-5D2C3B4C0BD5', '15.6015955', '73.7394603', 0, GETUTCDATE(),'1.00',0)

insert into ws_userlocation
values(NEWID(), '70F3B19E-4694-4F6E-B41B-7774DADBB437', '15.5708411', '73.7546189', 0, GETUTCDATE(),'1.00',0)


insert into ws_userlocation
values(NEWID(), 'F09C7105-ADFB-4CC7-9F09-D21F50909A77', '15.4946562', '73.7671932', 0, GETUTCDATE(),'1.00',0)

15.4946562,73.7671932





select top 10 * from ws_userlocation


update ws_userevent 
set EventAcceptanceStateId = 1, IsTrackingAccepted = 1 
where eventid = '423BA418-CE61-4D09-A378-D8412ADDE6DD' and UserId =  'F09C7105-ADFB-4CC7-9F09-D21F50909A77'