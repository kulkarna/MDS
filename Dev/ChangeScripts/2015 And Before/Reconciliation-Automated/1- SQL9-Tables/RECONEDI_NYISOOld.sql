/****** Object:  Table [dbo].[RECONEDI_NYISOOld]    Script Date: 6/26/2014 4:13:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECONEDI_NYISOOld](
	[814_key] [bigint] IDENTITY(1,1) NOT NULL,
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
	[FileLoadDate] [nvarchar](255) NULL,
 CONSTRAINT [PK_RECONEDI_NYISOOld] PRIMARY KEY CLUSTERED 
(
	[814_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
