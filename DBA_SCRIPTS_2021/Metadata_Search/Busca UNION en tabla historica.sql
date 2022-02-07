SELECT DISTINCT o.name AS Object_Name, o.type_desc, 'sp_helptext ''' + o.name + ''''
FROM sys.sql_modules m
INNER JOIN
sys.objects o
ON m.object_id = o.object_id
WHERE 
	m.definition Like '%UNION%'
	AND 
	m.definition LIKE '%tbl_distributor_commissions_v2_Historic%'
	--AND o.name='FN_GETACTIVEDISTRIBUTOR_XC'
	--AND o.type_desc = 'SQL_SCALAR_FUNCTION';
