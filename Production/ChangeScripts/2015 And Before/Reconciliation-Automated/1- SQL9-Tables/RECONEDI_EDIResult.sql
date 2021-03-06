/****** Object:  Table [dbo].[RECONEDI_EDIResult]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDIResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[LineRef] [int] NOT NULL,
	[Esiid] [varchar](50) NULL,
	[UtilityCode] [nvarchar](50) NULL,
	[IDFrom] [int] NULL,
	[TransactionDateFrom] [datetime] NULL,
	[TransactionEffectiveDateFrom] [datetime] NULL,
	[ReadCycleDateFrom] [datetime] NULL,
	[OriginFrom] [varchar](100) NULL,
	[ReferenceNbrFrom] [varchar](100) NULL,
	[IDTo] [int] NULL,
	[TransactionDateTo] [datetime] NULL,
	[TransactionEffectiveDateTo] [datetime] NULL,
	[ReadCycleDateTo] [datetime] NULL,
	[OriginTo] [varchar](100) NULL,
	[ReferenceNbrTo] [varchar](100) NULL,
	[Note] [varchar](500) NULL,
	[Status] [varchar](8) NULL,
	[DateCanRej] [datetime] NULL,
	[AsOfDate] [datetime] NULL,
	[ProcessDate] [datetime] NULL,
 CONSTRAINT [PK_RECONEDI_EDIResult] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EDIResult]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EDIResult] ON [dbo].[RECONEDI_EDIResult]
(
	[ReconID] ASC,
	[UtilityCode] ASC,
	[Esiid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
