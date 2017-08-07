/****** Object:  Table [dbo].[RECONEDI_EDIPendingControl]    Script Date: 7/3/2014 2:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDIPendingControl](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Utility] [varchar](50) NOT NULL,
	[AsOfDate] [date] NOT NULL,
	[InactiveInd] [bit] NOT NULL,
 CONSTRAINT [PK_RECONEDI_EDIPendingControl] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EDIPendingControl]    Script Date: 7/3/2014 2:51:00 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EDIPendingControl] ON [dbo].[RECONEDI_EDIPendingControl]
(
	[ReconID] ASC,
	[ISO] ASC,
	[Utility] ASC,
	[InactiveInd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
