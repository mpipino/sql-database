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

--Ejecutar en MASTER:
----------------------------1-----------------------------------------
CREATE LOGIN [xirect] WITH PASSWORD=N'64ELhP5WYHKZ4d'
GO

CREATE LOGIN dbupmilennialDev WITH PASSWORD=N'ADSDwTurZJ7Ein'
GO

CREATE LOGIN [dbupmilennialStage] WITH PASSWORD=N'd96GvsgSRLQBfd'
GO

CREATE LOGIN [dbupmilennialLive] WITH PASSWORD=N'Nxu3hapEZZjtxi'
GO

--drop login xorderemilennialstage
CREATE LOGIN [milennialDev] WITH PASSWORD=N'ddkSu4pmjuSJBL'
GO
CREATE LOGIN [xapimilennialDev] WITH PASSWORD=N'nG8Fe2GmWN8xuh'
GO
CREATE LOGIN [xautoshipmilennialDev] WITH PASSWORD=N'teCWQP8s6DisWB'
GO
CREATE LOGIN [xbackofficemilennialDev] WITH PASSWORD=N'AEfvjLaNtK7mBd'
GO
CREATE LOGIN [xcorporatemilennialDev] WITH PASSWORD=N'9QKYT9RDvC65tU'
GO
CREATE LOGIN [xenrollMilennialDev] WITH PASSWORD=N'3D9Cm5FWqWbyug'
GO
CREATE LOGIN [xordermilennialDev] WITH PASSWORD=N'9SZrzPQtEeJSfM'
GO
CREATE LOGIN [xruntasksmilennialDev] WITH PASSWORD=N'zUG4NRxNsB3iqs'
GO
CREATE LOGIN [xtranslationsmilennialDev] WITH PASSWORD=N'ks77XfjtsT6Vy4'
GO
CREATE LOGIN [xwebservicescommmilennialDev] WITH PASSWORD=N'DmMej8qUH3awkD'
GO

------
CREATE LOGIN [milennialStage] WITH PASSWORD=N'KXH5oPUC7Eiubs'
GO
CREATE LOGIN [xapimilennialStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xautoshipmilennialStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xbackofficemilennialStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xcorporatemilennialStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xenrollMilennialStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xordermilennialStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xruntasksmilennialStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xtranslationsmilennialStage] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xwebservicescommmilennialStage] WITH PASSWORD=N'-'
GO

CREATE LOGIN [milennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xapimilennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xautoshipmilennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xbackofficemilennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xcorporatemilennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xenrollMilennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xordermilennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xruntasksmilennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xtranslationsmilennialLive] WITH PASSWORD=N'-'
GO
CREATE LOGIN [xwebservicescommmilennialLive] WITH PASSWORD=N'-'
GO

----------------------------2-----------------------------------------
--DROP USER [milennial_Dev_DBO]

-- ejecutar en dev
CREATE USER [milennialDev Reader] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [milennialDev ReadExecute] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [dbupmilennialDev] FOR LOGIN [dbupmilennialDev] WITH DEFAULT_SCHEMA=[dbo]
GO

--ejecutar en stage
CREATE USER [milennialStage Reader] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [milennialStage ReadExecute] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [dbupmilennialStage] FOR LOGIN [dbupmilennialStage] WITH DEFAULT_SCHEMA=[dbo]
GO

--ejecutar en live
CREATE USER [milennialLive Reader] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [milennialLive ReadExecute] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [dbupmilennialLive] FOR LOGIN [dbupmilennialLive] WITH DEFAULT_SCHEMA=[dbo]
GO


