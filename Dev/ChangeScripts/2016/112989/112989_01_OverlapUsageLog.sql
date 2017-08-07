USE [Libertypower]
GO

/****** Object:  Table [dbo].[OverlapUsageLog]    Script Date: 04/28/2016 07:24:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[OverlapUsageLog](
	[AccountNumber] [varchar](50) NULL,
	[UtilityCode] [varchar](50) NULL,
	[ISO] [varchar](50) NULL,
	[UsageSource] [varchar](50) NULL,
	[UsageType] [varchar](50) NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Days] [int] NULL,
	[TotalKwh] [decimal](15, 5) NULL,
	[BillingDemandKwh] [decimal](15, 5) NULL,
	[OffPeakKwh] [decimal](15, 5) NULL,
	[OnPeakKwh] [decimal](15, 5) NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL,
	[InterMediateKwh] [decimal](15, 5) NULL,
	[MonthlyOffPeakDemandKw] [decimal](15, 5) NULL,
	[ModifiedBy] [varchar](50) NULL,
	[MonthlyPeakDemandKw] [decimal](15, 5) NULL,
	[ID] [int] NULL,
	[IsConsolidated] [varchar](50) NULL,
	[isActive] [bit] NULL,
	[ReasonCode] [varchar](50) NULL,
	[MeterNumber] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


