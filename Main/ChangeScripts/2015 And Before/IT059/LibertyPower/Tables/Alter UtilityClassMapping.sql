/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[UtilityClassMapping]

     Make VM3LPCNOCSQL1.Libertypower Equal (local).LibertyPower

   AUTHOR:	[Insert Author Name]

   DATE:	11/27/2012 4:11:50 PM

   LEGAL:	2012[Insert Company Name]

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
USE [Libertypower]
GO

BEGIN TRAN
GO

-- Add Column RuleType to [dbo].[UtilityClassMapping]
Print 'Add Column RuleType to [dbo].[UtilityClassMapping]'
GO
ALTER TABLE [dbo].[UtilityClassMapping]
	ADD [RuleType] [int] NULL
	CONSTRAINT [DF_UtilityClassMapping_MappingRuleType] DEFAULT ((0)) WITH VALUES

ALTER TABLE [dbo].[UtilityClassMapping]
	ADD [TCap] [decimal](20, 5) NULL

ALTER TABLE [dbo].[UtilityClassMapping]
	ADD [ICap] [decimal](20, 5) NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

