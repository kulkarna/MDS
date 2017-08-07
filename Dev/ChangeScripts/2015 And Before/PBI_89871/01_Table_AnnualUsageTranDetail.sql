USE [LibertyPower]
GO

/****** Object:  Table [dbo].[AnnualUsageTranDetail]    Script Date: 9/24/2015 3:50:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AnnualUsageTranDetail](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountId] [bigint] NOT NULL,
	[AccountNumber] [nvarchar](30) NULL,
	[UtilityId] [int] NULL,
	[AnnualUsage] [int] NULL,
	[CreateDate] [datetime] NULL,
	[Iscomplete] [int] NULL,
 CONSTRAINT [PK_AnnualUsageTranDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO


