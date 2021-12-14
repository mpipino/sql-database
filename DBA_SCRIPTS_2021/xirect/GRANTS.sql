EXECUTE AS user = 'Ambrosia_Test ReadExecute'
GO
SELECT 
    USER_NAME() AS 'user_name'
    ,SUSER_NAME() AS 'suser_name'
    ,SUSER_SNAME() AS 'suser_sname'
    ,SYSTEM_USER AS 'system_user'
GO
REVERT
GO



