/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[MtMAccount]

     Make LPCNOCSQL9\TRANSACTIONS.lp_MtM Equal vm2lpcnocsql9\TRANSACTIONS.lp_MtM_UAT

   AUTHOR:	[Insert Author Name]

   DATE:	3/13/2013 1:32:30 PM

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
USE [lp_MtM]
GO

BEGIN TRAN
GO

-- Add Column DealPricingID to [dbo].[MtMAccount]
Print 'DROP Column DealPricingID to [dbo].[MtMAccount]'
GO
ALTER TABLE [dbo].[MtMAccount]
	DROP [DealPricingID]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

