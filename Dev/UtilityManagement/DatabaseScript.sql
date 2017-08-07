USE [master]
GO


-------------------------------- CREATE DATABASE BEGIN -------------------------------------


/****** Object:  Database [Lp_UtilityManagement]    Script Date: 06/05/2013 13:01:32 ******/
CREATE DATABASE [Lp_UtilityManagement] ON  PRIMARY 
( NAME = N'Lp_UtilityManagement', FILENAME = N'E:\MSSQL.SHRINK\Data\Lp_UtilityManagement.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Lp_UtilityManagement_log', FILENAME = N'E:\MSSQL.SHRINK\Logs\Lp_UtilityManagement_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [Lp_UtilityManagement] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Lp_UtilityManagement].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Lp_UtilityManagement] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET ARITHABORT OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Lp_UtilityManagement] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Lp_UtilityManagement] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Lp_UtilityManagement] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Lp_UtilityManagement] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Lp_UtilityManagement] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Lp_UtilityManagement] SET  READ_WRITE 
GO
ALTER DATABASE [Lp_UtilityManagement] SET RECOVERY FULL 
GO
ALTER DATABASE [Lp_UtilityManagement] SET  MULTI_USER 
GO
ALTER DATABASE [Lp_UtilityManagement] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Lp_UtilityManagement] SET DB_CHAINING OFF 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO


USE [Lp_UtilityManagement]
GO


-------------------------------- CREATE DATABASE END -------------------------------------


CREATE USER [LibertyPowerUtilityManagementUser] FOR LOGIN [LibertyPowerUtilityManagementUser] WITH DEFAULT_SCHEMA=[dbo]
GO





-------------------------------- CREATE TABLES BEGIN -------------------------------------



CREATE TABLE [dbo].[ChangeTableVersioning](
	[Id] [uniqueidentifier] NOT NULL,
	[ChangeTrackingVersion] [bigint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ChangeTableVersioning] PRIMARY KEY CLUSTERED  ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Log](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DATE] [datetime] NOT NULL,
	[THREAD] [varchar](255) NOT NULL,
	[LEV] [varchar](50) NOT NULL,
	[LOGGER] [varchar](255) NOT NULL,
	[MESSAGE] [varchar](4000) NOT NULL,
	[EXCEPTION] [varchar](2000) NULL
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED  ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[RequestModeTypeGenre](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeTypeGenre] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RequestModeTypeGenre] ADD  DEFAULT (newid()) FOR [Id]
GO




CREATE TABLE [dbo].[UtilityCompany](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityIdInt] [INT] NOT NULL,
	[UtilityCode] [varchar](50) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UtilityCompany] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[UtilityCompany] ADD  DEFAULT (newid()) FOR [Id]
GO




CREATE TABLE [dbo].[RequestModeType](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeType] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RequestModeType] ADD  DEFAULT (newid()) FOR [Id]
GO




CREATE TABLE [dbo].[RequestModeTypeToRequestModeTypeGenre](
	[Id] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeGenreId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeTypeToRequestModeTypeGenre] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestModeTypeToRequestModeTypeGenre]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeTypeToRequestModeTypeGenre_RequestModeType] FOREIGN KEY([RequestModeTypeId])
REFERENCES [dbo].[RequestModeType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeTypeToRequestModeTypeGenre] CHECK CONSTRAINT [FK_RequestModeTypeToRequestModeTypeGenre_RequestModeType]
GO

ALTER TABLE [dbo].[RequestModeTypeToRequestModeTypeGenre]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeTypeToRequestModeTypeGenre_RequestModeTypeGenre] FOREIGN KEY([RequestModeTypeGenreId])
REFERENCES [dbo].[RequestModeTypeGenre] ([Id])
GO
ALTER TABLE [dbo].[RequestModeTypeToRequestModeTypeGenre] CHECK CONSTRAINT [FK_RequestModeTypeToRequestModeTypeGenre_RequestModeTypeGenre]
GO

ALTER TABLE [dbo].[RequestModeTypeToRequestModeTypeGenre] ADD  DEFAULT (newid()) FOR [Id]
GO


CREATE TABLE [dbo].[RequestModeEnrollmentType](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeEnrollmentType] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestModeEnrollmentType] ADD  DEFAULT (newid()) FOR [Id]
GO




CREATE TABLE [dbo].[RequestModeHistoricalUsage](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[AddressForPreEnrollment] [nvarchar](200) NOT NULL,
	[EmailTemplate] [nvarchar](2000) NULL,
	[Instructions] [nvarchar](500) NOT NULL,
	[UtilitysSlaHistoricalUsageResponseInDays] [int] NOT NULL,
	[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays] [int] NOT NULL,
	[IsLoaRequired] [bit] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeHistoricalUsage] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsage]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeEnrollmentType] FOREIGN KEY([RequestModeEnrollmentTypeId])
REFERENCES [dbo].[RequestModeEnrollmentType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsage] CHECK CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeEnrollmentType]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsage]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeType] FOREIGN KEY([RequestModeTypeId])
REFERENCES [dbo].[RequestModeType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsage] CHECK CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeType]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsage]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsage_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsage] CHECK CONSTRAINT [FK_RequestModeHistoricalUsage_UtilityCompany]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsage] ADD  DEFAULT (newid()) FOR [Id]
GO




CREATE TABLE [dbo].[RequestModeIcap](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[AddressForPreEnrollment] [nvarchar](200) NOT NULL,
	[EmailTemplate] [nvarchar](2000) NULL,
	[Instructions] [nvarchar](500) NOT NULL,
	[UtilitysSlaIcapResponseInDays] [int] NOT NULL,
	[LibertyPowersSlaFollowUpIcapResponseInDays] [int] NOT NULL,
	[IsLoaRequired] [bit] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeIcap] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestModeIcap]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeIcap_RequestModeEnrollmentType] FOREIGN KEY([RequestModeEnrollmentTypeId])
REFERENCES [dbo].[RequestModeEnrollmentType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeIcap] CHECK CONSTRAINT [FK_RequestModeIcap_RequestModeEnrollmentType]
GO

ALTER TABLE [dbo].[RequestModeIcap]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeIcap_RequestModeType] FOREIGN KEY([RequestModeTypeId])
REFERENCES [dbo].[RequestModeType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeIcap] CHECK CONSTRAINT [FK_RequestModeIcap_RequestModeType]
GO

ALTER TABLE [dbo].[RequestModeIcap]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeIcap_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[RequestModeIcap] CHECK CONSTRAINT [FK_RequestModeIcap_UtilityCompany]
GO

ALTER TABLE [dbo].[RequestModeIcap] ADD  DEFAULT (newid()) FOR [Id]
GO





CREATE TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType](
	[Id] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeTypeToRequestModeEnrollmentType] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeEnrollmentType] FOREIGN KEY([RequestModeEnrollmentTypeId])
REFERENCES [dbo].[RequestModeEnrollmentType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType] CHECK CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeEnrollmentType]
GO

ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeType] FOREIGN KEY([RequestModeTypeId])
REFERENCES [dbo].[RequestModeType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType] CHECK CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeType]
GO

ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType] ADD  DEFAULT (newid()) FOR [Id]
GO





CREATE TABLE [dbo].[UserInterfaceForm](
	[Id] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormName] [varchar](50) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UserInterfaceForm] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO



CREATE TABLE [dbo].[UserInterfaceFormControl](
	[Id] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormId] [uniqueidentifier] NOT NULL,
	[ControlName] [varchar](50) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UserInterfaceFormControls] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[UserInterfaceFormControl]  WITH CHECK ADD  CONSTRAINT [FK_UserInterfaceFormControl_UserInterfaceForm] FOREIGN KEY([UserInterfaceFormId])
REFERENCES [dbo].[UserInterfaceForm] ([Id])
GO
ALTER TABLE [dbo].[UserInterfaceFormControl] CHECK CONSTRAINT [FK_UserInterfaceFormControl_UserInterfaceForm]
GO




CREATE TABLE [dbo].[UserInterfaceControlAndValueGoverningControlVisibility](
	[Id] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormId] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormControlGoverningVisibilityId] [uniqueidentifier] NOT NULL,
	[ControlValueGoverningVisibiltiy] [nvarchar](100) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UserInterfaceControlAndValueGoverningControlVisibility] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]  WITH CHECK ADD  CONSTRAINT [FK_UserInterfaceControlAndValueGoverningControlVisibility_UserInterfaceForm] FOREIGN KEY([UserInterfaceFormId])
REFERENCES [dbo].[UserInterfaceForm] ([Id])
GO
ALTER TABLE [dbo].[UserInterfaceControlAndValueGoverningControlVisibility] CHECK CONSTRAINT [FK_UserInterfaceControlAndValueGoverningControlVisibility_UserInterfaceForm]
GO

ALTER TABLE [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]  WITH CHECK ADD  CONSTRAINT [FK_UserInterfaceControlAndValueGoverningControlVisibility_UserInterfaceFormControl] FOREIGN KEY([UserInterfaceFormControlGoverningVisibilityId])
REFERENCES [dbo].[UserInterfaceFormControl] ([Id])
GO
ALTER TABLE [dbo].[UserInterfaceControlAndValueGoverningControlVisibility] CHECK CONSTRAINT [FK_UserInterfaceControlAndValueGoverningControlVisibility_UserInterfaceFormControl]
GO





CREATE TABLE [dbo].[UserInterfaceControlVisibility](
	[Id] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormId] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormControlId] [uniqueidentifier] NOT NULL,
	[UserInterfaceControlAndValueGoverningControlVisibilityId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UserInterfaceControlVisibility] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserInterfaceControlVisibility]  WITH CHECK ADD  CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceControlAndValueGoverningControlVisibility] FOREIGN KEY([UserInterfaceControlAndValueGoverningControlVisibilityId])
REFERENCES [dbo].[UserInterfaceControlAndValueGoverningControlVisibility] ([Id])
GO
ALTER TABLE [dbo].[UserInterfaceControlVisibility] CHECK CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceControlAndValueGoverningControlVisibility]
GO

ALTER TABLE [dbo].[UserInterfaceControlVisibility]  WITH CHECK ADD  CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceForm] FOREIGN KEY([UserInterfaceFormId])
REFERENCES [dbo].[UserInterfaceForm] ([Id])
GO
ALTER TABLE [dbo].[UserInterfaceControlVisibility] CHECK CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceForm]
GO

ALTER TABLE [dbo].[UserInterfaceControlVisibility]  WITH CHECK ADD  CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceFormControl] FOREIGN KEY([UserInterfaceFormControlId])
REFERENCES [dbo].[UserInterfaceFormControl] ([Id])
GO
ALTER TABLE [dbo].[UserInterfaceControlVisibility] CHECK CONSTRAINT [FK_UserInterfaceControlVisibility_UserInterfaceFormControl]
GO






