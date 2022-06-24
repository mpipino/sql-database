--conectado a la base de datos, no a master
/****** Object:  User [BodyLogic_Live ReadExecute]    Script Date: 6/24/2022 6:47:41 PM ******/
CREATE USER [ModBalls Commissions] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO

alter role db_owner add member [ModBalls Commissions]