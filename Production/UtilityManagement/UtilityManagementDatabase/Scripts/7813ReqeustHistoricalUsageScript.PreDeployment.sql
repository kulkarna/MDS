--/*
-- Pre-Deployment Script Template							
----------------------------------------------------------------------------------------
-- This file contains SQL statements that will be executed before the build script.	
-- Use SQLCMD syntax to include a file in the pre-deployment script.			
-- Example:      :r .\myfile.sql								
-- Use SQLCMD syntax to reference a variable in the pre-deployment script.		
-- Example:      :setvar TableName MyTable							
--               SELECT * FROM [$(TableName)]					
----------------------------------------------------------------------------------------
--*/
--USE [master]
--GO

--/****** Object:  Database [Lp_UtilityManagement]    Script Date: 06/05/2013 13:01:32 ******/
--CREATE DATABASE [Lp_UtilityManagement] ON  PRIMARY 
--( NAME = N'Lp_UtilityManagement', FILENAME = N'E:\MSSQL.SHRINK\Data\Lp_UtilityManagement.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
-- LOG ON 
--( NAME = N'Lp_UtilityManagement_log', FILENAME = N'E:\MSSQL.SHRINK\Logs\Lp_UtilityManagement_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO

--ALTER DATABASE [Lp_UtilityManagement] SET COMPATIBILITY_LEVEL = 100
--GO

--IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
--begin
--EXEC [Lp_UtilityManagement].[dbo].[sp_fulltext_database] @action = 'enable'
--end
--GO

--ALTER DATABASE [Lp_UtilityManagement] SET ANSI_NULL_DEFAULT OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET ANSI_NULLS OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET ANSI_PADDING OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET ANSI_WARNINGS OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET ARITHABORT OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET AUTO_CLOSE OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET AUTO_CREATE_STATISTICS ON 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET AUTO_SHRINK OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET AUTO_UPDATE_STATISTICS ON 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET CURSOR_CLOSE_ON_COMMIT OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET CURSOR_DEFAULT  GLOBAL 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET CONCAT_NULL_YIELDS_NULL OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET NUMERIC_ROUNDABORT OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET QUOTED_IDENTIFIER OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET RECURSIVE_TRIGGERS OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET  DISABLE_BROKER 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET DATE_CORRELATION_OPTIMIZATION OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET TRUSTWORTHY OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET ALLOW_SNAPSHOT_ISOLATION OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET PARAMETERIZATION SIMPLE 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET READ_COMMITTED_SNAPSHOT OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET HONOR_BROKER_PRIORITY OFF 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET  READ_WRITE 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET RECOVERY FULL 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET  MULTI_USER 
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET PAGE_VERIFY CHECKSUM  
--GO
--ALTER DATABASE [Lp_UtilityManagement] SET DB_CHAINING OFF 
--GO


--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--SET ANSI_PADDING ON
--GO


--CREATE TABLE [dbo].[UtilityCompany]
--(
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[UtilityCode] [varchar](50) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL,
--	CONSTRAINT [PK_UtilityCompany] PRIMARY KEY CLUSTERED ([Id] ASC)
--	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
--) ON [PRIMARY]
--GO


--CREATE TABLE [dbo].[RequestModeType](
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[Name] [nvarchar](50) NOT NULL,
--	[Description] [nvarchar](255) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL,
--	CONSTRAINT [PK_RequestModeType] PRIMARY KEY CLUSTERED ([Id] ASC)
--	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
--GO


--CREATE TABLE [dbo].[RequestModeEnrollmentType](
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[Name] [nvarchar](50) NOT NULL,
--	[Description] [nvarchar](255) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL,
--	CONSTRAINT [PK_RequestModeEnrollmentType] PRIMARY KEY CLUSTERED ([Id] ASC)
--	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
--GO


--CREATE TABLE [dbo].[RequestModeHistoricalUsage](
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[UtilityCompanyId] [int] NOT NULL,
--	[RequestModeEnrollmentTypeId] [int] NOT NULL,
--	[RequestModeTypeId] [int] NOT NULL,
--	[AddressForPreEnrollment] [nvarchar](200) NOT NULL,
--	[EmailTemplate] [nvarchar](2000) NULL,
--	[Instructions] [nvarchar](500) NOT NULL,
--	[UtilitysSlaHistoricalUsageResponseInDays] [int] NOT NULL,
--	[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays] [int] NOT NULL,
--	[IsLoaRequired] [bit] NOT NULL,
--	[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser] [bit] NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL,
--	CONSTRAINT [PK_RequestModeHistoricalUsage] PRIMARY KEY CLUSTERED ([Id] ASC)
--	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
--GO
--ALTER TABLE [dbo].[RequestModeHistoricalUsage]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsage_UtilityCompany] FOREIGN KEY([UtilityCompanyId])
--REFERENCES [dbo].[UtilityCompany] ([Id])
--GO
--ALTER TABLE [dbo].[RequestModeHistoricalUsage] CHECK CONSTRAINT [FK_RequestModeHistoricalUsage_UtilityCompany]
--GO

--ALTER TABLE [dbo].[RequestModeHistoricalUsage]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeEnrollmentType] FOREIGN KEY([RequestModeEnrollmentTypeId])
--REFERENCES [dbo].[RequestModeEnrollmentType] ([Id])
--GO
--ALTER TABLE [dbo].[RequestModeHistoricalUsage] CHECK CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeEnrollmentType]
--GO

--ALTER TABLE [dbo].[RequestModeHistoricalUsage]  WITH CHECK ADD  CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeType] FOREIGN KEY([RequestModeTypeId])
--REFERENCES [dbo].[RequestModeType] ([Id])
--GO
--ALTER TABLE [dbo].[RequestModeHistoricalUsage] CHECK CONSTRAINT [FK_RequestModeHistoricalUsage_RequestModeType]
--GO


--CREATE TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType]
--(
--	[Id] [int] IDENTITY(1,1) NOT NULL,
--	[RequestModeTypeId] [int] NOT NULL,
--	[RequestModeEnrollmentTypeId] [int] NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL,
--	CONSTRAINT [PK_RequestModeTypeToRequestModeEnrollmentType] PRIMARY KEY CLUSTERED ([Id] ASC)
--	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
--) ON [PRIMARY]
--GO
--ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType] WITH CHECK ADD CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeType] FOREIGN KEY([RequestModeTypeId])
--REFERENCES [dbo].[RequestModeType] ([Id])
--GO
--ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType] CHECK CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeType]
--GO

--ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType] WITH CHECK ADD CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeEnrollmentType] FOREIGN KEY([RequestModeEnrollmentTypeId])
--REFERENCES [dbo].[RequestModeEnrollmentType] ([Id])
--GO
--ALTER TABLE [dbo].[RequestModeTypeToRequestModeEnrollmentType] CHECK CONSTRAINT [FK_RequestModeTypeToRequestModeEnrollmentType_RequestModeEnrollmentType]
--GO

--CREATE PROC usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds
--	@RequestModeEnrollmentTypeId INT,
--	@UtilityCompanyId INT
--AS
--BEGIN

--	SELECT 
--		COUNT(RMHU.Id)
--	FROM 
--		RequestModeHistoricalUsage (NOLOCK) RMHU
--	WHERE
--		RMHU.UtilityCompanyId = @UtilityCompanyId
--		AND RMHU.RequestModeEnrollmentTypeId = @RequestModeEnrollmentTypeId
	
--END

--CREATE PROC usp_RequestModeType_SELECT_NameById
--@Id INT
--AS
--BEGIN
--	SELECT
--		[Name]
--	FROM 
--		dbo.RequestModeType (NOLOCK) RMT
--	WHERE
--		RMT.Id = @Id
--END

--GRANT EXEC ON usp_RequestModeType_SELECT_NameById TO LibertyPowerUtilityManagementUser


--GRANT EXEC ON usp_CheckForExistingUtilityCompanyIdRequestEnrollmentTypeIds TO LibertyPowerUtilityManagementUser


--USE [Lp_UtilityManagement]
--GO

