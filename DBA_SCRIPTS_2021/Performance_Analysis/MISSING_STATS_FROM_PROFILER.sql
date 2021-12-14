SELECT * INTO tbl_3600_Missing_Statistics
FROM fn_trace_gettable('C:\Users\abald\Downloads\3600_Missing_Statistics\3600_Missing_Statistics.trc', default);
GO

SELECT 'USE ' + DatabaseName + '; ' + 'CREATE STATISTICS [STATS_4_14_2021_' 
				+ RTRIM(convert(char,EventSequence)) 
				+ '] ' 
				+ ' ON TABLE_NAME (' + REPLACE(REPLACE(CONVERT(CHAR(200), TEXTDATA),'.',','),'NO STATS:(','') --+ ')'
FROM [dbo].[tbl_3600_Missing_Statistics]

SELECT textdata, 'CREATE STATISTICS [STATS_4_14_2021_' + RTRIM(convert(char,EventSequence)) + '] ' + 
				 ' ON TABLE_NAME (' + REPLACE(REPLACE(CONVERT(CHAR(200), TEXTDATA),'.',','),'NO STATS:(','') --+ ')'
FROM [dbo].[tbl_3600_Missing_Statistics]