/****** Object:  Table [dbo].[RECONEDI_MarkToMarketData]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_MarkToMarketData](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[AccountID] [int] NULL,
	[ContractID] [int] NULL,
	[ContractNumber] [varchar](50) NULL,
	[ISO] [varchar](10) NULL,
	[UtilityCode] [varchar](50) NULL,
	[AccountNumber] [varchar](30) NULL,
	[Zone] [varchar](50) NULL,
	[MtMAccountID] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[YearUsage] [int] NULL,
	[Volume] [decimal](38, 4) NULL,
	[Book] [bit] NOT NULL,
	[AsOfDate] [date] NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_RECONEDI_MarkToMarketData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [idx_RECONEDI_MarkToMarketData]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_MarkToMarketData] ON [dbo].[RECONEDI_MarkToMarketData]
(
	[ReconID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
