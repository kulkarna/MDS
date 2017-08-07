USE [Libertypower]
GO
/****** Object: Type Table [dbo].[AnnualUsageTranRecord]    Script Date: 9/24/2015 3:50:47 PM ******/

CREATE TYPE [dbo].[AnnualUsageTranRecord] AS TABLE 
    ( [AccountId] [bigint] NOT NULL,
	[AccountNumber] [nvarchar](30) NULL,
	[UtilityId] [int] NULL,
	[AnnualUsage] [bigint]  NULL)
GO