--/****** Object:  Table [dbo].[RequestModeEnrollmentType]    Script Date: 06/07/2013 14:53:46 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[zAuditRequestModeEnrollmentType](
--	[Id] [int] NOT NULL,
--	[Name] [nvarchar](50) NOT NULL,
--	[Description] [nvarchar](255) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL
--	)
--GO

--CREATE TABLE [dbo].[zAuditRequestModeHistoricalUsage](
--	[Id] [int] NOT NULL,
--	[UtilityCompanyId] [int] NOT NULL,
--	[RequestModeEnrollmentTypeId] [int] NOT NULL,
--	[RequestModeTypeId] [int] NOT NULL,
--	[AddressForPreEnrollment] [nvarchar](200) NOT NULL,
--	[EmailTemplate] [nvarchar](2000) NULL,
--	[Instructions] [nvarchar](500) NOT NULL,
--	[UtilitysSlaHistoricalUsageResponseInDays] [int] NOT NULL,
--	[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays] [int] NOT NULL,
--	[IsLoaRequired] [bit] NOT NULL,
--	[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser] [bit] NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL
--)
--GO

--CREATE TABLE [dbo].[zAuditRequestModeType](
--	[Id] [int] NOT NULL,
--	[Name] [nvarchar](50) NOT NULL,
--	[Description] [nvarchar](255) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL
--)
--GO

--CREATE TABLE [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType](
--	[Id] [int] NOT NULL,
--	[RequestModeTypeId] [int] NOT NULL,
--	[RequestModeEnrollmentTypeId] [int] NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL
--)
--GO

--CREATE TABLE [dbo].[zAuditUtilityCompany](
--	[Id] [int] NOT NULL,
--	[UtilityCode] [varchar](50) NOT NULL,
--	[Inactive] [bit] NOT NULL,
--	[CreatedBy] [nvarchar](100) NOT NULL,
--	[CreatedDate] [datetime] NOT NULL,
--	[LastModifiedBy] [nvarchar](100) NOT NULL,
--	[LastModifiedDate] [datetime] NOT NULL
--)
--GO


--CREATE TRIGGER [dbo].[zAuditRequestModeEnrollmentTypeUpdate]
--	ON  [dbo].[RequestModeEnrollmentType]
--	AFTER UPDATE
--AS 
--BEGIN
--	SET NOCOUNT ON;

--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditRequestModeEnrollmentType]
--	(
--		[Id],
--		[Name],
--		[Description],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[Name],
--		[Description],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO


--CREATE TRIGGER [dbo].[zAuditRequestModeEnrollmentTypeInsert]
--	ON  [dbo].[RequestModeEnrollmentType]
--	AFTER INSERT
--AS 
--BEGIN
--	SET NOCOUNT ON;

--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditRequestModeEnrollmentType]
--	(
--		[Id],
--		[Name],
--		[Description],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[Name],
--		[Description],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO


--CREATE TRIGGER [dbo].[zAuditRequestModeHistoricalUsageUpdate]
--	ON  [dbo].[RequestModeHistoricalUsage]
--	AFTER UPDATE
--AS 
--BEGIN
--	SET NOCOUNT ON;

--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditRequestModeHistoricalUsage]
--	(
--		[Id],
--		[UtilityCompanyId],
--		[RequestModeEnrollmentTypeId],
--		[RequestModeTypeId],
--		[AddressForPreEnrollment],
--		[EmailTemplate],
--		[Instructions],
--		[UtilitysSlaHistoricalUsageResponseInDays],
--		[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays],
--		[IsLoaRequired],
--		[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[UtilityCompanyId],
--		[RequestModeEnrollmentTypeId],
--		[RequestModeTypeId],
--		[AddressForPreEnrollment],
--		[EmailTemplate],
--		[Instructions],
--		[UtilitysSlaHistoricalUsageResponseInDays],
--		[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays],
--		[IsLoaRequired],
--		[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO


--CREATE TRIGGER [dbo].[zAuditRequestModeHistoricalUsageInsert]
--	ON  [dbo].[RequestModeHistoricalUsage]
--	AFTER INSERT
--AS 
--BEGIN
--	SET NOCOUNT ON;

--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditRequestModeHistoricalUsage]
--	(
--		[Id],
--		[UtilityCompanyId],
--		[RequestModeEnrollmentTypeId],
--		[RequestModeTypeId],
--		[AddressForPreEnrollment],
--		[EmailTemplate],
--		[Instructions],
--		[UtilitysSlaHistoricalUsageResponseInDays],
--		[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays],
--		[IsLoaRequired],
--		[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[UtilityCompanyId],
--		[RequestModeEnrollmentTypeId],
--		[RequestModeTypeId],
--		[AddressForPreEnrollment],
--		[EmailTemplate],
--		[Instructions],
--		[UtilitysSlaHistoricalUsageResponseInDays],
--		[LibertyPowersSlaFollowUpHistoricalUsageResponseInDays],
--		[IsLoaRequired],
--		[IcapAndHuPreEnrollmentRequestModeDifferenceIdentifiedAndOkdByUser],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO




--CREATE TRIGGER [dbo].[zAuditRequestModeTypeUpdate]
--	ON  [dbo].[RequestModeType]
--	AFTER UPDATE
--AS 
--BEGIN
--	SET NOCOUNT ON;

--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditRequestModeType]
--	(
--		[Id],
--		[Name],
--		[Description],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[Name],
--		[Description],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO


--CREATE TRIGGER [dbo].[zAuditRequestModeTypeInsert]
--	ON  [dbo].[RequestModeType]
--	AFTER INSERT
--AS 
--BEGIN
--	SET NOCOUNT ON;


--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditRequestModeType]
--	(
--		[Id],
--		[Name],
--		[Description],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[Name],
--		[Description],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO

--CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentTypeUpdate]
--	ON  [dbo].[RequestModeTypeToRequestModeEnrollmentType]
--	AFTER UPDATE
--AS 
--BEGIN
--	SET NOCOUNT ON;

--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType]
--	(
--		[Id],
--		[RequestModeTypeId],
--		[RequestModeEnrollmentTypeId],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[RequestModeTypeId],
--		[RequestModeEnrollmentTypeId],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO


--CREATE TRIGGER [dbo].[zAuditRequestModeTypeToRequestModeEnrollmentTypeInsert]
--	ON  [dbo].[RequestModeTypeToRequestModeEnrollmentType]
--	AFTER INSERT
--AS 
--BEGIN
--	SET NOCOUNT ON;


--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditRequestModeTypeToRequestModeEnrollmentType]
--	(
--		[Id],
--		[RequestModeTypeId],
--		[RequestModeEnrollmentTypeId],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[RequestModeTypeId],
--		[RequestModeEnrollmentTypeId],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO


--CREATE TRIGGER [dbo].[zAuditUtilityCompanyUpdate]
--	ON  [dbo].[UtilityCompany]
--	AFTER UPDATE
--AS 
--BEGIN
--	SET NOCOUNT ON;

--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditUtilityCompany]
--	(
--		[Id],
--		[UtilityCode],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[UtilityCode],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO


--CREATE TRIGGER [dbo].[zAuditUtilityCompanyInsert]
--	ON  [dbo].[UtilityCompany]
--	AFTER INSERT
--AS 
--BEGIN
--	SET NOCOUNT ON;


--	INSERT INTO [Lp_UtilityManagement].[dbo].[zAuditUtilityCompany]
--	(
--		[Id],
--		[UtilityCode],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	)
--	SELECT 
--		[Id],
--		[UtilityCode],
--		[Inactive],
--		[CreatedBy],
--		[CreatedDate],
--		[LastModifiedBy],
--		[LastModifiedDate]
--	FROM 
--		inserted
	
--	SET NOCOUNT OFF;
--END
--GO


--ALTER DATABASE Lp_UtilityManagement SET ALLOW_SNAPSHOT_ISOLATION ON

--ALTER DATABASE Lp_UtilityManagement
--SET CHANGE_TRACKING = ON
--(CHANGE_RETENTION = 30 DAYS, AUTO_CLEANUP = ON)

--ALTER TABLE Lp_UtilityManagement.dbo.RequestModeEnrollmentType
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.RequestModeHistoricalUsage
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.RequestModeType
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.RequestModeTypeGenre
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.RequestModeTypeToRequestModeEnrollmentType
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.RequestModeTypeToRequestModeTypeGenre
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.UserInterfaceControlAndValueGoverningControlVisibility
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.UserInterfaceControlVisibility
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.UserInterfaceForm
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.UserInterfaceFormControl
--ENABLE CHANGE_TRACKING
--ALTER TABLE Lp_UtilityManagement.dbo.UtilityCompany
--ENABLE CHANGE_TRACKING