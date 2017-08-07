USE [Libertypower]
GO

/****** Object:  UserDefinedTableType [dbo].[ListAccount]    Script Date: 07/18/2016 11:11:31 ******/
CREATE TYPE [dbo].[ListAccount] AS TABLE(
	[AccountNumber] [varchar](100) NOT NULL,
	[UtilityCode] [varchar](100) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[UtilityCode] ASC,
	[AccountNumber] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO


