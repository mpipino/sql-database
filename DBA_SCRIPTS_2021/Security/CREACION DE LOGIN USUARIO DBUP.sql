/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [dbupexpress]    Script Date: 2/7/2022 6:44:51 PM ******/
CREATE LOGIN [dbupexpress] WITH PASSWORD=N'XXX'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupexpress] FOR LOGIN [dbupexpress] WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupexpress'
