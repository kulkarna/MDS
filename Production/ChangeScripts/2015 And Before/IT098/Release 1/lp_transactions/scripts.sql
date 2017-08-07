SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO
USE [lp_transactions]
GO

BEGIN TRAN
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrAccountStageInfo]
Print 'Create Table [dbo].[IdrAccountStageInfo]'
GO
CREATE TABLE [dbo].[IdrAccountStageInfo] (
		[Id]                [int] IDENTITY(1, 1) NOT NULL,
		[AccountNumber]     [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[UtilityCode]       [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Stage]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Status]            [tinyint] NOT NULL,
		[CreatedBy]         [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[TimeStamp]         [datetime] NOT NULL,
		[Notes]             [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrAccountStageInfo to [dbo].[IdrAccountStageInfo]
Print 'Add Primary Key PK_IdrAccountStageInfo to [dbo].[IdrAccountStageInfo]'
GO
ALTER TABLE [dbo].[IdrAccountStageInfo]
	ADD
	CONSTRAINT [PK_IdrAccountStageInfo]
	PRIMARY KEY
	CLUSTERED
	([Id])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrFileLogHeader]
Print 'Create Table [dbo].[IdrFileLogHeader]'
GO
CREATE TABLE [dbo].[IdrFileLogHeader] (
		[ID]            [int] IDENTITY(1, 1) NOT NULL,
		[FileGuid]      [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[FileName]      [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Attempts]      [smallint] NULL,
		[CreatedBy]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TimeStamp]     [datetime] NOT NULL,
		[FileType]      [tinyint] NULL,
		[Notes]         [varchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Status]        [tinyint] NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrFileLogHeader to [dbo].[IdrFileLogHeader]
Print 'Add Primary Key PK_IdrFileLogHeader to [dbo].[IdrFileLogHeader]'
GO
ALTER TABLE [dbo].[IdrFileLogHeader]
	ADD
	CONSTRAINT [PK_IdrFileLogHeader]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_IdrFileLogHeader_TimeStamp to [dbo].[IdrFileLogHeader]
Print 'Add Default Constraint DF_IdrFileLogHeader_TimeStamp to [dbo].[IdrFileLogHeader]'
GO
ALTER TABLE [dbo].[IdrFileLogHeader]
	ADD
	CONSTRAINT [DF_IdrFileLogHeader_TimeStamp]
	DEFAULT (getdate()) FOR [TimeStamp]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrAccountStageInfo_History]
Print 'Create Table [dbo].[IdrAccountStageInfo_History]'
GO
CREATE TABLE [dbo].[IdrAccountStageInfo_History] (
		[Id]                [int] IDENTITY(1, 1) NOT NULL,
		[AccountNumber]     [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[UtilityCode]       [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Stage]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Status]            [tinyint] NOT NULL,
		[CreatedBy]         [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[TimeStamp]         [datetime] NOT NULL,
		[Notes]             [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Archived]          [datetime] NULL,
		[Operation]         [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrAccountStageInfo_History to [dbo].[IdrAccountStageInfo_History]
Print 'Add Primary Key PK_IdrAccountStageInfo_History to [dbo].[IdrAccountStageInfo_History]'
GO
ALTER TABLE [dbo].[IdrAccountStageInfo_History]
	ADD
	CONSTRAINT [PK_IdrAccountStageInfo_History]
	PRIMARY KEY
	CLUSTERED
	([Id])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[Idr8760FileTemp]
Print 'Create Table [dbo].[Idr8760FileTemp]'
GO
CREATE TABLE [dbo].[Idr8760FileTemp] (
		[idrFileLogId]          [int] NOT NULL,
		[utilityCode]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[accountNumber]         [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[meterNumber]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[recorderNumber]        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[usageSource]           [smallint] NULL,
		[usageType]             [smallint] NULL,
		[unitOfMeasurement]     [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[idrDate]               [datetime] NOT NULL,
		[intervals]             [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[createdBy]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_Idr8760FileTemp_CreatedBy to [dbo].[Idr8760FileTemp]
Print 'Add Default Constraint DF_Idr8760FileTemp_CreatedBy to [dbo].[Idr8760FileTemp]'
GO
ALTER TABLE [dbo].[Idr8760FileTemp]
	ADD
	CONSTRAINT [DF_Idr8760FileTemp_CreatedBy]
	DEFAULT ('Save8760Tab') FOR [createdBy]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrFileLog]
Print 'Create Table [dbo].[IdrFileLog]'
GO
CREATE TABLE [dbo].[IdrFileLog] (
		[ID]              [int] IDENTITY(1, 1) NOT NULL,
		[FileGuid]        [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[FileName]        [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Tab]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[UtilityCode]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Attempts]        [smallint] NULL,
		[Information]     [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[IsProcessed]     [tinyint] NULL,
		[CreatedBy]       [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TimeStamp]       [datetime] NOT NULL,
		[FileType]        [tinyint] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrFileLog to [dbo].[IdrFileLog]
Print 'Add Primary Key PK_IdrFileLog to [dbo].[IdrFileLog]'
GO
ALTER TABLE [dbo].[IdrFileLog]
	ADD
	CONSTRAINT [PK_IdrFileLog]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrProcessLog]
Print 'Create Table [dbo].[IdrProcessLog]'
GO
CREATE TABLE [dbo].[IdrProcessLog] (
		[ID]                  [int] IDENTITY(1, 1) NOT NULL,
		[IdrFileLogID]        [int] NULL,
		[Information]         [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[IsProcessed]         [tinyint] NULL,
		[TimeStampInsert]     [datetime] NULL,
		[TimeStampUpdate]     [datetime] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrProcessLog to [dbo].[IdrProcessLog]
Print 'Add Primary Key PK_IdrProcessLog to [dbo].[IdrProcessLog]'
GO
ALTER TABLE [dbo].[IdrProcessLog]
	ADD
	CONSTRAINT [PK_IdrProcessLog]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrUsageSource]
Print 'Create Table [dbo].[IdrUsageSource]'
GO
CREATE TABLE [dbo].[IdrUsageSource] (
		[Value]           [int] NOT NULL,
		[Description]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Created]         [datetime] NOT NULL,
		[CreatedBy]       [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrNonEdiHeader]
Print 'Create Table [dbo].[IdrNonEdiHeader]'
GO
CREATE TABLE [dbo].[IdrNonEdiHeader] (
		[ID]                    [int] IDENTITY(100, 1) NOT NULL,
		[UtilityCode]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[AccountNumber]         [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[MeterNumber]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RecorderNumber]        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[UsageSource]           [smallint] NOT NULL,
		[UsageType]             [smallint] NOT NULL,
		[AverageDifference]     [decimal](9, 2) NULL,
		[Intervals]             [smallint] NULL,
		[OriginalUnit]          [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CreatedBy]             [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TimeStamp]             [datetime] NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_Idr8760Header to [dbo].[IdrNonEdiHeader]
Print 'Add Primary Key PK_Idr8760Header to [dbo].[IdrNonEdiHeader]'
GO
ALTER TABLE [dbo].[IdrNonEdiHeader]
	ADD
	CONSTRAINT [PK_Idr8760Header]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrFileStatus]
Print 'Create Table [dbo].[IdrFileStatus]'
GO
CREATE TABLE [dbo].[IdrFileStatus] (
		[Value]           [smallint] NOT NULL,
		[Description]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Created]         [datetime] NULL,
		[CreatedBy]       [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrFileStatus to [dbo].[IdrFileStatus]
Print 'Add Primary Key PK_IdrFileStatus to [dbo].[IdrFileStatus]'
GO
ALTER TABLE [dbo].[IdrFileStatus]
	ADD
	CONSTRAINT [PK_IdrFileStatus]
	PRIMARY KEY
	CLUSTERED
	([Value])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_IdrFileStatus_Created to [dbo].[IdrFileStatus]
Print 'Add Default Constraint DF_IdrFileStatus_Created to [dbo].[IdrFileStatus]'
GO
ALTER TABLE [dbo].[IdrFileStatus]
	ADD
	CONSTRAINT [DF_IdrFileStatus_Created]
	DEFAULT (getdate()) FOR [Created]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrNonEdiDetailIntervals]
Print 'Create Table [dbo].[IdrNonEdiDetailIntervals]'
GO
CREATE TABLE [dbo].[IdrNonEdiDetailIntervals] (
		[Id]            [bigint] IDENTITY(1, 1) NOT NULL,
		[Intervals]     [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrNonEdiDetailValue to [dbo].[IdrNonEdiDetailIntervals]
Print 'Add Primary Key PK_IdrNonEdiDetailValue to [dbo].[IdrNonEdiDetailIntervals]'
GO
ALTER TABLE [dbo].[IdrNonEdiDetailIntervals]
	ADD
	CONSTRAINT [PK_IdrNonEdiDetailValue]
	PRIMARY KEY
	CLUSTERED
	([Id])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrUsageType]
Print 'Create Table [dbo].[IdrUsageType]'
GO
CREATE TABLE [dbo].[IdrUsageType] (
		[Value]           [int] NOT NULL,
		[Description]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Created]         [datetime] NOT NULL,
		[CreatedBy]       [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrVsHuDiscrepancies]
Print 'Create Table [dbo].[IdrVsHuDiscrepancies]'
GO
CREATE TABLE [dbo].[IdrVsHuDiscrepancies] (
		[ID]                  [bigint] IDENTITY(100, 1) NOT NULL,
		[IdrAccountId]        [bigint] NOT NULL,
		[FromDate]            [datetime] NOT NULL,
		[ToDate]              [datetime] NOT NULL,
		[HUKwh]               [int] NOT NULL,
		[IDRKwh]              [decimal](9, 2) NULL,
		[Difference]          [decimal](9, 2) NULL,
		[Created]             [datetime] NULL,
		[EffectiveToDate]     [datetime] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrUtilityRawParser]
Print 'Create Table [dbo].[IdrUtilityRawParser]'
GO
CREATE TABLE [dbo].[IdrUtilityRawParser] (
		[Id]             [int] IDENTITY(1, 1) NOT NULL,
		[UtilityId]      [int] NOT NULL,
		[FormatType]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ParserType]     [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[IsDefault]      [bit] NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrUtilityRawParser to [dbo].[IdrUtilityRawParser]
Print 'Add Primary Key PK_IdrUtilityRawParser to [dbo].[IdrUtilityRawParser]'
GO
ALTER TABLE [dbo].[IdrUtilityRawParser]
	ADD
	CONSTRAINT [PK_IdrUtilityRawParser]
	PRIMARY KEY
	CLUSTERED
	([Id])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_IdrUtilityRawParser_IsDefault to [dbo].[IdrUtilityRawParser]
Print 'Add Default Constraint DF_IdrUtilityRawParser_IsDefault to [dbo].[IdrUtilityRawParser]'
GO
ALTER TABLE [dbo].[IdrUtilityRawParser]
	ADD
	CONSTRAINT [DF_IdrUtilityRawParser_IsDefault]
	DEFAULT ((0)) FOR [IsDefault]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create View [dbo].[Utility]
Print 'Create View [dbo].[Utility]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO


--Create new view to LibertyPower Utilities table.
CREATE VIEW [dbo].[Utility]
AS
SELECT     *
FROM         LibertyPower.dbo.Utility (NOLOCK)


GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Create Table [dbo].[IdrAccountVsHuDiscrepancies]'
GO
CREATE TABLE [dbo].[IdrAccountVsHuDiscrepancies] (
		[ID]                    [bigint] IDENTITY(100, 1) NOT NULL,
		[IdrNonEdiHeaderId]     [int] NOT NULL,
		[FromDate]              [datetime] NOT NULL,
		[ToDate]                [datetime] NOT NULL,
		[HUKwh]                 [int] NOT NULL,
		[IDRKwh]                [decimal](9, 2) NULL,
		[Difference]            [decimal](9, 2) NULL,
		[Created]               [datetime] NULL,
		[EffectiveToDate]       [datetime] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrAccountVsHuDiscrepancies to [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Add Primary Key PK_IdrAccountVsHuDiscrepancies to [dbo].[IdrAccountVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies]
	ADD
	CONSTRAINT [PK_IdrAccountVsHuDiscrepancies]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_IdrAccountVsHuDiscrepancies_Created to [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Add Default Constraint DF_IdrAccountVsHuDiscrepancies_Created to [dbo].[IdrAccountVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies]
	ADD
	CONSTRAINT [DF_IdrAccountVsHuDiscrepancies_Created]
	DEFAULT (getdate()) FOR [Created]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrNonEdiDetail]
Print 'Create Table [dbo].[IdrNonEdiDetail]'
GO
CREATE TABLE [dbo].[IdrNonEdiDetail] (
		[ID]               [bigint] IDENTITY(1, 1) NOT NULL,
		[IdrAccountId]     [int] NOT NULL,
		[IdrDate]          [datetime] NOT NULL,
		[Peak]             [decimal](9, 2) NULL,
		[OffPeak]          [decimal](9, 2) NULL,
		[IntervalsId]      [bigint] NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_Idr8760Detail to [dbo].[IdrNonEdiDetail]
Print 'Add Primary Key PK_Idr8760Detail to [dbo].[IdrNonEdiDetail]'
GO
ALTER TABLE [dbo].[IdrNonEdiDetail]
	ADD
	CONSTRAINT [PK_Idr8760Detail]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrFileLogDetail]
Print 'Create Table [dbo].[IdrFileLogDetail]'
GO
CREATE TABLE [dbo].[IdrFileLogDetail] (
		[ID]                    [int] IDENTITY(1, 1) NOT NULL,
		[FileLogHeaderId]       [int] NOT NULL,
		[Tab]                   [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[UtilityCode]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Information]           [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[IsProcessed]           [tinyint] NULL,
		[TimeStamp]             [datetime] NOT NULL,
		[Status]                [tinyint] NOT NULL,
		[AccountNumber]         [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[FormatType]            [smallint] NULL,
		[AverageDifference]     [decimal](9, 2) NULL,
		[MeterNumber]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RecorderNumber]        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrFileLogDetail to [dbo].[IdrFileLogDetail]
Print 'Add Primary Key PK_IdrFileLogDetail to [dbo].[IdrFileLogDetail]'
GO
ALTER TABLE [dbo].[IdrFileLogDetail]
	ADD
	CONSTRAINT [PK_IdrFileLogDetail]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_IdrFileLogDetail_TimeStamp to [dbo].[IdrFileLogDetail]
Print 'Add Default Constraint DF_IdrFileLogDetail_TimeStamp to [dbo].[IdrFileLogDetail]'
GO
ALTER TABLE [dbo].[IdrFileLogDetail]
	ADD
	CONSTRAINT [DF_IdrFileLogDetail_TimeStamp]
	DEFAULT (getdate()) FOR [TimeStamp]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index IX_IdrFileLogDetail on [dbo].[IdrFileLogDetail]
Print 'Create Index IX_IdrFileLogDetail on [dbo].[IdrFileLogDetail]'
GO
CREATE NONCLUSTERED INDEX [IX_IdrFileLogDetail]
	ON [dbo].[IdrFileLogDetail] ([FileLogHeaderId])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Trigger [dbo].[IdrAccountStageInfo_UpdateHistoryTrigger]
Print 'Create Trigger [dbo].[IdrAccountStageInfo_UpdateHistoryTrigger]'
GO

CREATE TRIGGER IdrAccountStageInfo_UpdateHistoryTrigger
   ON  IdrAccountStageInfo
   AFTER UPDATE, INSERT, DELETE
AS 
BEGIN

	IF EXISTS (SELECT * FROM INSERTED)
	BEGIN
		INSERT IdrAccountStageInfo_History (AccountNumber, UtilityCode, Stage, [Status], CreatedBy, [Timestamp], Notes, Archived, Operation)
		SELECT AccountNumber, UtilityCode, Stage, [Status], CreatedBy, [Timestamp], Notes, getdate(), 'INSERT OR UPDATE' 
		FROM inserted
	END
	ELSE
	BEGIN
		INSERT IdrAccountStageInfo_History (AccountNumber, UtilityCode, Stage, [Status], CreatedBy, [Timestamp], Notes, Archived, Operation)
		SELECT AccountNumber, UtilityCode, Stage, [Status], CreatedBy, [Timestamp], Notes, getdate(), 'DELETE' 
		FROM deleted
	END
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[IdrFileVsHuDiscrepancies]
Print 'Create Table [dbo].[IdrFileVsHuDiscrepancies]'
GO
CREATE TABLE [dbo].[IdrFileVsHuDiscrepancies] (
		[ID]                     [bigint] IDENTITY(100, 1) NOT NULL,
		[IdrFileLogDetailId]     [int] NOT NULL,
		[FromDate]               [datetime] NOT NULL,
		[ToDate]                 [datetime] NOT NULL,
		[HUKwh]                  [int] NOT NULL,
		[IDRKwh]                 [decimal](9, 2) NULL,
		[Difference]             [decimal](9, 2) NULL,
		[Created]                [datetime] NULL,
		[EffectiveToDate]        [datetime] NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key PK_IdrVsHuDiscrepancies to [dbo].[IdrFileVsHuDiscrepancies]
Print 'Add Primary Key PK_IdrVsHuDiscrepancies to [dbo].[IdrFileVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrFileVsHuDiscrepancies]
	ADD
	CONSTRAINT [PK_IdrVsHuDiscrepancies]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_IdrVsHuDiscrepancies_Created to [dbo].[IdrFileVsHuDiscrepancies]
Print 'Add Default Constraint DF_IdrVsHuDiscrepancies_Created to [dbo].[IdrFileVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrFileVsHuDiscrepancies]
	ADD
	CONSTRAINT [DF_IdrVsHuDiscrepancies_Created]
	DEFAULT (getdate()) FOR [Created]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index IX_IdrFileVsHuDiscrepancies on [dbo].[IdrFileVsHuDiscrepancies]
Print 'Create Index IX_IdrFileVsHuDiscrepancies on [dbo].[IdrFileVsHuDiscrepancies]'
GO
CREATE NONCLUSTERED INDEX [IX_IdrFileVsHuDiscrepancies]
	ON [dbo].[IdrFileVsHuDiscrepancies] ([IdrFileLogDetailId])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_IdrAccountVsHuDiscrepancies_IdrNonEdiHeader on [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Create Foreign Key FK_IdrAccountVsHuDiscrepancies_IdrNonEdiHeader on [dbo].[IdrAccountVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies]
	WITH CHECK
	ADD CONSTRAINT [FK_IdrAccountVsHuDiscrepancies_IdrNonEdiHeader]
	FOREIGN KEY ([IdrNonEdiHeaderId]) REFERENCES [dbo].[IdrNonEdiHeader] ([ID])
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies]
	CHECK CONSTRAINT [FK_IdrAccountVsHuDiscrepancies_IdrNonEdiHeader]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_FileHeader_FileDetail on [dbo].[IdrFileLogDetail]
Print 'Create Foreign Key FK_FileHeader_FileDetail on [dbo].[IdrFileLogDetail]'
GO
ALTER TABLE [dbo].[IdrFileLogDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_FileHeader_FileDetail]
	FOREIGN KEY ([FileLogHeaderId]) REFERENCES [dbo].[IdrFileLogHeader] ([ID])
	ON DELETE CASCADE
	ON UPDATE CASCADE
ALTER TABLE [dbo].[IdrFileLogDetail]
	CHECK CONSTRAINT [FK_FileHeader_FileDetail]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_IdrVsHuDiscrepancies_IdrFileLogDetail on [dbo].[IdrFileVsHuDiscrepancies]
Print 'Create Foreign Key FK_IdrVsHuDiscrepancies_IdrFileLogDetail on [dbo].[IdrFileVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrFileVsHuDiscrepancies]
	WITH CHECK
	ADD CONSTRAINT [FK_IdrVsHuDiscrepancies_IdrFileLogDetail]
	FOREIGN KEY ([IdrFileLogDetailId]) REFERENCES [dbo].[IdrFileLogDetail] ([ID])
ALTER TABLE [dbo].[IdrFileVsHuDiscrepancies]
	CHECK CONSTRAINT [FK_IdrVsHuDiscrepancies_IdrFileLogDetail]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_IdrNonEdiDetail_IdrNonEdiDetailIntervals on [dbo].[IdrNonEdiDetail]
Print 'Create Foreign Key FK_IdrNonEdiDetail_IdrNonEdiDetailIntervals on [dbo].[IdrNonEdiDetail]'
GO
ALTER TABLE [dbo].[IdrNonEdiDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_IdrNonEdiDetail_IdrNonEdiDetailIntervals]
	FOREIGN KEY ([IntervalsId]) REFERENCES [dbo].[IdrNonEdiDetailIntervals] ([Id])
ALTER TABLE [dbo].[IdrNonEdiDetail]
	CHECK CONSTRAINT [FK_IdrNonEdiDetail_IdrNonEdiDetailIntervals]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_IdrNonEdiDetail_IdrNonEdiHeader on [dbo].[IdrNonEdiDetail]
Print 'Create Foreign Key FK_IdrNonEdiDetail_IdrNonEdiHeader on [dbo].[IdrNonEdiDetail]'
GO
ALTER TABLE [dbo].[IdrNonEdiDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_IdrNonEdiDetail_IdrNonEdiHeader]
	FOREIGN KEY ([IdrAccountId]) REFERENCES [dbo].[IdrNonEdiHeader] ([ID])
ALTER TABLE [dbo].[IdrNonEdiDetail]
	CHECK CONSTRAINT [FK_IdrNonEdiDetail_IdrNonEdiHeader]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

