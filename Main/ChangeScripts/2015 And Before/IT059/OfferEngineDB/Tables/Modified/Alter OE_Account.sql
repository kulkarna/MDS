/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    tables:
        [dbo].[OE_ACCOUNT]

     Make VM3LPCNOCSQL1.OfferEngineDB Equal (local).OfferEngineDB

   AUTHOR:	[Insert Author Name]

   DATE:	11/27/2012 4:05:02 PM

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
USE [OfferEngineDB]
GO

BEGIN TRAN
GO

-- Add Default Constraint DF_OE_ACCOUNT_ICAP to [dbo].[OE_ACCOUNT]
Print 'Add Default Constraint DF_OE_ACCOUNT_ICAP to [dbo].[OE_ACCOUNT]'
GO
ALTER TABLE [dbo].[OE_ACCOUNT]
	ADD
	CONSTRAINT [DF_OE_ACCOUNT_ICAP]
	DEFAULT ((-1)) FOR [ICAP]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint DF_OE_ACCOUNT_TCAP to [dbo].[OE_ACCOUNT]
Print 'Add Default Constraint DF_OE_ACCOUNT_TCAP to [dbo].[OE_ACCOUNT]'
GO
ALTER TABLE [dbo].[OE_ACCOUNT]
	ADD
	CONSTRAINT [DF_OE_ACCOUNT_TCAP]
	DEFAULT ((-1)) FOR [TCAP]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF
GO


