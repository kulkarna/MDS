/****** Object:  Table [dbo].[RECONEDI_EDI]    Script Date: 3/19/2014 8:54:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDI](
	[814_Key] [int] NULL,
	[ISO] [varchar](50) NULL,
	[Esiid] [varchar](100) NULL,
	[UtilityCode] [varchar](50) NULL,
	[TdspDuns] [varchar](100) NULL,
	[TdspName] [varchar](100) NULL,
	[TransactionType] [varchar](100) NULL,
	[TransactionStatus] [varchar](100) NULL,
	[Direction] [bit] NULL,
	[ChangeReason] [varchar](100) NULL,
	[ChangeDescription] [varchar](100) NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionEffectiveDate] [datetime] NULL,
	[EsiIdStartDate] [varchar](100) NULL,
	[EsiIdEndDate] [varchar](100) NULL,
	[SpecialReadSwitchDate] [varchar](100) NULL,
	[EntityName] [varchar](100) NULL,
	[MeterNumber] [varchar](100) NULL,
	[PreviousESiId] [varchar](100) NULL,
	[LDCBillingCycle] [varchar](100) NULL,
	[TransactionSetId] [varchar](100) NULL,
	[TransactionSetControlNbr] [varchar](100) NULL,
	[TransactionSetPurposeCode] [varchar](100) NULL,
	[TransactionNbr] [varchar](100) NULL,
	[ReferenceNbr] [varchar](100) NULL,
	[CrDuns] [varchar](100) NULL,
	[CrName] [varchar](100) NULL,
	[ProcessFlag] [smallint] NULL,
	[ProcessDate] [datetime] NULL,
	[ServiceTypeCode1] [varchar](100) NULL,
	[ServiceType1] [varchar](100) NULL,
	[ServiceTypeCode2] [varchar](100) NULL,
	[ServiceType2] [varchar](100) NULL,
	[ServiceTypeCode3] [varchar](100) NULL,
	[ServiceType3] [varchar](100) NULL,
	[ServiceTypeCode4] [varchar](100) NULL,
	[ServiceType4] [varchar](100) NULL,
	[MaintenanceTypeCode] [varchar](100) NULL,
	[RejectCode] [varchar](100) NULL,
	[RejectReason] [varchar](100) NULL,
	[StatusCode] [varchar](100) NULL,
	[StatusReason] [varchar](100) NULL,
	[StatusType] [varchar](10) NULL,
	[CapacityObligation] [varchar](100) NULL,
	[TransmissionObligation] [varchar](100) NULL,
	[LBMPZone] [varchar](100) NULL,
	[PowerRegion] [varchar](100) NULL,
	[stationid] [varchar](100) NULL,
	[AssignId] [varchar](100) NULL,
	[Origin] [varchar](100) NULL,
	[ControlDate] [datetime] NULL,
	[DateProcessed] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_EDIPending]    Script Date: 3/19/2014 8:54:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDIPending](
	[814_Key] [int] NULL,
	[ISO] [varchar](50) NULL,
	[Esiid] [varchar](100) NULL,
	[UtilityCode] [varchar](50) NULL,
	[TdspDuns] [varchar](100) NULL,
	[TdspName] [varchar](100) NULL,
	[TransactionType] [varchar](100) NULL,
	[TransactionStatus] [varchar](100) NULL,
	[Direction] [bit] NULL,
	[ChangeReason] [varchar](100) NULL,
	[ChangeDescription] [varchar](100) NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionEffectiveDate] [datetime] NULL,
	[EsiIdStartDate] [varchar](100) NULL,
	[EsiIdEndDate] [varchar](100) NULL,
	[SpecialReadSwitchDate] [varchar](100) NULL,
	[EntityName] [varchar](100) NULL,
	[MeterNumber] [varchar](100) NULL,
	[PreviousESiId] [varchar](100) NULL,
	[LDCBillingCycle] [varchar](100) NULL,
	[TransactionSetId] [varchar](100) NULL,
	[TransactionSetControlNbr] [varchar](100) NULL,
	[TransactionSetPurposeCode] [varchar](100) NULL,
	[TransactionNbr] [varchar](100) NULL,
	[ReferenceNbr] [varchar](100) NULL,
	[CrDuns] [varchar](100) NULL,
	[CrName] [varchar](100) NULL,
	[ProcessFlag] [smallint] NULL,
	[ProcessDate] [datetime] NULL,
	[ServiceTypeCode1] [varchar](100) NULL,
	[ServiceType1] [varchar](100) NULL,
	[ServiceTypeCode2] [varchar](100) NULL,
	[ServiceType2] [varchar](100) NULL,
	[ServiceTypeCode3] [varchar](100) NULL,
	[ServiceType3] [varchar](100) NULL,
	[ServiceTypeCode4] [varchar](100) NULL,
	[ServiceType4] [varchar](100) NULL,
	[MaintenanceTypeCode] [varchar](100) NULL,
	[RejectCode] [varchar](100) NULL,
	[RejectReason] [varchar](100) NULL,
	[StatusCode] [varchar](100) NULL,
	[StatusReason] [varchar](100) NULL,
	[StatusType] [varchar](10) NULL,
	[CapacityObligation] [varchar](100) NULL,
	[TransmissionObligation] [varchar](100) NULL,
	[LBMPZone] [varchar](100) NULL,
	[PowerRegion] [varchar](100) NULL,
	[stationid] [varchar](100) NULL,
	[AssignId] [varchar](100) NULL,
	[Origin] [varchar](100) NULL,
	[ControlDate] [datetime] NULL,
	[DateProcessed] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_EDIPending_Work]    Script Date: 3/19/2014 8:54:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDIPending_Work](
	[814_Key] [int] NOT NULL,
	[Esiid] [varchar](50) NULL,
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
	[Origin] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_EDIResult]    Script Date: 3/19/2014 8:54:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDIResult](
	[ERID] [int] NOT NULL,
	[Esiid] [nvarchar](50) NULL,
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
	[ProcessDate] [datetime] NULL,
	[ControlDate] [datetime] NULL,
	[DateProcessed] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_EnrollmentChanges]    Script Date: 3/19/2014 8:54:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EnrollmentChanges](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[ContractID] [int] NOT NULL,
	[Term] [int] NOT NULL,
	[Action] [char](1) NOT NULL,
 CONSTRAINT [PK_RECONEDI_EnrollmentChanges] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_EnrollmentFixed]    Script Date: 3/19/2014 8:54:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EnrollmentFixed](
	[ENID] [bigint] IDENTITY(1,1) NOT NULL,
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
	[ProcessDate] [datetime] NULL,
	[ControlDate] [datetime] NULL,
	[DateProcessed] [datetime] NULL,
 CONSTRAINT [PK_RECONEDI_EnrollmentFixed] PRIMARY KEY CLUSTERED 
(
	[ENID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_EnrollmentIncremental]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EnrollmentIncremental](
	[ENID] [bigint] NOT NULL,
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
	[ProcessDate] [datetime] NULL,
	[ControlDate] [datetime] NULL,
	[DateProcessed] [datetime] NULL,
	[Action] [char](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_EnrollmentVariable]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EnrollmentVariable](
	[ENID] [int] IDENTITY(1,1) NOT NULL,
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
	[ProcessDate] [datetime] NULL,
	[ControlDate] [datetime] NULL,
	[DateProcessed] [datetime] NULL,
 CONSTRAINT [PK_RECONEDI_EnrollmentVariable] PRIMARY KEY CLUSTERED 
(
	[ENID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_Filter]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_Filter](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ISO] [varchar](50) NULL,
	[Utility] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[Action] [char](1) NULL,
 CONSTRAINT [PK_RECONEDI_Filter] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_ForecastDaily]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECONEDI_ForecastDaily](
	[FDailyID] [bigint] IDENTITY(1,1) NOT NULL,
	[ENID] [bigint] NOT NULL,
	[FDatesID] [bigint] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RECONEDI_ForecastDates]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_ForecastDates](
	[FDatesID] [bigint] IDENTITY(1,1) NOT NULL,
	[ENID] [bigint] NULL,
	[ActualStartDate] [datetime] NULL,
	[ActualEndDate] [datetime] NULL,
	[OverlapIndicator] [char](1) NULL,
	[OverlapDays] [int] NULL,
	[SearchActualStartDate] [datetime] NULL,
	[SearchActualEndDate] [datetime] NULL,
 CONSTRAINT [PK_RECONEDI_ForecastDates] PRIMARY KEY CLUSTERED 
(
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_ForecastWholesale]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECONEDI_ForecastWholesale](
	[FWhosaleID] [bigint] IDENTITY(1,1) NOT NULL,
	[ENID] [int] NOT NULL,
	[FDatesID] [int] NOT NULL,
	[UsagesYear] [int] NULL,
	[MinDate] [datetime] NULL,
	[Maxdate] [datetime] NULL,
	[ETP] [float] NULL,
	[Month01TotalVolume] [float] NULL,
	[Month02TotalVolume] [float] NULL,
	[Month03TotalVolume] [float] NULL,
	[Month04TotalVolume] [float] NULL,
	[Month05TotalVolume] [float] NULL,
	[Month06TotalVolume] [float] NULL,
	[Month07TotalVolume] [float] NULL,
	[Month08TotalVolume] [float] NULL,
	[Month09TotalVolume] [float] NULL,
	[Month10TotalVolume] [float] NULL,
	[Month11TotalVolume] [float] NULL,
	[Month12TotalVolume] [float] NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RECONEDI_ForecastWholesaleError]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_ForecastWholesaleError](
	[FWhosaleErrorID] [bigint] IDENTITY(1,1) NOT NULL,
	[ENID] [int] NOT NULL,
	[ErrorType] [varchar](20) NOT NULL,
 CONSTRAINT [PK_RECONEDI_ForecastWholesaleError] PRIMARY KEY CLUSTERED 
(
	[FWhosaleErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_Header]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_Header](
	[REHID] [bigint] IDENTITY(1,1) NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Utility] [varchar](50) NOT NULL,
	[ProductCategory] [varchar](50) NOT NULL,
	[ProcessType] [varchar](50) NOT NULL,
	[Process] [char](1) NOT NULL,
	[ReconProcessDate] [datetime] NOT NULL,
	[ReconSubmitDate] [datetime] NOT NULL,
	[ReconAccountChangeDate] [datetime] NOT NULL,
	[EnrollmentStep] [bit] NOT NULL,
	[MTMStep] [bit] NOT NULL,
	[EDIStep] [bit] NOT NULL,
	[EDIResultStep] [bit] NOT NULL,
	[ForecastStep] [bit] NOT NULL,
	[STID] [int] NOT NULL,
	[Notes] [varchar](100) NOT NULL,
	[ProcessDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RECONEDI_Header] PRIMARY KEY CLUSTERED 
(
	[REHID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_ISOControl]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_ISOControl](
	[ISO] [varchar](50) NULL,
	[814_Key] [int] NOT NULL,
	[AccountChange] [datetime] NULL,
	[Forecast] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_ISOProcess]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_ISOProcess](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Criteria] [varchar](80) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_MTM]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_MTM](
	[ENID] [int] NULL,
	[ID] [int] NULL,
	[BatchNumber] [varchar](50) NULL,
	[QuoteNumber] [varchar](50) NULL,
	[AccountID] [int] NULL,
	[ContractID] [int] NULL,
	[Zone] [varchar](50) NULL,
	[LoadProfile] [varchar](50) NULL,
	[ProxiedZone] [bit] NULL,
	[ProxiedProfile] [bit] NULL,
	[ProxiedUsage] [bit] NULL,
	[MeterReadCount] [int] NULL,
	[Status] [varchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[DateModified] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_NYISOOld]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECONEDI_NYISOOld](
	[Utility] [nvarchar](255) NULL,
	[UtilAcct] [nvarchar](255) NULL,
	[ESCO] [nvarchar](255) NULL,
	[ESCOAcct] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[ServAddr] [nvarchar](255) NULL,
	[BillAddr] [nvarchar](255) NULL,
	[TransmissionDate] [nvarchar](255) NULL,
	[TrnsType] [nvarchar](255) NULL,
	[TrnsPurp] [nvarchar](255) NULL,
	[Reason] [nvarchar](255) NULL,
	[ServType] [nvarchar](255) NULL,
	[TransEffDate] [nvarchar](255) NULL,
	[BillingParty] [nvarchar](255) NULL,
	[BillingType] [nvarchar](255) NULL,
	[ReadCycle] [nvarchar](255) NULL,
	[MeterCycle] [nvarchar](255) NULL,
	[MarketerRate] [nvarchar](255) NULL,
	[UtilityRateClass] [nvarchar](255) NULL,
	[LoadProfile] [nvarchar](255) NULL,
	[Meter] [nvarchar](255) NULL,
	[MeterTicketNumber] [nvarchar](255) NULL,
	[Blank1] [nvarchar](255) NULL,
	[Blank2] [nvarchar](255) NULL,
	[Blank3] [nvarchar](255) NULL,
	[HumanNeedsCust] [nvarchar](255) NULL,
	[NYISOArea] [nvarchar](255) NULL,
	[TaxedResidential] [nvarchar](255) NULL,
	[TaxStatus] [nvarchar](255) NULL,
	[LifeSupportCust] [nvarchar](255) NULL,
	[BudgetBilling] [nvarchar](255) NULL,
	[PartialParticipation] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[CubsRate] [nvarchar](255) NULL,
	[FeeApproved] [nvarchar](255) NULL,
	[UtilitySubClass] [nvarchar](255) NULL,
	[MeterType] [nvarchar](255) NULL,
	[OldInformation] [nvarchar](255) NULL,
	[TrackingNumber] [nvarchar](255) NULL,
	[FileLoadDate] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RECONEDI_NYISORisk]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_NYISORisk](
	[814_Key] [int] NOT NULL,
	[ISO] [varchar](50) NULL,
	[Esiid] [varchar](100) NULL,
	[UtilityCode] [varchar](50) NULL,
	[TdspDuns] [varchar](100) NULL,
	[TdspName] [varchar](100) NULL,
	[TransactionType] [varchar](100) NULL,
	[TransactionStatus] [varchar](100) NULL,
	[Direction] [bit] NULL,
	[ChangeReason] [varchar](100) NULL,
	[ChangeDescription] [varchar](100) NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionEffectiveDate] [datetime] NULL,
	[EsiIdStartDate] [varchar](100) NULL,
	[EsiIdEndDate] [varchar](100) NULL,
	[SpecialReadSwitchDate] [varchar](100) NULL,
	[EntityName] [varchar](100) NULL,
	[MeterNumber] [varchar](100) NULL,
	[PreviousESiId] [varchar](100) NULL,
	[LDCBillingCycle] [varchar](100) NULL,
	[TransactionSetId] [varchar](100) NULL,
	[TransactionSetControlNbr] [varchar](100) NULL,
	[TransactionSetPurposeCode] [varchar](100) NULL,
	[TransactionNbr] [varchar](100) NULL,
	[ReferenceNbr] [varchar](100) NULL,
	[CrDuns] [varchar](100) NULL,
	[CrName] [varchar](100) NULL,
	[ProcessFlag] [smallint] NULL,
	[ProcessDate] [datetime] NULL,
	[ServiceTypeCode1] [varchar](100) NULL,
	[ServiceType1] [varchar](100) NULL,
	[ServiceTypeCode2] [varchar](100) NULL,
	[ServiceType2] [varchar](100) NULL,
	[ServiceTypeCode3] [varchar](100) NULL,
	[ServiceType3] [varchar](100) NULL,
	[ServiceTypeCode4] [varchar](100) NULL,
	[ServiceType4] [varchar](100) NULL,
	[MaintenanceTypeCode] [varchar](100) NULL,
	[RejectCode] [varchar](100) NULL,
	[RejectReason] [varchar](100) NULL,
	[StatusCode] [varchar](100) NULL,
	[StatusReason] [varchar](100) NULL,
	[StatusType] [varchar](10) NULL,
	[CapacityObligation] [varchar](100) NULL,
	[TransmissionObligation] [varchar](100) NULL,
	[LBMPZone] [varchar](100) NULL,
	[PowerRegion] [varchar](100) NULL,
	[stationid] [varchar](100) NULL,
	[AssignId] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_Status]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_Status](
	[STID] [int] IDENTITY(1,1) NOT NULL,
	[Status] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RECONEDI_Status] PRIMARY KEY CLUSTERED 
(
	[STID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_Tracking]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_Tracking](
	[RETID] [bigint] IDENTITY(1,1) NOT NULL,
	[REHID] [bigint] NOT NULL,
	[ISO] [varchar](50) NOT NULL,
	[Utility] [varchar](50) NOT NULL,
	[StepName] [varchar](50) NOT NULL,
	[StepDate] [datetime] NOT NULL,
	[Notes] [varchar](100) NOT NULL,
 CONSTRAINT [PK_RECONEDI_Tracking] PRIMARY KEY CLUSTERED 
(
	[RETID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_Transaction]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_Transaction](
	[ISO] [varchar](50) NOT NULL,
	[Action] [char](1) NOT NULL,
	[ProcessType] [varchar](100) NOT NULL,
	[TransactionType] [varchar](100) NOT NULL,
	[TransactionStatus] [varchar](100) NOT NULL,
	[StatusCode] [varchar](100) NOT NULL,
	[ChangeReason] [varchar](100) NOT NULL,
	[ChangeDescription] [varchar](100) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RECONEDI_UtilityProcess]    Script Date: 3/19/2014 8:54:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_UtilityProcess](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Criteria] [varchar](80) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EDI]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE CLUSTERED INDEX [idx_RECONEDI_EDI] ON [dbo].[RECONEDI_EDI]
(
	[UtilityCode] ASC,
	[Esiid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EDIPending]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE CLUSTERED INDEX [idx_RECONEDI_EDIPending] ON [dbo].[RECONEDI_EDIPending]
(
	[UtilityCode] ASC,
	[Esiid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EDIPending_Work]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE CLUSTERED INDEX [idx_RECONEDI_EDIPending_Work] ON [dbo].[RECONEDI_EDIPending_Work]
(
	[UtilityCode] ASC,
	[Esiid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx2_RECONEDI_EnrollmentIncremental]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE CLUSTERED INDEX [idx2_RECONEDI_EnrollmentIncremental] ON [dbo].[RECONEDI_EnrollmentIncremental]
(
	[ISO] ASC,
	[ControlDate] ASC,
	[Action] ASC,
	[ENID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_RECONEDI_MTM]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE CLUSTERED INDEX [idx_RECONEDI_MTM] ON [dbo].[RECONEDI_MTM]
(
	[ENID] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx1_RECONEDI_EDI]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_EDI] ON [dbo].[RECONEDI_EDI]
(
	[ISO] ASC,
	[814_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx1_RECONEDI_EDIPending]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_EDIPending] ON [dbo].[RECONEDI_EDIPending]
(
	[ISO] ASC,
	[ControlDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EDIResult]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EDIResult] ON [dbo].[RECONEDI_EDIResult]
(
	[UtilityCode] ASC,
	[Esiid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_RECONEDI_EnrollmentChanges]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EnrollmentChanges] ON [dbo].[RECONEDI_EnrollmentChanges]
(
	[AccountID] ASC,
	[ContractID] ASC,
	[Term] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EnrollmentFixed]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[ProcessType] ASC,
	[ISO] ASC,
	[Utility] ASC,
	[ENID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx1_RECONEDI_EnrollmentFixed]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[Utility] ASC,
	[ENID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx2_RECONEDI_EnrollmentFixed]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx2_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[Utility] ASC,
	[AccountID] ASC,
	[ContractID] ASC,
	[RateID] ASC,
	[Rate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx3_RECONEDI_EnrollmentFixed]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx3_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[AccountID] ASC,
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx4_RECONEDI_EnrollmentFixed]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx4_RECONEDI_EnrollmentFixed] ON [dbo].[RECONEDI_EnrollmentFixed]
(
	[Utility] ASC,
	[AccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EnrollmentIncremental]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EnrollmentIncremental] ON [dbo].[RECONEDI_EnrollmentIncremental]
(
	[Utility] ASC,
	[ProcessDate] ASC,
	[Action] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx1_RECONEDI_EnrollmentIncremental]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_EnrollmentIncremental] ON [dbo].[RECONEDI_EnrollmentIncremental]
(
	[ProcessDate] ASC,
	[Action] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EnrollmentVariable]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EnrollmentVariable] ON [dbo].[RECONEDI_EnrollmentVariable]
(
	[Utility] ASC,
	[AccountID] ASC,
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_Filter]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_Filter] ON [dbo].[RECONEDI_Filter]
(
	[Utility] ASC,
	[AccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx1_RECONEDI_Filter]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_Filter] ON [dbo].[RECONEDI_Filter]
(
	[ISO] ASC,
	[Utility] ASC,
	[AccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_RECONEDI_ForecastDaily]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_ForecastDaily] ON [dbo].[RECONEDI_ForecastDaily]
(
	[ENID] ASC,
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx1_RECONEDI_ForecastDaily]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_ForecastDaily] ON [dbo].[RECONEDI_ForecastDaily]
(
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_RECONEDI_ForecastDates]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_ForecastDates] ON [dbo].[RECONEDI_ForecastDates]
(
	[ENID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_RECONEDI_ForecastWholesale]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_ForecastWholesale] ON [dbo].[RECONEDI_ForecastWholesale]
(
	[ENID] ASC,
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx1_RECONEDI_ForecastWholesale]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_ForecastWholesale] ON [dbo].[RECONEDI_ForecastWholesale]
(
	[FDatesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_ForecastWholesaleError]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_ForecastWholesaleError] ON [dbo].[RECONEDI_ForecastWholesaleError]
(
	[ENID] ASC,
	[ErrorType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx1_RECONEDI_MTM]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_MTM] ON [dbo].[RECONEDI_MTM]
(
	[AccountID] ASC,
	[ContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_Transaction]    Script Date: 3/19/2014 8:54:54 AM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_Transaction] ON [dbo].[RECONEDI_Transaction]
(
	[ISO] ASC,
	[Action] ASC,
	[ProcessType] ASC,
	[TransactionType] ASC,
	[TransactionStatus] ASC,
	[StatusCode] ASC,
	[ChangeReason] ASC,
	[ChangeDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
