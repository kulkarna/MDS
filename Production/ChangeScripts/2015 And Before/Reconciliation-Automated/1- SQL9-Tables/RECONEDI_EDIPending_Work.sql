/****** Object:  Table [dbo].[RECONEDI_EDIPending_Work]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDIPending_Work](
	[ID] [int] NOT NULL,
	[814_Key] [int] NOT NULL,
	[Esiid] [varchar](50) NOT NULL,
	[UtilityCode] [varchar](50) NULL,
	[TransactionType] [nvarchar](255) NULL,
	[TransactionStatus] [nvarchar](255) NULL,
	[ChangeReason] [nvarchar](255) NULL,
	[ChangeDescription] [nvarchar](255) NULL,
	[StatusCode] [nvarchar](255) NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionEffectiveDate] [datetime] NULL,
	[ReferenceNbr] [varchar](100) NULL,
	[TransactionNbr] [varchar](100) NULL,
	[AssignId] [varchar](100) NULL,
	[Origin] [varchar](100) NULL,
	[TransactionSetControlNbr] [varchar](100) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx1_RECONEDI_EDIPending_Work]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE UNIQUE CLUSTERED INDEX [idx1_RECONEDI_EDIPending_Work] ON [dbo].[RECONEDI_EDIPending_Work]
(
	[ID] ASC,
	[814_Key] ASC,
	[Esiid] ASC,
	[UtilityCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EDIPending_Work]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EDIPending_Work] ON [dbo].[RECONEDI_EDIPending_Work]
(
	[UtilityCode] ASC,
	[Esiid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
