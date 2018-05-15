select * from dbo.ws_Event

insert into ws_Event
values(newid(),'CricketMatch',2,'Match at VSV ground', '2015-05-10 9:54:16','2015-05-10 10:54:16',
null,'F679E4C0-6C20-4140-905E-950B8A381576',1,1,null,null,null,null,1,'1.0','1.0')

select GETDATE()

select NEWID()

select * from dbo.ws_UserEvent
insert into ws_UserEvent
values('AD655427-3EFA-4790-A2C2-1C5781B71A42', 'F679E4C0-6C20-4140-905E-950B8A381576',1,1,null,null,null,0)

insert into ws_UserEvent
values('AD655427-3EFA-4790-A2C2-1C5781B71A42', '7DC3D9D0-C7AE-4EEC-8F3F-D9F964A4A33A',1,1,null,null,null,0)

insert into ws_UserEvent
values('AD655427-3EFA-4790-A2C2-1C5781B71A42', '66BED9FA-2DB6-4307-AD34-932701AA1F3F',1,1,null,null,null,0)

select * from dbo.ws_Device
select * from dbo.ws_DeviceLocation

select * from dbo.ws_UserProfile
insert into ws_UserProfile
values('F679E4C0-6C20-4140-905E-950B8A381576', 'Atul','Sagar','asagar','atulsagar2000@gmail.com',null,null,'26BE08BB-4C82-4F4E-92C0-4EDB6DB1F534',0,GETDATE(),'api',GETDATE(), 'api')


insert into ws_UserProfile
values('7DC3D9D0-C7AE-4EEC-8F3F-D9F964A4A33A', 'Shyam','Sunder','ssk','shyamsk666@gmail.com',null,null,'5E776AF4-0758-4024-8E3F-116A71D84BB1',0,GETDATE(),'api',GETDATE(), 'api')

insert into ws_UserProfile
values('66BED9FA-2DB6-4307-AD34-932701AA1F3F', 'Priya','Darshan','pdc','pdc@gmail.com',null,null,'B5877280-E22D-4EA4-AAEA-09CF83E7E97E',0,GETDATE(),'api',GETDATE(), 'api')
