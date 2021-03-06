USE [lp_transactions]
GO
/****** Object:  UserDefinedTableType [dbo].[AccountUsageList]    Script Date: 03/01/2017 13:19:23 ******/
DROP TYPE [dbo].[AccountUsageList]
GO
/****** Object:  UserDefinedTableType [dbo].[AccountUsageList]    Script Date: 03/01/2017 13:19:23 ******/
CREATE TYPE [dbo].[AccountUsageList] AS TABLE(
	[AccountNumber] [varchar](100) NOT NULL,
	[UtilityId] [int] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[UtilityId] ASC,
	[AccountNumber] ASC,
	[FromDate] ASC,
	[ToDate] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
