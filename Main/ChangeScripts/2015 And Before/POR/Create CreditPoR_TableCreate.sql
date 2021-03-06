/* ------------------------------------------------------------
   DESCRIPTION:	Table: [dbo].[CreditPoR]
   AUTHOR:		Ryan Russon
   DATE:		05/01/2012
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

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[CreditPoR]
Print 'Create Table [dbo].[CreditPoR]'
GO
CREATE TABLE [dbo].[CreditPoR] (
		[ID]                 [int] IDENTITY(1, 1) NOT NULL,
		[ServiceClassID]     [int] NOT NULL,
		[IsPoRAvailable]     [bit] NOT NULL,
		[EffectiveDate]      [datetime] NULL,
		[DateCreated]        [datetime] NOT NULL,
		[CreatedBy]          [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[DateModified]       [datetime] NULL,
		[ModifiedBy]         [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Primary Key [PK_CreditPoR] to [dbo].[CreditPoR]
Print 'Add Primary Key [PK_CreditPoR] to [dbo].[CreditPoR]'
GO
ALTER TABLE [dbo].[CreditPoR]
	ADD
	CONSTRAINT [PK_CreditPoR]
	PRIMARY KEY
	CLUSTERED
	([ID])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_CreditPoR_DateCreated] to [dbo].[CreditPoR]
Print 'Add Default Constraint [DF_CreditPoR_DateCreated] to [dbo].[CreditPoR]'
GO
ALTER TABLE [dbo].[CreditPoR]
	ADD
	CONSTRAINT [DF_CreditPoR_DateCreated]
	DEFAULT (getdate()) FOR [DateCreated]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_CreditPoR_IsPoRAvailable] to [dbo].[CreditPoR]
Print 'Add Default Constraint [DF_CreditPoR_IsPoRAvailable] to [dbo].[CreditPoR]'
GO
ALTER TABLE [dbo].[CreditPoR]
	ADD
	CONSTRAINT [DF_CreditPoR_IsPoRAvailable]
	DEFAULT ((0)) FOR [IsPoRAvailable]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Extended Property [MS_Description] on [dbo].[CreditPoR]
Print 'Create Extended Property [MS_Description] on [dbo].[CreditPoR]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to lp_common..service_rate_class table', 'SCHEMA', N'dbo', 'TABLE', N'CreditPoR', 'COLUMN', N'ServiceClassID'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

