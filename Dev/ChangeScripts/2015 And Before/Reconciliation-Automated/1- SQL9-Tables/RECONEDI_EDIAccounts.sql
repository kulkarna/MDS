/****** Object:  Table [dbo].[RECONEDI_EDIAccounts]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDIAccounts](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[AccountID] [int] NULL,
	[ContractID] [int] NULL,
	[ContractNumber] [varchar](50) NULL,
	[ISO] [varchar](50) NULL,
	[Utility] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[ContractRateStart] [datetime] NULL,
	[ContractRateEnd] [datetime] NULL,
	[ProcessType] [varchar](50) NULL,
	[ReconStatus] [varchar](20) NULL,
	[ReconReasonID] [varchar](100) NULL,
 CONSTRAINT [PK_RECONEDI_EDIAccounts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [idx_RECONEDI_EDIAccounts]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EDIAccounts] ON [dbo].[RECONEDI_EDIAccounts]
(
	[ReconID] ASC,
	[AccountID] ASC,
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
