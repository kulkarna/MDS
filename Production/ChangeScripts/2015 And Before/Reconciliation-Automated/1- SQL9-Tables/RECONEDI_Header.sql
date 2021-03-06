/****** Object:  Table [dbo].[RECONEDI_Header]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_Header](
	[ReconID] [int] IDENTITY(1,1) NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Utility] [varchar](50) NOT NULL,
	[AsOfDate] [date] NOT NULL,
	[StatusID] [int] NOT NULL,
	[SubStatusID] [int] NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[ProcessDate] [datetime] NOT NULL,
	[EmailList] [varchar](500) NOT NULL,
	[ParentReconID] [int] NOT NULL,
 CONSTRAINT [PK_RECONEDI_Header] PRIMARY KEY CLUSTERED 
(
	[ReconID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
