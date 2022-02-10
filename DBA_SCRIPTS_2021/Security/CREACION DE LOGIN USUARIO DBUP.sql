
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [dbupexpress]    Script Date: 2/7/2022 6:44:51 PM ******/
CREATE LOGIN [dbupenvisionarydev] WITH PASSWORD=N'w7hgdiXCSTebGT'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupenvisionarydev] FOR LOGIN [dbupenvisionarydev] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupenvisionarydev'


/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [dbupexpress]    Script Date: 2/7/2022 6:44:51 PM ******/
CREATE LOGIN [dbupenvisionarystage] WITH PASSWORD=N'6m9AYn9ARWkNiC'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupenvisionarystage] FOR LOGIN [dbupenvisionarystage] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupenvisionarystage'



------------------------------------

CREATE LOGIN [dbupenvisionarylive] WITH PASSWORD=N'S3D9DHnqZYyiJ7'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupenvisionarylive] FOR LOGIN [dbupenvisionarylive] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupenvisionarylive'