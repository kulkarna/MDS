/****** Object:  Table [dbo].[RECONEDI_EnrollmentFixed]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EnrollmentFixed](
	[EnrollmentID] [int] IDENTITY(1,1) NOT NULL,
	[ReconID] [int] NOT NULL,
	[ProcessType] [varchar](50) NULL,
	[ISO] [varchar](50) NULL,
	[AccountID] [int] NULL,
	[AccountType] [varchar](50) NULL,
	[Utility] [varchar](50) NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[ContractID] [int] NULL,
	[ContractNumber] [varchar](50) NULL,
	[Term] [int] NULL,
	[Status] [varchar](15) NULL,
	[SubStatus] [varchar](15) NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ContractStartDate] [datetime] NULL,
	[ContractEndDate] [datetime] NULL,
	[ContractRateStart] [datetime] NULL,
	[ContractRateEnd] [datetime] NULL,
	[LastServiceStartDate] [datetime] NULL,
	[LastServiceEndDate] [datetime] NULL,
	[ServiceStartDate] [datetime] NULL,
	[ServiceEndDate] [datetime] NULL,
	[CriteriaStartDate] [datetime] NULL,
	[CriteriaEndDate] [datetime] NULL,
	[CriteriaStatus] [varchar](20) NULL,
	[SubmitDate] [datetime] NULL,
	[Zone] [varchar](50) NULL,
	[ContractStatusID] [int] NULL,
	[ProductID] [varchar](20) NULL,
	[ProductCategory] [varchar](20) NULL,
	[ProductSubCategory] [varchar](50) NULL,
	[RateID] [int] NULL,
	[Rate] [float] NULL,
	[IsContractedRate] [int] NULL,
	[PricingRequestID] [varchar](50) NULL,
	[BackToBack] [int] NULL,
	[AnnualUsage] [int] NULL,
	[InvoiceID] [varchar](100) NULL,
	[InvoiceFromDate] [datetime] NULL,
	[InvoiceToDate] [datetime] NULL,
	[OverlapType] [char](1) NULL,
	[OverlapDays] [int] NULL,
	[AsOfDate] [date] NULL,
	[ProcessDate] [datetime] NULL,
	[ForecastType] [varchar](15) NOT NULL,
	[ParentEnrollmentID] [int] NOT NULL,
 CONSTRAINT [PK_RECONEDI_EnrollmentFixed] PRIMARY KEY CLUSTERED 
(
	[EnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EnrollmentFixed]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[ReconID] ASC,
	[ISO] ASC,
	[Utility] ASC,
	[EnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx1_RECONEDI_EnrollmentFixed]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[ReconID] ASC,
	[Utility] ASC,
	[EnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx2_RECONEDI_EnrollmentFixed]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx2_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[ReconID] ASC,
	[ISO] ASC,
	[Utility] ASC,
	[ContractID] ASC,
	[Term] ASC,
	[ContractRateStart] ASC,
	[ContractRateEnd] ASC,
	[ForecastType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [idx3_RECONEDI_EnrollmentFixed]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx3_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[ReconID] ASC,
	[AccountID] ASC,
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx4_RECONEDI_EnrollmentFixed]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx4_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[ReconID] ASC,
	[Utility] ASC,
	[AccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [idx5_RECONEDI_EnrollmentFixed]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx5_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[ReconID] ASC,
	[EnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
