/****** Object:  Table [dbo].[RECONEDI_MTMAccounts]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_MTMAccounts](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[AccountID] [int] NULL,
	[ContractID] [int] NULL,
	[ContractNumber] [varchar](50) NULL,
	[ISO] [varchar](50) NULL,
	[Utility] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[MtMAccountID] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Book] [int] NULL,
	[ReconStatus] [varchar](20) NULL,
	[ReconReasonID] [varchar](100) NULL,
 CONSTRAINT [PK_RECONEDI_MTMAccounts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
