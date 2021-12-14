
CREATE SCHEMA Alerts

Create TABLE Alerts.EmailNotifications (MessageID int identity(1,1),MessageText nvarchar(max) )
alter table Alerts.EmailNotifications add [sent] bit

create proc Alerts.SendAlert
AS
select 'enviar alerta'

create login xAlert with password='--'

create user xAlert from login xAlert

exec sp_addrolemember 'db_owner','xAlert'