--Ejecutar en base de datos Dev:
--CREATE USER xapimilennialdev FOR LOGIN xapimilennialdev WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER milennialDev	FOR LOGIN milennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xapimilennialDev FOR LOGIN xapimilennialdev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xautoshipmilennialDev FOR LOGIN xautoshipmilennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xbackofficemilennialDev FOR LOGIN xbackofficemilennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xcorporatemilennialDev FOR LOGIN xcorporatemilennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xenrollMilennialDev FOR LOGIN xenrollMilennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xordermilennialDev FOR LOGIN xordermilennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xruntasksmilennialDev FOR LOGIN xruntasksmilennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xtranslationsmilennialDev FOR LOGIN xtranslationsmilennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER xwebservicescommmilennialDev FOR LOGIN xwebservicescommmilennialDev WITH DEFAULT_SCHEMA =[dbo]  
GO
EXEC sp_addRoleMember 'db_owner', 'dbupmilennialDev';
EXEC sp_addRoleMember 'db_owner', 'xbackofficemilennialDev';
EXEC sp_addRoleMember 'db_owner', 'milennialDev';
EXEC sp_addRoleMember 'db_owner', 'xapimilennialDev';
EXEC sp_addRoleMember 'db_owner', 'xautoshipmilennialDev';
EXEC sp_addRoleMember 'db_owner', 'xcorporatemilennialDev'
EXEC sp_addRoleMember 'db_owner', 'xenrollMilennialDev'
EXEC sp_addRoleMember 'db_owner', 'xordermilennialDev' 
EXEC sp_addRoleMember 'db_owner', 'xruntasksmilennialDev' 
EXEC sp_addRoleMember 'db_owner', 'xtranslationsmilennialDev'
EXEC sp_addRoleMember 'db_owner', 'xwebservicescommmilennialDev'


--Ejecutar en base de datos Stage:
--CREATE USER xapimilennialdev FOR LOGIN xapimilennialdev WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [milennialStage]	FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xapimilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xautoshipmilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xbackofficemilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xcorporatemilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xenrollMilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xordermilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xruntasksmilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xtranslationsmilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
CREATE USER [xwebservicescommmilennialStage] FOR LOGIN xapimilennialStage WITH DEFAULT_SCHEMA =[dbo]  
GO
EXEC sp_addRoleMember 'db_owner', 'dbupmilennialStage';
EXEC sp_addRoleMember 'db_owner', 'xbackofficemilennialStage';
EXEC sp_addRoleMember 'db_owner', 'milennialStage';
EXEC sp_addRoleMember 'db_owner', 'xapimilennialStage';
EXEC sp_addRoleMember 'db_owner', 'xautoshipmilennialStage';
EXEC sp_addRoleMember 'db_owner', 'xcorporatemilennialStage'
EXEC sp_addRoleMember 'db_owner', 'xenrollMilennialStage'
EXEC sp_addRoleMember 'db_owner', 'xordermilennialStage' 
EXEC sp_addRoleMember 'db_owner', 'xruntasksmilennialStage' 
EXEC sp_addRoleMember 'db_owner', 'xtranslationsmilennialStage'
EXEC sp_addRoleMember 'db_owner', 'xwebservicescommmilennialStage'


--Ejecutar en base de datos Live:
--CREATE USER xapimilennialdev FOR LOGIN xapimilennialdev WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [milennialLive]	FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xapimilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xautoshipmilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xbackofficemilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xcorporatemilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xenrollMilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xordermilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xruntasksmilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xtranslationsmilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER [xwebservicescommmilennialLive] FOR LOGIN xapimilennialLive WITH DEFAULT_SCHEMA =[dbo]  
GO
EXEC sp_addRoleMember 'db_owner', 'dbupmilenniallive';
EXEC sp_addRoleMember 'db_owner', 'xbackofficemilennialLive';
EXEC sp_addRoleMember 'db_owner', 'milenniallive';
EXEC sp_addRoleMember 'db_owner', 'xapimilenniallive';
EXEC sp_addRoleMember 'db_owner', 'xautoshipmilenniallive';
EXEC sp_addRoleMember 'db_owner', 'xcorporatemilenniallive'
EXEC sp_addRoleMember 'db_owner', 'xenrollMilenniallive'
EXEC sp_addRoleMember 'db_owner', 'xordermilenniallive' 
EXEC sp_addRoleMember 'db_owner', 'xruntasksmilenniallive' 
EXEC sp_addRoleMember 'db_owner', 'xruntasksmilenniallive' 
EXEC sp_addRoleMember 'db_owner', 'xtranslationsmilenniallive'
EXEC sp_addRoleMember 'db_owner', 'xwebservicescommmilenniallive'

--Ejecutar en todas las bases:
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

EXEC sp_addRoleMember 'ReadExecute', 'milennialDev ReadExecute';
EXEC sp_addRoleMember 'db_datareader', 'milennialDev Reader';


GO

--------------------------------------7---------------------------
--  Permission  ReadExecute to Schemas
declare @nameUser sysname='milennialDev ReadExecute'

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
declare @nameUser sysname='milennialDev Reader'
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
