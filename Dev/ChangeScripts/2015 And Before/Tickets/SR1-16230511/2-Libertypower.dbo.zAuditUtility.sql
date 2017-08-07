USE [LibertyPower]
GO

/****** Object:  Table [dbo].[zAuditUtility]    Script Date: 06/25/2012 11:16:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF OBJECT_ID ( '[dbo].[zAuditUtility]' ) IS NOT NULL 
    DROP TABLE [dbo].[zAuditUtility]
GO

CREATE TABLE [dbo].[zAuditUtility](
	[zAuditUtilityID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityCode] [varchar](50) NOT NULL,
	[FullName] [varchar](100) NOT NULL,
	[ShortName] [varchar](50) NOT NULL,
	[MarketID] [int] NOT NULL,
	[DunsNumber] [varchar](30) NULL,
	[EntityId] [varchar](15) NULL,
	[EnrollmentLeadDays] [int] NULL,
	[BillingType] [varchar](15) NULL,
	[AccountLength] [int] NULL,
	[AccountNumberPrefix] [varchar](10) NULL,
	[LeadScreenProcess] [varchar](15) NULL,
	[DealScreenProcess] [varchar](15) NULL,
	[PorOption] [varchar](3) NULL,
	[DateCreated] [datetime] NULL,
	[UserName] [nchar](200) NULL,
	[InactiveInd] [char](1) NULL,
	[ActiveDate] [datetime] NULL,
	[ChgStamp] [smallint] NULL,
	[MeterNumberRequired] [smallint] NULL,
	[MeterNumberLength] [smallint] NULL,
	[AnnualUsageMin] [int] NULL,
	[Qualifier] [varchar](50) NULL,
	[EdiCapable] [smallint] NULL,
	[WholeSaleMktID] [varchar](50) NULL,
	[Phone] [varchar](30) NULL,
	[RateCodeRequired] [tinyint] NULL,
	[HasZones] [tinyint] NULL,
	[ZoneDefault] [int] NULL,
	[RateCodeFormat] [varchar](20) NOT NULL,
	[RateCodeFields] [varchar](50) NOT NULL,
	[LegacyName] [varchar](100) NOT NULL,
	[SSNIsRequired] [bit] NULL,
	[PricingModeID] [int] NULL,
	[isIDR_EDI_Capable] [bit] NULL,
	[HU_RequestType] [nchar](10) NULL,
	[MultipleMeters] [bit] NULL,
	[AuditChangeType] [char](3) NOT NULL,
	[AuditChangeDate] [datetime] NOT NULL,
	[AuditChangeBy] [varchar](30) NOT NULL,
	[AuditChangeLocation] [varchar](30) NOT NULL,
	[ColumnsUpdated] [varchar](max) NOT NULL,
	[ColumnsChanged] [varchar](max) NOT NULL
	)
 ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[zAuditUtility] ADD  CONSTRAINT [DFzAuditUtilityAuditChangeDate]  DEFAULT (getdate()) FOR [AuditChangeDate]
GO

ALTER TABLE [dbo].[zAuditUtility] ADD  CONSTRAINT [DFzAuditUtilityAuditChangeBy]  DEFAULT (substring(suser_sname(),(1),(30))) FOR [AuditChangeBy]
GO

ALTER TABLE [dbo].[zAuditUtility] ADD  CONSTRAINT [DFzAuditUtilityAuditChangeLocation]  DEFAULT (substring(host_name(),(1),(30))) FOR [AuditChangeLocation]
GO

