USE [lp_MtM]
GO

/****** Object:  Table [dbo].[MtMRiskControlProcess]    Script Date: 11/29/2013 16:26:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MtMRiskControlProcess](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NULL,
	[MtMAccountID] [int] NULL,
	[AccountNumber] [varchar](50) NULL,
	[ContractNumber] [varchar](50) NULL,
	[UtilityCode] [varchar](50) NULL,
	[BatchNumber] [varchar](100) NULL,
	[QuoteNumber] [varchar](100) NULL,
	[Status] [varchar](50) NULL,
	[MeterType] [varchar](50) NULL,
	[IsDaily] [bit] NULL,
	[RateStartDate] [datetime] NULL,
	[RateEndDate] [datetime] NULL,
	[ReasonID] [int] NULL,
	[LoadProfile] [varchar](50) NULL,
	[Zone] [varchar](50) NULL,
 CONSTRAINT [PK_MtMRiskControlProcess] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [Data_01]
) ON [Data_01]

GO

SET ANSI_PADDING OFF
GO

