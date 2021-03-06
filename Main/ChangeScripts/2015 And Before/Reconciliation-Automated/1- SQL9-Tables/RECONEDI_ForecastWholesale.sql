/****** Object:  Table [dbo].[RECONEDI_ForecastWholesale]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECONEDI_ForecastWholesale](
	[FWhosaleID] [int] IDENTITY(1,1) NOT NULL,
	[EnrollmentID] [int] NOT NULL,
	[FDatesID] [int] NOT NULL,
	[UsagesYear] [int] NULL,
	[MinDate] [datetime] NULL,
	[Maxdate] [datetime] NULL,
	[ETP] [float] NULL,
	[Month01TotalVolume] [decimal](20, 4) NULL,
	[Month02TotalVolume] [decimal](20, 4) NULL,
	[Month03TotalVolume] [decimal](20, 4) NULL,
	[Month04TotalVolume] [decimal](20, 4) NULL,
	[Month05TotalVolume] [decimal](20, 4) NULL,
	[Month06TotalVolume] [decimal](20, 4) NULL,
	[Month07TotalVolume] [decimal](20, 4) NULL,
	[Month08TotalVolume] [decimal](20, 4) NULL,
	[Month09TotalVolume] [decimal](20, 4) NULL,
	[Month10TotalVolume] [decimal](20, 4) NULL,
	[Month11TotalVolume] [decimal](20, 4) NULL,
	[Month12TotalVolume] [decimal](20, 4) NULL,
	[Month01TotalPeak] [float] NULL,
	[Month02TotalPeak] [float] NULL,
	[Month03TotalPeak] [float] NULL,
	[Month04TotalPeak] [float] NULL,
	[Month05TotalPeak] [float] NULL,
	[Month06TotalPeak] [float] NULL,
	[Month07TotalPeak] [float] NULL,
	[Month08TotalPeak] [float] NULL,
	[Month09TotalPeak] [float] NULL,
	[Month10TotalPeak] [float] NULL,
	[Month11TotalPeak] [float] NULL,
	[Month12TotalPeak] [float] NULL,
	[Month01TotalOffPeak] [float] NULL,
	[Month02TotalOffPeak] [float] NULL,
	[Month03TotalOffPeak] [float] NULL,
	[Month04TotalOffPeak] [float] NULL,
	[Month05TotalOffPeak] [float] NULL,
	[Month06TotalOffPeak] [float] NULL,
	[Month07TotalOffPeak] [float] NULL,
	[Month08TotalOffPeak] [float] NULL,
	[Month09TotalOffPeak] [float] NULL,
	[Month10TotalOffPeak] [float] NULL,
	[Month11TotalOffPeak] [float] NULL,
	[Month12TotalOffPeak] [float] NULL,
 CONSTRAINT [PK_RECONEDI_ForecastWholesale] PRIMARY KEY CLUSTERED 
(
	[FWhosaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [idx_RECONEDI_ForecastWholesale]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_ForecastWholesale] ON [dbo].[RECONEDI_ForecastWholesale]
(
	[EnrollmentID] ASC,
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [idx1_RECONEDI_ForecastWholesale]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_ForecastWholesale] ON [dbo].[RECONEDI_ForecastWholesale]
(
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
