USE [Integration]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'U' AND name = 'LPIgnoreEDITransactionRule')
   DROP TABLE [dbo].[LPIgnoreEDITransactionRule]

/****** Object:  Table [dbo].[LPIgnoreEDITransactionRule]    Script Date: 6/30/2015 10:16:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[LPIgnoreEDITransactionRule](
	[LPIgnoreEDITransactionRuleID] [int] IDENTITY(1,1) NOT NULL,
	[LPTransactionID] [int] NULL,
	[Status] [varchar](15) NULL,
	[SubStatus] [varchar](15) NULL,
	[TransactionFromDate] [datetime] NULL,
	[TransactionToDate] [datetime] NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[IsActive] [tinyint] NULL
) 

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[LPIgnoreEDITransactionRule] ADD  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [dbo].[LPIgnoreEDITransactionRule] ADD  DEFAULT ((1)) FOR [IsActive]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'LP_Transaction_ID from lp_transaction_mapping table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LPIgnoreEDITransactionRule', @level2type=N'COLUMN',@level2name=N'LPTransactionID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Account current Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LPIgnoreEDITransactionRule', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Account current Sub Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LPIgnoreEDITransactionRule', @level2type=N'COLUMN',@level2name=N'SubStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'transaction date for ignoring the transcations from' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LPIgnoreEDITransactionRule', @level2type=N'COLUMN',@level2name=N'TransactionFromDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'transaction date for ignoring the transcations to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LPIgnoreEDITransactionRule', @level2type=N'COLUMN',@level2name=N'TransactionToDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'mapping rule is Active if 1 and inactive if 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LPIgnoreEDITransactionRule', @level2type=N'COLUMN',@level2name=N'IsActive'
GO


