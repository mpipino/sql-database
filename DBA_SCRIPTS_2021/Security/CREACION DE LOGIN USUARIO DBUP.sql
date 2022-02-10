/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [dbupexpress]    Script Date: 2/7/2022 6:44:51 PM ******/
CREATE LOGIN [dbupenvisionarystage] WITH PASSWORD=N'GzU5hAJhvp5T2h'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupenvisionarystage] FOR LOGIN [dbupenvisionarystage] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupenvisionarystage'


/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [dbupexpress]    Script Date: 2/7/2022 6:44:51 PM ******/
CREATE LOGIN [dbupenvisionarystage] WITH PASSWORD=N'Jgow7V4VUXPpJj'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupenvisionarystage] FOR LOGIN [dbupenvisionarystage] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupenvisionarystage'

------------------------------------

CREATE LOGIN [dbupenvisionarylive] WITH PASSWORD=N'75TaJEjtz7iama'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupenvisionarylive] FOR LOGIN [dbupenvisionarylive] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupenvisionarylive'