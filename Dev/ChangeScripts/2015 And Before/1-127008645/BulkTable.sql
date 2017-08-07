USE [LibertyPower]
GO

/****** Object:  Table [dbo].[BulkCustomPricing]    Script Date: 06/04/2013 10:37:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[BulkCustomPricing](
	[BulkID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NULL,
	[AccountName] [varchar](50) NULL,
	[PricingRequestID] [varchar](50) NULL,
	[ExpirationDate] [datetime] NULL,
	[SalesChannel] [varchar](50) NULL,
	[Market] [varchar](2) NULL,
	[UtilityCode] [varchar](15) NULL,
	[AccountType] [varchar](4) NULL,
	[LegacyProductID] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[Term] [int] NULL,
	[IndexType] [varchar](50) NULL,
	[BillingType] [char](4) NULL,
	[Commission] [decimal](9, 6) NULL,
	[ContractRate] [decimal](9, 6) NULL,
	[Cost] [decimal](9, 6) NULL,
	[MTM] [decimal](9, 6) NULL,
	[CommissionCap] [decimal](9, 6) NULL,
	[ETP] [decimal](9, 6) NULL,
	[HeatRate] [decimal](9, 6) NULL,
	[ExpectedTermUsage] [int] NULL,
	[ExpectedAccountsAmount] [int] NULL,
	[HasPassThrough] [varchar] (50) NULL,
	[BackToBack] [varchar] (50) NULL,
	[SelfGeneration] [varchar] (50) NULL,
	[PriceID] [bigint] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


