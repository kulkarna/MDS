/****** Object:  Table [dbo].[RECONEDI_EDIPending]    Script Date: 6/26/2014 4:13:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RECONEDI_EDIPending](
	[ID] [int] IDENTITY(1,1) NOT NULL,
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
	[AssignId] [varchar](100) NULL,
	[Origin] [varchar](100) NULL,
	[AsOfDate] [date] NULL,
	[ReconProcessDate] [datetime] NULL,
	[ReconID] [int] NOT NULL,
 CONSTRAINT [PK_RECONEDI_EDIPending] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_RECONEDI_EDIPending]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx_RECONEDI_EDIPending] ON [dbo].[RECONEDI_EDIPending]
(
	[ISO] ASC,
	[UtilityCode] ASC,
	[Esiid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx1_RECONEDI_EDIPending]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx1_RECONEDI_EDIPending] ON [dbo].[RECONEDI_EDIPending]
(
	[ISO] ASC,
	[AsOfDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [idx2_RECONEDI_EDIPending]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx2_RECONEDI_EDIPending] ON [dbo].[RECONEDI_EDIPending]
(
	[ID] ASC,
	[814_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Object:  Index [idx3_RECONEDI_EDIPending]    Script Date: 6/26/2014 4:13:59 PM ******/
CREATE NONCLUSTERED INDEX [idx3_RECONEDI_EDIPending] ON [dbo].[RECONEDI_EDIPending]
(
	[ReconID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
