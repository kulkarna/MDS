/****** Object:  Table [dbo].[RECONEDI_ForecastDaily]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECONEDI_ForecastDaily](
	[FDailyID] [int] IDENTITY(1,1) NOT NULL,
	[EnrollmentID] [int] NOT NULL,
	[FDatesID] [int] NOT NULL,
	[UsagesYear] [int] NULL,
	[MinDate] [datetime] NULL,
	[Maxdate] [datetime] NULL,
	[Month01Peak] [float] NULL,
	[Month01OffPeak] [float] NULL,
	[Month02Peak] [float] NULL,
	[Month02OffPeak] [float] NULL,
	[Month03Peak] [float] NULL,
	[Month03OffPeak] [float] NULL,
	[Month04Peak] [float] NULL,
	[Month04OffPeak] [float] NULL,
	[Month05Peak] [float] NULL,
	[Month05OffPeak] [float] NULL,
	[Month06Peak] [float] NULL,
	[Month06OffPeak] [float] NULL,
	[Month07Peak] [float] NULL,
	[Month07OffPeak] [float] NULL,
	[Month08Peak] [float] NULL,
	[Month08OffPeak] [float] NULL,
	[Month09Peak] [float] NULL,
	[Month09OffPeak] [float] NULL,
	[Month10Peak] [float] NULL,
	[Month10OffPeak] [float] NULL,
	[Month11Peak] [float] NULL,
	[Month11OffPeak] [float] NULL,
	[Month12Peak] [float] NULL,
	[Month12OffPeak] [float] NULL,
 CONSTRAINT [PK_RECONEDI_ForecastDaily] PRIMARY KEY CLUSTERED 
(
	[FDailyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [idx_RECONEDI_ForecastDaily]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_ForecastDaily] ON [dbo].[RECONEDI_ForecastDaily]
(
	[EnrollmentID] ASC,
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [idx1_RECONEDI_ForecastDaily]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_ForecastDaily] ON [dbo].[RECONEDI_ForecastDaily]
(
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
