/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[IdrAccountVsHuDiscrepancies]

     Make VM2LPCNOCSQLINT1\PROD.lp_transactions Equal (local)\MSSQL2008R2.Lp_transactions

   AUTHOR:    Eduardo Patino
   DATE:      7/10/2013 10:44:30 AM
   DESCRIPTION: Changes for the HU Adjustment audit. PBI #4753
   ------------------------------------------------------------ */

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

-- Drop Foreign Key FK_IdrAccountVsHuDiscrepancies_IdrNonEdiHeader from [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Drop Foreign Key FK_IdrAccountVsHuDiscrepancies_IdrNonEdiHeader from [dbo].[IdrAccountVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies] DROP CONSTRAINT [FK_IdrAccountVsHuDiscrepancies_IdrNonEdiHeader]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Rename Column IdrAcctStageInfoId on [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Rename Column IdrAcctStageInfoId on [dbo].[IdrAccountVsHuDiscrepancies]'
GO
EXEC sp_rename N'[dbo].[IdrAccountVsHuDiscrepancies].[IdrNonEdiHeaderId]', N'IdrAcctStageInfoId', 'COLUMN'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Column CreatedBy to [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Add Column CreatedBy to [dbo].[IdrAccountVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies]
       ADD [CreatedBy] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Column Adjusted to [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Add Column Adjusted to [dbo].[IdrAccountVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies]
       ADD [Adjusted] [smallint] NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Foreign Key FK_IdrAccountVsHuDiscrepancies_IdrAccountStageInfo on [dbo].[IdrAccountVsHuDiscrepancies]
Print 'Create Foreign Key FK_IdrAccountVsHuDiscrepancies_IdrAccountStageInfo on [dbo].[IdrAccountVsHuDiscrepancies]'
GO
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies]
       WITH CHECK
       ADD CONSTRAINT [FK_IdrAccountVsHuDiscrepancies_IdrAccountStageInfo]
       FOREIGN KEY ([IdrAcctStageInfoId]) REFERENCES [dbo].[IdrAccountStageInfo] ([Id])
ALTER TABLE [dbo].[IdrAccountVsHuDiscrepancies]
       CHECK CONSTRAINT [FK_IdrAccountVsHuDiscrepancies_IdrAccountStageInfo]

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
       COMMIT

SET NOEXEC OFF


