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

declare @nameproject sysname ='ModBallsLive'

declare @namesuserlive varchar(max)='xcorporate$,xbackoffice$,xenroll$,xautoship$,xorder$,xwebservicescomm$,xruntasks$,xtranslations$,$live,xapi$'
declare @replaceuser varchar(max)= REPLACE(@namesuserlive,'$',@nameproject)

---SCRIPT IN DB @nameproject
select 'CREATE USER '+ value +' FOR LOGIN '+value+
' WITH DEFAULT_SCHEMA =[dbo]  ' as ScriptDb
FROM
STRING_SPLIT(@replaceuser,',')
UNION
select 'EXEC sp_addRoleMember ''db_owner'', '''+ value +''';'  --as AddRoles
FROM
STRING_SPLIT(@replaceuser,',')

---SCRIPT IN MASTER --no hay que crear en master

select 'CREATE LOGIN '+ value +' WITH PASSWORD = ''-''' as ScriptMaster
FROM
STRING_SPLIT(@replaceuser,',')
Union
select 'CREATE USER '+ value +' FOR LOGIN '+value+
' WITH DEFAULT_SCHEMA =[dbo]  ' as ScriptDb
FROM
STRING_SPLIT(@replaceuser,',')

GO

-- Run Script in Master



GO


/*

Ejemplo de modballs_live:

CREATE LOGIN xapiImpactGlobalLive WITH PASSWORD = 'R53FnwKZc5ebxN'
CREATE LOGIN xautoshipModBallsLive WITH PASSWORD = ''
CREATE LOGIN xbackofficeModBallsLive WITH PASSWORD = ''
CREATE LOGIN xcorporateModBallsLive WITH PASSWORD = ''
CREATE LOGIN xenrollModBallsLive WITH PASSWORD = ''
CREATE LOGIN xorderModBallsLive WITH PASSWORD = ''
CREATE LOGIN xruntasksModBallsLive WITH PASSWORD = ''
CREATE LOGIN xtranslationsModBallsLive WITH PASSWORD = ''
CREATE LOGIN xwebservicescommModBallsLive WITH PASSWORD = ''

CREATE USER xapiModBallsLive FOR LOGIN xapiModBallsLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xautoshipModBallsLive FOR LOGIN xautoshipModBallsLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xbackofficeModBallsLive FOR LOGIN xbackofficeModBallsLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xcorporateModBallsLive FOR LOGIN xcorporateModBallsLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xenrollModBallsLive FOR LOGIN xenrollModBallsLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xorderModBallsLive FOR LOGIN xorderModBallsLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xruntasksModBallsLive FOR LOGIN xruntasksModBallsLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xtranslationsModBallsLive FOR LOGIN xtranslationsModBallsLive WITH DEFAULT_SCHEMA =[dbo]  
CREATE USER xwebservicescommModBallsLive FOR LOGIN xwebservicescommModBallsLive WITH DEFAULT_SCHEMA =[dbo]  

EXEC sp_addRoleMember 'db_owner', 'xapiModBallsLive';
EXEC sp_addRoleMember 'db_owner', 'xautoshipModBallsLive';
EXEC sp_addRoleMember 'db_owner', 'xbackofficeModBallsLive';
EXEC sp_addRoleMember 'db_owner', 'xcorporateModBallsLive';
EXEC sp_addRoleMember 'db_owner', 'xenrollModBallsLive';
EXEC sp_addRoleMember 'db_owner', 'xorderModBallsLive';
EXEC sp_addRoleMember 'db_owner', 'xruntasksModBallsLive';
EXEC sp_addRoleMember 'db_owner', 'xtranslationsModBallsLive';
EXEC sp_addRoleMember 'db_owner', 'xwebservicescommModBallsLive';


*/

