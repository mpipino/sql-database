SELECT DP1.name AS DatabaseRoleName,   
    isnull (DP2.name, 'No members') AS DatabaseUserName   
FROM sys.database_role_members AS DRM  
RIGHT OUTER JOIN sys.database_principals AS DP1  
    ON DRM.role_principal_id = DP1.principal_id  
LEFT OUTER JOIN sys.database_principals AS DP2  
    ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
ORDER BY DP1.name;  


/*
dbmanager:
Can create and delete databases. A member of the dbmanager role that creates a database, 
becomes the owner of that database which allows that user to connect to that database as 
the dbo user. The dbo user has all database permissions in the database. Members of the 
dbmanager role do not necessarily have permission to access databases that they do not own.

loginmanager: Can create and delete logins in the virtual master database.
*/