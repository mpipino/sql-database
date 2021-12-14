/*
Resumen para permisos:
----------------------
Crear logins, sin roles a nivel server
Crear usuarios de base de datos mapeados a logins SQL
Crear grupos de AD
Crear usuarios en función de grupos de AD
Crear Roles de Bases de datos (Read Execute y Read)
Asignar permisos a Roles de punto 5 según script Deivi. (todos los esquemas por igual para un mismo rol) 
*/


----------------------------1-----------------------------------------

CREATE LOGIN [ModballsStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xapiModballsstage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xautoshipModballsstage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xbackofficeModballsstage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xcorporateModballsstage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xenrollNetShare] WITH PASSWORD=N'-'
GO
--drop login xordereModballsstage
CREATE LOGIN [xorderModballsstage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xruntasksModballsstage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xtranslationsModballsstage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xwebservicescommModballsstage] WITH PASSWORD=N'-'
GO


----------------------------2-----------------------------------------
--DROP USER [ModBalls_Dev_DBO]
--GO
--DROP USER [Modballsdev]
--GO
--DROP USER [votiniano]
--GO

CREATE USER xapi FOR LOGIN xapi WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER ModBallsStage FOR LOGIN ModBallsStage WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xapiModballsstage FOR LOGIN xapiModballsstage WITH DEFAULT_SCHEMA =[dbo]  

--drop user [xenrollNetShare]
CREATE USER [xenrollNetShare] FOR LOGIN [xenrollNetShare] WITH DEFAULT_SCHEMA =[dbo]  


--drop user xordereModballsstage
CREATE USER xorderModballsstage FOR LOGIN xorderModballsstage WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xautoshipModballsstage FOR LOGIN xautoshipModballsstage WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xbackofficeModballsstage FOR LOGIN xbackofficeModballsstage WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xcorporateModballsstage FOR LOGIN xcorporateModballsstage WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xruntasksModballsstage FOR LOGIN xruntasksModballsstage WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xtranslationsModballsstage FOR LOGIN xtranslationsModballsstage WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xwebservicescommModballsstage FOR LOGIN xwebservicescommModballsstage WITH DEFAULT_SCHEMA =[dbo]  
--CREATE USER x FOR LOGIN x WITH DEFAULT_SCHEMA =[dbo]  
--CREATE USER x FOR LOGIN x WITH DEFAULT_SCHEMA =[dbo]  
--CREATE USER x FOR LOGIN x WITH DEFAULT_SCHEMA =[dbo]  
GO

----------------------------------------3-----------------------------------------
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
create user [NetShare_Dev ReadExecute]
from external provider
with default_schema =dbo
go

--drop user [ModBalls_Live Reader] En caso de que la base de datos sea una copia.
create user [NetShare_Dev Reader]
from external provider
with default_schema =dbo
GO

--------------------------------------6---------------------------
-- in DB
EXEC sp_addRoleMember 'db_owner', 'xapiModballsstage';
EXEC sp_addRoleMember 'db_owner', 'xenrollNetShare';
EXEC sp_addRoleMember 'db_owner', 'ModBallsStage';
EXEC sp_addRoleMember 'db_owner', 'xapiModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xautoshipModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xbackofficeModballsstage' 
EXEC sp_addRoleMember 'db_owner', 'xcorporateModballsstage' 
EXEC sp_addRoleMember 'db_owner', 'xruntasksModballsstage' 
EXEC sp_addRoleMember 'db_owner', 'xtranslationsModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xwebservicescommModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xorderModballsstage'
EXEC sp_addRoleMember 'db_owner', 'xruntasksNetShare'


EXEC sp_addRoleMember 'ReadExecute', 'NetShare_Dev ReadExecute';
EXEC sp_addRoleMember 'db_datareader', 'NetShare_Dev Reader';


GO

--------------------------------------7---------------------------
--  Permission  ReadExecute to Schemas
declare @nameUser sysname='NetShare_Dev ReadExecute'

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
declare @nameUser sysname='NetShare_Dev Reader'

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



--GRANT CONTROL ON SCHEMA::[dbo] TO [ReadExecute]