CREATE TABLE [dbo].[UtilityLegacy](
	[ID] [int] IDENTITY(1,1) NOT NULL,
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
	[Field01Label] [varchar](20) NULL,
	[Field01Type] [varchar](30) NULL,
	[Field02Label] [varchar](20) NULL,
	[Field02Type] [varchar](30) NULL,
	[Field03Label] [varchar](20) NULL,
	[Field03Type] [varchar](30) NULL,
	[Field04Label] [varchar](20) NULL,
	[Field04Type] [varchar](30) NULL,
	[Field05Label] [varchar](20) NULL,
	[Field05Type] [varchar](30) NULL,
	[Field06Label] [varchar](20) NULL,
	[Field06Type] [varchar](30) NULL,
	[Field07Label] [varchar](20) NULL,
	[Field07Type] [varchar](30) NULL,
	[Field08Label] [varchar](20) NULL,
	[Field08Type] [varchar](30) NULL,
	[Field09Label] [varchar](20) NULL,
	[Field09Type] [varchar](30) NULL,
	[Field10Label] [varchar](20) NULL,
	[Field10Type] [varchar](30) NULL,
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
	[Field11Label] [varchar](20) NULL,
	[Field11Type] [varchar](30) NULL,
	[Field12Label] [varchar](20) NULL,
	[Field12Type] [varchar](30) NULL,
	[Field13Label] [varchar](20) NULL,
	[Field13Type] [varchar](30) NULL,
	[Field14Label] [varchar](20) NULL,
	[Field14Type] [varchar](30) NULL,
	[Field15Label] [varchar](20) NULL,
	[Field15Type] [varchar](30) NULL,
	[RateCodeFormat] [varchar](20) NOT NULL,
	[RateCodeFields] [varchar](50) NOT NULL,
	[LegacyName] [varchar](100) NOT NULL,
	[SSNIsRequired] [bit] NULL,
	[PricingModeID] [int] NULL,
	[isIDR_EDI_Capable] [bit] NULL,
	[HU_RequestType] [nchar](10) NULL,
	[MultipleMeters] [bit] NULL,
	[MeterReadOverlap] [bit] NULL,
	[AutoApproval] [bit] NULL,
	[DeliveryLocationRefID] [int] NULL,
	[DefaultProfileRefID] [int] NULL,
	[SettlementLocationRefID] [int] NULL,
 CONSTRAINT [PK_EftUtility] PRIMARY KEY CLUSTERED ( [ID] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[UtilityLegacy] ADD  CONSTRAINT [DF_Utility_RateCodeFormat]  DEFAULT ((0)) FOR [RateCodeFormat]
GO
ALTER TABLE [dbo].[UtilityLegacy] ADD  CONSTRAINT [DF_Utility_RateCodeFields]  DEFAULT ((0)) FOR [RateCodeFields]
GO
ALTER TABLE [dbo].[UtilityLegacy] ADD  CONSTRAINT [DF_Utility_PricingModeID]  DEFAULT ((1)) FOR [PricingModeID]
GO





CREATE TABLE [dbo].[UtilityCompanyToUtilityLegacy](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[UtilityLegacyId] [int] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_UtilityCompanyToUtilityLegacy] PRIMARY KEY CLUSTERED ( [Id] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UtilityCompanyToUtilityLegacy]  WITH CHECK ADD  CONSTRAINT [FK_UtilityCompanyToUtilityLegacy_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[UtilityCompanyToUtilityLegacy] CHECK CONSTRAINT [FK_UtilityCompanyToUtilityLegacy_UtilityCompany]
GO

ALTER TABLE [dbo].[UtilityCompanyToUtilityLegacy]  WITH CHECK ADD  CONSTRAINT [FK_UtilityCompanyToUtilityLegacy_UtilityLegacy] FOREIGN KEY([UtilityLegacyId])
REFERENCES [dbo].[UtilityLegacy] ([ID])
GO
ALTER TABLE [dbo].[UtilityCompanyToUtilityLegacy] CHECK CONSTRAINT [FK_UtilityCompanyToUtilityLegacy_UtilityLegacy]
GO





--USE [Lp_UtilityManagement]
--GO

--/****** Object:  Table [dbo].[RateClass]    Script Date: 07/03/2013 10:30:03 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--DROP TABLE [RequestModeIdr]
--GO
--DROP TABLE [dbo].[IdrRules]
--GO
--DROP TABLE [dbo].[RateClass]
--GO
--DROP TABLE [dbo].[LoadProfile]
--GO
--DROP TABLE [dbo].[TariffCode]
--GO
--DROP TABLE [dbo].[ServiceClass]
--GO
--DROP TABLE [dbo].[MeterType]
--GO
--DROP TABLE [dbo].[AccountType]
--GO

CREATE TABLE [dbo].[AccountType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AccountType] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
 ON [PRIMARY]
) 
ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountType] ADD  DEFAULT (newid()) FOR [Id]
GO

CREATE TABLE [dbo].[ServiceClass](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NULL,
	[ServiceClassCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[LpStandardServiceClass] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ServiceClass] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
 ON [PRIMARY]
) 
ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceClass] ADD  DEFAULT (newid()) FOR [Id]
GO

ALTER TABLE [dbo].[ServiceClass]  WITH CHECK ADD  CONSTRAINT [FK_ServiceClass_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountType] ([Id])
GO
ALTER TABLE [dbo].[ServiceClass] CHECK CONSTRAINT [FK_ServiceClass_AccountType]
GO

ALTER TABLE [dbo].[ServiceClass]  WITH CHECK ADD  CONSTRAINT [FK_ServiceClass_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[ServiceClass] CHECK CONSTRAINT [FK_ServiceClass_UtilityCompany]
GO



CREATE TABLE [dbo].[MeterType](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NULL,
	[MeterTypeCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[LpStandardMeterType] [nvarchar](255) NOT NULL,
	[Sequence] [int] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_MeterType] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
 ON [PRIMARY]
) 
ON [PRIMARY]
GO
ALTER TABLE [dbo].[MeterType] ADD  DEFAULT (newid()) FOR [Id]
GO

ALTER TABLE [dbo].[MeterType]  WITH CHECK ADD  CONSTRAINT [FK_MeterType_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountType] ([Id])
GO
ALTER TABLE [dbo].[MeterType] CHECK CONSTRAINT [FK_MeterType_AccountType]
GO

ALTER TABLE [dbo].[MeterType]  WITH CHECK ADD  CONSTRAINT [FK_MeterType_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[MeterType] CHECK CONSTRAINT [FK_MeterType_UtilityCompany]
GO


CREATE TABLE [dbo].[TariffCode]
(
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[TariffCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[LpStandardTariffCode] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TariffCode] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
 ON [PRIMARY]
) 
 ON [PRIMARY]
GO
ALTER TABLE [dbo].[TariffCode] ADD  DEFAULT (newid()) FOR [Id]
GO

ALTER TABLE [dbo].[TariffCode]  WITH CHECK ADD  CONSTRAINT [FK_TariffCode_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountType] ([Id])
GO
ALTER TABLE [dbo].[TariffCode] CHECK CONSTRAINT [FK_TariffCode_AccountType]
GO

ALTER TABLE [dbo].[TariffCode]  WITH CHECK ADD  CONSTRAINT [FK_TariffCode_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[TariffCode] CHECK CONSTRAINT [FK_TariffCode_UtilityCompany]
GO



CREATE TABLE [dbo].[LpStandardRateClass](
	[Id] [uniqueidentifier] NOT NULL,
	[LpStandardRateClassCode] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_LpStandardRateClass] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LpStandardRateClass]  WITH CHECK ADD  CONSTRAINT [FK_LpStandardRateClass_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[LpStandardRateClass] CHECK CONSTRAINT [FK_LpStandardRateClass_UtilityCompany]
GO




CREATE TABLE [dbo].[RateClass](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardRateClassId] [uniqueidentifier] NOT NULL,
	[RateClassCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[RateClassId] [int] NOT NULL,
 CONSTRAINT [PK_RateClass] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RateClass]  WITH CHECK ADD  CONSTRAINT [FK_RateClass_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountType] ([Id])
GO

ALTER TABLE [dbo].[RateClass] CHECK CONSTRAINT [FK_RateClass_AccountType]
GO

ALTER TABLE [dbo].[RateClass]  WITH CHECK ADD  CONSTRAINT [FK_RateClass_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO

ALTER TABLE [dbo].[RateClass] CHECK CONSTRAINT [FK_RateClass_UtilityCompany]
GO

ALTER TABLE [dbo].[RateClass]  WITH CHECK ADD  CONSTRAINT [FK_RateClass_LpStandardRateClass] FOREIGN KEY([LpStandardRateClassId])
REFERENCES [dbo].[LpStandardRateClass] ([Id])
GO

ALTER TABLE [dbo].[RateClass] CHECK CONSTRAINT [FK_RateClass_LpStandardRateClass]
GO

ALTER TABLE [dbo].[RateClass] ADD  DEFAULT (newid()) FOR [Id]
GO





CREATE TABLE [dbo].[RateClassAlias](
	[Id] [uniqueidentifier] NOT NULL,
	[RateClassId] [uniqueidentifier] NOT NULL,
	[RateClassCodeAlias] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RateClassAlias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[RateClassAlias]  WITH CHECK ADD  CONSTRAINT [FK_RateClassAlias_RateClass] FOREIGN KEY([RateClassId])
REFERENCES [dbo].[RateClass] ([Id])
GO

ALTER TABLE [dbo].[RateClassAlias] CHECK CONSTRAINT [FK_RateClassAlias_RateClass]
GO

ALTER TABLE [dbo].[RateClassAlias] ADD  DEFAULT (newid()) FOR [Id]
GO





--CREATE TABLE [dbo].[LoadProfile]
--(
--	[Id] [uniqueidentifier] NOT NULL,
--	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
--	[LoadProfileCode] [nvarchar](255) NOT NULL,
--	[Description] [nvarchar] (500) NOT NULL,
--	[AccountTypeId] [uniqueidentifier] NOT NULL,
--	[LpStandardLoadProfile] [nvarchar](255) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL,
-- CONSTRAINT [PK_LoadProfile] PRIMARY KEY CLUSTERED ([Id] ASC)
-- WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
-- ON [PRIMARY]
--)
--ON [PRIMARY]
--GO
--ALTER TABLE [dbo].[LoadProfile] ADD DEFAULT (NEWID()) FOR [Id]
--GO

--ALTER TABLE [dbo].[LoadProfile] WITH CHECK ADD CONSTRAINT [FK_LoadProfile_UtilityCompany] FOREIGN KEY ([UtilityCompanyId])
--REFERENCES [dbo].[UtilityCompany] ([Id])
--GO
--ALTER TABLE [dbo].[LoadProfile] CHECK CONSTRAINT [FK_LoadProfile_UtilityCompany]
--GO

--ALTER TABLE [dbo].[LoadProfile] WITH CHECK ADD CONSTRAINT [FK_LoadProfile_AccountType] FOREIGN KEY ([AccountTypeId])
--REFERENCES [dbo].[AccountType] ([Id])
--GO
--ALTER TABLE [dbo].[LoadProfile] CHECK CONSTRAINT [FK_LoadProfile_AccountType]
--GO

--DROP TABLE LoadProfile

CREATE TABLE [dbo].[LpStandardLoadProfile](
	[Id] [uniqueidentifier] NOT NULL,
	[LpStandardLoadProfileCode] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_LpStandardLoadProfile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LpStandardLoadProfile]  WITH CHECK ADD  CONSTRAINT [FK_LpStandardLoadProfile_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[LpStandardLoadProfile] CHECK CONSTRAINT [FK_LpStandardLoadProfile_UtilityCompany]
GO




CREATE TABLE [dbo].[LoadProfile](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardLoadProfileId] [uniqueidentifier] NOT NULL,
	[LoadProfileCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LoadProfileId] [int] NOT NULL,
 CONSTRAINT [PK_LoadProfile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LoadProfile]  WITH CHECK ADD  CONSTRAINT [FK_LoadProfile_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountType] ([Id])
GO

ALTER TABLE [dbo].[LoadProfile] CHECK CONSTRAINT [FK_LoadProfile_AccountType]
GO

ALTER TABLE [dbo].[LoadProfile]  WITH CHECK ADD  CONSTRAINT [FK_LoadProfile_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO

ALTER TABLE [dbo].[LoadProfile] CHECK CONSTRAINT [FK_LoadProfile_UtilityCompany]
GO

ALTER TABLE [dbo].[LoadProfile]  WITH CHECK ADD  CONSTRAINT [FK_LoadProfile_LpStandardLoadProfile] FOREIGN KEY([LpStandardLoadProfileId])
REFERENCES [dbo].[LpStandardLoadProfile] ([Id])
GO

ALTER TABLE [dbo].[LoadProfile] CHECK CONSTRAINT [FK_LoadProfile_LpStandardLoadProfile]
GO

ALTER TABLE [dbo].[LoadProfile] ADD  DEFAULT (newid()) FOR [Id]
GO





CREATE TABLE [dbo].[LoadProfileAlias](
	[Id] [uniqueidentifier] NOT NULL,
	[LoadProfileId] [uniqueidentifier] NOT NULL,
	[LoadProfileCodeAlias] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_LoadProfileAlias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LoadProfileAlias]  WITH CHECK ADD  CONSTRAINT [FK_LoadProfileAlias_LoadProfile] FOREIGN KEY([LoadProfileId])
REFERENCES [dbo].[LoadProfile] ([Id])
GO

ALTER TABLE [dbo].[LoadProfileAlias] CHECK CONSTRAINT [FK_LoadProfileAlias_LoadProfile]
GO

ALTER TABLE [dbo].[LoadProfileAlias] ADD  DEFAULT (newid()) FOR [Id]
GO





CREATE TABLE [dbo].[LpStandardTariffCode](
	[Id] [uniqueidentifier] NOT NULL,
	[LpStandardTariffCodeCode] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_LpStandardTariffCode] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LpStandardTariffCode]  WITH CHECK ADD  CONSTRAINT [FK_LpStandardTariffCode_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[LpStandardTariffCode] CHECK CONSTRAINT [FK_LpStandardTariffCode_UtilityCompany]
GO




CREATE TABLE [dbo].[TariffCode](
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardTariffCodeId] [uniqueidentifier] NOT NULL,
	[TariffCodeCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[TariffCodeId] [int] NOT NULL,
 CONSTRAINT [PK_TariffCode] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TariffCode]  WITH CHECK ADD  CONSTRAINT [FK_TariffCode_AccountType] FOREIGN KEY([AccountTypeId])
REFERENCES [dbo].[AccountType] ([Id])
GO

ALTER TABLE [dbo].[TariffCode] CHECK CONSTRAINT [FK_TariffCode_AccountType]
GO

ALTER TABLE [dbo].[TariffCode]  WITH CHECK ADD  CONSTRAINT [FK_TariffCode_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO

ALTER TABLE [dbo].[TariffCode] CHECK CONSTRAINT [FK_TariffCode_UtilityCompany]
GO

ALTER TABLE [dbo].[TariffCode]  WITH CHECK ADD  CONSTRAINT [FK_TariffCode_LpStandardTariffCode] FOREIGN KEY([LpStandardTariffCodeId])
REFERENCES [dbo].[LpStandardTariffCode] ([Id])
GO

ALTER TABLE [dbo].[TariffCode] CHECK CONSTRAINT [FK_TariffCode_LpStandardTariffCode]
GO

ALTER TABLE [dbo].[TariffCode] ADD  DEFAULT (newid()) FOR [Id]
GO





CREATE TABLE [dbo].[TariffCodeAlias](
	[Id] [uniqueidentifier] NOT NULL,
	[TariffCodeId] [uniqueidentifier] NOT NULL,
	[TariffCodeCodeAlias] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TariffCodeAlias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TariffCodeAlias]  WITH CHECK ADD  CONSTRAINT [FK_TariffCodeAlias_TariffCode] FOREIGN KEY([TariffCodeId])
REFERENCES [dbo].[TariffCode] ([Id])
GO

ALTER TABLE [dbo].[TariffCodeAlias] CHECK CONSTRAINT [FK_TariffCodeAlias_TariffCode]
GO

ALTER TABLE [dbo].[TariffCodeAlias] ADD  DEFAULT (newid()) FOR [Id]
GO







CREATE TABLE [dbo].[RequestModeIdr]
(
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[AddressForPreEnrollment] [nvarchar](255) NOT NULL,
	[EmailTemplate] [nvarchar](2000) NOT NULL,
	[Instructions] [nvarchar](500) NOT NULL,
	[UtilitysSlaIdrResponseInDays] [int] NOT NULL,
	[LibertyPowersSlaFollowUpIdrResponseInDays] [int] NOT NULL,
	[IsLoaRequired] [bit] NOT NULL,
	[RequestCostAccount] [money] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeIdr] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
 ON [PRIMARY]
)
ON [PRIMARY]
GO
ALTER TABLE [dbo].[RequestModeIdr] ADD DEFAULT (NEWID()) FOR [Id]
GO

ALTER TABLE [dbo].[RequestModeIdr] WITH CHECK ADD CONSTRAINT [FK_RequestModeIdr_UtilityCompany] FOREIGN KEY ([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[RequestModeIdr] CHECK CONSTRAINT [FK_RequestModeIdr_UtilityCompany]
GO

ALTER TABLE [dbo].[RequestModeIdr] WITH CHECK ADD CONSTRAINT [FK_RequestModeIdr_RequestModeEnrollmentType] FOREIGN KEY ([RequestModeEnrollmentTypeId])
REFERENCES [dbo].[RequestModeEnrollmentType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeIdr] CHECK CONSTRAINT [FK_RequestModeIdr_RequestModeEnrollmentType]
GO

ALTER TABLE [dbo].[RequestModeIdr] WITH CHECK ADD CONSTRAINT [FK_RequestModeIdr_RequestModeType] FOREIGN KEY ([RequestModeTypeId])
REFERENCES [dbo].[RequestModeType] ([Id])
GO
ALTER TABLE [dbo].[RequestModeIdr] CHECK CONSTRAINT [FK_RequestModeIdr_RequestModeType]
GO



CREATE TABLE [dbo].[IdrRules]
(
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[Instruction] [nvarchar](750) NOT NULL,
	[MinUsageMWh] [int] NULL,
	[MaxUsageMWh] [int] NULL,
	[RateClassId] [uniqueidentifier] NOT NULL,
	[ServiceClassId] [uniqueidentifier] NOT NULL,
	[LoadProfileId] [uniqueidentifier] NOT NULL,
	[MeterTypeId] [uniqueidentifier] NOT NULL,
	[IsOnEligibleCustomerList] [bit] NOT NULL,
	[IsHistoricalArchiveAvailable] [bit] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_IdrRules] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
 ON [PRIMARY]
) 
ON [PRIMARY]
GO
ALTER TABLE [dbo].[IdrRules] ADD  DEFAULT (newid()) FOR [Id]
GO

ALTER TABLE [dbo].[IdrRules]  WITH CHECK ADD  CONSTRAINT [FK_IdrRules_LoadProfile] FOREIGN KEY([LoadProfileId])
REFERENCES [dbo].[LoadProfile] ([Id])
GO
ALTER TABLE [dbo].[IdrRules] CHECK CONSTRAINT [FK_IdrRules_LoadProfile]
GO

ALTER TABLE [dbo].[IdrRules]  WITH CHECK ADD  CONSTRAINT [FK_IdrRules_MeterType] FOREIGN KEY([MeterTypeId])
REFERENCES [dbo].[MeterType] ([Id])
GO
ALTER TABLE [dbo].[IdrRules] CHECK CONSTRAINT [FK_IdrRules_MeterType]
GO

ALTER TABLE [dbo].[IdrRules]  WITH CHECK ADD  CONSTRAINT [FK_IdrRules_RateClass] FOREIGN KEY([RateClassId])
REFERENCES [dbo].[RateClass] ([Id])
GO
ALTER TABLE [dbo].[IdrRules] CHECK CONSTRAINT [FK_IdrRules_RateClass]
GO

ALTER TABLE [dbo].[IdrRules]  WITH CHECK ADD  CONSTRAINT [FK_IdrRules_RequestModeType] FOREIGN KEY([RequestModeTypeId])
REFERENCES [dbo].[RequestModeType] ([Id])
GO
ALTER TABLE [dbo].[IdrRules] CHECK CONSTRAINT [FK_IdrRules_RequestModeType]
GO

ALTER TABLE [dbo].[IdrRules]  WITH CHECK ADD  CONSTRAINT [FK_IdrRules_ServiceClass] FOREIGN KEY([ServiceClassId])
REFERENCES [dbo].[ServiceClass] ([Id])
GO
ALTER TABLE [dbo].[IdrRules] CHECK CONSTRAINT [FK_IdrRules_ServiceClass]
GO

ALTER TABLE [dbo].[IdrRules]  WITH CHECK ADD  CONSTRAINT [FK_IdrRules_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[IdrRules] CHECK CONSTRAINT [FK_IdrRules_UtilityCompany]
GO




CREATE TABLE [dbo].[TriStateValue]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar] (20) NOT NULL,
	[NumericValue] [int] NOT NULL,
	[Description] [nvarchar] (255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TriStateValue] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TriStateValue] ADD  DEFAULT (newid()) FOR [Id]
GO



CREATE TABLE [dbo].[RequestModeHistoricalUsageParameter]
(
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[IsNameKeyNumberRequiredId] [uniqueidentifier] NOT NULL,
	[IsZipCodeRequiredId] [uniqueidentifier] NOT NULL,
	[IsNameKeyRequiredId] [uniqueidentifier] NOT NULL,
	[IsMdmaId] [uniqueidentifier] NOT NULL,
	[IsServiceProviderId] [uniqueidentifier] NOT NULL,
	[IsMeterInstallerId] [uniqueidentifier] NOT NULL,
	[IsMeterReaderId] [uniqueidentifier] NOT NULL,
	[IsMeterOwnerId] [uniqueidentifier] NOT NULL,
	[IsSchedulingCoordinatorId] [uniqueidentifier] NOT NULL,
	[HasReferenceNumberId] [uniqueidentifier] NOT NULL,
	[HasCustomerNumberId] [uniqueidentifier] NOT NULL,
	[HasPodIdNumberId] [uniqueidentifier] NOT NULL,
	[HasMeterTypeId] [uniqueidentifier] NOT NULL,
	[IsMeterNumberRequiredId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_RequestModeHistoricalUsageParameter] PRIMARY KEY CLUSTERED ([Id] ASC)
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsNameKeyNumberRequiredId] FOREIGN KEY([IsNameKeyNumberRequiredId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsNameKeyNumberRequiredId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_UtilityCompanyId] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_UtilityCompanyId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsZipCodeRequiredId] FOREIGN KEY([IsZipCodeRequiredId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsZipCodeRequiredId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsNameKeyRequiredId] FOREIGN KEY([IsNameKeyRequiredId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsNameKeyRequiredId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMdmaId] FOREIGN KEY([IsMdmaId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMdmaId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMeterInstallerId] FOREIGN KEY([IsMeterInstallerId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMeterInstallerId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMeterReaderId] FOREIGN KEY([IsMeterReaderId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMeterReaderId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMeterOwnerId] FOREIGN KEY([IsMeterOwnerId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMeterOwnerId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsSchedulingCoordinatorId] FOREIGN KEY([IsSchedulingCoordinatorId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsSchedulingCoordinatorId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_HasReferenceNumberId] FOREIGN KEY([HasReferenceNumberId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_HasReferenceNumberId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_HasCustomerNumberId] FOREIGN KEY([HasCustomerNumberId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_HasCustomerNumberId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_HasPodIdNumberId] FOREIGN KEY([HasPodIdNumberId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_HasPodIdNumberId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_HasMeterTypeId] FOREIGN KEY([HasMeterTypeId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_HasMeterTypeId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMeterNumberRequiredId] FOREIGN KEY([IsMeterNumberRequiredId])
REFERENCES [dbo].[TriStateValue] ([Id])
GO
ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] CHECK CONSTRAINT [FK_RequestModeHistoricalUsageParameter_TriStateValue_IsMeterNumberRequiredId]
GO

ALTER TABLE [dbo].[RequestModeHistoricalUsageParameter] ADD  DEFAULT (newid()) FOR [Id]
GO






CREATE TABLE [dbo].[PorDriver]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PorDriver] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PorDriver] ADD  DEFAULT (newid()) FOR [Id]
GO

CREATE TABLE [dbo].[PorRecourse]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PorRecourse] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PorRecourse] ADD  DEFAULT (newid()) FOR [Id]
GO


CREATE TABLE [dbo].[PurchaseOfReceivables]
(
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[PorDriverId] [uniqueidentifier] NOT NULL,
	[RateClassId] [uniqueidentifier] NULL,
	[LoadProfileId] [uniqueidentifier] NULL,
	[TariffCodeId] [uniqueidentifier] NULL,
	[IsPorOffered] [bit] NOT NULL,
	[IsPorParticipated] [bit] NOT NULL,
	[PorRecourseId] [uniqueidentifier] NOT NULL,
	[IsPorAssurance] [bit] NOT NULL,
	[PorDiscountRate] [decimal] NOT NULL,
	[PorFlatFee] [decimal] NOT NULL,
	[PorDiscountEffectiveDate] [datetime] NOT NULL,
	[PorDiscountExpirationDate] [datetime] NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PurchaseOfReceivables] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PurchaseOfReceivables]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseOfReceivables_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
REFERENCES [dbo].[UtilityCompany] ([Id])
GO
ALTER TABLE [dbo].[PurchaseOfReceivables] CHECK CONSTRAINT [FK_PurchaseOfReceivables_UtilityCompany]
GO

ALTER TABLE [dbo].[PurchaseOfReceivables]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseOfReceivables_PorDriver] FOREIGN KEY([PorDriverId])
REFERENCES [dbo].[PorDriver] ([Id])
GO
ALTER TABLE [dbo].[PurchaseOfReceivables] CHECK CONSTRAINT [FK_PurchaseOfReceivables_PorDriver]
GO

ALTER TABLE [dbo].[PurchaseOfReceivables]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseOfReceivables_PorRecourse] FOREIGN KEY([PorRecourseId])
REFERENCES [dbo].[PorRecourse] ([Id])
GO
ALTER TABLE [dbo].[PorResource] CHECK CONSTRAINT [FK_PurchaseOfReceivables_PorRecourse]
GO

ALTER TABLE [dbo].[PurchaseOfReceivables] ADD  DEFAULT (newid()) FOR [Id]
GO






-------------------------------- CREATE TABLE END -------------------------------------






-------------------------------- CREATE STORED PROCEDURE BEGIN -------------------------------------


CREATE PROC dbo.usp_PurchaseOfReceivables_SELECT_ByUtilityAndPorDriver
	@UtilityIdInt AS INT,
	@EffectiveDate AS DATETIME,
	@PorDriverId AS UNIQUEIDENTIFIER,
	@PorDriver AS NVARCHAR(50)
AS
BEGIN
	SELECT
		POR.[Id],
		POR.[UtilityCompanyId],
		UC.UtilityCode,
		POR.[PorDriverId],
		PD.Name PorDriverName,
		POR.[RateClassId],
		RC.RateClassCode,
		RC.RateClassId,
		POR.[LoadProfileId],
		LP.LoadProfileCode,
		LP.LoadProfileId,
		POR.[TariffCodeId],
		TC.TariffCodeCode,
		TC.TariffCodeId,
		POR.[IsPorOffered],
		POR.[IsPorParticipated],
		POR.[PorRecourseId],
		PR.[Name] PorRecourseName,
		POR.[IsPorAssurance],
		POR.[PorDiscountRate],
		POR.[PorFlatFee],
		POR.[PorDiscountEffectiveDate],
		POR.[PorDiscountExpirationDate],
		POR.[Inactive],
		POR.[CreatedBy],
		POR.[CreatedDate],
		POR.[LastModifiedBy],
		POR.[LastModifiedDate]
	FROM
		dbo.PurchaseOfReceivables (NOLOCK) POR
		INNER JOIN dbo.PorDriver (NOLOCK) PD
			ON POR.PorDriverId = PD.Id
		INNER JOIN dbo.porRecourse (NOLOCK) PR
			ON POR.PorRecourseId = PR.Id
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON POR.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON POR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON POR.LoadProfileId = LP.Id
		LEFT OUTER JOIN dbo.TariffCode (NOLOCK) TC
			ON POR.TariffCodeId = TC.Id
	WHERE
		POR.PorDiscountEffectiveDate IS NOT NULL 
		AND POR.PorDiscountEffectiveDate <= @EffectiveDate
		AND UC.UtilityIdInt = @UtilityIdInt
		AND
		(
			(
				RTRIM(LTRIM(PD.Name)) = 'Load Profile' 
				AND POR.LoadProfileId = @PorDriverId
				AND @PorDriver = 'Load Profile'
			)
			OR	
			(
				RTRIM(LTRIM(PD.Name)) = 'Tariff Code' 
				AND POR.TariffCodeId = @PorDriverId
				AND @PorDriver = 'Tariff Code' 
			)
			OR	
			(
				RTRIM(LTRIM(PD.Name)) = 'Rate Class' 
				AND POR.RateClassId = @PorDriverId
				AND @PorDriver = 'Rate Class' 
			)
		)
	
END
GO
--GRANT EXEC ON [usp_PurchaseOfReceivables_SELECT_ByUtilityAndPorDriver] TO LibertyPowerUtilityManagementUser
GO

CREATE PROC [dbo].[usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIdsRequestModeIdr]
	@RequestModeEnrollmentTypeId NVARCHAR(50),
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN

	SELECT 
		COUNT(RMI.Id)
	FROM 
		RequestModeIdr (NOLOCK) RMI
	WHERE
		RMI.UtilityCompanyId = @UtilityCompanyId
		AND RMI.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
	
END
GO
--GRANT EXEC ON [usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIdsRequestModeIdr] TO LibertyPowerUtilityManagementUser
GO


CREATE PROC dbo.usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds
	@RequestModeEnrollmentTypeId NVARCHAR(50),
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN

	SELECT 
		COUNT(RMHU.Id)
	FROM 
		RequestModeHistoricalUsage (NOLOCK) RMHU
	WHERE
		RMHU.UtilityCompanyId = @UtilityCompanyId
		AND RMHU.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
	
END
GO
--GRANT EXEC ON usp_RequestModeType_SELECT_NameById TO LibertyPowerUtilityManagementUser
GO

CREATE PROC dbo.usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIdsRequestModeIcap
	@RequestModeEnrollmentTypeId NVARCHAR(50),
	@UtilityCompanyId NVARCHAR(50)
AS
BEGIN

	SELECT 
		COUNT(RMHU.Id)
	FROM 
		RequestModeIcap (NOLOCK) RMHU
	WHERE
		RMHU.UtilityCompanyId = @UtilityCompanyId
		AND RMHU.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
	
END
GO
--GRANT EXEC ON usp_RequestModeType_SELECT_NameById TO LibertyPowerUtilityManagementUser
GO

CREATE PROC [dbo].[usp_RequestModeEnrollmentType_SELECT_NameById]
@Id NVARCHAR(50)
AS
BEGIN
	SELECT
		[Name]
	FROM
		dbo.RequestModeEnrollmentType (NOLOCK) RMET
	WHERE
		CONVERT(NVARCHAR(50),RMET.Id) = @Id
END
GO
--GRANT EXEC ON usp_RequestModeType_SELECT_NameById TO LibertyPowerUtilityManagementUser
GO

CREATE PROC dbo.usp_RequestModeType_SELECT_NameById
@Id NVARCHAR(50)
AS
BEGIN
	SELECT
		[Name]
	FROM 
		dbo.RequestModeType (NOLOCK) RMT
	WHERE
		RMT.Id = @Id
END
GO
--GRANT EXEC ON usp_RequestModeType_SELECT_NameById TO LibertyPowerUtilityManagementUser
GO


CREATE PROC [dbo].[usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName]
	@RequestModeEnrollmentTypeId NVARCHAR(50),
	@RequestModeTypeGenreName NVARCHAR(50)
AS
BEGIN
	SELECT 
		RMT.Id,
		RMT.Name
	FROM 
		dbo.RequestModeType (NOLOCK) RMT
		INNER JOIN dbo.RequestModeTypeToRequestModeEnrollmentType (NOLOCK) RMT2RMET
			ON RMT.Id = RMT2RMET.RequestModeTypeId
		INNER JOIN RequestModeEnrollmentType (NOLOCK) RMET
			ON RMT2RMET.RequestModeEnrollmentTypeId = RMET.Id
		INNER JOIN RequestModeTypeGenre (NOLOCK) RMTG
			ON RMT2RMET.RequestModeTypeGenreid = RMTG.Id
	WHERE
		RMET.Id = @RequestModeEnrollmentTypeId
		 and RMTG.Name = @RequestModeTypeGenreName--'historical usage'
END
GO
--GRANT EXEC ON [usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName] TO LibertyPowerUtilityManagementUser
GO


CREATE PROC [dbo].[usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId]
@RequestModeEnrollmentTypeId NVARCHAR(50)
AS
BEGIN
	SELECT
		[RMT].[Id],
		[RMT].[Name]
	FROM
		dbo.RequestModeType (NOLOCK) RMT
		INNER JOIN dbo.RequestModeTypeToRequestModeEnrollmentType (NOLOCK) RMT2RMET
			ON RMT.Id = RMT2RMET.RequestModeTypeId
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMT2RMET.RequestModeEnrollmentTypeId = RMET.Id
	WHERE
		CONVERT(NVARCHAR(50),RMET.Id) = @RequestModeEnrollmentTypeId
END
GO
--GRANT EXEC ON [usp_RequestModeTypes_SELECT_By_RequestModeEnrollmentTypeId] TO LibertyPowerUtilityManagementUser
GO



CREATE PROC [dbo].[usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm]
	@FormName NVARCHAR(50)
AS
BEGIN

	SELECT 
		UIFCC.ControlName AS ControllingControlName,
		UICVGCV.ControlValueGoverningVisibiltiy AS ControllingControlValue,
		UIFC.ControlName AS VisibilityControlName
	FROM 
		dbo.UserInterfaceForm (NOLOCK) UIF
		INNER JOIN dbo.UserInterfaceFormControl (NOLOCK) UIFC
			ON UIF.Id = UIFC.UserInterfaceFormId
		INNER JOIN dbo.UserInterfaceFormControl (NOLOCK) UIFCC
			ON UIF.Id = UIFCC.UserInterfaceFormId
		INNER JOIN dbo.UserInterfaceControlAndValueGoverningControlVisibility (NOLOCK) UICVGCV
			ON UIF.Id = UICVGCV.UserInterfaceFormId
				AND UIFCC.Id = UICVGCV.UserInterfaceFormControlGoverningVisibilityId
		INNER JOIN dbo.UserInterfaceControlVisibility (NOLOCK) UICV
			ON UIF.Id = UICV.UserInterfaceFormId
				AND UIFC.Id = UICV.UserInterfaceFormControlId
				AND UICVGCV.Id = UICV.UserInterfaceControlAndValueGoverningControlVisibilityId
	WHERE
		UIF.UserInterfaceFormName = @FormName
	ORDER BY
		UIFCC.ControlName,
		UICVGCV.ControlValueGoverningVisibiltiy,
		UIFC.ControlName  
END
GO
--GRANT EXEC ON [usp_UserInterfaceForm_GET_ControllingControlsAndVisibilityByForm] TO LibertyPowerUtilityManagementUser
GO


CREATE PROC [dbo].[usp_UserInterfaceForm_SELECT_ControllingControlsAndVisibilityByForm]
	@FormName NVARCHAR(50)
AS
BEGIN

	SELECT 
		UIFCC.ControlName AS ControllingControlName,
		UICVGCV.ControlValueGoverningVisibiltiy AS ControllingControlValue,
		UIFC.ControlName AS VisibilityControlName,
		UIF.Id,
		UIF.UserInterfaceFormName,
		UIFC.Id,
		UIFC.ControlName,
		UIFCC.Id,
		UIFCC.ControlName,
		UICVGCV.Id,
		UICVGCV.ControlValueGoverningVisibiltiy,
		UICV.Id
	FROM 
		dbo.UserInterfaceForm (NOLOCK) UIF
		INNER JOIN dbo.UserInterfaceFormControl (NOLOCK) UIFC
			ON UIF.Id = UIFC.UserInterfaceFormId
		INNER JOIN dbo.UserInterfaceFormControl (NOLOCK) UIFCC
			ON UIF.Id = UIFCC.UserInterfaceFormId
		INNER JOIN dbo.UserInterfaceControlAndValueGoverningControlVisibility (NOLOCK) UICVGCV
			ON UIF.Id = UICVGCV.UserInterfaceFormId
				AND UIFCC.Id = UICVGCV.UserInterfaceFormControlGoverningVisibilityId
		INNER JOIN dbo.UserInterfaceControlVisibility (NOLOCK) UICV
			ON UIF.Id = UICV.UserInterfaceFormId
				AND UIFC.Id = UICV.UserInterfaceFormControlId
				AND UICVGCV.Id = UICV.UserInterfaceControlAndValueGoverningControlVisibilityId
	WHERE
		UIF.UserInterfaceFormName = @FormName
	ORDER BY
		UIFCC.ControlName,
		UICVGCV.ControlValueGoverningVisibiltiy,
		UIFC.ControlName  

END
GO
--GRANT EXEC ON [usp_UserInterfaceForm_SELECT_ControllingControlsAndVisibilityByForm] TO LibertyPowerUtilityManagementUser
GO



CREATE PROC usp_zAuditRequestModeHistoricalUsage_SELECT
AS
BEGIN

	SELECT 
		ZARMHU.Id,
		ZARMHU.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode,
		RMET.Id AS RequestModeEnrollmentTypeId,
		RMETPrev.Id AS RequestModeEnrollmentTypeIdPrevious,
		RMET.Name AS RequestModeEnrollmentType,
		RMETPrev.Name AS RequestModeEnrollmentTypePrevious,
		RMT.Id AS RequestModeTypeId,
		RMTPrev.Id AS RequestModeTypeIdPrevious,
		RMT.Name AS RequestModeType,
		RMTPrev.Name AS RequestModeTypePrevious,
		ZARMHU.AddressForPreEnrollment,
		ZARMHU.AddressForPreEnrollmentPrevious,
		ZARMHU.EmailTemplate,
		ZARMHU.EmailTemplatePrevious,
		ZARMHU.Instructions,
		ZARMHU.InstructionsPrevious,
		ZARMHU.UtilitysSlaHistoricalUsageResponseInDays,
		ZARMHU.UtilitysSlaHistoricalUsageResponseInDaysPrevious,
		ZARMHU.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays,
		ZARMHU.LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevious,
		ZARMHU.IsLoaRequired,
		ZARMHU.IsLoaRequiredPrevious,
		ZARMHU.Inactive,
		ZARMHU.InactivePrevious,
		ZARMHU.CreatedBy,
		ZARMHU.CreatedByPrevious,
		ZARMHU.CreatedDate,
		ZARMHU.CreatedDatePrevious,
		ZARMHU.LastModifiedBy,
		ZARMHU.LastModifiedByPrevious,
		ZARMHU.LastModifiedDate,
		ZARMHU.LastModifiedDatePrevious,
		ZARMHU.SYS_CHANGE_COLUMNS,
		ZARMHU.SYS_CHANGE_CREATION_VERSION,
		ZARMHU.SYS_CHANGE_OPERATION,
		ZARMHU.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditRequestModeHistoricalUsage (NOLOCK) ZARMHU
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON ZARMHU.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON ZARMHU.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON ZARMHU.RequestModeEnrollmentTypeId = RMET.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMETPrev
			ON ZARMHU.RequestModeEnrollmentTypeIdPrevious = RMETPrev.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RMT
			ON ZARMHU.RequestModeTypeId = RMT.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RMTPrev
			ON ZARMHU.RequestModeTypeIdPrevious = RMTPrev.Id

END
GO
----GRANT EXEC ON [usp_zAuditRequestModeHistoricalUsage_SELECT] TO LibertyPowerUtilityManagementUser
--GO



CREATE PROC usp_zAuditRequestModeIcap_SELECT
AS
BEGIN

	SELECT 
		ZARMHU.Id,
		ZARMHU.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode,
		RMET.Id AS RequestModeEnrollmentTypeId,
		RMETPrev.Id AS RequestModeEnrollmentTypeIdPrevious,
		RMET.Name AS RequestModeEnrollmentType,
		RMETPrev.Name AS RequestModeEnrollmentTypePrevious,
		RMT.Id AS RequestModeTypeId,
		RMTPrev.Id AS RequestModeTypeIdPrevious,
		RMT.Name AS RequestModeType,
		RMTPrev.Name AS RequestModeTypePrevious,
		ZARMHU.AddressForPreEnrollment,
		ZARMHU.AddressForPreEnrollmentPrevious,
		ZARMHU.EmailTemplate,
		ZARMHU.EmailTemplatePrevious,
		ZARMHU.Instructions,
		ZARMHU.InstructionsPrevious,
		ZARMHU.UtilitysSlaIcapResponseInDays,
		ZARMHU.UtilitysSlaIcapResponseInDaysPrevious,
		ZARMHU.LibertyPowersSlaFollowUpIcapResponseInDays,
		ZARMHU.LibertyPowersSlaFollowUpIcapResponseInDaysPrevious,
		ZARMHU.IsLoaRequired,
		ZARMHU.IsLoaRequiredPrevious,
		ZARMHU.Inactive,
		ZARMHU.InactivePrevious,
		ZARMHU.CreatedBy,
		ZARMHU.CreatedByPrevious,
		ZARMHU.CreatedDate,
		ZARMHU.CreatedDatePrevious,
		ZARMHU.LastModifiedBy,
		ZARMHU.LastModifiedByPrevious,
		ZARMHU.LastModifiedDate,
		ZARMHU.LastModifiedDatePrevious,
		ZARMHU.SYS_CHANGE_COLUMNS,
		ZARMHU.SYS_CHANGE_CREATION_VERSION,
		ZARMHU.SYS_CHANGE_OPERATION,
		ZARMHU.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditRequestModeIcap (NOLOCK) ZARMHU
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON ZARMHU.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON ZARMHU.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON ZARMHU.RequestModeEnrollmentTypeId = RMET.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMETPrev
			ON ZARMHU.RequestModeEnrollmentTypeIdPrevious = RMETPrev.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RMT
			ON ZARMHU.RequestModeTypeId = RMT.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RMTPrev
			ON ZARMHU.RequestModeTypeIdPrevious = RMTPrev.Id

END
GO
--GRANT EXEC ON [usp_zAuditRequestModeIcap_SELECT] TO LibertyPowerUtilityManagementUser
GO



CREATE PROC [dbo].[usp_zAuditRequestModeIdr_SELECT]
AS
BEGIN

	SELECT 
		ZARMHU.Id,
		ZARMHU.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		RMET.Id AS RequestModeEnrollmentTypeId,
		RMETPrev.Id AS RequestModeEnrollmentTypeIdPrevious,
		RMET.Name AS RequestModeEnrollmentType,
		RMETPrev.Name AS RequestModeEnrollmentTypePrevious,
		RMT.Id AS RequestModeTypeId,
		RMTPrev.Id AS RequestModeTypeIdPrevious,
		RMT.Name AS RequestModeType,
		RMTPrev.Name AS RequestModeTypePrevious,
		ZARMHU.AddressForPreEnrollment,
		ZARMHU.AddressForPreEnrollmentPrevious,
		ZARMHU.EmailTemplate,
		ZARMHU.EmailTemplatePrevious,
		ZARMHU.Instructions,
		ZARMHU.InstructionsPrevious,
		ZARMHU.UtilitysSlaIdrResponseInDays,
		ZARMHU.UtilitysSlaIdrResponseInDaysPrevious,
		ZARMHU.LibertyPowersSlaFollowUpIdrResponseInDays,
		ZARMHU.LibertyPowersSlaFollowUpIdrResponseInDaysPrevious,
		ZARMHU.IsLoaRequired,
		ZARMHU.IsLoaRequiredPrevious,
		ZARMHU.Inactive,
		ZARMHU.InactivePrevious,
		ZARMHU.CreatedBy,
		ZARMHU.CreatedByPrevious,
		ZARMHU.CreatedDate,
		ZARMHU.CreatedDatePrevious,
		ZARMHU.LastModifiedBy,
		ZARMHU.LastModifiedByPrevious,
		ZARMHU.LastModifiedDate,
		ZARMHU.LastModifiedDatePrevious,
		REPLACE(ZARMHU.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		ZARMHU.SYS_CHANGE_CREATION_VERSION,
		ZARMHU.SYS_CHANGE_OPERATION,
		ZARMHU.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditRequestModeIdr (NOLOCK) ZARMHU
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON ZARMHU.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON ZARMHU.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON ZARMHU.RequestModeEnrollmentTypeId = RMET.Id
		LEFT OUTER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMETPrev
			ON ZARMHU.RequestModeEnrollmentTypeIdPrevious = RMETPrev.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RMT
			ON ZARMHU.RequestModeTypeId = RMT.Id
		LEFT OUTER JOIN dbo.RequestModeType (NOLOCK) RMTPrev
			ON ZARMHU.RequestModeTypeIdPrevious = RMTPrev.Id

END
GO
--GRANT EXEC ON [usp_zAuditRequestModeIdr_SELECT] TO LibertyPowerUtilityManagementUser
GO



CREATE PROC [dbo].[usp_zAuditLoadProfile_SELECT]
AS
BEGIN
	SELECT 
		ALP.Id,
		ALP.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		ALP.LoadProfileCode,
		ALP.LoadProfileCodePrevious,
		ALP.[Description],
		ALP.[DescriptionPrevious],
		ALP.AccountTypeId,
		ALP.AccountTypeIdPrevious,
		AT.Name AS AccountTypeName,
		ATPrev.Name AS AccountTypeNamePrevious,
		ALP.LpStandardLoadProfile,
		ALP.LpStandardLoadProfilePrevious,
		ALP.Inactive,
		ALP.InactivePrevious,
		ALP.CreatedBy,
		ALP.CreatedByPrevious,
		ALP.CreatedDate,
		ALP.CreatedDatePrevious,
		ALP.LastModifiedBy,
		ALP.LastModifiedByPrevious,
		ALP.LastModifiedDate,
		ALP.LastModifiedDatePrevious,
		REPLACE(ALP.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		ALP.SYS_CHANGE_CREATION_VERSION,
		ALP.SYS_CHANGE_OPERATION,
		ALP.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditLoadProfile (NOLOCK) ALP
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON ALP.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON ALP.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) AT
			ON ALP.AccountTypeId = AT.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) ATPrev
			ON ALP.AccountTypeIdPrevious = ATPrev.Id
END
GO
--GRANT EXEC ON [usp_zAuditLoadProfile_SELECT] TO LibertyPowerUtilityManagementUser
GO


CREATE PROC [dbo].[usp_zAuditMeterType_SELECT]
AS
BEGIN
	SELECT 
		AMT.Id,
		AMT.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		AMT.MeterTypeCode,
		AMT.MeterTypeCodePrevious,
		AMT.[Description],
		AMT.[DescriptionPrevious],
		AMT.AccountTypeId,
		AMT.AccountTypeIdPrevious,
		AT.Name AS AccountTypeName,
		ATPrev.Name AS AccountTypeNamePrevious,
		AMT.LpStandardMeterType,
		AMT.LpStandardMeterTypePrevious,
		AMT.Inactive,
		AMT.InactivePrevious,
		AMT.CreatedBy,
		AMT.CreatedByPrevious,
		AMT.CreatedDate,
		AMT.CreatedDatePrevious,
		AMT.LastModifiedBy,
		AMT.LastModifiedByPrevious,
		AMT.LastModifiedDate,
		AMT.LastModifiedDatePrevious,
		REPLACE(AMT.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		AMT.SYS_CHANGE_CREATION_VERSION,
		AMT.SYS_CHANGE_OPERATION,
		AMT.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditMeterType (NOLOCK) AMT
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON AMT.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON AMT.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) AT
			ON AMT.AccountTypeId = AT.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) ATPrev
			ON AMT.AccountTypeIdPrevious = ATPrev.Id
END
GO
--GRANT EXEC ON [usp_zAuditMeterType_SELECT] TO LibertyPowerUtilityManagementUser
GO



CREATE PROC [dbo].[usp_zAuditRateClass_SELECT]
AS
BEGIN
	SELECT 
		AMT.Id,
		AMT.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		AMT.RateClassCode,
		AMT.RateClassCodePrevious,
		AMT.[Description],
		AMT.[DescriptionPrevious],
		AMT.AccountTypeId,
		AMT.AccountTypeIdPrevious,
		AT.Name AS AccountTypeName,
		ATPrev.Name AS AccountTypeNamePrevious,
		AMT.LpStandardRateClass,
		AMT.LpStandardRateClassPrevious,
		AMT.Inactive,
		AMT.InactivePrevious,
		AMT.CreatedBy,
		AMT.CreatedByPrevious,
		AMT.CreatedDate,
		AMT.CreatedDatePrevious,
		AMT.LastModifiedBy,
		AMT.LastModifiedByPrevious,
		AMT.LastModifiedDate,
		AMT.LastModifiedDatePrevious,
		REPLACE(AMT.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		AMT.SYS_CHANGE_CREATION_VERSION,
		AMT.SYS_CHANGE_OPERATION,
		AMT.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditRateClass (NOLOCK) AMT
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON AMT.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON AMT.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) AT
			ON AMT.AccountTypeId = AT.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) ATPrev
			ON AMT.AccountTypeIdPrevious = ATPrev.Id
END
GO
--GRANT EXEC ON [usp_zAuditRateClass_SELECT] TO LibertyPowerUtilityManagementUser
GO



CREATE PROC [dbo].[usp_zAuditServiceClass_SELECT]
AS
BEGIN
	SELECT 
		AMT.Id,
		AMT.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		AMT.ServiceClassCode,
		AMT.ServiceClassCodePrevious,
		AMT.[Description],
		AMT.[DescriptionPrevious],
		AMT.AccountTypeId,
		AMT.AccountTypeIdPrevious,
		AT.Name AS AccountTypeName,
		ATPrev.Name AS AccountTypeNamePrevious,
		AMT.LpStandardServiceClass,
		AMT.LpStandardServiceClassPrevious,
		AMT.Inactive,
		AMT.InactivePrevious,
		AMT.CreatedBy,
		AMT.CreatedByPrevious,
		AMT.CreatedDate,
		AMT.CreatedDatePrevious,
		AMT.LastModifiedBy,
		AMT.LastModifiedByPrevious,
		AMT.LastModifiedDate,
		AMT.LastModifiedDatePrevious,
		REPLACE(AMT.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		AMT.SYS_CHANGE_CREATION_VERSION,
		AMT.SYS_CHANGE_OPERATION,
		AMT.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditServiceClass (NOLOCK) AMT
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON AMT.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON AMT.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) AT
			ON AMT.AccountTypeId = AT.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) ATPrev
			ON AMT.AccountTypeIdPrevious = ATPrev.Id
END
GO
--GRANT EXEC ON [usp_zAuditServiceClass_SELECT] TO LibertyPowerUtilityManagementUser
GO



CREATE PROC [dbo].[usp_zAuditTariffCode_SELECT]
AS
BEGIN
	SELECT 
		AMT.Id,
		AMT.IdPrevious,
		UC.Id AS UtilityCompanyId,
		UCPrev.Id AS UtilityCompanyIdPrevious,
		UC.UtilityCode,
		UCPrev.UtilityCode UtilityCodePrevious,
		AMT.TariffCode,
		AMT.TariffCodePrevious,
		AMT.[Description],
		AMT.[DescriptionPrevious],
		AMT.AccountTypeId,
		AMT.AccountTypeIdPrevious,
		AT.Name AS AccountTypeName,
		ATPrev.Name AS AccountTypeNamePrevious,
		AMT.LpStandardTariffCode,
		AMT.LpStandardTariffCodePrevious,
		AMT.Inactive,
		AMT.InactivePrevious,
		AMT.CreatedBy,
		AMT.CreatedByPrevious,
		AMT.CreatedDate,
		AMT.CreatedDatePrevious,
		AMT.LastModifiedBy,
		AMT.LastModifiedByPrevious,
		AMT.LastModifiedDate,
		AMT.LastModifiedDatePrevious,
		REPLACE(AMT.SYS_CHANGE_COLUMNS, ',', ', ') AS SYS_CHANGE_COLUMNS,
		AMT.SYS_CHANGE_CREATION_VERSION,
		AMT.SYS_CHANGE_OPERATION,
		AMT.SYS_CHANGE_VERSION
	FROM 
		dbo.zAuditTariffCode (NOLOCK) AMT
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UC 
			ON AMT.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.UtilityCompany (NOLOCK) UCPrev 
			ON AMT.UtilityCompanyIdPrevious = UCPrev.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) AT
			ON AMT.AccountTypeId = AT.Id
		LEFT OUTER JOIN dbo.AccountType (NOLOCK) ATPrev
			ON AMT.AccountTypeIdPrevious = ATPrev.Id
END
GO
--GRANT EXEC ON [usp_zAuditTariffCode_SELECT] TO LibertyPowerUtilityManagementUser
GO



CREATE PROC [dbo].[usp_RequestModeHistoricalUsage_VALIDATE_RequestModeIcapRequestModeType]
	@UtilityCompanyId AS NVARCHAR(50),
	@RequestModeTypeId AS NVARCHAR(50)
AS
BEGIN

	SELECT
		COUNT(RMHU.ID) AS MatchCount
	FROM
		dbo.RequestModeHistoricalUsage (NOLOCK) RMHU
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMHU.RequestModeEnrollmentTypeId = RMET.Id
		INNER JOIN  dbo.UtilityCompany (NOLOCK) UC
			ON RMHU.UtilityCompanyId = UC.Id
	WHERE
		RMET.Id = '390712C2-AAF9-4B96-96B8-CD12FA33EEF1'
		AND RMHU.RequestModeTypeId <> @RequestModeTypeId
		AND RMHU.UtilityCompanyId = @UtilityCompanyId

END
GO
--GRANT EXEC ON [usp_RequestModeHistoricalUsage_VALIDATE_RequestModeIcapRequestModeType] TO LibertyPowerUtilityManagementUser
GO


CREATE PROC [dbo].[usp_RequestModeHistoricalUsage_VALIDATE_RequestModeIcapRequestModeType_EDIT]
	@RequestModeIcapId AS NVARCHAR(50),
	@RequestModeTypeId AS NVARCHAR(50)
AS
BEGIN

	DECLARE @UtilityCompanyId NVARCHAR(50)
	SELECT
		@UtilityCompanyId = UtilityCompanyId
	FROM
		dbo.RequestModeIcap (NOLOCK) RMI
	WHERE
		RMI.Id = @RequestModeIcapId

	SELECT
		COUNT(RMHU.ID) AS MatchCount
	FROM
		dbo.RequestModeHistoricalUsage (NOLOCK) RMHU
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMHU.RequestModeEnrollmentTypeId = RMET.Id
		INNER JOIN  dbo.UtilityCompany (NOLOCK) UC
			ON RMHU.UtilityCompanyId = UC.Id
	WHERE
		RMET.Id = '390712C2-AAF9-4B96-96B8-CD12FA33EEF1'
		AND RMHU.RequestModeTypeId <> @RequestModeTypeId
		AND RMHU.RequestModeTypeId IS NOT NULL
		AND RMHU.UtilityCompanyId = @UtilityCompanyId
END
GO
--GRANT EXEC ON [usp_RequestModeHistoricalUsage_VALIDATE_RequestModeIcapRequestModeType_EDIT] TO LibertyPowerUtilityManagementUser
GO


CREATE PROC [dbo].[usp_RequestModeIcap_VALIDATE_RequestModeHistoricalUsageRequestModeType]
	@UtilityCompanyId AS NVARCHAR(50),
	@RequestModeTypeId AS NVARCHAR(50)
AS
BEGIN

	SELECT
		COUNT(RMI.ID) AS MatchCount
	FROM
		dbo.RequestModeIcap (NOLOCK) RMI
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMI.RequestModeEnrollmentTypeId = RMET.Id
		INNER JOIN  dbo.UtilityCompany (NOLOCK) UC
			ON RMI.UtilityCompanyId = UC.Id
	WHERE
		RMET.Id = '390712C2-AAF9-4B96-96B8-CD12FA33EEF1'
		AND RMI.RequestModeTypeId <> @RequestModeTypeId
		AND RMI.UtilityCompanyId = @UtilityCompanyId
END
GO
--GRANT EXEC ON [usp_RequestModeIcap_VALIDATE_RequestModeHistoricalUsageRequestModeType] TO LibertyPowerUtilityManagementUser
GO

CREATE PROC [dbo].[usp_RequestModeIcap_VALIDATE_RequestModeHistoricalUsageRequestModeType_EDIT]
	@RequestModeHistoricalUsageId AS NVARCHAR(50),
	@RequestModeTypeId AS NVARCHAR(50)
AS
BEGIN

	DECLARE @UtilityCompanyId NVARCHAR(50)
	
	SELECT
		@UtilityCompanyId = UtilityCompanyId
	FROM
		dbo.RequestModeHistoricalUsage (NOLOCK) RMHU
	WHERE
		RMHU.Id = @RequestModeHistoricalUsageId

	SELECT
		COUNT(RMI.ID) AS MatchCount
	FROM
		dbo.RequestModeIcap (NOLOCK) RMI
		INNER JOIN dbo.RequestModeEnrollmentType (NOLOCK) RMET
			ON RMI.RequestModeEnrollmentTypeId = RMET.Id
		INNER JOIN  dbo.UtilityCompany (NOLOCK) UC
			ON RMI.UtilityCompanyId = UC.Id
	WHERE
		RMET.Id = '390712C2-AAF9-4B96-96B8-CD12FA33EEF1'
		AND RMI.RequestModeTypeId <> @RequestModeTypeId
		AND RMI.UtilityCompanyId = @UtilityCompanyId

END
GO
--GRANT EXEC ON [usp_RequestModeIcap_VALIDATE_RequestModeHistoricalUsageRequestModeType_EDIT] TO LibertyPowerUtilityManagementUser
GO



-------------------------------- CREATE STORED PROCEDURE END -------------------------------------







-------------------------------- CREATE AUDIT TABLES BEGIN -------------------------------------


CREATE TABLE [dbo].[zAuditRequestModeEnrollmentType](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[NamePrevious] [nvarchar](50) NULL,
	[DescriptionPrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRequestModeEnrollmentType] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRequestModeEnrollmentType] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO


CREATE TABLE [dbo].[zAuditRequestModeHistoricalUsage](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[AddressForPreEnrollment] [nvarchar](200) NOT NULL,
	[EmailTemplate] [nvarchar](2000) NULL,
	[Instructions] [nvarchar](500) NOT NULL,
	[UtilitysSlaHistoricalUsageResponseInDays] [int] NOT NULL,
	[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays] [int] NOT NULL,
	[IsLoaRequired] [bit] NOT NULL,
	[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser] [bit] NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[RequestModeEnrollmentTypeIdPrevious] [uniqueidentifier] NULL,
	[RequestModeTypeIdPrevious] [uniqueidentifier] NULL,
	[AddressForPreEnrollmentPrevious] [nvarchar](200) NULL,
	[EmailTemplatePrevious] [nvarchar](2000) NULL,
	[InstructionsPrevious] [nvarchar](500) NULL,
	[UtilitysSlaHistoricalUsageResponseInDaysPrevious] [int] NULL,
	[LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevious] [int] NULL,
	[IsLoaRequiredPrevious] [bit] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRequestModeHistoricalUsage] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRequestModeHistoricalUsage] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO


CREATE TABLE [dbo].[zAuditRequestModeIcap](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[AddressForPreEnrollment] [nvarchar](200) NOT NULL,
	[EmailTemplate] [nvarchar](2000) NULL,
	[Instructions] [nvarchar](500) NOT NULL,
	[UtilitysSlaIcapResponseInDays] [int] NOT NULL,
	[LibertyPowersSlaFollowUpIcapResponseInDays] [int] NOT NULL,
	[IsLoaRequired] [bit] NOT NULL,
	[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser] [bit] NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[RequestModeEnrollmentTypeIdPrevious] [uniqueidentifier] NULL,
	[RequestModeTypeIdPrevious] [uniqueidentifier] NULL,
	[AddressForPreEnrollmentPrevious] [nvarchar](200) NULL,
	[EmailTemplatePrevious] [nvarchar](2000) NULL,
	[InstructionsPrevious] [nvarchar](500) NULL,
	[UtilitysSlaIcapResponseInDaysPrevious] [int] NULL,
	[LibertyPowersSlaFollowUpIcapResponseInDaysPrevious] [int] NULL,
	[IsLoaRequiredPrevious] [bit] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRequestModeIcap] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRequestModeIcap] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO


CREATE TABLE [dbo].[zAuditRequestModeType](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[NamePrevious] [nvarchar](50) NULL,
	[DescriptionPrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRequestModeType] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRequestModeType] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditRequestModeTypeGenre](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[NamePrevious] [nvarchar](50) NULL,
	[DescriptionPrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRequestModeTypeGenre] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRequestModeTypeGenre] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO




CREATE TABLE [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[RequestModeTypeIdPrevious] [uniqueidentifier] NULL,
	[RequestModeEnrollmentTypeIdPrevious] [uniqueidentifier] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRequestModeTypeToRequestModeEnrollmentType] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO


CREATE TABLE [dbo].[zAuditRequestModeTypeToRequestModeTypeGenre](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeGenreId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[RequestModeTypeIdPrevious] [uniqueidentifier] NULL,
	[RequestModeTypeGenreIdPrevious] [uniqueidentifier] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRequestModeTypeToRequestModeTypeGenre] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRequestModeTypeToRequestModeTypeGenre] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO


CREATE TABLE [dbo].[zAuditUserInterfaceControlAndValueGoverningControlVisibility](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormId] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormControlGoverningVisibilityId] [uniqueidentifier] NOT NULL,
	[ControlValueGoverningVisibiltiy] [nvarchar](100) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UserInterfaceFormIdPrevious] [uniqueidentifier] NULL,
	[UserInterfaceFormControlGoverningVisibilityIdPrevious] [uniqueidentifier] NULL,
	[ControlValueGoverningVisibiltiyPrevious] [nvarchar](100) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditUserInterfaceControlAndValueGoverningControlVisibility] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditUserInterfaceControlAndValueGoverningControlVisibility] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditUserInterfaceControlVisibility](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormId] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormControlId] [uniqueidentifier] NOT NULL,
	[UserInterfaceControlAndValueGoverningControlVisibilityId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UserInterfaceFormIdPrevious] [uniqueidentifier] NULL,
	[UserInterfaceFormControlIdPrevious] [uniqueidentifier] NULL,
	[UserInterfaceControlAndValueGoverningControlVisibilityIdPrevious] [uniqueidentifier] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditUserInterfaceControlVisibility] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditUserInterfaceControlVisibility] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditUserInterfaceForm](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormName] [varchar](50) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UserInterfaceFormNamePrevious] [varchar](50) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditUserInterfaceForm] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditUserInterfaceForm] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditUserInterfaceFormControl](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UserInterfaceFormId] [uniqueidentifier] NOT NULL,
	[ControlName] [varchar](50) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UserInterfaceFormIdPrevious] [uniqueidentifier] NULL,
	[ControlNamePrevious] [varchar](50) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditUserInterfaceFormControl] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditUserInterfaceFormControl] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditUtilityCompanyToUtilityLegacy](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[UtilityLegacyId] [int] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[UtilityLegacyIdPrevious] [int] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditUtilityCompanyToUtilityLegacy] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditUtilityCompanyToUtilityLegacy] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditUtilityCompany](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCode] [varchar](50) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCodePrevious] [nvarchar](50) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditUtilityCompany] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditUtilityCompany] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditRateClass](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardRateClassId] [uniqueidentifier] NULL,
	[RateClassId] [int] NULL,
	[RateClassCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[LpStandardRateClassIdPrevious] [uniqueidentifier] NULL,
	[RateClassIdPrevious] [int] NULL,
	[RateClassCodePrevious] [nvarchar](255) NULL,
	[DescriptionPrevious] [nvarchar](255) NULL,
	[AccountTypeIdPrevious] [uniqueidentifier] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRateClass] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRateClass] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditLpStandardRateClass](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardRateClassCode] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[LpStandardRateClassCodePrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditLpStandardRateClass] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditLpStandardRateClass] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO




CREATE TABLE [dbo].[zAuditRateClassAlias](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[RateClassId] [uniqueidentifier] NOT NULL,
	[RateClassCodeAlias] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[RateClassIdPrevious] [uniqueidentifier] NULL,
	[RateClassCodeAliasPrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditRateClassAlias] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRateClassAlias] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO






CREATE TABLE [dbo].[zAuditLoadProfile](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardLoadProfileId] [uniqueidentifier] NULL,
	[LoadProfileId] [int] NULL,
	[LoadProfileCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[LpStandardLoadProfileIdPrevious] [uniqueidentifier] NULL,
	[LoadProfileIdPrevious] [int] NULL,
	[LoadProfileCodePrevious] [nvarchar](255) NULL,
	[DescriptionPrevious] [nvarchar](255) NULL,
	[AccountTypeIdPrevious] [uniqueidentifier] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditLoadProfile] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditLoadProfile] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditLpStandardLoadProfile](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardLoadProfileCode] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[LpStandardLoadProfileCodePrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditLpStandardLoadProfile] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditLpStandardLoadProfile] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO




CREATE TABLE [dbo].[zAuditLoadProfileAlias](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[LoadProfileId] [uniqueidentifier] NOT NULL,
	[LoadProfileCodeAlias] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[LoadProfileIdPrevious] [uniqueidentifier] NULL,
	[LoadProfileCodeAliasPrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditLoadProfileAlias] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditLoadProfileAlias] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO






CREATE TABLE [dbo].[zAuditTariffCode](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardTariffCodeId] [uniqueidentifier] NULL,
	[TariffCodeId] [int] NULL,
	[TariffCodeCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[LpStandardTariffCodeIdPrevious] [uniqueidentifier] NULL,
	[TariffCodeIdPrevious] [int] NULL,
	[TariffCodeCodePrevious] [nvarchar](255) NULL,
	[DescriptionPrevious] [nvarchar](255) NULL,
	[AccountTypeIdPrevious] [uniqueidentifier] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditTariffCode] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditTariffCode] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO



CREATE TABLE [dbo].[zAuditLpStandardTariffCode](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[LpStandardTariffCodeCode] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[LpStandardTariffCodeCodePrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditLpStandardTariffCode] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditLpStandardTariffCode] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO




CREATE TABLE [dbo].[zAuditTariffCodeAlias](
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TariffCodeId] [uniqueidentifier] NOT NULL,
	[TariffCodeCodeAlias] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[TariffCodeIdPrevious] [uniqueidentifier] NULL,
	[TariffCodeCodeAliasPrevious] [nvarchar](255) NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditTariffCodeAlias] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditTariffCodeAlias] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO








CREATE TABLE [dbo].[zAuditServiceClass](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NULL,
	[ServiceClassCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[LpStandardServiceClass] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NOT NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[ServiceClassCodePrevious] [nvarchar](255) NOT NULL,
	[DescriptionPrevious] [nvarchar](255) NOT NULL,
	[AccountTypeIdPrevious] [uniqueidentifier] NOT NULL,
	[LpStandardServiceClassPrevious] [nvarchar](255) NOT NULL,
	[InactivePrevious] [bit] NOT NULL,
	[CreatedByPrevious] [nvarchar](100) NOT NULL,
	[CreatedDatePrevious] [datetime] NOT NULL,
	[LastModifiedByPrevious] [nvarchar](100) NOT NULL,
	[LastModifiedDatePrevious] [datetime] NOT NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL
 CONSTRAINT [PK_zAuditServiceClass] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditServiceClass] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO




--CREATE TABLE [dbo].[zAuditLoadProfile](
--	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
--	[Id] [uniqueidentifier] NOT NULL,
--	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
--	[LoadProfileCode] [nvarchar](255) NOT NULL,
--	[Description] [nvarchar] (500) NOT NULL,
--	[AccountTypeId] [uniqueidentifier] NOT NULL,
--	[LpStandardLoadProfile] [nvarchar](255) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL,
--	[IdPrevious] [uniqueidentifier] NOT NULL,
--	[UtilityCompanyIdPrevious] [uniqueidentifier] NOT NULL,
--	[LoadProfileCodePrevious] [nvarchar](255) NOT NULL,
--	[DescriptionPrevious] [nvarchar] (500) NOT NULL,
--	[AccountTypeIdPrevious] [uniqueidentifier] NOT NULL,
--	[LpStandardLoadProfilePrevious] [nvarchar](255) NOT NULL,
--	[InactivePrevious] [bit] NOT NULL,
--	[CreatedByPrevious] [nvarchar](100) NOT NULL,
--	[CreatedDatePrevious] [datetime] NOT NULL,
--	[LastModifiedByPrevious] [nvarchar](100) NOT NULL,
--	[LastModifiedDatePrevious] [datetime] NOT NULL,
--	[SYS_CHANGE_VERSION] [bigint] NULL,
--	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
--	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
--	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL
-- CONSTRAINT [PK_zAuditLoadProfile] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
-- WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
--GO
--ALTER TABLE [dbo].[zAuditLoadProfile] ADD  DEFAULT (newid()) FOR [IdPrimary]
--GO




--CREATE TABLE [dbo].[zAuditTariffCode](
--	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
--	[Id] [uniqueidentifier] NOT NULL,
--	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
--	[TariffCode] [nvarchar](255) NOT NULL,
--	[Description] [nvarchar](500) NOT NULL,
--	[AccountTypeId] [uniqueidentifier] NOT NULL,
--	[LpStandardTariffCode] [nvarchar](255) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL,
--	[IdPrevious] [uniqueidentifier] NOT NULL,
--	[UtilityCompanyIdPrevious] [uniqueidentifier] NOT NULL,
--	[TariffCodePrevious] [nvarchar](255) NOT NULL,
--	[DescriptionPrevious] [nvarchar](500) NOT NULL,
--	[AccountTypeIdPrevious] [uniqueidentifier] NOT NULL,
--	[LpStandardTariffCodePrevious] [nvarchar](255) NOT NULL,
--	[InactivePrevious] [bit] NOT NULL,
--	[CreatedByPrevious] [nvarchar](100) NOT NULL,
--	[CreatedDatePrevious] [datetime] NOT NULL,
--	[LastModifiedByPrevious] [nvarchar](100) NOT NULL,
--	[LastModifiedDatePrevious] [datetime] NOT NULL,
--	[SYS_CHANGE_VERSION] [bigint] NULL,
--	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
--	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
--	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL
-- CONSTRAINT [PK_zAuditTariffCode] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
-- WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
--GO
--ALTER TABLE [dbo].[zAuditTariffCode] ADD  DEFAULT (newid()) FOR [IdPrimary]
--GO




CREATE TABLE [dbo].[zAuditMeterType](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NULL,
	[MeterTypeCode] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[AccountTypeId] [uniqueidentifier] NOT NULL,
	[LpStandardMeterType] [nvarchar](255) NOT NULL,
	[Sequence] [int] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NOT NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[MeterTypeCodePrevious] [nvarchar](255) NOT NULL,
	[DescriptionPrevious] [nvarchar](255) NOT NULL,
	[AccountTypeIdPrevious] [uniqueidentifier] NOT NULL,
	[LpStandardMeterTypePrevious] [nvarchar](255) NOT NULL,
	[SequencePrevious] [int] NOT NULL,
	[InactivePrevious] [bit] NOT NULL,
	[CreatedByPrevious] [nvarchar](100) NOT NULL,
	[CreatedDatePrevious] [datetime] NOT NULL,
	[LastModifiedByPrevious] [nvarchar](100) NOT NULL,
	[LastModifiedDatePrevious] [datetime] NOT NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL
 CONSTRAINT [PK_zAuditMeterType] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditMeterType] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO




CREATE TABLE [dbo].[zAuditRequestModeIdr](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[AddressForPreEnrollment] [nvarchar](255) NOT NULL,
	[EmailTemplate] [nvarchar](2000) NOT NULL,
	[Instructions] [nvarchar](500) NOT NULL,
	[UtilitysSlaIdrResponseInDays] [int] NOT NULL,
	[LibertyPowersSlaFollowUpIdrResponseInDays] [int] NOT NULL,
	[IsLoaRequired] [bit] NOT NULL,
	[RequestCostAccount] [money] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NOT NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NOT NULL,
	[RequestModeEnrollmentTypeIdPrevious] [uniqueidentifier] NOT NULL,
	[RequestModeTypeIdPrevious] [uniqueidentifier] NOT NULL,
	[AddressForPreEnrollmentPrevious] [nvarchar](255) NOT NULL,
	[EmailTemplatePrevious] [nvarchar](2000) NOT NULL,
	[InstructionsPrevious] [nvarchar](500) NOT NULL,
	[UtilitysSlaIdrResponseInDaysPrevious] [int] NOT NULL,
	[LibertyPowersSlaFollowUpIdrResponseInDaysPrevious] [int] NOT NULL,
	[IsLoaRequiredPrevious] [bit] NOT NULL,
	[RequestCostAccountPrevious] [money] NOT NULL,
	[InactivePrevious] [bit] NOT NULL,
	[CreatedByPrevious] [nvarchar](100) NOT NULL,
	[CreatedDatePrevious] [datetime] NOT NULL,
	[LastModifiedByPrevious] [nvarchar](100) NOT NULL,
	[LastModifiedDatePrevious] [datetime] NOT NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL
 CONSTRAINT [PK_zAuditRequestModeIdr] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditRequestModeIdr] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO




CREATE TABLE [dbo].[zAuditIdrRules](
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[RequestModeTypeId] [uniqueidentifier] NOT NULL,
	[Instruction] [nvarchar](750) NOT NULL,
	[MinUsageMWh] [int],
	[MaxUsageMWh] [int],
	[RateClassId] [uniqueidentifier] NOT NULL,
	[ServiceClassId] [uniqueidentifier] NOT NULL,
	[LoadProfileId] [uniqueidentifier] NOT NULL,
	[MeterTypeId] [uniqueidentifier] NOT NULL,
	[IsOnEligibleCustomerList] [bit] NOT NULL,
	[IsHistoricalArchiveAvailable] [bit] NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NOT NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NOT NULL,
	[RequestModeTypeIdPrevious] [uniqueidentifier] NOT NULL,
	[InstructionPrevious] [nvarchar](750) NOT NULL,
	[MinUsageMWhPrevious] [int],
	[MaxUsageMWhPrevious] [int],
	[RateClassIdPrevious] [uniqueidentifier] NOT NULL,
	[ServiceClassIdPrevious] [uniqueidentifier] NOT NULL,
	[LoadProfileIdPrevious] [uniqueidentifier] NOT NULL,
	[MeterTypeIdPrevious] [uniqueidentifier] NOT NULL,
	[IsOnEligibleCustomerListPrevious] [bit] NOT NULL,
	[IsHistoricalArchiveAvailablePrevious] [bit] NOT NULL,
	[InactivePrevious] [bit] NOT NULL,
	[CreatedByPrevious] [nvarchar](100) NOT NULL,
	[CreatedDatePrevious] [datetime] NOT NULL,
	[LastModifiedByPrevious] [nvarchar](100) NOT NULL,
	[LastModifiedDatePrevious] [datetime] NOT NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL
 CONSTRAINT [PK_zAuditIdrRules] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditIdrRules] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO


CREATE TABLE [dbo].[zAuditAccountType]
(
	[IdPrimary] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NOT NULL,
	[NamePrevious] [nvarchar](255) NOT NULL,
	[DescriptionPrevious] [nvarchar](255) NOT NULL,
	[InactivePrevious] [bit] NOT NULL,
	[CreatedByPrevious] [nvarchar](100) NOT NULL,
	[CreatedDatePrevious] [datetime] NOT NULL,
	[LastModifiedByPrevious] [nvarchar](100) NOT NULL,
	[LastModifiedDatePrevious] [datetime] NOT NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL
 CONSTRAINT [PK_zAuditAccountType] PRIMARY KEY CLUSTERED  ( [IdPrimary] ASC )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[zAuditAccountType] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO







CREATE TABLE [dbo].[zAuditPurchaseOfReceivables]
(
	[IdPrimary] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[UtilityCompanyId] [uniqueidentifier] NOT NULL,
	[PorDriverId] [uniqueidentifier] NOT NULL,
	[RateClassId] [uniqueidentifier] NULL,
	[LoadProfileId] [uniqueidentifier] NULL,
	[TariffCodeId] [uniqueidentifier] NULL,
	[IsPorOffered] [bit] NOT NULL,
	[IsPorParticipated] [bit] NOT NULL,
	[PorRecourseId] [uniqueidentifier] NOT NULL,
	[IsPorAssurance] [bit] NOT NULL,
	[PorDiscountRate] [decimal] NOT NULL,
	[PorFlatFee] [decimal] NOT NULL,
	[PorDiscountEffectiveDate] [datetime] NOT NULL,
	[PorDiscountExpirationDate] [datetime] NULL,
	[Inactive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](100) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IdPrevious] [uniqueidentifier] NULL,
	[UtilityCompanyIdPrevious] [uniqueidentifier] NULL,
	[PorDriverIdPrevious] [uniqueidentifier] NULL,
	[RateClassIdPrevious] [uniqueidentifier] NULL,
	[LoadProfileIdPrevious] [uniqueidentifier] NULL,
	[TariffCodeIdPrevious] [uniqueidentifier] NULL,
	[IsPorOfferedPrevious] [bit] NULL,
	[IsPorParticipatedPrevious] [bit] NULL,
	[PorRecourseIdPrevious] [uniqueidentifier] NULL,
	[IsPorAssurancePrevious] [bit] NULL,
	[PorDiscountRatePrevious] [decimal] NULL,
	[PorFlatFeePrevious] [decimal] NULL,
	[PorDiscountEffectiveDatePrevious] [datetime] NULL,
	[PorDiscountExpirationDatePrevious] [datetime] NULL,
	[InactivePrevious] [bit] NULL,
	[CreatedByPrevious] [nvarchar](100) NULL,
	[CreatedDatePrevious] [datetime] NULL,
	[LastModifiedByPrevious] [nvarchar](100) NULL,
	[LastModifiedDatePrevious] [datetime] NULL,
	[SYS_CHANGE_VERSION] [bigint] NULL,
	[SYS_CHANGE_CREATION_VERSION] [bigint] NULL,
	[SYS_CHANGE_OPERATION] [nchar](1) NULL,
	[SYS_CHANGE_COLUMNS] [nvarchar](1000) NULL,
 CONSTRAINT [PK_zAuditTariffCode] PRIMARY KEY CLUSTERED 
(
	[IdPrimary] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[PurchaseOfReceivables] ADD  DEFAULT (newid()) FOR [IdPrimary]
GO





-------------------------------- CREATE AUDIT TABLE END -------------------------------------







-------------------------------- CREATE TRIGGERS BEGIN -------------------------------------




CREATE TRIGGER [dbo].[zAuditRequestModeEnrollmentTypeUpdate]
	ON [dbo].[RequestModeEnrollmentType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMET.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRequestModeEnrollmentType (NOLOCK) ZARMET
		INNER JOIN inserted a
			ON ZARMET.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Name],'') <> isnull(b.[Name],'') THEN 'Name' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditRequestModeEnrollmentType]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[NamePrevious]
           ,[DescriptionPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id]
		,a.[Name]
		,a.[Description]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[Name]
		,b.[Description]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
			

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
			
	SET NOCOUNT OFF;
END
GO	



CREATE TRIGGER [dbo].[zAuditRequestModeEnrollmentTypeInsert]
	ON  [dbo].[RequestModeEnrollmentType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRequestModeEnrollmentType]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[NamePrevious]
           ,[DescriptionPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id]
		,a.[Name]
		,a.[Description]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,Name,Description,Inactive,CreatedBy,CreatedDate,LastModifiedBy,[LastModifiedDate'	
	FROM 
		inserted a


	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()


	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditRequestModeHistoricalUsageInsert]
	ON  [dbo].[RequestModeHistoricalUsage]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT;
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	PRINT @ChangeTrackingCurrentVersion 

	INSERT INTO [dbo].[zAuditRequestModeHistoricalUsage]
	(
		[Id]
       ,[UtilityCompanyId]
       ,[RequestModeEnrollmentTypeId]
       ,[RequestModeTypeId]
       ,[AddressForPreEnrollment]
       ,[EmailTemplate]
       ,[Instructions]
       ,[UtilitysSlaHistoricalUsageResponseInDays]
       ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
       ,[IsLoaRequired]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
       ,[IdPrevious]
       ,[UtilityCompanyIdPrevious]
       ,[RequestModeEnrollmentTypeIdPrevious]
       ,[RequestModeTypeIdPrevious]
       ,[AddressForPreEnrollmentPrevious]
       ,[EmailTemplatePrevious]
       ,[InstructionsPrevious]
       ,[UtilitysSlaHistoricalUsageResponseInDaysPrevious]
       ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevious]
       ,[IsLoaRequiredPrevious]
       ,[InactivePrevious]
       ,[CreatedByPrevious]
       ,[CreatedDatePrevious]
       ,[LastModifiedByPrevious]
       ,[LastModifiedDatePrevious]
       ,[SYS_CHANGE_VERSION]
       ,[SYS_CHANGE_CREATION_VERSION]
       ,[SYS_CHANGE_OPERATION]
       ,[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		[Id]
       ,[UtilityCompanyId]
       ,[RequestModeEnrollmentTypeId]
       ,[RequestModeTypeId]
       ,[AddressForPreEnrollment]
       ,[EmailTemplate]
       ,[Instructions]
       ,[UtilitysSlaHistoricalUsageResponseInDays]
       ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
       ,[IsLoaRequired]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UtilityCompanyId,RequestModeEnrollmentTypeId,RequestModeTypeId,AddressForPreEnrollment,EmailTemplate,Instructions,UtilitysSlaHistoricalUsageResponseInDays,LibertyPowersSlaFollowUpHistoricalUsageResponseInDays,IsLoaRequired,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
		
	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditRequestModeHistoricalUsageUpdate]
	ON [dbo].[RequestModeHistoricalUsage]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)
			
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	
	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMHU.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRequestModeHistoricalUsage (NOLOCK) ZARMHU 
		INNER JOIN inserted a
			ON ZARMHU.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeEnrollmentTypeId],'') <> isnull(b.[RequestModeEnrollmentTypeId],'') THEN 'RequestModeEnrollmentTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AddressForPreEnrollment],'') <> isnull(b.[AddressForPreEnrollment],'') THEN 'AddressForPreEnrollment' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EmailTemplate],'') <> isnull(b.[EmailTemplate],'') THEN 'EmailTemplate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Instructions],'') <> isnull(b.[Instructions],'') THEN 'Instructions' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilitysSlaHistoricalUsageResponseInDays],'') <> isnull(b.[UtilitysSlaHistoricalUsageResponseInDays],'') THEN 'UtilitysSlaHistoricalUsageResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays],'') <> isnull(b.[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays],'') THEN 'LibertyPowersSlaFollowUpHistoricalUsageResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsLoaRequired],'') <> isnull(b.[IsLoaRequired],'') THEN 'IsLoaRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeHistoricalUsage]
           ([Id]
           ,[UtilityCompanyId]
           ,[RequestModeEnrollmentTypeId]
           ,[RequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[EmailTemplate]
           ,[Instructions]
           ,[UtilitysSlaHistoricalUsageResponseInDays]
           ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
           ,[IsLoaRequired]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UtilityCompanyIdPrevious]
           ,[RequestModeEnrollmentTypeIdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[AddressForPreEnrollmentPrevious]
           ,[EmailTemplatePrevious]
           ,[InstructionsPrevious]
           ,[UtilitysSlaHistoricalUsageResponseInDaysPrevious]
           ,[LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevious]
           ,[IsLoaRequiredPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id]
		,a.[UtilityCompanyId]
		,a.[RequestModeEnrollmentTypeId]
		,a.[RequestModeTypeId]
		,a.[AddressForPreEnrollment]
		,a.[EmailTemplate]
		,a.[Instructions]
		,a.[UtilitysSlaHistoricalUsageResponseInDays]
		,a.[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
		,a.[IsLoaRequired]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[RequestModeEnrollmentTypeId]
		,b.[RequestModeTypeId]
		,b.[AddressForPreEnrollment]
		,b.[EmailTemplate]
		,b.[Instructions]
		,b.[UtilitysSlaHistoricalUsageResponseInDays]
		,b.[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays]
		,b.[IsLoaRequired]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO





CREATE TRIGGER [dbo].[zAuditRequestModeIcapInsert]
	ON  [dbo].[RequestModeIcap]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT;
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	PRINT @ChangeTrackingCurrentVersion 

	INSERT INTO [dbo].[zAuditRequestModeIcap]
	(
		[Id]
       ,[UtilityCompanyId]
       ,[RequestModeEnrollmentTypeId]
       ,[RequestModeTypeId]
       ,[AddressForPreEnrollment]
       ,[EmailTemplate]
       ,[Instructions]
       ,[UtilitysSlaIcapResponseInDays]
       ,[LibertyPowersSlaFollowUpIcapResponseInDays]
       ,[IsLoaRequired]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
       ,[IdPrevious]
       ,[UtilityCompanyIdPrevious]
       ,[RequestModeEnrollmentTypeIdPrevious]
       ,[RequestModeTypeIdPrevious]
       ,[AddressForPreEnrollmentPrevious]
       ,[EmailTemplatePrevious]
       ,[InstructionsPrevious]
       ,[UtilitysSlaIcapResponseInDaysPrevious]
       ,[LibertyPowersSlaFollowUpIcapResponseInDaysPrevious]
       ,[IsLoaRequiredPrevious]
       ,[InactivePrevious]
       ,[CreatedByPrevious]
       ,[CreatedDatePrevious]
       ,[LastModifiedByPrevious]
       ,[LastModifiedDatePrevious]
       ,[SYS_CHANGE_VERSION]
       ,[SYS_CHANGE_CREATION_VERSION]
       ,[SYS_CHANGE_OPERATION]
       ,[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		[Id]
       ,[UtilityCompanyId]
       ,[RequestModeEnrollmentTypeId]
       ,[RequestModeTypeId]
       ,[AddressForPreEnrollment]
       ,[EmailTemplate]
       ,[Instructions]
       ,[UtilitysSlaIcapResponseInDays]
       ,[LibertyPowersSlaFollowUpIcapResponseInDays]
       ,[IsLoaRequired]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UtilityCompanyId,RequestModeEnrollmentTypeId,RequestModeTypeId,AddressForPreEnrollment,EmailTemplate,Instructions,UtilitysSlaHistoricalUsageResponseInDays,LibertyPowersSlaFollowUpHistoricalUsageResponseInDays,IsLoaRequired,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
		
	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditRequestModeIcapUpdate]
	ON [dbo].[RequestModeIcap]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)
			
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	
	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMHU.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRequestModeIcap (NOLOCK) ZARMHU 
		INNER JOIN inserted a
			ON ZARMHU.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeEnrollmentTypeId],'') <> isnull(b.[RequestModeEnrollmentTypeId],'') THEN 'RequestModeEnrollmentTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AddressForPreEnrollment],'') <> isnull(b.[AddressForPreEnrollment],'') THEN 'AddressForPreEnrollment' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EmailTemplate],'') <> isnull(b.[EmailTemplate],'') THEN 'EmailTemplate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Instructions],'') <> isnull(b.[Instructions],'') THEN 'Instructions' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilitysSlaIcapResponseInDays],'') <> isnull(b.[UtilitysSlaIcapResponseInDays],'') THEN 'UtilitysSlaIcapResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LibertyPowersSlaFollowUpIcapResponseInDays],'') <> isnull(b.[LibertyPowersSlaFollowUpIcapResponseInDays],'') THEN 'LibertyPowersSlaFollowUpIcapResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsLoaRequired],'') <> isnull(b.[IsLoaRequired],'') THEN 'IsLoaRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeIcap]
           ([Id]
           ,[UtilityCompanyId]
           ,[RequestModeEnrollmentTypeId]
           ,[RequestModeTypeId]
           ,[AddressForPreEnrollment]
           ,[EmailTemplate]
           ,[Instructions]
           ,[UtilitysSlaIcapResponseInDays]
           ,[LibertyPowersSlaFollowUpIcapResponseInDays]
           ,[IsLoaRequired]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UtilityCompanyIdPrevious]
           ,[RequestModeEnrollmentTypeIdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[AddressForPreEnrollmentPrevious]
           ,[EmailTemplatePrevious]
           ,[InstructionsPrevious]
           ,[UtilitysSlaIcapResponseInDaysPrevious]
           ,[LibertyPowersSlaFollowUpIcapResponseInDaysPrevious]
           ,[IsLoaRequiredPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id]
		,a.[UtilityCompanyId]
		,a.[RequestModeEnrollmentTypeId]
		,a.[RequestModeTypeId]
		,a.[AddressForPreEnrollment]
		,a.[EmailTemplate]
		,a.[Instructions]
		,a.[UtilitysSlaIcapResponseInDays]
		,a.[LibertyPowersSlaFollowUpIcapResponseInDays]
		,a.[IsLoaRequired]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[RequestModeEnrollmentTypeId]
		,b.[RequestModeTypeId]
		,b.[AddressForPreEnrollment]
		,b.[EmailTemplate]
		,b.[Instructions]
		,b.[UtilitysSlaIcapResponseInDays]
		,b.[LibertyPowersSlaFollowUpIcapResponseInDays]
		,b.[IsLoaRequired]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditRequestModeTypeUpdate]
	ON  [dbo].[RequestModeType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRequestModeType (NOLOCK) ZARMT
		INNER JOIN inserted a
			ON ZARMT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Name],'') <> isnull(b.[Name],'') THEN 'Name' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditRequestModeType]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[NamePrevious]
           ,[DescriptionPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id]
		,a.[Name]
		,a.[Description]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[Name]
		,b.[Description]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO

CREATE TRIGGER [dbo].[zAuditRequestModeTypeInsert]
	ON  [dbo].[RequestModeType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

		DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRequestModeType]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[NamePrevious]
           ,[DescriptionPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		 a.[Id]
		,a.[Name]
		,a.[Description]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,Name,Description,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'	
	FROM 
		inserted a

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditRequestModeTypeGenreUpdate]
	ON  [dbo].[RequestModeTypeGenre]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRequestModeType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Name],'') <> isnull(b.[Name],'') THEN 'Name' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditRequestModeTypeGenre]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[NamePrevious]
           ,[DescriptionPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id]
		,a.[Name]
		,a.[Description]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[Name]
		,b.[Description]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditRequestModeTypeGenreInsert]
	ON  [dbo].[RequestModeTypeGenre]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	
	INSERT INTO [dbo].[zAuditRequestModeTypeGenre]
           ([Id]
           ,[Name]
           ,[Description]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[NamePrevious]
           ,[DescriptionPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id]
		,a.[Name]
		,a.[Description]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,Name,Description,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted a

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO






CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentTypeInsert]
	ON  [dbo].[RequestModeTypeToRequestModeEnrollmentType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType]
           ([Id]
           ,[RequestModeTypeId]
           ,[RequestModeEnrollmentTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[RequestModeEnrollmentTypeIdPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		[Id],
		[RequestModeTypeId],
		[RequestModeEnrollmentTypeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,RequestModeTypeId,RequestModeEnrollmentTypeId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO


CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentTypeUpdate]
	ON  [dbo].[RequestModeTypeToRequestModeEnrollmentType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRequestModeTypeToRequestModeEnrollmentType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeEnrollmentTypeId],'') <> isnull(b.[RequestModeEnrollmentTypeId],'') THEN 'RequestModeEnrollmentTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType]
           ([Id]
           ,[RequestModeTypeId]
           ,[RequestModeEnrollmentTypeId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[RequestModeEnrollmentTypeIdPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id],
		a.[RequestModeTypeId],
		a.[RequestModeEnrollmentTypeId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[RequestModeTypeId],
		b.[RequestModeEnrollmentTypeId],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeTypeGenreInsert]
	ON  [dbo].[RequestModeTypeToRequestModeTypeGenre]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRequestModeTypeToRequestModeTypeGenre]
           ([Id]
           ,[RequestModeTypeId]
           ,[RequestModeTypeGenreId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[RequestModeTypeGenreIdPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		[Id],
		[RequestModeTypeId],
		[RequestModeTypeGenreId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,RequestModeTypeId,RequestModeTypeGenreId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeTypeGenreUpdate]
	ON  [dbo].[RequestModeTypeToRequestModeTypeGenre]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRequestModeTypeToRequestModeTypeGenre (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeGenreId],'') <> isnull(b.[RequestModeTypeGenreId],'') THEN 'RequestModeTypeGenreId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeTypeToRequestModeTypeGenre]
           ([Id]
           ,[RequestModeTypeId]
           ,[RequestModeTypeGenreId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[RequestModeTypeIdPrevious]
           ,[RequestModeTypeGenreIdPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id],
		a.[RequestModeTypeId],
		a.[RequestModeTypeGenreId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[RequestModeTypeId],
		b.[RequestModeTypeGenreId],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditUserInterfaceControlAndValueGoverningControlVisibilityInsert]
	ON  [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditUserInterfaceControlAndValueGoverningControlVisibility]
           ([Id]
           ,[UserInterfaceFormId]
           ,[UserInterfaceFormControlGoverningVisibilityId]
           ,[ControlValueGoverningVisibiltiy]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[UserInterfaceFormControlGoverningVisibilityIdPrevious]
           ,[ControlValueGoverningVisibiltiyPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		[Id],
		[UserInterfaceFormId],
		[UserInterfaceFormControlGoverningVisibilityId],
		[ControlValueGoverningVisibiltiy],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,RequestModeTypeId,RequestModeTypeGenreId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO


CREATE TRIGGER [dbo].[zAuditUserInterfaceControlAndValueGoverningControlVisibilityUpdate]
	ON  [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditUserInterfaceControlAndValueGoverningControlVisibility (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormId],'') <> isnull(b.[UserInterfaceFormId],'') THEN 'UserInterfaceFormId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormControlGoverningVisibilityId],'') <> isnull(b.[UserInterfaceFormControlGoverningVisibilityId],'') THEN 'UserInterfaceFormControlGoverningVisibilityId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ControlValueGoverningVisibiltiy],'') <> isnull(b.[ControlValueGoverningVisibiltiy],'') THEN 'ControlValueGoverningVisibiltiy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditUserInterfaceControlAndValueGoverningControlVisibility]
           ([Id]
           ,[UserInterfaceFormId]
           ,[UserInterfaceFormControlGoverningVisibilityId]
           ,[ControlValueGoverningVisibiltiy]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[UserInterfaceFormControlGoverningVisibilityIdPrevious]
           ,[ControlValueGoverningVisibiltiyPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id],
		a.[UserInterfaceFormId],
		a.[UserInterfaceFormControlGoverningVisibilityId],
		a.[ControlValueGoverningVisibiltiy],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UserInterfaceFormId],
		b.[UserInterfaceFormControlGoverningVisibilityId],
		b.[ControlValueGoverningVisibiltiy],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditUserInterfaceControlVisibilityInsert]
	ON  [dbo].[UserInterfaceControlVisibility]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditUserInterfaceControlVisibility]
           ([Id]
           ,[UserInterfaceFormId]
           ,[UserInterfaceFormControlId]
           ,[UserInterfaceControlAndValueGoverningControlVisibilityId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[UserInterfaceFormControlIdPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		[Id],
		[UserInterfaceFormId],
		[UserInterfaceFormControlId],
		[UserInterfaceControlAndValueGoverningControlVisibilityId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UserInterfaceFormId,UserInterfaceFormControlId,UserInterfaceControlAndValueGoverningControlVisibilityId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditUserInterfaceControlVisibilityUpdate]
	ON  [dbo].[UserInterfaceControlVisibility]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditUserInterfaceControlVisibility (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormId],'') <> isnull(b.[UserInterfaceFormId],'') THEN 'UserInterfaceFormId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormControlId],'') <> isnull(b.[UserInterfaceFormControlId],'') THEN 'UserInterfaceFormControlId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceControlAndValueGoverningControlVisibilityId],'') <> isnull(b.[UserInterfaceControlAndValueGoverningControlVisibilityId],'') THEN 'UserInterfaceControlAndValueGoverningControlVisibilityId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditUserInterfaceControlVisibility]
           ([Id]
           ,[UserInterfaceFormId]
           ,[UserInterfaceFormControlId]
           ,[UserInterfaceControlAndValueGoverningControlVisibilityId]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[UserInterfaceFormControlIdPrevious]
           ,[UserInterfaceControlAndValueGoverningControlVisibilityIdPrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id],
		a.[UserInterfaceFormId],
		a.[UserInterfaceFormControlId],
		a.[UserInterfaceControlAndValueGoverningControlVisibilityId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UserInterfaceFormId],
		b.[UserInterfaceFormControlId],
		b.[UserInterfaceControlAndValueGoverningControlVisibilityId],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditUserInterfaceFormInsert]
	ON  [dbo].[UserInterfaceForm]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditUserInterfaceForm]
           ([Id]
           ,[UserInterfaceFormName]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormNamePrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		[Id],
		[UserInterfaceFormName],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UserInterfaceFormName,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditUserInterfaceFormUpdate]
	ON  [dbo].[UserInterfaceForm]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditUserInterfaceForm (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormName],'') <> isnull(b.[UserInterfaceFormName],'') THEN 'UserInterfaceFormName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditUserInterfaceForm]
           ([Id]
           ,[UserInterfaceFormName]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormNamePrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id],
		a.[UserInterfaceFormName],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UserInterfaceFormName],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditUserInterfaceFormControlInsert]
	ON  [dbo].[UserInterfaceFormControl]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditUserInterfaceFormControl]
           ([Id]
           ,[UserInterfaceFormId]
           ,[ControlName]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[ControlNamePrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		[Id],
		[UserInterfaceFormId],
		[ControlName],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UserInterfaceFormId,ControlName,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditUserInterfaceFormControlUpdate]
	ON  [dbo].[UserInterfaceFormControl]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditUserInterfaceFormControl (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UserInterfaceFormId],'') <> isnull(b.[UserInterfaceFormId],'') THEN 'UserInterfaceFormId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ControlName],'') <> isnull(b.[ControlName],'') THEN 'ControlName' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditUserInterfaceFormControl]
           ([Id]
           ,[UserInterfaceFormId]
           ,[ControlName]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UserInterfaceFormIdPrevious]
           ,[ControlNamePrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id],
		a.[UserInterfaceFormId],
		a.[ControlName],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UserInterfaceFormId],
		b.[ControlName],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO








-----------------------------------------------------------------
CREATE TRIGGER [dbo].[zAuditUtilityCompanyInsert]
	ON  [dbo].[UtilityCompany]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT;
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	PRINT @ChangeTrackingCurrentVersion 


	INSERT INTO [dbo].[zAuditUtilityCompany]
	(
		[Id]
		,[UtilityCode]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[UtilityCodePrevious]
		,[InactivePrevious]
		,[CreatedByPrevious]
		,[CreatedDatePrevious]
		,[LastModifiedByPrevious]
		,[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		[Id]
		,[UtilityCode]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UtilityCode,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
		
	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditUtilityCompanyUpdate]
	ON  [dbo].[UtilityCompany]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)
			
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	
	SELECT 
		@ChangeTrackingCreationVersion = MIN(AZUC.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditUtilityCompany (NOLOCK) AZUC 
		INNER JOIN inserted a
			ON AZUC.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCode],'') <> isnull(b.[UtilityCode],'') THEN 'UtilityCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]
	
	INSERT INTO [dbo].[zAuditUtilityCompany] 
	(
		[Id]
		,[UtilityCode]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[UtilityCodePrevious]
		,[InactivePrevious]
		,[CreatedByPrevious]
		,[CreatedDatePrevious]
		,[LastModifiedByPrevious]
		,[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id]
		,a.[UtilityCode]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCode]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO
----------------------------------------------------------










CREATE TRIGGER [dbo].[zAuditRateClassInsert]
	ON  [dbo].[RateClass]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRateClass]
	(	
		[Id],
		[UtilityCompanyId],
		[RateClassCode],
		[Description],
		[AccountTypeId],
		[LpStandardRateClassId],
		[RateClassId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RateClassCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardRateClassIdPrevious],
		[RateClassIdPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[RateClassCode],
			[Description],
			[AccountTypeId],
			[LpStandardRateClassId],
			[RateClassId],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,RateClassCode,Description,AccountTypeId,LpStandardRateClassId,RateClassId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO



CREATE TRIGGER [dbo].[zAuditRateClassUpdate]
	ON  [dbo].[RateClass]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRateClass (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassCode],'') <> isnull(b.[RateClassCode],'') THEN 'RateClassCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN a.[LpStandardRateClassId] <> b.[LpStandardRateClassId] THEN 'LpStandardRateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],0) <> isnull(b.[RateClassId],0) THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRateClass]
	(
		[Id],
		[UtilityCompanyId],
		[RateClassCode],
		[Description],
		[AccountTypeId],
		[LpStandardRateClassId],
		[RateClassId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RateClassCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardRateClassIdPrevious],
		[RateClassIdPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[RateClassCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardRateClassId],
		a.[RateClassId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[RateClassCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardRateClassId],
		b.[RateClassId],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO










CREATE TRIGGER [dbo].[zAuditTariffCodeInsert]
	ON  [dbo].[TariffCode]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditTariffCode]
	(	
		[Id],
		[UtilityCompanyId],
		[TariffCodeCode],
		[Description],
		[AccountTypeId],
		[LpStandardTariffCodeId],
		[TariffCodeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[TariffCodeCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardTariffCodeIdPrevious],
		[TariffCodeIdPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[TariffCodeCode],
			[Description],
			[AccountTypeId],
			[LpStandardTariffCodeId],
			[TariffCodeId],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,TariffCodeCode,Description,AccountTypeId,LpStandardTariffCodeId,TariffCodeId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO



CREATE TRIGGER [dbo].[zAuditTariffCodeUpdate]
	ON  [dbo].[TariffCode]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditTariffCode (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeCode],'') <> isnull(b.[TariffCodeCode],'') THEN 'TariffCodeCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN a.[LpStandardTariffCodeId] <> b.[LpStandardTariffCodeId] THEN 'LpStandardTariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeId],0) <> isnull(b.[TariffCodeId],0) THEN 'TariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditTariffCode]
	(
		[Id],
		[UtilityCompanyId],
		[TariffCodeCode],
		[Description],
		[AccountTypeId],
		[LpStandardTariffCodeId],
		[TariffCodeId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[TariffCodeCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardTariffCodeIdPrevious],
		[TariffCodeIdPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[TariffCodeCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardTariffCodeId],
		a.[TariffCodeId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[TariffCodeCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardTariffCodeId],
		b.[TariffCodeId],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO











CREATE TRIGGER [dbo].[zAuditLoadProfileInsert]
	ON  [dbo].[LoadProfile]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditLoadProfile]
	(	
		[Id],
		[UtilityCompanyId],
		[LoadProfileCode],
		[Description],
		[AccountTypeId],
		[LpStandardLoadProfileId],
		[LoadProfileId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[LoadProfileCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardLoadProfileIdPrevious],
		[LoadProfileIdPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[LoadProfileCode],
			[Description],
			[AccountTypeId],
			[LpStandardLoadProfileId],
			[LoadProfileId],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,LoadProfileCode,Description,AccountTypeId,LpStandardLoadProfileId,LoadProfileId,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO



CREATE TRIGGER [dbo].[zAuditLoadProfileUpdate]
	ON  [dbo].[LoadProfile]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditLoadProfile (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileCode],'') <> isnull(b.[LoadProfileCode],'') THEN 'LoadProfileCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN a.[LpStandardLoadProfileId] <> b.[LpStandardLoadProfileId] THEN 'LpStandardLoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileId],0) <> isnull(b.[LoadProfileId],0) THEN 'LoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditLoadProfile]
	(
		[Id],
		[UtilityCompanyId],
		[LoadProfileCode],
		[Description],
		[AccountTypeId],
		[LpStandardLoadProfileId],
		[LoadProfileId],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[LoadProfileCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardLoadProfileIdPrevious],
		[LoadProfileIdPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[LoadProfileCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardLoadProfileId],
		a.[LoadProfileId],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[LoadProfileCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardLoadProfileId],
		b.[LoadProfileId],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO








CREATE TRIGGER [dbo].[zAuditLpStandardRateClassInsert]
	ON  [dbo].[LpStandardRateClass]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditLpStandardRateClass]
	(	
		[Id],
		[UtilityCompanyId],
		[LpStandardRateClassCode],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[LpStandardRateClassCodePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[LpStandardRateClassCode],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,LpStandardRateClassCode,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END

GO





CREATE TRIGGER [dbo].[zAuditLpStandardRateClassUpdate]
	ON  [dbo].[LpStandardRateClass]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditLpStandardRateClass (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LpStandardRateClassCode],'') <> isnull(b.[LpStandardRateClassCode],'') THEN 'LpStandardRateClassCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditLpStandardRateClass]
	(
		[Id],
		[UtilityCompanyId],
		[LpStandardRateClassCode],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[LpStandardRateClassCodePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[LpStandardRateClassCode],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[LpStandardRateClassCode],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
	SET NOCOUNT OFF;
END

GO
















CREATE TRIGGER [dbo].[zAuditRateClassAliasInsert]
	ON  [dbo].[RateClassAlias]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRateClassAlias]
	(	
		[Id]
		,[RateClassId]
		,[RateClassCodeAlias]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[RateClassIdPrevious]
		,[RateClassCodeAliasPrevious]
		,[InactivePrevious]
		,[CreatedByPrevious]
		,[CreatedDatePrevious]
		,[LastModifiedByPrevious]
		,[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[RateClassId],
			[RateClassCodeAlias],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,RateClassId,RateClassCodeAlias,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO





CREATE TRIGGER [dbo].[zAuditRateClassAliasUpdate]
	ON  [dbo].[RateClassAlias]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRateClassAlias (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],'') <> isnull(b.[RateClassId],'') THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassCodeAlias],'') <> isnull(b.[RateClassCodeAlias],'') THEN 'RateClassCodeAlias' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRateClassAlias]
	(
		[Id],
		[RateClassId],
		[RateClassCodeAlias],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[RateClassIdPrevious],
		[RateClassCodeAliasPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[RateClassId],
		a.[RateClassCodeAlias],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[RateClassId],
		b.[RateClassCodeAlias],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
	SET NOCOUNT OFF;
END

GO









CREATE TRIGGER [dbo].[zAuditLoadProfileAliasInsert]
	ON  [dbo].[LoadProfileAlias]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditLoadProfileAlias]
	(	
		[Id]
		,[LoadProfileId]
		,[LoadProfileCodeAlias]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[LoadProfileIdPrevious]
		,[LoadProfileCodeAliasPrevious]
		,[InactivePrevious]
		,[CreatedByPrevious]
		,[CreatedDatePrevious]
		,[LastModifiedByPrevious]
		,[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[LoadProfileId],
			[LoadProfileCodeAlias],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,LoadProfileId,LoadProfileCodeAlias,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO





CREATE TRIGGER [dbo].[zAuditLoadProfileAliasUpdate]
	ON  [dbo].[LoadProfileAlias]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditLoadProfileAlias (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileId],'') <> isnull(b.[LoadProfileId],'') THEN 'LoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileCodeAlias],'') <> isnull(b.[LoadProfileCodeAlias],'') THEN 'LoadProfileCodeAlias' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditLoadProfileAlias]
	(
		[Id],
		[LoadProfileId],
		[LoadProfileCodeAlias],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[LoadProfileIdPrevious],
		[LoadProfileCodeAliasPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[LoadProfileId],
		a.[LoadProfileCodeAlias],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[LoadProfileId],
		b.[LoadProfileCodeAlias],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
	SET NOCOUNT OFF;
END

GO







CREATE TRIGGER [dbo].[zAuditTariffCodeAliasInsert]
	ON  [dbo].[TariffCodeAlias]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditTariffCodeAlias]
	(	
		[Id]
		,[TariffCodeId]
		,[TariffCodeCodeAlias]
		,[Inactive]
		,[CreatedBy]
		,[CreatedDate]
		,[LastModifiedBy]
		,[LastModifiedDate]
		,[IdPrevious]
		,[TariffCodeIdPrevious]
		,[TariffCodeCodeAliasPrevious]
		,[InactivePrevious]
		,[CreatedByPrevious]
		,[CreatedDatePrevious]
		,[LastModifiedByPrevious]
		,[LastModifiedDatePrevious]
		,[SYS_CHANGE_VERSION]
		,[SYS_CHANGE_CREATION_VERSION]
		,[SYS_CHANGE_OPERATION]
		,[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[TariffCodeId],
			[TariffCodeCodeAlias],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,TariffCodeId,TariffCodeCodeAlias,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO





CREATE TRIGGER [dbo].[zAuditTariffCodeAliasUpdate]
	ON  [dbo].[TariffCodeAlias]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditTariffCodeAlias (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id

	set @SysChangeColumns = ''

	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeId],'') <> isnull(b.[TariffCodeId],'') THEN 'TariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeCodeAlias],'') <> isnull(b.[TariffCodeCodeAlias],'') THEN 'TariffCodeCodeAlias' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditTariffCodeAlias]
	(
		[Id],
		[TariffCodeId],
		[TariffCodeCodeAlias],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[TariffCodeIdPrevious],
		[TariffCodeCodeAliasPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[TariffCodeId],
		a.[TariffCodeCodeAlias],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[TariffCodeId],
		b.[TariffCodeCodeAlias],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate],
		@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
	SET NOCOUNT OFF;
END

GO















CREATE TRIGGER [dbo].[zAuditServiceClassInsert]
	ON  [dbo].[ServiceClass]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditServiceClass]
	(	
		[Id],
		[UtilityCompanyId],
		[ServiceClassCode],
		[Description],
		[AccountTypeId],
		[LpStandardServiceClass],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[ServiceClassCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardServiceClassPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[ServiceClassCode],
			[Description],
			[AccountTypeId],
			[LpStandardServiceClass],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,ServiceClassCode,Description,AccountTypeId,LpStandardServiceClass,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO




CREATE TRIGGER [dbo].[zAuditServiceClassUpdate]
	ON  [dbo].[ServiceClass]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditServiceClass (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceClassCode],'') <> isnull(b.[ServiceClassCode],'') THEN 'ServiceClassCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LpStandardServiceClass],'') <> isnull(b.[LpStandardServiceClass],'') THEN 'LpStandardServiceClass' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditServiceClass]
	(
		[Id],
		[UtilityCompanyId],
		[ServiceClassCode],
		[Description],
		[AccountTypeId],
		[LpStandardServiceClass],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[ServiceClassCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardServiceClassPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[ServiceClassCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardServiceClass],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[ServiceClassCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardServiceClass],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditLoadProfileInsert]
	ON  [dbo].[LoadProfile]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditLoadProfile]
	(	
		[Id],
		[UtilityCompanyId],
		[LoadProfileCode],
		[Description],
		[AccountTypeId],
		[LpStandardLoadProfile],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[LoadProfileCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardLoadProfilePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[LoadProfileCode],
			[Description],
			[AccountTypeId],
			[LpStandardLoadProfile],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,LoadProfileCode,Description,AccountTypeId,LpStandardLoadProfile,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO




CREATE TRIGGER [dbo].[zAuditLoadProfileUpdate]
	ON  [dbo].[LoadProfile]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditLoadProfile (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileCode],'') <> isnull(b.[LoadProfileCode],'') THEN 'LoadProfileCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LpStandardLoadProfile],'') <> isnull(b.[LpStandardLoadProfile],'') THEN 'LpStandardLoadProfile' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditLoadProfile]
	(
		[Id],
		[UtilityCompanyId],
		[LoadProfileCode],
		[Description],
		[AccountTypeId],
		[LpStandardLoadProfile],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[LoadProfileCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardLoadProfilePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[LoadProfileCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardLoadProfile],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[LoadProfileCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardLoadProfile],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditMeterTypeInsert]
	ON  [dbo].[MeterType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditMeterType]
	(	
		[Id],
		[UtilityCompanyId],
		[MeterTypeCode],
		[Description],
		[AccountTypeId],
		[LpStandardMeterType],
		[Sequence],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[MeterTypeCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardMeterTypePrevious],
		[SequencePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[MeterTypeCode],
			[Description],
			[AccountTypeId],
			[LpStandardMeterType],
			[Sequence],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,MeterTypeCode,Description,AccountTypeId,LpStandardMeterType,Sequence,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO




CREATE TRIGGER [dbo].[zAuditMeterTypeUpdate]
	ON  [dbo].[MeterType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditMeterType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterTypeCode],'') <> isnull(b.[MeterTypeCode],'') THEN 'MeterTypeCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LpStandardMeterType],'') <> isnull(b.[LpStandardMeterType],'') THEN 'LpStandardMeterType' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Sequence],'') <> isnull(b.[Sequence],'') THEN 'Sequence' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditMeterType]
	(
		[Id],
		[UtilityCompanyId],
		[MeterTypeCode],
		[Description],
		[AccountTypeId],
		[LpStandardMeterType],
		[Sequence],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[MeterTypeCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardMeterTypePrevious],
		[SequencePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[MeterTypeCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardMeterType],
		a.[Sequence],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[MeterTypeCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardMeterType],
		b.[Sequence],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditTariffCodeInsert]
	ON  [dbo].[TariffCode]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditTariffCode]
	(	
		[Id],
		[UtilityCompanyId],
		[TariffCode],
		[Description],
		[AccountTypeId],
		[LpStandardTariffCode],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[TariffCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardTariffCodePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[TariffCode],
			[Description],
			[AccountTypeId],
			[LpStandardTariffCode],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,TariffCode,Description,AccountTypeId,LpStandardTariffCode,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO




CREATE TRIGGER [dbo].[zAuditTariffCodeUpdate]
	ON  [dbo].[TariffCode]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditTariffCode (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCode],'') <> isnull(b.[TariffCode],'') THEN 'TariffCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AccountTypeId],'') <> isnull(b.[AccountTypeId],'') THEN 'AccountTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LpStandardTariffCode],'') <> isnull(b.[LpStandardTariffCode],'') THEN 'LpStandardTariffCode' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditTariffCode]
	(
		[Id],
		[UtilityCompanyId],
		[TariffCode],
		[Description],
		[AccountTypeId],
		[LpStandardTariffCode],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[TariffCodePrevious],
		[DescriptionPrevious],
		[AccountTypeIdPrevious],
		[LpStandardTariffCodePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[TariffCode],
		a.[Description],
		a.[AccountTypeId],
		a.[LpStandardTariffCode],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[TariffCode],
		b.[Description],
		b.[AccountTypeId],
		b.[LpStandardTariffCode],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO








CREATE TRIGGER [dbo].[zAuditAccountTypeInsert]
	ON  [dbo].[AccountType]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditAccountType]
	(	
		[Id],
		[Name],
		[Description],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[NamePrevious],
		[DescriptionPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[Name],
			[Description],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,Name,Description,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO




CREATE TRIGGER [dbo].[zAuditAccountTypeUpdate]
	ON  [dbo].[AccountType]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditAccountType (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Name],'') <> isnull(b.[Name],'') THEN 'Name' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Description],'') <> isnull(b.[Description],'') THEN 'Description' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditAccountType]
	(
		[Id],
		[Name],
		[Description],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[NamePrevious],
		[DescriptionPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[Name],
		a.[Description],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[Name],
		b.[Description],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO




CREATE TRIGGER [dbo].[zAuditIdrRulesInsert]
	ON  [dbo].[IdrRules]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditIdrRules]
	(	
		[Id],
		[UtilityCompanyId],
		[RequestModeTypeId],
		[Instruction],
		[MinUsageMWh],
		[MaxUsageMWh],
		[RateClassId],
		[ServiceClassId],
		[LoadProfileId],
		[MeterTypeId],
		[IsOnEligibleCustomerList],
		[IsHistoricalArchiveAvailable],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RequestModeTypeIdPrevious],
		[InstructionPrevious],
		[MinUsageMWhPrevious],
		[MaxUsageMWhPrevious],
		[RateClassIdPrevious],
		[ServiceClassIdPrevious],
		[LoadProfileIdPrevious],
		[MeterTypeIdPrevious],
		[IsOnEligibleCustomerListPrevious],
		[IsHistoricalArchiveAvailablePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[RequestModeTypeId],
			[Instruction],
			[MinUsageMWh],
			[MaxUsageMWh],
			[RateClassId],
			[ServiceClassId],
			[LoadProfileId],
			[MeterTypeId],
			[IsOnEligibleCustomerList],
			[IsHistoricalArchiveAvailable],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,RequestModeTypeId,Instruction,MinUsageMWh,MaxUsageMWh,RateClassId,ServiceClassId,LoadProfileId,MeterTypeId,IsOnEligibleCustomerList,IsHistoricalArchiveAvailable,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO




CREATE TRIGGER [dbo].[zAuditIdrRulesUpdate]
	ON  [dbo].[IdrRules]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditIdrRules (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Instruction],'') <> isnull(b.[Instruction],'') THEN 'Instruction' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MinUsageMWh],'') <> isnull(b.[MinUsageMWh],'') THEN 'MinUsageMWh' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MaxUsageMWh],'') <> isnull(b.[MaxUsageMWh],'') THEN 'MaxUsageMWh' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],'') <> isnull(b.[RateClassId],'') THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[ServiceClassId],'') <> isnull(b.[ServiceClassId],'') THEN 'ServiceClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileId],'') <> isnull(b.[LoadProfileId],'') THEN 'LoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterTypeId],'') <> isnull(b.[MeterTypeId],'') THEN 'MeterTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsOnEligibleCustomerList],'') <> isnull(b.[IsOnEligibleCustomerList],'') THEN 'IsOnEligibleCustomerList' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsHistoricalArchiveAvailable],'') <> isnull(b.[IsHistoricalArchiveAvailable],'') THEN 'IsHistoricalArchiveAvailable' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[MeterTypeId],'') <> isnull(b.[MeterTypeId],'') THEN 'MeterTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditIdrRules]
	(
		[Id],
		[UtilityCompanyId],
		[RequestModeTypeId],
		[Instruction],
		[MinUsageMWh],
		[MaxUsageMWh],
		[RateClassId],
		[ServiceClassId],
		[LoadProfileId],
		[MeterTypeId],
		[IsOnEligibleCustomerList],
		[IsHistoricalArchiveAvailable],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RequestModeTypeIdPrevious],
		[InstructionPrevious],
		[MinUsageMWhPrevious],
		[MaxUsageMWhPrevious],
		[RateClassIdPrevious],
		[ServiceClassIdPrevious],
		[LoadProfileIdPrevious],
		[MeterTypeIdPrevious],
		[IsOnEligibleCustomerListPrevious],
		[IsHistoricalArchiveAvailablePrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[RequestModeTypeId],
		a.[Instruction],
		a.[MinUsageMWh],
		a.[MaxUsageMWh],
		a.[RateClassId],
		a.[ServiceClassId],
		a.[LoadProfileId],
		a.[MeterTypeId],
		a.[IsOnEligibleCustomerList],
		a.[IsHistoricalArchiveAvailable],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[RequestModeTypeId],
		b.[Instruction],
		b.[MinUsageMWh],
		b.[MaxUsageMWh],
		b.[RateClassId],
		b.[ServiceClassId],
		b.[LoadProfileId],
		b.[MeterTypeId],
		b.[IsOnEligibleCustomerList],
		b.[IsHistoricalArchiveAvailable],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO







CREATE TRIGGER [dbo].[zAuditRequestModeIdrInsert]
	ON  [dbo].[RequestModeIdr]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditRequestModeIdr]
	(	
		[Id],
		[UtilityCompanyId],
		[RequestModeEnrollmentTypeId],
		[RequestModeTypeId],
		[AddressForPreEnrollment],
		[EmailTemplate],
		[Instructions],
		[UtilitysSlaIdrResponseInDays],
		[LibertyPowersSlaFollowUpIdrResponseInDays],
		[IsLoaRequired],
		[RequestCostAccount],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RequestModeEnrollmentTypeIdPrevious],
		[RequestModeTypeIdPrevious],
		[AddressForPreEnrollmentPrevious],
		[EmailTemplatePrevious],
		[InstructionsPrevious],
		[UtilitysSlaIdrResponseInDaysPrevious],
		[LibertyPowersSlaFollowUpIdrResponseInDaysPrevious],
		[IsLoaRequiredPrevious],
		[RequestCostAccountPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[UtilityCompanyId],
			[RequestModeEnrollmentTypeId],
			[RequestModeTypeId],
			[AddressForPreEnrollment],
			[EmailTemplate],
			[Instructions],
			[UtilitysSlaIdrResponseInDays],
			[LibertyPowersSlaFollowUpIdrResponseInDays],
			[IsLoaRequired],
			[RequestCostAccount],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,UtilityCompanyId,RequestModeEnrollmentTypeId,RequestModeTypeId,AddressForPreEnrollment,EmailTemplate,Instructions,UtilitysSlaIdrResponseInDays,LibertyPowersSlaFollowUpIdrResponseInDays,IsLoaRequired,RequestCostAccount,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END
GO




CREATE TRIGGER [dbo].[zAuditRequestModeIdrUpdate]
	ON  [dbo].[RequestModeIdr]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMGT.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditRequestModeIdr (NOLOCK) ZARMGT
		INNER JOIN inserted a
			ON ZARMGT.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeEnrollmentTypeId],'') <> isnull(b.[RequestModeEnrollmentTypeId],'') THEN 'RequestModeEnrollmentTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestModeTypeId],'') <> isnull(b.[RequestModeTypeId],'') THEN 'RequestModeTypeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[AddressForPreEnrollment],'') <> isnull(b.[AddressForPreEnrollment],'') THEN 'AddressForPreEnrollment' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[EmailTemplate],'') <> isnull(b.[EmailTemplate],'') THEN 'EmailTemplate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Instructions],'') <> isnull(b.[Instructions],'') THEN 'Instructions' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilitysSlaIdrResponseInDays],'') <> isnull(b.[UtilitysSlaIdrResponseInDays],'') THEN 'UtilitysSlaIdrResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LibertyPowersSlaFollowUpIdrResponseInDays],'') <> isnull(b.[LibertyPowersSlaFollowUpIdrResponseInDays],'') THEN 'LibertyPowersSlaFollowUpIdrResponseInDays' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsLoaRequired],'') <> isnull(b.[IsLoaRequired],'') THEN 'IsLoaRequired' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RequestCostAccount],'') <> isnull(b.[RequestCostAccount],'') THEN 'RequestCostAccount' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditRequestModeIdr]
	(
		[Id],
		[UtilityCompanyId],
		[RequestModeEnrollmentTypeId],
		[RequestModeTypeId],
		[AddressForPreEnrollment],
		[EmailTemplate],
		[Instructions],
		[UtilitysSlaIdrResponseInDays],
		[LibertyPowersSlaFollowUpIdrResponseInDays],
		[IsLoaRequired],
		[RequestCostAccount],
		[Inactive],
		[CreatedBy],
		[CreatedDate],
		[LastModifiedBy],
		[LastModifiedDate],
		[IdPrevious],
		[UtilityCompanyIdPrevious],
		[RequestModeEnrollmentTypeIdPrevious],
		[RequestModeTypeIdPrevious],
		[AddressForPreEnrollmentPrevious],
		[EmailTemplatePrevious],
		[InstructionsPrevious],
		[UtilitysSlaIdrResponseInDaysPrevious],
		[LibertyPowersSlaFollowUpIdrResponseInDaysPrevious],
		[IsLoaRequiredPrevious],
		[RequestCostAccountPrevious],
		[InactivePrevious],
		[CreatedByPrevious],
		[CreatedDatePrevious],
		[LastModifiedByPrevious],
		[LastModifiedDatePrevious],
		[SYS_CHANGE_VERSION],
		[SYS_CHANGE_CREATION_VERSION],
		[SYS_CHANGE_OPERATION],
		[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		a.[Id],
		a.[UtilityCompanyId],
		a.[RequestModeEnrollmentTypeId],
		a.[RequestModeTypeId],
		a.[AddressForPreEnrollment],
		a.[EmailTemplate],
		a.[Instructions],
		a.[UtilitysSlaIdrResponseInDays],
		a.[LibertyPowersSlaFollowUpIdrResponseInDays],
		a.[IsLoaRequired],
		a.[RequestCostAccount],
		a.[Inactive],
		a.[CreatedBy],
		a.[CreatedDate],
		a.[LastModifiedBy],
		a.[LastModifiedDate],
		b.[Id],
		b.[UtilityCompanyId],
		b.[RequestModeEnrollmentTypeId],
		b.[RequestModeTypeId],
		b.[AddressForPreEnrollment],
		b.[EmailTemplate],
		b.[Instructions],
		b.[UtilitysSlaIdrResponseInDays],
		b.[LibertyPowersSlaFollowUpIdrResponseInDays],
		b.[IsLoaRequired],
		b.[RequestCostAccount],
		b.[Inactive],
		b.[CreatedBy],
		b.[CreatedDate],
		b.[LastModifiedBy],
		b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END
GO










CREATE TRIGGER [dbo].[zAuditPurchaseOfReceivablesInsert]
	ON  [dbo].[PurchaseOfReceivables]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT;
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	PRINT @ChangeTrackingCurrentVersion 

	INSERT INTO [dbo].[zAuditPurchaseOfReceivables]
	(
		[Id]
       ,[UtilityCompanyId]
       ,[PorDriverId]
       ,[RateClassId]
       ,[LoadProfileId]
       ,[TariffCodeId]
       ,[IsPorOffered]
       ,[IsPorParticipated]
       ,[PorRecourseId]
       ,[IsPorAssurance]
       ,[PorDiscountRate]
       ,[PorFlatFee]
       ,[PorDiscountEffectiveDate]
       ,[PorDiscountExpirationDate]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
       ,[IdPrevious]
       ,[UtilityCompanyIdPrevious]
       ,[PorDriverIdPrevious]
       ,[RateClassIdPrevious]
       ,[LoadProfileIdPrevious]
       ,[TariffCodeIdPrevious]
       ,[IsPorOfferedPrevious]
       ,[IsPorParticipatedPrevious]
       ,[PorRecourseIdPrevious]
       ,[IsPorAssurancePrevious]
       ,[PorDiscountRatePrevious]
       ,[PorFlatFeePrevious]
       ,[PorDiscountEffectiveDatePrevious]
       ,[PorDiscountExpirationDatePrevious]
       ,[InactivePrevious]
       ,[CreatedByPrevious]
       ,[CreatedDatePrevious]
       ,[LastModifiedByPrevious]
       ,[LastModifiedDatePrevious]
       ,[SYS_CHANGE_VERSION]
       ,[SYS_CHANGE_CREATION_VERSION]
       ,[SYS_CHANGE_OPERATION]
       ,[SYS_CHANGE_COLUMNS]
	)
	SELECT 
		[Id]
       ,[UtilityCompanyId]
       ,[PorDriverId]
       ,[RateClassId]
       ,[LoadProfileId]
       ,[TariffCodeId]
       ,[IsPorOffered]
       ,[IsPorParticipated]
       ,[PorRecourseId]
       ,[IsPorAssurance]
       ,[PorDiscountRate]
       ,[PorFlatFee]
       ,[PorDiscountEffectiveDate]
       ,[PorDiscountExpirationDate]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCurrentVersion
		,'I'
		,'Id,UtilityCompanyId,PorDriverId,RateClassId,LoadProfileId,TariffCodeId,IsPorOffered,IsPorParticipated,PorRecourceId,IsPorAssurance,PorDiscountRate,PorFlatFee,PorDiscountEffectiveDate,PorDiscountExpirationDate,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
	FROM 
		inserted

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()
		
	SET NOCOUNT OFF;
END
GO



CREATE TRIGGER [dbo].[zAuditPurchaseOfReceivablesUpdate]
	ON [dbo].[PurchaseOfReceivables]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)
			
	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()
	
	SELECT 
		@ChangeTrackingCreationVersion = MIN(ZARMHU.[SYS_CHANGE_CREATION_VERSION]) 
	FROM 
		dbo.zAuditPurchaseOfReceivables (NOLOCK) ZARMHU 
		INNER JOIN inserted a
			ON ZARMHU.Id = a.Id
	set @SysChangeColumns = ''
	SELECT
		@SysChangeColumns = CASE WHEN isnull(a.[Id],'') <> isnull(b.[Id],'') THEN 'Id' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[UtilityCompanyId],'') <> isnull(b.[UtilityCompanyId],'') THEN 'UtilityCompanyId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDriverId],'') <> isnull(b.[PorDriverId],'') THEN 'PorDriverId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[RateClassId],'') <> isnull(b.[RateClassId],'') THEN 'RateClassId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LoadProfileId],'') <> isnull(b.[LoadProfileId],'') THEN 'LoadProfileId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[TariffCodeId],'') <> isnull(b.[TariffCodeId],'') THEN 'TariffCodeId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsPorOffered],'') <> isnull(b.[IsPorOffered],'') THEN 'IsPorOffered' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsPorParticipated],'') <> isnull(b.[IsPorParticipated],'') THEN 'IsPorParticipated' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorRecourseId],'') <> isnull(b.[PorRecourseId],'') THEN 'PorRecourseId' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[IsPorAssurance],'') <> isnull(b.[IsPorAssurance],'') THEN 'IsPorAssurance' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDiscountRate],'') <> isnull(b.[PorDiscountRate],'') THEN 'PorDiscountRate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorFlatFee],'') <> isnull(b.[PorFlatFee],'') THEN 'PorFlatFee' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDiscountEffectiveDate],'') <> isnull(b.[PorDiscountEffectiveDate],'') THEN 'PorDiscountEffectiveDate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[PorDiscountExpirationDate],'') <> isnull(b.[PorDiscountExpirationDate],'') THEN 'PorDiscountExpirationDate' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[Inactive],0) <> isnull(b.[Inactive],0) THEN 'Inactive' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[CreatedBy],'') <> isnull(b.[CreatedBy],'') THEN 'CreatedBy' + ',' ELSE '' END
		+ CASE WHEN isnull(a.[LastModifiedBy],'') <> isnull(b.[LastModifiedBy],'') THEN 'LastModifiedBy' + ',' ELSE '' END
		+ 'LastModifiedDate'
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [dbo].[zAuditPurchaseOfReceivables]
           ([Id]
           ,[UtilityCompanyId]
           ,[PorDriverId]
           ,[RateClassId]
           ,[LoadProfileId]
           ,[TariffCodeId]
           ,[IsPorOffered]
           ,[IsPorParticipated]
           ,[PorRecourseId]
           ,[IsPorAssurance]
           ,[PorDiscountRate]
           ,[PorFlatFee]
           ,[PorDiscountEffectiveDate]
           ,[PorDiscountExpirationDate]
           ,[Inactive]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[LastModifiedBy]
           ,[LastModifiedDate]
           ,[IdPrevious]
           ,[UtilityCompanyIdPrevious]
           ,[PorDriverIdPrevious]
           ,[RateClassIdPrevious]
           ,[LoadProfileIdPrevious]
           ,[TariffCodeIdPrevious]
           ,[IsPorOfferedPrevious]
           ,[IsPorParticipatedPrevious]
           ,[PorRecourseIdPrevious]
           ,[IsPorAssurancePrevious]
           ,[PorDiscountRatePrevious]
           ,[PorFlatFeePrevious]
           ,[PorDiscountEffectiveDatePrevious]
           ,[PorDiscountExpirationDatePrevious]
           ,[InactivePrevious]
           ,[CreatedByPrevious]
           ,[CreatedDatePrevious]
           ,[LastModifiedByPrevious]
           ,[LastModifiedDatePrevious]
           ,[SYS_CHANGE_VERSION]
           ,[SYS_CHANGE_CREATION_VERSION]
           ,[SYS_CHANGE_OPERATION]
           ,[SYS_CHANGE_COLUMNS])
	SELECT 
		a.[Id]
		,a.[UtilityCompanyId]
		,a.[PorDriverId]
		,a.[RateClassId]
		,a.[LoadProfileId]
		,a.[TariffCodeId]
		,a.[IsPorOffered]
		,a.[IsPorParticipated]
		,a.[PorRecourseId]
		,a.[IsPorAssurance]
		,a.[PorDiscountRate]
		,a.[PorFlatFee]
		,a.[PorDiscountEffectiveDate]
		,a.[PorDiscountExpirationDate]
		,a.[Inactive]
		,a.[CreatedBy]
		,a.[CreatedDate]
		,a.[LastModifiedBy]
		,a.[LastModifiedDate]
		,b.[Id]
		,b.[UtilityCompanyId]
		,b.[PorDriverId]
		,b.[RateClassId]
		,b.[LoadProfileId]
		,b.[TariffCodeId]
		,b.[IsPorOffered]
		,b.[IsPorParticipated]
		,b.[PorRecourseId]
		,b.[IsPorAssurance]
		,b.[PorDiscountRate]
		,b.[PorFlatFee]
		,b.[PorDiscountEffectiveDate]
		,b.[PorDiscountExpirationDate]
		,b.[Inactive]
		,b.[CreatedBy]
		,b.[CreatedDate]
		,b.[LastModifiedBy]
		,b.[LastModifiedDate]
		,@ChangeTrackingCurrentVersion
		,@ChangeTrackingCreationVersion
		,'U'
		,@SysChangeColumns	
	FROM 
		inserted a
		INNER JOIN deleted b
			on b.[Id] = a.[Id]

	INSERT INTO [ChangeTableVersioning]
	(
		Id,
		ChangeTrackingVersion,
		CreatedDate
	)
	SELECT
		NEWID(),
		@ChangeTrackingCurrentVersion,
		GETDATE()

	SET NOCOUNT OFF;
END


GO









-------------------------------- CREATE TRIGGERS END -------------------------------------








-------------------------------- CREATE CHANGE TRACKING BEGIN -------------------------------------




ALTER DATABASE [Lp_UtilityManagement] SET ALLOW_SNAPSHOT_ISOLATION ON

ALTER DATABASE [Lp_UtilityManagement]
SET CHANGE_TRACKING = ON
(CHANGE_RETENTION = 30 DAYS, AUTO_CLEANUP = ON)

ALTER TABLE [Lp_UtilityManagement].dbo.RequestModeEnrollmentType
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RequestModeHistoricalUsage
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RequestModeIcap
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RequestModeType
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RequestModeTypeGenre
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RequestModeTypeToRequestModeEnrollmentType
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RequestModeTypeToRequestModeTypeGenre
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.UserInterfaceControlAndValueGoverningControlVisibility
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.UserInterfaceControlVisibility
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.UserInterfaceForm
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.UserInterfaceFormControl
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.UtilityCompany
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.UtilityCompanyToUtilityLegacy
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.UtilityLegacy
ENABLE CHANGE_TRACKING


ALTER TABLE [Lp_UtilityManagement].dbo.AccountType
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.LoadProfile
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.MeterType
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RateClass
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RequestModeIdr
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.ServiceClass
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.TariffCode
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.RateClassAlias
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.LpStandardRateClass
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.LoadProfileAlias
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.LpStandardLoadProfile
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.TariffCodeAlias
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.LpStandardTariffCode
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.PorDriver
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.PorRecourse
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.PurchaseOfReceivables
ENABLE CHANGE_TRACKING
ALTER TABLE [Lp_UtilityManagement].dbo.IdrRule
ENABLE CHANGE_TRACKING

-------------------------------- CREATE CHANGE TRACKING END -------------------------------------






-------------------------------- INSERT INITIALIZATION DATA BEGIN -------------------------------------

SET IDENTITY_INSERT [dbo].[TriStateValue] ON
GO
INSERT INTO [dbo].[TriStateValue] ([Id],[Value],[NumericValue],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate]) VALUES ('29BB8246-7723-469E-B85B-31E5680F1FA9', 'Yes',1,'Yes',0,'Database Initialization','2013-07-15 17:04:10.557','Database Initialization','2013-07-15 17:04:10.557')
INSERT INTO [dbo].[TriStateValue] ([Id],[Value],[NumericValue],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate]) VALUES ('94B3DBE6-8CDF-4CD3-9250-0944011696CA', 'No',2,'No',0,'Database Initialization','2013-07-15 17:04:10.557','Database Initialization','2013-07-15 17:04:10.557')
INSERT INTO [dbo].[TriStateValue] ([Id],[Value],[NumericValue],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate]) VALUES ('A38CF7A8-F247-414D-B2EC-40878EF696F5', 'NA',0,'Not Applicable',0,'Database Initialization','2013-07-15 17:04:10.557','Database Initialization','2013-07-15 17:04:10.557')
GO

SET IDENTITY_INSERT [dbo].[TriStateValue] OFF
GO


SET IDENTITY_INSERT [dbo].[UtilityLegacy] ON
GO


---------------------------------------- RequestModeEnrollmentType BEGIN ---------------------------------------------------------


INSERT INTO [dbo].[RequestModeEnrollmentType]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('65325E2F-6FC4-4DB1-A1B7-28BBB1A606B9', 'Post Enrollment', 'Post Enrollment', 0, 'DatabaseInitialization', GETDATE(), 'DatabaseInitialization', GETDATE())

INSERT INTO [dbo].[RequestModeEnrollmentType]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('390712C2-AAF9-4B96-96B8-CD12FA33EEF1', 'Pre Enrollment', 'Pre Enrollment', 0, 'DatabaseInitialization', GETDATE(), 'DatabaseInitialization', GETDATE())
GO

---------------------------------------- RequestModeEnrollmentType END ---------------------------------------------------------


---------------------------------------- RequestModeType BEGIN ---------------------------------------------------------

INSERT INTO dbo.[RequestModeType]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('896B99A5-14CF-4328-BE35-0AE82F527B06','Website','Website', 0, 'DatabaseInitialization', GETDATE(), 'DatabaseInitialization', GETDATE())

INSERT INTO dbo.[RequestModeType]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('5B86DCBA-609D-4C6C-95C7-490F37D5CB61','E-mail','E-mail', 0, 'DatabaseInitialization', GETDATE(), 'DatabaseInitialization', GETDATE())

INSERT INTO dbo.[RequestModeType]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('E12C33F0-A9F9-494B-93A1-83E3B0B290A0','EDI','EDI', 0, 'DatabaseInitialization', GETDATE(), 'DatabaseInitialization', GETDATE())

INSERT INTO dbo.[RequestModeType]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('AAF52588-03FA-46B6-9C40-B338B7BA91EA','Scraper','Scraper', 0, 'DatabaseInitialization', GETDATE(), 'DatabaseInitialization', GETDATE())
GO

---------------------------------------- RequestModeType END ---------------------------------------------------------


---------------------------------------- RequestModeTypeGenre BEGIN ---------------------------------------------------------

INSERT INTO [dbo].[RequestModeTypeGenre]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('22382487-0BDE-4497-9190-7438E24C3D96','Historical Usage','Historical Usage',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeGenre]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('A60C3C98-CD13-4E0F-BC05-9943728E833B','Interval Data Recorder','Interval Data Recorder',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeGenre]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('BEE790A3-6A90-4A81-B6ED-B4A99310EFDE','Account Information','Account Information',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())
GO

INSERT INTO [dbo].[RequestModeTypeGenre]
([Id],[Name],[Description],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('F3DC8CF9-FEE9-49A3-866E-1C7376627F3C','I-CAP','I-Cap',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())
GO

---------------------------------------- RequestModeTypeGenre END ---------------------------------------------------------


---------------------------------------- RequestModeTypeToRequestModeEnrollmentType BEGIN ---------------------------------------------------------

INSERT INTO [dbo].[RequestModeTypeToRequestModeEnrollmentType]
([Id],[RequestModeTypeId],[RequestModeEnrollmentTypeId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('8718F148-55D9-4A65-81B9-5782114324BC','896B99A5-14CF-4328-BE35-0AE82F527B06','390712C2-AAF9-4B96-96B8-CD12FA33EEF1',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeToRequestModeEnrollmentType]
([Id],[RequestModeTypeId],[RequestModeEnrollmentTypeId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('192D8B44-38A8-47FB-9710-59F44FB627E9','5B86DCBA-609D-4C6C-95C7-490F37D5CB61','390712C2-AAF9-4B96-96B8-CD12FA33EEF1',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeToRequestModeEnrollmentType]
([Id],[RequestModeTypeId],[RequestModeEnrollmentTypeId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('E66DA6B6-957E-43A5-8B0A-9C98B34617C1','E12C33F0-A9F9-494B-93A1-83E3B0B290A0','65325E2F-6FC4-4DB1-A1B7-28BBB1A606B9',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeToRequestModeEnrollmentType]
([Id],[RequestModeTypeId],[RequestModeEnrollmentTypeId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('12104647-8E97-47E4-BC82-A3CB0A9B6CFC','E12C33F0-A9F9-494B-93A1-83E3B0B290A0','390712C2-AAF9-4B96-96B8-CD12FA33EEF1',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeToRequestModeEnrollmentType]
([Id],[RequestModeTypeId],[RequestModeEnrollmentTypeId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('403E00FC-3A3B-4395-8F18-AECE176994F2','AAF52588-03FA-46B6-9C40-B338B7BA91EA','65325E2F-6FC4-4DB1-A1B7-28BBB1A606B9',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeToRequestModeEnrollmentType]
([Id],[RequestModeTypeId],[RequestModeEnrollmentTypeId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('F859D8AA-6C2B-4E25-9D38-E650D20937FE','AAF52588-03FA-46B6-9C40-B338B7BA91EA','390712C2-AAF9-4B96-96B8-CD12FA33EEF1',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())
GO

---------------------------------------- RequestModeTypeToRequestModeEnrollmentType END ---------------------------------------------------------


---------------------------------------- RequestModeTypeToRequestModeTypeGenre BEGIN ---------------------------------------------------------

INSERT INTO [dbo].[RequestModeTypeToRequestModeTypeGenre] ([Id],[RequestModeTypeId],[RequestModeTypeGenreId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES ('097BCE57-627F-4CF7-8D36-BEC7C1B344AA','E12C33F0-A9F9-494B-93A1-83E3B0B290A0','22382487-0BDE-4497-9190-7438E24C3D96',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeToRequestModeTypeGenre] ([Id],[RequestModeTypeId],[RequestModeTypeGenreId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES ('737BB5A5-971A-4B3E-A1AD-CDC634D6CAC1','5B86DCBA-609D-4C6C-95C7-490F37D5CB61','22382487-0BDE-4497-9190-7438E24C3D96',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeToRequestModeTypeGenre] ([Id],[RequestModeTypeId],[RequestModeTypeGenreId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES ('F01F80D6-9EE8-41F9-99DA-D67AD4ACD791','896B99A5-14CF-4328-BE35-0AE82F527B06','22382487-0BDE-4497-9190-7438E24C3D96',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[RequestModeTypeToRequestModeTypeGenre] ([Id],[RequestModeTypeId],[RequestModeTypeGenreId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES ('5F8ADB2B-6042-4E4F-AA13-F0861F1A2739','AAF52588-03FA-46B6-9C40-B338B7BA91EA','22382487-0BDE-4497-9190-7438E24C3D96',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())
GO

---------------------------------------- RequestModeTypeToRequestModeTypeGenre END ---------------------------------------------------------




---------------------------------------- UserInterfaceForm BEGIN ---------------------------------------------------------

INSERT INTO [dbo].[UserInterfaceForm]
([Id],[UserInterfaceFormName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','Historical Usage Request Mode',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())
GO
INSERT INTO [dbo].[UserInterfaceForm]
([Id],[UserInterfaceFormName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('51E8078D-7A78-452B-AF3F-B9EC7B8654A7','Icap Request Mode',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())
GO
INSERT INTO [dbo].[UserInterfaceForm]
([Id],[UserInterfaceFormName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('217482B7-3686-4D21-9812-F56B9B4ADAB2','Idr Request Mode',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())
GO
---------------------------------------- UserInterfaceForm END ---------------------------------------------------------




---------------------------------------- UserInterfaceFormControl BEGIN ---------------------------------------------------------

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('30F9EE78-F192-4720-B06B-3AE4C583D537','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','RequestModeTypeId',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('279AF832-D183-4826-BE87-5BC506C87E79','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','divAddressLabel',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('3A08A857-9B31-4EEB-B653-6DFFA7B274EF','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','divAddressField',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('8310DC1A-134F-4027-AF00-9B6A543D2089','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','divEmailTemplateText',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('46377E4C-7072-4D6E-B45A-B271760A0C5E','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','divEmailTemplateLabel',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())


INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('99DCDBB1-AB62-4889-9BD6-4B33A6A80C39','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','RequestModeTypeId',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('38BF9399-C4DC-4000-A932-39DC245AE076','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','divAddressField',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('FABEDF9B-FBB5-4981-800C-9007D1182C62','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','divAddressLabel',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('3ADCF02E-712D-4B10-8AF8-A3EDB6D42C1B','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','divEmailTemplateText',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('6E3DFC9C-FC1A-401C-AADE-EDD616E7EC74','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','divEmailTemplateLabel',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())



INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('C91B8C62-6A5A-49E1-A588-7E9FA5ED7FFF','217482B7-3686-4D21-9812-F56B9B4ADAB2','divAddressField',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('6B44E4D7-5563-4AC1-A445-D7209F8459A3','217482B7-3686-4D21-9812-F56B9B4ADAB2','divAddressLabel',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('4F04E0B9-79DF-49CD-BD67-DA0EB927E8EA','217482B7-3686-4D21-9812-F56B9B4ADAB2','RequestModeTypeId',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('45DEB42B-4A92-4349-BF42-F48EDC81952D','217482B7-3686-4D21-9812-F56B9B4ADAB2','divEmailTemplateLabel',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceFormControl]
([Id],[UserInterfaceFormId],[ControlName],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('ACC26C0E-B98E-427B-B619-164801C17016','217482B7-3686-4D21-9812-F56B9B4ADAB2','divEmailTemplateText',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

GO
---------------------------------------- UserInterfaceFormControl END ---------------------------------------------------------




---------------------------------------- UserInterfaceControlAndValueGoverningControlVisibility BEGIN ---------------------------------------------------------

INSERT INTO [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]
([Id],[UserInterfaceFormId],[UserInterfaceFormControlGoverningVisibilityId],[ControlValueGoverningVisibiltiy],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('7708CB63-C5E8-4EA4-8BAD-2AA0A237DC5D','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','30F9EE78-F192-4720-B06B-3AE4C583D537','website',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]
([Id],[UserInterfaceFormId],[UserInterfaceFormControlGoverningVisibilityId],[ControlValueGoverningVisibiltiy],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('7FEEA046-219F-4604-BF0F-D48D2320F47C','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','30F9EE78-F192-4720-B06B-3AE4C583D537','e-mail',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())



INSERT INTO [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]
([Id],[UserInterfaceFormId],[UserInterfaceFormControlGoverningVisibilityId],[ControlValueGoverningVisibiltiy],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('A368572A-3DBE-4146-A424-AAA602A3145A','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','99DCDBB1-AB62-4889-9BD6-4B33A6A80C39','website',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]
([Id],[UserInterfaceFormId],[UserInterfaceFormControlGoverningVisibilityId],[ControlValueGoverningVisibiltiy],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('E0F35E7A-220F-4F54-AE8B-BF2110602F35','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','99DCDBB1-AB62-4889-9BD6-4B33A6A80C39','e-mail',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())



INSERT INTO [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]
([Id],[UserInterfaceFormId],[UserInterfaceFormControlGoverningVisibilityId],[ControlValueGoverningVisibiltiy],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('9FE285BF-9ABD-4836-A799-B1B86AC2AE95','217482B7-3686-4D21-9812-F56B9B4ADAB2','4F04E0B9-79DF-49CD-BD67-DA0EB927E8EA','website',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())

INSERT INTO [dbo].[UserInterfaceControlAndValueGoverningControlVisibility]
([Id],[UserInterfaceFormId],[UserInterfaceFormControlGoverningVisibilityId],[ControlValueGoverningVisibiltiy],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])
VALUES
('6A395993-C693-4138-921D-E99626FA55BB','217482B7-3686-4D21-9812-F56B9B4ADAB2','4F04E0B9-79DF-49CD-BD67-DA0EB927E8EA','e-mail',0,'DatabaseInitialization',GETDATE(),'DatabaseInitialization',GETDATE())
GO
---------------------------------------- UserInterfaceControlAndValueGoverningControlVisibility END ---------------------------------------------------------




---------------------------------------- UserInterfaceControlVisibility BEGIN ---------------------------------------------------------
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('7BF09CEF-F2CC-4D1A-B85C-203FE1DF9672','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','6E3DFC9C-FC1A-401C-AADE-EDD616E7EC74','E0F35E7A-220F-4F54-AE8B-BF2110602F35',0,'DevTestOne','06/24/2013','DevTestOne','06/24/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('9F821EA1-F45D-4D2E-BA68-22A1C53B2F4B','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','FABEDF9B-FBB5-4981-800C-9007D1182C62','A368572A-3DBE-4146-A424-AAA602A3145A',0,'DevTestOne','06/24/2013','DevTestOne','06/24/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('D9215C05-BA3B-4460-AADA-AFF66F45781F','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','FABEDF9B-FBB5-4981-800C-9007D1182C62','E0F35E7A-220F-4F54-AE8B-BF2110602F35',0,'DevTestOne','06/24/2013','DevTestOne','06/24/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('4FED3A57-B648-474C-89E1-B505CDC9135B','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','38BF9399-C4DC-4000-A932-39DC245AE076','A368572A-3DBE-4146-A424-AAA602A3145A',0,'DevTestOne','06/24/2013','DevTestOne','06/24/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('C05BCA70-40D1-4C10-8699-C54D334D7C15','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','3ADCF02E-712D-4B10-8AF8-A3EDB6D42C1B','E0F35E7A-220F-4F54-AE8B-BF2110602F35',0,'DevTestOne','06/24/2013','DevTestOne','06/24/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('836B111F-8CFE-4576-A01B-EACF77D5026A','51E8078D-7A78-452B-AF3F-B9EC7B8654A7','38BF9399-C4DC-4000-A932-39DC245AE076','E0F35E7A-220F-4F54-AE8B-BF2110602F35',0,'DevTestOne','06/24/2013','DevTestOne','06/24/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('DFBD2422-8442-4CC5-B9D2-A386071C28B9','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','46377E4C-7072-4D6E-B45A-B271760A0C5E','7FEEA046-219F-4604-BF0F-D48D2320F47C',0,'DevTestOne','06/12/2013','DevTestOne','06/12/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('F2B0FFF1-118E-4EC1-94FD-A91A49D2700E','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','3A08A857-9B31-4EEB-B653-6DFFA7B274EF','7FEEA046-219F-4604-BF0F-D48D2320F47C',0,'DevTestOne','06/12/2013','DevTestOne','06/12/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('E489EF12-D726-455C-BBF7-E38B7D929CF8','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','8310DC1A-134F-4027-AF00-9B6A543D2089','7FEEA046-219F-4604-BF0F-D48D2320F47C',0,'DevTestOne','06/12/2013','DevTestOne','06/12/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('65C3D51A-3274-425C-97D0-2E1D17967454','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','279AF832-D183-4826-BE87-5BC506C87E79','7708CB63-C5E8-4EA4-8BAD-2AA0A237DC5D',0,'DevTestOne','06/12/2013','DevTestOne','06/13/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('C7A9AC2D-C889-4540-860E-87AC62AAF098','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','279AF832-D183-4826-BE87-5BC506C87E79','7FEEA046-219F-4604-BF0F-D48D2320F47C',0,'DevTestOne','06/12/2013','DevTestOne','06/12/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('959FAABF-571C-4FEC-BC59-8F76C5E822FF','DFB34014-7C5D-4A5E-9C0C-CB4045E4D44D','3A08A857-9B31-4EEB-B653-6DFFA7B274EF','7708CB63-C5E8-4EA4-8BAD-2AA0A237DC5D',0,'DevTestOne','06/12/2013','DevTestOne','06/12/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('98109CCC-FE70-4547-9B29-946FB9F7B27A','217482B7-3686-4D21-9812-F56B9B4ADAB2','45DEB42B-4A92-4349-BF42-F48EDC81952D','6A395993-C693-4138-921D-E99626FA55BB',0,'User','07/09/2013','User','07/09/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('59796E4E-83A2-49FA-A73E-A136E16A53F9','217482B7-3686-4D21-9812-F56B9B4ADAB2','ACC26C0E-B98E-427B-B619-164801C17016','6A395993-C693-4138-921D-E99626FA55BB',0,'User','07/09/2013','User','07/09/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('C5481211-156F-465F-8B43-3EE3514B68ED','217482B7-3686-4D21-9812-F56B9B4ADAB2','6B44E4D7-5563-4AC1-A445-D7209F8459A3','6A395993-C693-4138-921D-E99626FA55BB',0,'User','07/09/2013','User','07/09/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('791AFC5C-6564-4EC8-B7A1-618D0D1B81D2','217482B7-3686-4D21-9812-F56B9B4ADAB2','C91B8C62-6A5A-49E1-A588-7E9FA5ED7FFF','6A395993-C693-4138-921D-E99626FA55BB',0,'User','07/09/2013','User','07/09/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('E00FC2BD-24FC-4559-AE2D-2DBD36188B8C','217482B7-3686-4D21-9812-F56B9B4ADAB2','C91B8C62-6A5A-49E1-A588-7E9FA5ED7FFF','9FE285BF-9ABD-4836-A799-B1B86AC2AE95',0,'User','07/09/2013','User','07/09/2013')
INSERT INTO [dbo].[UserInterfaceControlVisibility]([Id],[UserInterfaceFormId],[UserInterfaceFormControlId],[UserInterfaceControlAndValueGoverningControlVisibilityId],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('49E9F898-C057-4273-9183-1CCE7A71349E','217482B7-3686-4D21-9812-F56B9B4ADAB2','6B44E4D7-5563-4AC1-A445-D7209F8459A3','9FE285BF-9ABD-4836-A799-B1B86AC2AE95',0,'User','07/09/2013','User','07/09/2013')
GO
---------------------------------------- UserInterfaceControlVisibility END ---------------------------------------------------------



INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('EBBD1446-B9B5-416C-9270-059E21CB1936','DUKE',0,'Script','Jun 17 2013  5:04PM','DevTestOne','Jun 21 2013  3:36PM') 
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('F631473B-491E-4BD6-B73D-0AB204CC8ED8','NANT',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('2DF05B0B-C553-45EF-872A-0AEFE9D0104B','UGI',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('9BBE244F-3154-492D-B898-0B10EE5BF928','NYSEG',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('739EC3E7-B3D9-42DE-87D1-0FC04C3335BC','b7051d89-5ec9-4',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('72C4F915-5A69-4BE3-BF96-1965653E4B8A','PPL',0,'DevTestTwo','Jun 17 2013  3:32PM','DevTestTwo','Jun 17 2013  3:33PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('3BA9F09B-972B-4C10-8435-1BAA0989C042','AMEREN',0,'Script','Jun 17 2013  5:04PM','DevTestTwo','Jun 25 2013 10:48AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('E04C8C49-3245-4E4D-A01B-1C95E8BC1DB1','CENHUD',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('5EAD28FF-99D6-4417-9903-1E259BBF773F','DELMD',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('BD2A0627-0DD9-4446-BE8A-2A785AD2A6B8','NSTAR-COMM',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('81264AB3-234C-42E2-BFE0-2CA1E9CB81EB','Test Utility 3',0,'lptest','Jun 25 2013 11:11AM','lptest','Jun 25 2013 11:11AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('BC2C087E-3D1C-488A-8A85-2E0131FF1BA7','PEPCO-MD',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('F4EF320D-7671-491D-8F97-352282AC1608','207936ea-a2a1-4',0,'Script','Jun 17 2013  5:04PM','DevTestThree','Jun 21 2013 11:41AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('8CB866AF-8354-40AA-8168-3A083A491D12','SCE',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('BDD8C927-EE46-4640-8813-3D6D15DC3FA6','DUQ',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('450CCAA1-BFBB-44A1-9D74-3F12744FCCF3','Emerson',0,'DevTestOne','Jun 10 2013  4:22PM','DevTestTwo','Jun 25 2013 10:42AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('17354A6D-10D4-416F-8CBB-3FFE07A34A45','CTPEN',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('9C5951A3-6EE6-4D59-B0CA-40F4EED134FF','BGE',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('188C8A0C-EA68-4177-90FD-426F2DB3A4D1','AEPCE',0,'DevTestOne','Jun 14 2013 11:05AM','DevTestOne','Jun 14 2013 12:13PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('2CE67548-A7F6-4668-A970-45579BBE5CDE','Test Utility Company 1',0,'DevTestTwo','Jun 25 2013 10:48AM','DevTestTwo','Jun 25 2013 10:48AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('51E753B7-4FA1-4DFD-BC94-4AFBEAD684E9','SHARYLAND',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('5EA7302D-408D-4898-B01B-4C569A86179E','CEI',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('EC13801E-55AE-4C73-81A5-4E9F67B9AB3B','A to Z',0,'DevTestThree','Jun 21 2013 10:13AM','DevTestThree','Jun 21 2013 10:29AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('B5752A99-D836-4E3F-AF1D-4F706A76B98A','CONED',0,'DevTestOne','Jun 13 2013  1:58PM','DevTestOne','Jun 14 2013 11:26AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('8646A836-1192-412B-B95A-50FCB99719DD','DAYTON',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('AA094633-2216-4501-A98B-53C2E40D67DF','MECO',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('BB9F6730-58B9-4AA3-98B6-54BB11387C71','FPL',0,'DevTestOne','Jun 10 2013  2:52PM','DevTestOne','Jun 14 2013 11:12AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('02534F34-D68E-4FE8-B202-5544745C6493','BANGOR',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('3B73777A-71A4-4D45-A3A3-584814A9E5AA','PSEG',0,'DevTestOne','Jun 13 2013  3:34PM','DevTestOne','Jun 14 2013 11:12AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('B8126F35-AE51-4BAD-9DF7-59091AEC3DDE','TXNMP',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('A7172E9A-5F63-4C83-8634-5A880435AE41','OHP',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('31840080-5E04-473C-A34C-5D579613D8D3','5065ed70-aac1-4',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('8E839BD7-F840-42BD-941B-5F7676F1243C','PENNPR',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('BDB41D87-19F5-4887-A55D-6208EF246806','OHED',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('04A37847-AF38-4EB7-8C43-6C5595B32336','ORNJ',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('6A71B8DC-FB67-47FD-9E72-6F0EF87B106E','PEPCO-DC',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('C5F85B90-44FC-4EF8-A976-714D940DA086','SDGE',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('C656C392-4FDD-4A36-84BA-7205D2890263','WMECO',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('4536F846-FBBC-431D-8068-7485679F786B','ROCKLAND',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('53164C93-71B7-4104-BBF5-778BBA364DE5','CL&P',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('E3D84C60-4DE7-4965-80B7-7A691EA22485','CSP',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('7F11CC94-5A53-44B8-9C6A-81D586822677','NSTAR-BOS',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('717B8795-C296-4AFD-AA4B-89D83C55C284','METED',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('44D86050-0962-4F7E-8A46-8F3B54A5FA87','CMP',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('35D4B486-FA2A-4295-BF5C-93ABF56C5BAE','RGE',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('3CEAD686-1436-4ABF-99E5-A7C072F4459F','Test One',0,'DevTestTwo','Jun 25 2013 10:42AM','DevTestTwo','Jun 25 2013 10:42AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('781B0811-20F9-4DEC-814F-AC6111353D4E','ALLEGMD',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('6D629430-E9FA-411F-8DAC-ADBFCFBED101','COMED',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('AB3AE938-DC26-4A96-9DAF-AE976C987485','8e86b611-607f-4',0,'Script','Jun 17 2013  5:04PM','NULL USER NAME','Jun 20 2013  4:34PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('A3C6B621-C361-4123-BB2C-B79F9484632D','O&R',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('D6FD610C-FFC7-41F2-8CE9-BDD9A4CDE55A','ONCOR-SESCO',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('0AE1BFCA-26CF-423A-9F7A-BF95E30516C6','ACE',0,'DevTestOne','Jun 13 2013  2:58PM','lptest','Jun 25 2013 11:10AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('F5DC416A-C6B3-4E5E-8139-BFC557BAD5DF','WPP',0,'Script','Jun 17 2013  5:04PM','DevTestThree','Jun 20 2013  2:24PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('CF1FDA97-9464-445D-8F8B-C23D0C4B7B9D','TXU-SESCO',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('E90DEE46-4355-4CDD-8756-C4151AFFCE49','4e08f050-9ccc-4',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('2032D6F6-411A-4DB1-BAC7-C57EE80B3678','TOLED',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('9239EEAD-74E3-4ADA-8BB4-CF4837E75368','UI',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('6B3ADBF4-EE09-4F59-9869-D118430D0243','ONCOR',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('08F30DDC-86C2-46D6-A880-D9571292FA92','PENELEC',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('318ECB2A-FFDB-49F3-B2EF-DD3F3AED9499','TXU',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('DCECE9E3-A9F8-40C2-9BDA-DF1B3D84B519','UNITIL',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('E91250D2-BF8C-4F65-BC60-DF8AC19A0562','&&&&',0,'lptest','Jun 26 2013  4:20AM','lptest','Jun 26 2013  4:22AM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('EAB6A123-8715-43FA-99A1-E1C5AF1DC99D','AEPNO',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('1D6A5BFA-09ED-401C-B3E2-E8BE8940A13E','NECO',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('DA779CCD-6632-402A-A4A6-E9D201E0B859','JCP&L',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('66F9FA9E-9C41-462B-ABFC-EB6D17B38B15','NIMO',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('50D6486E-7614-4D95-8BCE-ECB1AD45F65A','DELDE',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('1BBBEFC1-759D-49FA-8CBB-ECF2F4B8A7D3','a4d16f50-756e-4006-940d-9bfad111f4d1',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('B26EB9B3-313C-485B-B42F-F39FD2C7D5DE','NSTAR-CAMB',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('EE73DF43-1B48-446C-85D0-F61C99FAB9DA','PGE',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')
INSERT INTO [dbo].[UtilityCompany]([Id],[UtilityCode],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate])VALUES('1325DBDF-A286-4DEE-A7F8-FDA23C1500F5','PECO',0,'Script','Jun 17 2013  5:04PM','Script','Jun 17 2013  5:04PM')


---------------------------------------- UtilityLegacy BEGIN ---------------------------------------------------------


INSERT INTO [dbo].[UtilityLegacy] ([ID],[UtilityCode],[FullName],[ShortName],[MarketID],[DunsNumber],[EntityId],[EnrollmentLeadDays],[BillingType],[AccountLength],[AccountNumberPrefix],[LeadScreenProcess],[DealScreenProcess],[PorOption],[Field01Label],[Field01Type],[Field02Label],[Field02Type],[Field03Label],[Field03Type],[Field04Label],[Field04Type],[Field05Label],[Field05Type],[Field06Label],[Field06Type],[Field07Label],[Field07Type],[Field08Label],[Field08Type],[Field09Label],[Field09Type],[Field10Label],[Field10Type],[DateCreated],[UserName],[InactiveInd],[ActiveDate],[ChgStamp],[MeterNumberRequired],[MeterNumberLength],[AnnualUsageMin],[Qualifier],[EdiCapable],[WholeSaleMktID],[Phone],[RateCodeRequired],[HasZones],[ZoneDefault],[Field11Label],[Field11Type],[Field12Label],[Field12Type],[Field13Label],[Field13Type],[Field14Label],[Field14Type],[Field15Label],[Field15Type],[RateCodeFormat],[RateCodeFields],[LegacyName],[SSNIsRequired],[PricingModeID],[isIDR_EDI_Capable],[HU_RequestType],[MultipleMeters],[MeterReadOverlap],[AutoApproval])
VALUES
 (1,'AEPCE','AEP TEXAS CENTRAL (CORPUS CHRISTI AREA)','',1,'007924772','LPT',0,'SC',17,'1003278','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','VALUE','04/04/2006','LIBERTYPOWER\sclark','0','04/04/2006',0,0,0,0,'',0,'ERCOT','1-877-373-4858',0,1,11,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','AEP TEXAS CENTRAL COMPANY',1,2,0,'NONE',0,0,0)
,(2,'AEPNO','AEP TEXAS NORTH (ABILENE AREA)','',1,'007923311','LPT',0,'SC',17,'1020404','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','VALUE','04/04/2006','LIBERTYPOWER\sclark','0','04/04/2006',0,0,0,0,'',0,'ERCOT','1-877-373-4858',0,1,9,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','AEP TEXAS NORTH',1,2,0,'NONE',0,1,0)
,(3,'CTPEN','CENTERPOINT ENERGY (HOUSTON AREA)','',1,'957877905','LPT',0,'SC',22,'1008901','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','VALUE','04/04/2006','LIBERTYPOWER\sclark','0','04/04/2006',0,0,0,0,'',0,'ERCOT','1-800-332-7143',0,1,71,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','CENTERPOINT ENERGY HOUSTON ELECTRIC LLC',1,2,0,'NONE',0,1,0)
,(4,'TXNMP','TNMP (TEXAS NEW MEXICO POWER AREA)','',1,'007929441','LPT',0,'SC',17,'10400','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','08/29/2006','LIBERTYPOWER\sclark','0','08/29/2006',0,0,0,0,'',0,'ERCOT','1-888-866-7456',0,1,72,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','TXNMP (TEXAS NEW MEXICO POWER)',1,2,0,'NONE',0,1,0)
,(5,'ONCOR','ONCOR ELECTRIC DELIVERY','',1,'1039940674000','LPT',0,'SC',17,'10','NONE','CREDIT CHECK','NO','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','10/02/2009','LIBERTYPOWER\sclark','0','10/02/2009',0,0,0,0,'',0,'ERCOT','1-888-313-4747',0,1,79,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','ONCOR ELECTRIC DELIVERY',1,2,0,'NONE',0,1,0)
,(8,'TXU-SESCO','ONCOR ELECTRIC DELIVERY (SESCO)','',1,'1039940674000','LPT',0,'SC',17,'1017699000','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','09/06/2007','LIBERTYPOWER\sclark','0','09/06/2007',0,0,0,0,'',0,'ERCOT','1-888-313-6862/1-800-242-9113',0,0,70,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','TXU-SESCO ( TXU ELECTRIC DELIVERY SESCO)',1,3,0,'NONE',0,0,0)
,(9,'ACE','ACE (ATLANTIC CITY ELECTRIC)','ACE (ATLANTIC CITY ELECTRIC)',9,'006971618NJ','LPH-P',21,'BR',12,'','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','05/08/2007','libertypower\mbarrant','0','05/08/2007',2,0,0,0,'',1,'PJM','1-800-833-7476',0,0,20,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','ACE (ATLANTIC CITY ELECTRIC)',1,2,0,'EDI',0,0,1)
,(10,'ALLEGMD','POTOMAC EDISON (ALLEGHENY POWER)','POTOMAC EDISON (ALLEGHENY POWER)',10,'043381565EDC','LPH-MD',13,'DUAL',20,'','NONE','CREDIT CHECK','NO','','NONE','','NONE','','NONE','NONE','NONE','','NONE','NONE','NONE','','NONE','','NONE','','NONE','NONE','NONE','10/24/2006','LIBERTYPOWER\atafur','0','10/24/2006',0,0,0,0,'',1,'PJM','1-800-686-0011',0,0,17,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','ALLEGMD (ALLEGHENY POWER)',1,3,0,'EDI',0,1,0)
,(11,'AMEREN','AMEREN ELECTRIC','AMEREN ELECTRIC',13,'006936017','LPH',12,'BR',10,'','NONE','CREDIT CHECK','YES','','NONE','','NONE','','NONE','NONE','NONE','','NONE','NONE','NONE','','NONE','','NONE','','NONE','NONE','NONE','10/30/2007','libertypower\mbarrant','0','10/30/2007',6,0,8,15000,'',1,'MISO','800-755-5000',0,1,21,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','AMEREN ELECTRIC',1,3,0,'NONE',1,1,0)
,(12,'BANGOR','BANGOR-HYD (BANGOR HYDRO ELECTRIC CO.)','BANGOR-HYD (BANGOR HYDRO ELECTRIC CO.)',5,'006949002','LPHME          ',2,'DUAL',16,'0','NONE','CREDIT CHECK','NO','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','08/07/2008','LIBERTYPOWER\dmarino','0','08/07/2008',0,0,0,0,'',1,'NEISO','1-800-440-1111',0,0,22,'NONE','NONE','NONE','NONE','SIC','NONE','Accuracy %','NONE','NONE','NONE','0','0','BANGOR-HYD (BANGOR HYDRO ELECTRIC CO.)',1,2,0,'EDI',1,1,0)
,(13,'BGE','BGE (BALTIMORE GAS AND ELECTRIC)','BGE (BALTIMORE GAS AND ELECTRIC)',10,'156171464','LPMD',12,'BR',10,'','NONE','CREDIT CHECK','YES','','','','','','','','VALUE','','','','NONE','','','','','','','','VALUE','04/03/2006','libertypower\mbarrant','0','04/03/2006',8,0,0,0,'',1,'PJM','1-877-778-2222',0,0,23,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','BGE (BALTIMORE GAS AND ELECTRIC)',1,3,0,'NONE',0,1,1)
,(14,'CENHUD','CENHUD (CENTRAL HUDSON)','',7,'006993695','LPH',15,'RR',10,'','NONE','CREDIT CHECK','NO','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','10/24/2006','LIBERTYPOWER\atafur','0','10/24/2006',0,0,0,0,'',1,'NYISO','1-800 527-2714',0,1,19,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','2','1','CENHUD (CENTRAL HUDSON)',1,3,0,'EDI',0,1,0)
,(15,'CL&P','CL&P (CONNECTICUT LIGHT AND POWER)','CL&P (CONNECTICUT LIGHT AND POWER)',3,'006917090','LPH',2,'RR',9,'','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','10/17/2007','LIBERTYPOWER\gmangaroo','0','10/17/2007',1,0,0,0,'',1,'NEISO','1-800-286-2000',1,0,29,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','4','1','CL&P (CONNECTICUT LIGHT AND POWER)',1,3,0,'EDI',1,1,1)
,(16,'CMP','CMP (CENTRAL MAINE POWER)','CMP (CENTRAL MAINE POWER)',5,'006948954','LPHME2',3,'DUAL',14,'0','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','05/28/2008','libertypower\mbarrant','0','05/28/2008',3,0,0,0,'',1,'NEISO','1-800-696-1000',0,0,24,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','1','CMP (CENTRAL MAINE POWER)',1,2,0,'EDI',0,1,0)
,(17,'COMED','COMED (COMMONWEALTH EDISON)','COMED (COMMONWEALTH EDISON)',13,'006929509','LPH',7,'BR',10,'','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','05/08/2007','LIBERTYPOWER\gmangaroo','0','05/08/2007',2,0,9,15000,'',1,'PJM','1-800-334-7661',0,0,25,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','COMED (COMMONWEALTH EDISON)',1,2,0,'NONE',0,1,0)
,(18,'CONED','CONED (CON EDISON COMPANY OF NEW YORK)','CONED (CON EDISON COMPANY OF NEW YORK)',7,'006982359','LPH',15,'RR',15,'','ZONE','PROFITABILITY','YES','','','','','','','','VALUE','','','','VALUE','','','','','','','','VALUE','03/30/2006','LIBERTYPOWER\aliberman','0','03/30/2006',10,0,0,0,'',1,'NYISO','1-800-752-6633',0,1,3,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','CONED (CON EDISON COMPANY OF NEW YORK)',1,3,0,'NONE',0,1,1)
,(19,'DELDE','DELDE (DELMARVA POWER)','DELDE (DELMARVA POWER)',12,'006971618DE','LPH',16,'BR',12,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','10/24/2006','libertypower\mbarrant','0','10/24/2006',6,0,0,0,'',1,'PJM','1-800-375-7117',0,0,39,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','DELDE (DELMARVA POWER)',1,2,0,'EDI',0,1,0)
,(20,'DELMD','DELMD (DELMARVA POWER)','DELMD (DELMARVA POWER)',10,'006971618MD','LPMD',13,'BR',12,'','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','10/24/2006','libertypower\e3hernandez','0','10/24/2006',6,0,0,0,'',1,'PJM','1-800-375-7117',0,0,18,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','DELMD (DELMARVA POWER)',1,2,0,'EDI',0,1,1)
,(21,'DUQ','DUQ (DUQUESNE LIGHT AND POWER)','',8,'007915606','LPH',12,'DUAL',13,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','07/24/2009','LIBERTYPOWER\sclark','0','07/24/2009',0,0,0,0,'',1,'PJM','412-393-7100',0,0,41,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','DUQ (DUQUESNE LIGHT AND POWER)',1,2,0,'EDI',0,1,0)
,(22,'JCP&L','JCP&L (JERSEY CENTRAL POWER & LIGHT)','JCP&L (JERSEY CENTRAL POWER & LIGHT)',9,'006973358','LPH',21,'BR',20,'080','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','11/08/2007','libertypower\mbarrant','0','11/08/2007',4,0,0,0,'',1,'PJM','1-888-544-4877',0,0,26,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','JCP&L (JERSEY CENTRAL POWER & LIGHT)',1,3,0,'EDI',0,1,1)
,(23,'MECO','MECO (MASSACHUSETTS ELECTRIC CO - NATIONAL GRID)','MECO (MASSACHUSETTS ELECTRIC CO - NATIONAL GRID)',4,'006952626','LPH-NE',2,'RR',10,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','10/24/2006','libertypower\mbarrant','0','10/24/2006',6,0,0,0,'',1,'NEISO','800-322-3223',1,1,15,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','4','1','MECO (MASSACHUSETTS ELECTRIC CO - NATIONAL GRID)',1,3,0,'EDI',0,1,0)
,(24,'NANT','NANT (NANTUCKET ELECTRIC CO. - NATIONAL GRID)','NANT (NANTUCKET ELECTRIC CO. - NATIONAL GRID)',4,'007998644','LPH-NE',2,'RR',10,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','10/24/2006','libertypower\mbarrant','0','10/24/2006',13,0,0,0,'',1,'NEISO','800-465-1212',1,1,77,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','4','1','NANT (NANTUCKET ELECTRIC CO. - NATIONAL GRID)',1,2,0,'EDI',0,1,0)
,(25,'NECO','NECO (NARRANGANSETT ELECTRIC CO. - NATIONAL GRID)','NECO (NARRANGANSETT ELECTRIC CO. - NATIONAL GRID)',6,'001193655','LPH-NE',2,'DUAL',10,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','10/24/2006','LIBERTYPOWER\gmangaroo','0','10/24/2006',12,0,0,0,'',1,'NEISO','1-800-322-3223',1,0,30,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','4','1','NECO (NARRANGANSETT ELECTRIC CO. - NATIONAL GRID)',1,2,0,'EDI',0,1,0)
,(26,'NIMO','NIMO (NIAGARA MOHAWK)','NIMO (NIAGARA MOHAWK)',7,'006994735','LPH',15,'DUAL',10,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','VALUE','04/03/2006','libertypower\mbarrant','0','04/03/2006',15,0,0,0,'',1,'NYISO','1-800-664-6729/1-800-642-4272',1,1,16,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','3','5','NIMO (NIAGRA MOHAK)',1,3,0,'NONE',0,1,0)
,(27,'NSTAR-BOS','NSTAR-BOS (NSTAR BOSTON EDISON)','NSTAR-BOS (NSTAR BOSTON EDISON)',4,'006951552','LPH',2,'RR',11,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','06/13/2008','libertypower\mbarrant','0','06/13/2008',2,0,0,0,'',1,'NEISO','800-592-2000',1,1,43,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','4','1','NSTAR-BOS (NSTAR BOSTON EDISON)',1,3,0,'EDI',0,1,0)
,(28,'NSTAR-CAMB','NSTAR-CAMB (NSTAR CAMBRIDGE)','NSTAR-CAMB (NSTAR CAMBRIDGE)',4,'006953665','LPH',2,'RR',11,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','06/13/2008','libertypower\mbarrant','0','06/13/2008',3,0,0,0,'',1,'NEISO','800-592-2000',1,1,44,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','4','1','NSTAR-CAMB (NSTAR CAMBRIDGE)',1,3,0,'EDI',0,1,0)
,(29,'NSTAR-COMM','NSTAR-COMM (NSTAR COMMONWEALTH)','NSTAR-COMM (NSTAR COMMONWEALTH)',4,'006953848','LPH',2,'RR',11,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','06/13/2008','libertypower\mbarrant','0','06/13/2008',3,0,0,0,'',1,'NEISO','800-592-2000',1,1,48,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','4','1','NSTAR-COMM (NSTAR COMMONWEALTH)',1,3,0,'EDI',0,1,0)
,(30,'NYSEG','NYSEG (NEW YORK STATE ELECTRIC AND GAS)','NYSEG (NEW YORK STATE ELECTRIC AND GAS)',7,'006977763','LPH',15,'BR',15,'N01','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','08/23/2006','libertypower\mbarrant','0','08/23/2006',8,0,0,0,'',1,'NYISO','1-800-572-1131',0,1,52,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','NYSEG (NEW YORK STATE ELECTRIC AND GAS)',1,3,0,'NONE',1,0,1)
,(31,'O&R','ORANGE AND ROCKLAND','ORANGE AND ROCKLAND',7,'006993406','LPH',15,'DUAL',10,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','10/23/2006','libertypower\mbarrant','0','10/23/2006',2,0,0,0,'',1,'NYISO','1-800-533-5325',0,1,59,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','ORANGE AND ROCKLAND',1,3,0,'EDI',0,1,0)
,(32,'ONCOR-SESCO','ONCOR-SESCO (ONCOR ELECTRIC DELIVERY SESCO)','',1,'1039940674000','LPT',0,'SC',17,'101769','NONE','CREDIT CHECK','NO','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','10/07/2009','LIBERTYPOWER\sclark','0','10/07/2009',0,0,0,0,'',0,'ERCOT','1-888-313-6862/1-800-242-9113',0,0,82,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','ONCOR-SESCO (ONCOR ELECTRIC DELIVERY SESCO)',1,2,0,'NONE',0,1,0)
,(33,'ORNJ','ROCKLAND NEW JERSEY','ROCKLAND NEW JERSEY',9,'006993406','LPH',20,'DUAL',10,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','02/19/2009','libertypower\mbarrant','0','02/19/2009',5,0,0,0,'',1,'PJM','',0,0,38,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','ROCKLAND ELECTRIC',1,2,0,'EDI',0,1,0)
,(34,'PEPCO-DC','PEPCO-DC (POTOMAC ELECTRIC POWER COMPANY DC)','PEPCO-DC (POTOMAC ELECTRIC POWER COMPANY DC)',11,'006920284DC','LPDC',17,'BR',10,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','Facility Rating','VALUE','06/14/2006','libertypower\dmarino','0','06/14/2006',0,0,0,0,'',1,'PJM','1-877-737-2662',0,0,27,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','PEPCO-DC (POTOMAC ELECTRIC POWER COMPANY DC)',1,3,0,'NONE',0,1,0)
,(35,'PEPCO-MD','PEPCO-MD (POTOMAC ELECTRIC POWER COMPANY MARYLAND)','PEPCO-MD (POTOMAC ELECTRIC POWER COMPANY MARYLAND)',10,'006920284','LPMD',12,'BR',10,'','NONE','CREDIT CHECK','YES','','','','','','',' ','NONE','','',' ','NONE','','','','','','','Facility Rating','VALUE','04/03/2006','libertypower\dmarino','0','04/03/2006',1,0,0,0,'',1,'PJM','1-877-737-2662',0,0,42,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','PEPCO-MD (POTOMAC ELECTRIC POWER COMPANY MARYLAND)',1,3,0,'NONE',0,1,1)
,(36,'PGE','PGE (PACIFIC GAS AND ELECTRIC COMPANY)','PGE (PACIFIC GAS AND ELECTRIC COMPANY)',2,'006912877','LPH',5,'DUAL',10,'','NONE','CREDIT CHECK','NO','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','11/19/2009','libertypower\mbarrant','0','11/19/2009',0,0,0,0,'',1,'CAISO','',0,0,94,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','PGE (PACIFIC GAS AND ELECTRIC COMPANY)',1,3,0,'EDI',0,1,0)
,(37,'PPL','PPL (PENNSYLVANIA POWER AND LIGHT)','',8,'007909427AC','LPH',11,'BR',10,'','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','09/10/2009','LIBERTYPOWER\sclark','0','09/10/2009',0,0,0,0,'',1,'PJM','1-800-342-5775',0,0,40,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','PPL (PENNSYLVANIA POWER AND LIGHT)',1,3,1,'EDI',0,1,0)
,(38,'PSEG','PSEG (PUBLIC SERVICE ELECTRIC & GAS)','PSEG (PUBLIC SERVICE ELECTRIC & GAS)',9,'006973812','LPH',20,'BR',20,'PE','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','05/08/2007','libertypower\mbarrant','0','05/08/2007',6,0,0,0,'',1,'PJM','1-800-436-7734',0,0,28,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','PSEG (PUBLIC SERVICE ELECTRIC & GAS)',1,3,0,'EDI',0,1,1)
,(39,'RGE','RGE (ROCHESTER GAS & ELECTRIC)','RGE (ROCHESTER GAS & ELECTRIC)',7,'160612110','LPH',15,'BR',15,'','NONE','CREDIT CHECK','YES','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','10/24/2006','libertypower\mbarrant','0','10/24/2006',4,0,0,0,'',1,'NYISO','1-800-743-1701',0,1,51,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','RGE (ROCHESTER GAS & ELECTRIC)',1,3,0,'NONE',1,1,1)
,(40,'ROCKLAND','ROCKLAND ELECTRIC','ROCKLAND ELECTRIC',9,'006993406','LPH',15,'DUAL',10,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','05/08/2007','libertypower\mbarrant','1','05/08/2007',7,0,0,0,'',1,'PJM','1-877-434-4100',0,0,83,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','ROCKLAND ELECTRIC',1,3,0,'EDI',0,0,0)
,(41,'SCE','SCE (SOUTHERN CALIFORNIA EDISON)','SCE (SOUTHERN CALIFORNIA EDISON)',2,'006908818','LPH',5,'DUAL',10,'3','NONE','CREDIT CHECK','NO','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','11/19/2009','libertypower\mbarrant','0','11/19/2009',0,0,0,0,'',1,'CAISO','',0,0,95,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','SCE (SOUTHERN CALIFORNIA EDISON)',1,3,0,'EDI',0,1,0)
,(42,'SDGE','SDGE (SAN DIEGO GAS AND ELECTRIC)','SDGE (SAN DIEGO GAS AND ELECTRIC)',2,'006911457','LPH',5,'DUAL',10,'','NONE','CREDIT CHECK','NO','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','11/19/2009','libertypower\mbarrant','0','11/19/2009',1,1,8,0,'',1,'CAISO','',0,0,96,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','SDGE (SAN DIEGO GAS AND ELECTRIC)',1,3,0,'EDI',0,1,0)
,(43,'SHARYLAND','SHARYLAND UTILITIES','',1,'105262336','LPT',0,'SC',13,'1017008','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','VALUE','02/19/2008','LIBERTYPOWER\sclark','0','02/19/2008',0,0,0,0,'',0,'ERCOT','1-956-668-9551',0,0,65,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','SHARYLAND UTILITIES',1,2,0,'NONE',0,1,0)
,(44,'TXU','TXU ELECTRIC DELIVERY','',1,'1039940674000','LPT',0,'SC',17,'1044372','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','VALUE','04/04/2006','LIBERTYPOWER\sclark','1','04/04/2006',0,0,0,0,'',0,'ERCOT','1-888-313-4747',0,1,69,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','0','TXU ELECTRIC DELIVERY',1,3,0,'NONE',0,0,0)
,(45,'UGI','UGI (UGI UTILITIES)','UGI (UGI UTILITIES)',8,'099427866','LPH',17,'DUAL',12,'','NONE','CREDIT CHECK','NO','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','12/03/2009','libertypower\mbarrant','0','12/03/2009',0,0,0,0,'',1,'PJM','',0,0,75,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','UGI (UGI UTILITIES)',1,3,0,'EDI',0,1,0)
,(46,'UI','UI (UNITED ILLUMINATING)','UI (UNITED ILLUMINATING)',3,'006917967','LPH',2,'DUAL',13,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','06/03/2008','libertypower\mbarrant','0','06/03/2008',1,0,0,0,'',1,'NEISO','',0,0,58,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','1','UI (UNITED ILLUMINATING)',1,3,0,'EDI',0,1,0)
,(47,'UNITIL','UNITIL (FITCHBURG GAS & ELECTRIC CO)','UNITIL (FITCHBURG GAS & ELECTRIC CO)',4,'006954317','LPH',2,'DUAL',14,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','08/05/2008','libertypower\mbarrant','0','08/05/2008',4,0,0,0,'',1,'NEISO','888-301-7700',0,0,35,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','0','1','UNITIL (FITCHBURG GAS & ELECTRIC CO)',1,3,0,'EDI',0,1,0)
,(48,'WMECO','WMECO (WESTERN MASSACHUSETTS CO)','WMECO (WESTERN MASSACHUSETTS CO)',4,'006956551','LPH',2,'RR',9,'','NONE','CREDIT CHECK','NO','','','','','','','','NONE','','','','NONE','','','','','','','','NONE','05/28/2008','LIBERTYPOWER\gmangaroo','0','05/28/2008',1,0,0,0,'',1,'NEISO','1-413-781-4300/1-800-286-2000',1,1,49,'','','Carrier Ratecode','','SIC','','Accuracy %','','DUNS Number','','4','1','WMECO (WESTERN MASSACHUSETTS CO)',1,3,0,'EDI',0,1,0)
,(49,'METED','METED (METROPOLITAN EDISON COMPANY)','',8,'007916836','LPH-PA2',11,'BR',20,'','NONE','CREDIT CHECK','YES','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','03/24/2010','LIBERTYPOWER\sclark','0','03/24/2010',0,0,0,0,'',1,'PJM','',0,0,91,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','METED (METROPOLITAN EDISON COMPANY)',1,3,0,'EDI',0,1,0)
,(50,'PENELEC','PENELEC (PENNSYLVANIA ELECTRIC COMPANY)','',8,'008967614','LPH-PA2',11,'BR',20,'','NONE','CREDIT CHECK','YES','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','03/24/2010','LIBERTYPOWER\sclark','0','03/24/2010',0,0,0,0,'',1,'PJM','',0,0,92,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','PENELEC (PENNSYLVANIA ELECTRIC COMPANY)',1,3,0,'EDI',0,1,0)
,(51,'PENNPR','PENNPR (PENN POWER)','',8,'007912736','LPH-PA3',11,'BR',20,'','NONE','CREDIT CHECK','YES','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','','NONE','03/24/2010','LIBERTYPOWER\sclark','0','03/24/2010',0,0,0,0,'',1,'PJM','',0,0,74,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','PENNPR (PENN POWER)',1,3,0,'EDI',0,1,0)
,(55,'PECO','PECO ENERGY (EXELON)','',8,'007914468','LPH',12,'BR',10,'','NONE','CREDIT CHECK','YES','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','05/07/2010','LIBERTYPOWER\sclark','0','05/07/2010',0,0,0,0,'',1,'PJM','1-800-494-4000',0,0,90,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','PECO ENERGY (EXELON)',1,3,1,'EDI',0,1,1)
,(56,'WPP','WEST PENN POWER (ALLEGHENY)','',8,'007911050EDC','LPH-PA4',11,'DUAL',20,'080','NONE','CREDIT CHECK','NO','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','05/07/2010','LIBERTYPOWER\sscott','0','05/07/2010',0,0,0,0,'',1,'PJM','1-800-686-0021',0,0,0,'NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','NONE','0','0','WEST PENN POWER (ALLEGHENY)',1,3,0,'EDI',0,1,0)
,(58,'OHP','AEP OHIO POWER','AEP OHIO POWER',16,'002899953','LPH',12,'BR',17,'','NONE','CREDIT CHECK','NO','','','','','','','','','','','','','','','','','','','','','04/26/2012','LIBERTYPOWER\e3hernandez','0','05/01/2012',0,0,0,0,'',1,'PJM','',0,0,102,'','','','','','','','','','','0','0','OHIO POWER',1,3,0,'EDI',0,0,0)
,(59,'CSP','AEP COLUMBUS SOUTHERN POWER','AEP COLUMBUS SOUTHERN POWER',16,'007901739','LPH',12,'BR',17,'','NONE','CREDIT CHECK','NO','','','','','','','','','','','','','','','','','','','','','04/26/2012','libertypower\dmarino','0','05/01/2012',0,0,0,0,'',1,'PJM','',0,0,103,'','','','','','','','','','','0','0','COLUMBUS SOUTHERN POWER',1,3,0,'EDI',0,0,0)
,(60,'DUKE','DUKE ENERGY','',16,'006999189','LPH',12,'RR',10,'','NONE','CREDIT CHECK','YES','','','','','','','','','','','','','','','','','','','','','06/11/2012','libertypower\astudzinska','0','06/11/2012',0,0,0,0,'',1,'PJM','',0,0,104,'','','','','','','','','','','2','1','DUKE ENERGY',1,1,0,'EDI',0,0,1)
,(61,'DAYTON','DAYTON POWER & LIGHT','DAYTON POWER & LIGHT',16,'147212336','LPH',12,'BR',10,'','NONE','CREDIT CHECK','NO','','','','','','','','','','','','','','','','','','','','','06/11/2012','LIBERTYPOWER\dmarino','0','06/11/2012',0,0,0,0,'',1,'PJM','',0,0,105,'','','','','','','','','','','0','0','DAYTON POWER & LIGHT',1,1,0,'EDI',0,0,0)
,(62,'CEI','CLEVELAND ILLUMINATING','CLEVELAND ILLUMINATING',16,'007900293','LPHOH01',12,'BR',20,'080','NONE','CREDIT CHECK','NO','','','','','','','','','','','','','','','','','','','','','06/29/2012','LIBERTYPOWER\sclark','0','06/29/2012',0,0,0,0,'',1,'PJM','',0,0,106,'','','','','','','','','','','0','0','CLEVELAND ',1,1,0,'EDI',0,0,0)
,(63,'TOLED','TOLEDO EDISON','TOLEDO EDISON',16,'007904626','LPHOH01',12,'BR',20,'080','NONE','CREDIT CHECK','NO','','','','','','','','','','','','','','','','','','','','','06/29/2012','LIBERTYPOWER\sclark','0','06/29/2012',0,0,0,0,'',1,'PJM','',0,0,112,'','','','','','','','','','','0','0','TOLEDO EDISON',1,1,0,'EDI',0,0,0)
,(64,'OHED','OHIO EDISON','OHIO EDISON',16,'006998371','LPHOH01',12,'BR',20,'080','NONE','CREDIT CHECK','NO','','','','','','','','','','','','','','','','','','','','','06/29/2012','LIBERTYPOWER\sclark','0','06/29/2012',0,0,0,0,'',1,'PJM','',0,0,109,'','','','','','','','','','','0','0','OHIO EDISON',1,1,0,'EDI',0,0,0)


---------------------------------------- UtilityLegacy END ---------------------------------------------------------

SET IDENTITY_INSERT [dbo].[UtilityLegacy] OFF
GO









DECLARE @User AS NVARCHAR(44)
SET @User = 'DatabaseInitializer'


INSERT INTO [dbo].[RateClass]
(
	[Id],
	[LegacyRateClassId],
	[RateClassCode],
	[Description],
	[Inactive],
	[CreatedBy],
	[CreatedDate],
	[LastModifiedBy],
	[LastModifiedDate]
)
SELECT
	NEWID(), ID, RateClassCode, RateClassCode, 0, @User, GETDATE(), @User, GETDATE()
FROM
	[LibertyPower].[dbo].[RateClass]




INSERT INTO [dbo].[ServiceClass]
(
	[Id],
	[LegacyServiceClassId],
	[ServiceClassCode],
	[Description],
	[Inactive],
	[CreatedBy],
	[CreatedDate],
	[LastModifiedBy],
	[LastModifiedDate]
)
SELECT
	NEWID(), ID, ServiceClassCode, ServiceClassCode, 0, @User, GETDATE(), @User, GETDATE()
FROM
	[LibertyPower].[dbo].[ServiceClass]


INSERT INTO [LoadProfile]
(
	[Id],
	[LegacyLoadProfileId],
	[LoadProfileCode],
	[Description],
	[Inactive],
	[CreatedBy],
	[CreatedDate],
	[LastModifiedBy],
	[LastModifiedDate]
)
SELECT
	NEWID(), ID, LoadProfileCode, LoadProfileCode, 0, @User, GETDATE(), @User, GETDATE()
FROM
	[LibertyPower].[dbo].[LoadProfile]



INSERT INTO [dbo].[MeterType]
(
	[Id],
	[LegacyMeterTypeId],
	[MeterTypeCode],
	[Description],
	[Sequence],
	[Inactive],
	[CreatedBy],
	[CreatedDate],
	[LastModifiedBy],
	[LastModifiedDate]
)
SELECT
	NEWID(), ID, MeterTypeCode, MeterTypeCode, Sequence, 1-Active, @User, GETDATE(), @User, GETDATE()
FROM
	[LibertyPower].[dbo].[MeterType]




--- INSERT POR Driver BEGIN ---

INSERT INTO [dbo].[PorDriver] ([Id],[Name],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate]) VALUES ('84BF31AA-E734-46D4-99E9-61D68B41F8E1','Rate Class',0,'Database Initializtion',GETDATE(),'DatabaseInitializer',GETDATE())
INSERT INTO [dbo].[PorDriver] ([Id],[Name],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate]) VALUES ('F4D76F98-5AEB-4648-BB14-11A5EF62FDE0','Load Profile',0,'Database Initializtion',GETDATE(),'DatabaseInitializer',GETDATE())
INSERT INTO [dbo].[PorDriver] ([Id],[Name],[Inactive],[CreatedBy],[CreatedDate],[LastModifiedBy],[LastModifiedDate]) VALUES ('E2DE68F4-D065-4935-9671-60814636BD14','Tariff Code',0,'Database Initializtion',GETDATE(),'DatabaseInitializer',GETDATE())

--- INSERT POR Driver END ---


--- INSERT POR Recourse BEGIN ---

INSERT INTO [dbo].[PorRecourse]([Id], [Name], [Inactive], [CreatedBy], [CreatedDate], [LastModifiedBy], [LastModifiedDate]) VALUES ('CB353377-9F28-44C2-8322-804B2A2C5940','Recourse',0,'Database Initializtion',GETDATE(),'DatabaseInitializer',GETDATE())
INSERT INTO [dbo].[PorRecourse]([Id], [Name], [Inactive], [CreatedBy], [CreatedDate], [LastModifiedBy], [LastModifiedDate]) VALUES ('26F30CA6-D67D-4851-809E-478A6E8B332F','Non-Recourse',0,'Database Initializtion',GETDATE(),'DatabaseInitializer',GETDATE())

--- INSERT POR Recourse END ---


-------------------------------- INSERT INITIALIZATION DATA END -------------------------------------
