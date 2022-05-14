/*


https://www.brentozar.com/pastetheplan


*/



-- Executions Plan with convert inplicit.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @dbname SYSNAME
SET @dbname = QUOTENAME(DB_NAME());

WITH XMLNAMESPACES
   (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT
   stmt.value('(@StatementText)[1]', 'varchar(max)') as STATEMENT,
   t.value('(ScalarOperator/Identifier/ColumnReference/@Schema)[1]', 'varchar(128)') as [Schema],
   t.value('(ScalarOperator/Identifier/ColumnReference/@Table)[1]', 'varchar(128)') as [Table],
   t.value('(ScalarOperator/Identifier/ColumnReference/@Column)[1]', 'varchar(128)'),
   ic.DATA_TYPE AS ConvertFrom,
   ic.CHARACTER_MAXIMUM_LENGTH AS ConvertFromLength,
   t.value('(@DataType)[1]', 'varchar(128)') AS ConvertTo,
   t.value('(@Length)[1]', 'int') AS ConvertToLength,
   query_plan
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
CROSS APPLY query_plan.nodes('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple') AS batch(stmt)
CROSS APPLY stmt.nodes('.//Convert[@Implicit="1"]') AS n(t)
JOIN INFORMATION_SCHEMA.COLUMNS AS ic
   ON QUOTENAME(ic.TABLE_SCHEMA) = t.value('(ScalarOperator/Identifier/ColumnReference/@Schema)[1]', 'varchar(128)')
   AND QUOTENAME(ic.TABLE_NAME) = t.value('(ScalarOperator/Identifier/ColumnReference/@Table)[1]', 'varchar(128)')
   AND ic.COLUMN_NAME = t.value('(ScalarOperator/Identifier/ColumnReference/@Column)[1]', 'varchar(128)')
WHERE t.exist('ScalarOperator/Identifier/ColumnReference[@Database=sql:variable("@dbname")][@Schema!="[sys]"]') = 1




--Execution Plan by Cost and STMT
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan'),
core AS (
	SELECT
		eqp.query_plan AS [QueryPlan],
		ecp.plan_handle [PlanHandle],
		q.[Text] AS [Statement],
		n.value('(@StatementOptmLevel)[1]', 'VARCHAR(25)') AS OptimizationLevel ,
		ISNULL(CAST(n.value('(@StatementSubTreeCost)[1]', 'VARCHAR(128)') as float),0) AS SubTreeCost ,
		ecp.usecounts [UseCounts],
		ecp.size_in_bytes [SizeInBytes]
	FROM
		sys.dm_exec_cached_plans AS ecp
		CROSS APPLY sys.dm_exec_query_plan(ecp.plan_handle) AS eqp
		CROSS APPLY sys.dm_exec_sql_text(ecp.plan_handle) AS q
		CROSS APPLY query_plan.nodes ('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple') AS qn ( n )
	WHERE ISNULL(CAST(n.value('(@StatementSubTreeCost)[1]', 'VARCHAR(128)') as float),0)> 10
)
SELECT TOP 10
	QueryPlan,
	PlanHandle,
	[Statement],
	OptimizationLevel,
	SubTreeCost,
	UseCounts,
	SubTreeCost * UseCounts [GrossCost],
	SizeInBytes
FROM
	core
 --where [Statement] like '%sp_search%'
ORDER BY	
	GrossCost DESC,
	UseCounts desc
--SubTreeCost DESC


-------------------------------------------------------------

/*
	The following query shows the count of queries by query hash to determine whether a query is properly parameterized:
	--https://docs.microsoft.com/en-us/azure/azure-sql/identify-query-performance-issues
*/
SELECT TOP 10
  q.query_hash
  , count (distinct p.query_id ) AS number_of_distinct_query_ids
  , min(qt.query_sql_text) AS sampled_query_text
FROM sys.query_store_query_text AS qt
  JOIN sys.query_store_query AS q
     ON qt.query_text_id = q.query_text_id
  JOIN sys.query_store_plan AS p
     ON q.query_id = p.query_id
  JOIN sys.query_store_runtime_stats AS rs
     ON rs.plan_id = p.plan_id
  JOIN sys.query_store_runtime_stats_interval AS rsi
     ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE
  rsi.start_time >= DATEADD(hour, -2, GETUTCDATE())
  AND query_parameterization_type_desc IN ('User', 'None')
GROUP BY q.query_hash
ORDER BY count (distinct p.query_id) DESC;

----------------------------------------------------------------------------
--https://www.sqlshack.com/sql-server-query-execution-plans-viewing-plans/

--To see the plans for ad hoc queries cached in the plan cache:
SELECT qp.query_plan, 
       CP.usecounts, 
       cp.cacheobjtype, 
       cp.size_in_bytes, 
       cp.usecounts, 
       SQLText.text
  FROM sys.dm_exec_cached_plans AS CP
  CROSS APPLY sys.dm_exec_sql_text( plan_handle)AS SQLText
  CROSS APPLY sys.dm_exec_query_plan( plan_handle)AS QP
  WHERE objtype = 'Adhoc' and cp.cacheobjtype = 'Compiled Plan'

------------------------------------------------------------------------------------
--https://www.brentozar.com/archive/2018/07/tsql2sday-how-much-plan-cache-history-do-you-have/
-- EXECUTION PLAN CREATION BY HOUR.
select 
   *
from 
   sys.dm_exec_cached_plans cp
      CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
where 
   OBJECT_NAME(st.objectid, st.dbid) = 'sp_search_criteria_results_pagination%' and 
   st.dbid = DB_ID()

----------------------------------------------------------------------------------------


SELECT TOP 50
    creation_date = CAST(creation_time AS date),
    creation_hour = CASE
                        WHEN CAST(creation_time AS date) <> CAST(GETDATE() AS date) THEN 0
                        ELSE DATEPART(hh, creation_time)
                    END,
    SUM(1) AS plans
FROM sys.dm_exec_query_stats
GROUP BY CAST(creation_time AS date),
         CASE
             WHEN CAST(creation_time AS date) <> CAST(GETDATE() AS date) THEN 0
             ELSE DATEPART(hh, creation_time)
         END
ORDER BY 1 DESC, 2 DESC