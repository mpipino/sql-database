/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login dbupMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN dbupMillenialstage WITH PASSWORD=N'' --'
GO

--dbupMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login Millenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN Millenialstage WITH PASSWORD=N'' --'
GO

--Millenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xapiMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xapiMillenialstage WITH PASSWORD=N'' --'
GO

--xapiMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xautoshipMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xautoshipMillenialstage WITH PASSWORD=N'' --'
GO

--xautoshipMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xbackofficeMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xbackofficeMillenialstage WITH PASSWORD=N'' --'
GO

--xbackofficeMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xcorporateMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xcorporateMillenialstage WITH PASSWORD=N'' --'
GO

--xcorporateMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xenrollMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xenrollMillenialstage WITH PASSWORD=N'' --'
GO

--xenrollMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xorderMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xorderMillenialstage WITH PASSWORD=N'' --'
GO

--xorderMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xruntasksMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xruntasksMillenialstage WITH PASSWORD=N'' --'
GO

--xruntasksMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xtranslationsMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xtranslationsMillenialstage WITH PASSWORD=N'' --'
GO

--xtranslationsMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xwebservicescommMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xwebservicescommMillenialstage WITH PASSWORD=N'' --'
GO

--xwebservicescommMillenialstage DISABLE
GO



----------------EN LA BASE:
/****** Object:  User dbupMillenialstage    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER dbupMillenialstage FOR LOGIN dbupMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER dbupMillenialstage

/****** Object:  User Millenialstage    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER Millenialstage FOR LOGIN Millenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER Millenialstage

/****** Object:  User xbackofficeMillenialstage    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER xbackofficeMillenialstage FOR LOGIN xbackofficeMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xbackofficeMillenialstage

/****** Object:  User xtranslationsMillenialstage    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER xtranslationsMillenialstage FOR LOGIN xtranslationsMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xtranslationsMillenialstage

CREATE USER xorderMillenialstage FOR LOGIN xorderMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xorderMillenialstage

CREATE USER xruntasksMillenialstage FOR LOGIN xruntasksMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xruntasksMillenialstage

CREATE USER xwebservicescommMillenialstage FOR LOGIN xwebservicescommMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xwebservicescommMillenialstage

CREATE USER xapiMillenialstage FOR LOGIN xapiMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xapiMillenialstage

CREATE USER xautoshipMillenialstage FOR LOGIN xautoshipMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xautoshipMillenialstage

CREATE USER xcorporateMillenialstage FOR LOGIN xcorporateMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xcorporateMillenialstage

CREATE USER xenrollMillenialstage FOR LOGIN xenrollMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xenrollMillenialstage


CREATE ROLE ReadExecute AUTHORIZATION dbo
GRANT EXECUTE TO [ReadExecute]
GRANT SELECT TO [ReadExecute]
GRANT CREATE TABLE TO [ReadExecute]
GRANT CREATE FUNCTION TO [ReadExecute]
GRANT CREATE PROCEDURE TO [ReadExecute]
GRANT CREATE SCHEMA TO [ReadExecute]
GRANT EXECUTE ON SCHEMA::[dbo] TO [ReadExecute]
GRANT ALTER ON SCHEMA::[dbo] TO [ReadExecute]
GRANT SELECT ON SCHEMA::[dbo] TO [ReadExecute]
GRANT CONTROL ON SCHEMA::[dbo] TO [ReadExecute]
GRANT CREATE TYPE TO [ReadExecute]
GRANT CREATE VIEW TO [ReadExecute]
GRANT CREATE EXTERNAL LIBRARY TO [ReadExecute]
GRANT SHOWPLAN TO [ReadExecute]
GRANT VIEW DEFINITION TO [ReadExecute]
GRANT SELECT ON OBJECT::sys.sql_expression_dependencies TO [ReadExecute];


--------------------------------------4---------------------------
-- Create Group AD in azure
-- in Master and DB live

--------------------------------------5---------------------------
--drop user [ModBalls_Live ReadExecute] En caso de que la base de datos sea una copia.

CREATE USER [MilennialLive Reader] FROM EXTERNAL PROVIDER WITH DEFAULT_SCHEMA=[dbo]
GO

/****** Object: User [ModBallsDev ReadExecute] Script Date: 2/24/2022 4:20:00 PM ******/
CREATE USER [MilennialLive ReadExecute] FROM EXTERNAL PROVIDER WITH DEFAULT_SCHEMA=[dbo]
GO

--------------------------------------6---------------------------
-- in DB
EXEC sp_addRoleMember 'db_owner', 'xapiModballsstage';
EXEC sp_addRoleMember 'db_owner', 'xenrollMilennial';
EXEC sp_addRoleMember 'db_owner', 'ModBallsStage';
EXEC sp_addRoleMember 'db_owner', 'xapiModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xautoshipModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xbackofficeModballsstage' 
EXEC sp_addRoleMember 'db_owner', 'xcorporateModballsstage' 
EXEC sp_addRoleMember 'db_owner', 'xruntasksModballsstage' 
EXEC sp_addRoleMember 'db_owner', 'xtranslationsModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xwebservicescommModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xorderModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xruntasksMilennial'


EXEC sp_addRoleMember 'ReadExecute', 'MilennialLive ReadExecute';
EXEC sp_addRoleMember 'db_datareader', 'MilennialLive Reader';


GO

--------------------------------------7---------------------------
--  Permission  ReadExecute to Schemas
declare @nameUser sysname='MilennialStage ReadExecute'

select 'GRANT EXECUTE ON SCHEMA:: ' + QUOTENAME(sc.name) + ' TO '+  QUOTENAME(@nameUser) ,sc.schema_id
from sys.schemas sc 
where sc.principal_id=1
union
select 'GRANT SELECT ON SCHEMA:: ' + QUOTENAME(sc.name) + ' TO '+  QUOTENAME(@nameUser) ,sc.schema_id
from sys.schemas sc 
where sc.principal_id=1
UNION
select 'GRANT CONTROL ON SCHEMA:: ' + QUOTENAME(sc.name) + ' TO '+  QUOTENAME(@nameUser) ,sc.schema_id
from sys.schemas sc 
where sc.principal_id=1
order by sc.schema_id
GO -- Ejecutar el resultado.

--  Permission Reader to Schemas
declare @nameUser sysname='MilennialStage Reader'

select 'GRANT EXECUTE ON SCHEMA:: ' + QUOTENAME(sc.name) + ' TO '+  QUOTENAME(@nameUser) ,sc.schema_id
from sys.schemas sc 
where sc.principal_id=1
union
select 'GRANT SELECT ON SCHEMA:: ' + QUOTENAME(sc.name) + ' TO '+  QUOTENAME(@nameUser) ,sc.schema_id
from sys.schemas sc 
where sc.principal_id=1
UNION
select 'GRANT CONTROL ON SCHEMA:: ' + QUOTENAME(sc.name) + ' TO '+  QUOTENAME(@nameUser) ,sc.schema_id
from sys.schemas sc 
where sc.principal_id=1
order by sc.schema_id
GO -- Ejecutar el resultado.
