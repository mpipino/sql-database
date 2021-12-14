-- After Create Group AD in azure
-- in Master and DB live
create user [BioBoNum ReadExecute]
from external provider
with default_schema =dbo
go
create user [BioBoNum Reader]
from external provider
with default_schema =dbo

GO
-- in DB live
EXEC sp_addRoleMember 'ReadExecute', 'BioBoNum ReadExecute';
EXEC sp_addRoleMember 'db_datareader', 'BioBoNum Reader';
GO


--  Permission  BioBoNum ReadExecute to Schema

declare @nameUser sysname='BioBoNum ReadExecute'

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

GO

GRANT CONTROL ON SCHEMA:: [dbo] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [dbo] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [dbo] TO [BioBoNum ReadExecute]
GRANT CONTROL ON SCHEMA:: [Dst] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [Dst] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [Dst] TO [BioBoNum ReadExecute]
GRANT CONTROL ON SCHEMA:: [Gbl] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [Gbl] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [Gbl] TO [BioBoNum ReadExecute]
GRANT CONTROL ON SCHEMA:: [Prd] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [Prd] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [Prd] TO [BioBoNum ReadExecute]
GRANT CONTROL ON SCHEMA:: [Lgt] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [Lgt] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [Lgt] TO [BioBoNum ReadExecute]
GRANT CONTROL ON SCHEMA:: [Com] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [Com] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [Com] TO [BioBoNum ReadExecute]
GRANT CONTROL ON SCHEMA:: [Sec] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [Sec] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [Sec] TO [BioBoNum ReadExecute]
GRANT CONTROL ON SCHEMA:: [Crs] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [Crs] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [Crs] TO [BioBoNum ReadExecute]
GRANT CONTROL ON SCHEMA:: [dba] TO [BioBoNum ReadExecute]
GRANT EXECUTE ON SCHEMA:: [dba] TO [BioBoNum ReadExecute]
GRANT SELECT ON SCHEMA:: [dba] TO [BioBoNum ReadExecute]

GO

--  Permission  BioBoNum Reader to Schema

declare @nameUser sysname='BioBoNum Reader'

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

GO

GRANT CONTROL ON SCHEMA:: [dbo] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [dbo] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [dbo] TO [BioBoNum Reader]
GRANT CONTROL ON SCHEMA:: [Dst] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [Dst] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [Dst] TO [BioBoNum Reader]
GRANT CONTROL ON SCHEMA:: [Gbl] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [Gbl] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [Gbl] TO [BioBoNum Reader]
GRANT CONTROL ON SCHEMA:: [Prd] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [Prd] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [Prd] TO [BioBoNum Reader]
GRANT CONTROL ON SCHEMA:: [Lgt] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [Lgt] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [Lgt] TO [BioBoNum Reader]
GRANT CONTROL ON SCHEMA:: [Com] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [Com] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [Com] TO [BioBoNum Reader]
GRANT CONTROL ON SCHEMA:: [Sec] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [Sec] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [Sec] TO [BioBoNum Reader]
GRANT CONTROL ON SCHEMA:: [Crs] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [Crs] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [Crs] TO [BioBoNum Reader]
GRANT CONTROL ON SCHEMA:: [dba] TO [BioBoNum Reader]
GRANT EXECUTE ON SCHEMA:: [dba] TO [BioBoNum Reader]
GRANT SELECT ON SCHEMA:: [dba] TO [BioBoNum Reader]