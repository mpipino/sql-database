-- Percentage index creation by M.Angel Motos @aleson-itc   m.motos@aleson-itc.com

-- Declare @session_id to set session_id of index creation

DECLARE @session_id AS int
SET @session_id = 59

-- cte to simplify the code

;WITH tempdb_cte (node_id, Time_Taken)
	AS
		(

		SELECT 
			node_id,
			(DATEDIFF(SECOND, DATEADD(SECOND, - 3610, DATEADD(MILLISECOND, eqp.last_active_time % 1000, DATEADD(SECOND, eqp.last_active_time / 1000, (
			SELECT create_date
			FROM sys.databases
			WHERE NAME = 'tempdb'
			)))), DATEADD(SECOND, - 3610, DATEADD(MILLISECOND, eqp.first_active_time % 1000, DATEADD(SECOND, first_active_time / 1000, (
			SELECT create_date
			FROM sys.databases
			WHERE NAME = 'tempdb'
			))))) * - 1
		    ) AS Time_Taken
		FROM sys.dm_exec_query_profiles AS eqp
		)

-- Begin the Query

SELECT 
	   eqp.Node_Id,
	   eqp.Physical_Operator_Name,   
       SUM(eqp.row_count) Row_Count, 
       SUM(eqp.estimate_row_count) AS Estimate_Row_Count,
       CAST(SUM(eqp.row_count)*100 AS float)/SUM(eqp.estimate_row_count)  AS Estimate_Percent_Complete,
	CASE	
		WHEN eqp.node_id = 2 THEN (SELECT CAST(SUM(eqp.row_count)*50 AS float)/SUM(eqp.estimate_row_count))
		ELSE 
			CASE
				WHEN eqp.row_count = 0 THEN  0
				ELSE (SELECT 50+CAST(SUM(eqp.row_count)*50 AS float)/SUM(eqp.estimate_row_count))
			END  
	END AS 'Total_Percent_Complete',
	CASE
		WHEN eqp.row_count != 0 and node_id = 2 THEN (
			SELECT
				Time_Taken
			FROM tempdb_cte
			WHERE node_id = 2)
		WHEN eqp.row_count != 0 AND node_id = 1 THEN (
			SELECT 
				Time_Taken
			FROM tempdb_cte
			WHERE node_id = 1) - (
			SELECT
				Time_Taken
				FROM tempdb_cte
			WHERE node_id = 2)
		ELSE NULL
	END as Time_Taken,
	CASE
		WHEN eqp.row_count != 0 AND node_id = 1 THEN 
		ROUND((((
			SELECT
				Time_Taken
			FROM tempdb_cte
			WHERE node_id = 1)
			 -
		(
		SELECT
			Time_Taken
		FROM tempdb_cte
		WHERE node_id = 2) 
		)* 100)
		/ ((SELECT CAST(SUM(eqp.row_count)*100 AS float)/SUM(eqp.estimate_row_count) 
			FROM sys.dm_exec_query_profiles AS eqp WHERE node_id = 1)),2,1)
			
		WHEN eqp.row_count != 0 AND node_id = 2 THEN 
			ROUND(((SELECT
						Time_Taken
					FROM tempdb_cte
					WHERE node_id = 2) 
						*100) / (CAST(SUM(eqp.row_count)*100 AS float)
						/SUM(eqp.estimate_row_count)),2,1)
		ELSE NULL
	END AS Estimate_Time_Taken
FROM 
	sys.dm_exec_query_profiles AS eqp
WHERE 
	session_id = @session_id
GROUP BY 
	node_id,physical_operator_name,row_count,estimate_row_count,last_active_time,first_active_time
ORDER BY 
	node_id DESC;