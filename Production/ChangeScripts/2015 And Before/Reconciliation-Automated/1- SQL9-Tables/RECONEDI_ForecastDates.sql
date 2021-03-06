/****** Object:  Table [dbo].[RECONEDI_ForecastDates]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_ForecastDates](
	[FDatesID] [int] IDENTITY(1,1) NOT NULL,
	[EnrollmentID] [int] NULL,
	[ActualStartDate] [datetime] NULL,
	[ActualEndDate] [datetime] NULL,
	[OverlapIndicator] [char](1) NULL,
	[OverlapDays] [int] NULL,
	[SearchActualStartDate] [datetime] NULL,
	[SearchActualEndDate] [datetime] NULL,
 CONSTRAINT [PK_RECONEDI_ForecastDates] PRIMARY KEY CLUSTERED 
(
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [idx_RECONEDI_ForecastDates]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_ForecastDates] ON [dbo].[RECONEDI_ForecastDates]
(
	[EnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
