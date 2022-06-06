/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [dbupImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [dbupImpactGlobalLive] WITH PASSWORD=N'xxx'
GO

--[dbupImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [ImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [ImpactGlobalLive] WITH PASSWORD=N'xxx'
GO

--[ImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xapiImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xapiImpactGlobalLive] WITH PASSWORD=N'xxx'
GO

--[xapiImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xautoshipImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xautoshipImpactGlobalLive] WITH PASSWORD=N'xx'
GO

--[xautoshipImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xbackofficeImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xbackofficeImpactGlobalLive] WITH PASSWORD=N'xxx'
GO

--[xbackofficeImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xcorporateImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xcorporateImpactGlobalLive] WITH PASSWORD=N'xx'
GO

--[xcorporateImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xenrollImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xenrollImpactGlobalLive] WITH PASSWORD=N'xx'
GO

--[xenrollImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xorderImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xorderImpactGlobalLive] WITH PASSWORD=N'xxxx'
GO

--[xorderImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xruntasksImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xruntasksImpactGlobalLive] WITH PASSWORD=N'xxxx'
GO

--[xruntasksImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xtranslationsImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xtranslationsImpactGlobalLive] WITH PASSWORD=N'xxx'
GO

--[xtranslationsImpactGlobalLive] DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [xwebservicescommImpactGlobalLive]    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN [xwebservicescommImpactGlobalLive] WITH PASSWORD=N'xxx'
GO

--[xwebservicescommImpactGlobalLive] DISABLE
GO



----------------EN LA BASE:
/****** Object:  User [dbupImpactGlobalLive]    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER [dbupImpactGlobalLive] FOR LOGIN [dbupImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [dbupImpactGlobalLive]

/****** Object:  User [ImpactGlobalLive]    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER [ImpactGlobalLive] FOR LOGIN [ImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [ImpactGlobalLive]

/****** Object:  User [xbackofficeImpactGlobalLive]    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER [xbackofficeImpactGlobalLive] FOR LOGIN [xbackofficeImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xbackofficeImpactGlobalLive]

/****** Object:  User [xtranslationsImpactGlobalLive]    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER [xtranslationsImpactGlobalLive] FOR LOGIN [xtranslationsImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xtranslationsImpactGlobalLive]

CREATE USER [xorderImpactGlobalLive] FOR LOGIN [xorderImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xorderImpactGlobalLive]

CREATE USER [xruntasksImpactGlobalLive] FOR LOGIN [xruntasksImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xruntasksImpactGlobalLive]

CREATE USER [xwebservicescommImpactGlobalLive] FOR LOGIN [xwebservicescommImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xwebservicescommImpactGlobalLive]

CREATE USER [xapiImpactGlobalLive] FOR LOGIN [xapiImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xapiImpactGlobalLive]

CREATE USER [xautoshipImpactGlobalLive] FOR LOGIN [xautoshipImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xautoshipImpactGlobalLive]

CREATE USER [xcorporateImpactGlobalLive] FOR LOGIN [xcorporateImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xcorporateImpactGlobalLive]

CREATE USER [xenrollImpactGlobalLive] FOR LOGIN [xenrollImpactGlobalLive] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [xenrollImpactGlobalLive]



