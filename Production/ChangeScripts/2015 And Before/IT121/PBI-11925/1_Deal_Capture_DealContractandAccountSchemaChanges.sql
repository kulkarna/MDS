/* ------------------------------------------------------------

   DESCRIPTION:  Schema Synchronization Script for Object(s) 

    triggers:
        [dbo].[trg_deal_contract_account_ins]

    tables:
        [dbo].[deal_contract], [dbo].[deal_contract_account]

     Make LPCD7X64-013\MSSQL2008.Lp_deal_capture Equal (local).Lp_deal_capture

   AUTHOR:	[Insert Author Name]

   DATE:	8/2/2013 10:12:11 AM

   LEGAL:	2013 [Insert Company Name]

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
USE [Lp_deal_capture]
GO

BEGIN TRAN
GO

-- Drop Trigger [dbo].[trg_deal_contract_account_ins]
Print 'Drop Trigger [dbo].[trg_deal_contract_account_ins]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[trg_deal_contract_account_ins]') AND [type]='TR'))
DROP TRIGGER [dbo].[trg_deal_contract_account_ins]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index [deal_contract_idx1] from [dbo].[deal_contract]
Print 'Drop Index [deal_contract_idx1] from [dbo].[deal_contract]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_idx1' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract]')))
DROP INDEX [deal_contract_idx1] ON [dbo].[deal_contract]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index [deal_contract_idx] from [dbo].[deal_contract]
Print 'Drop Index [deal_contract_idx] from [dbo].[deal_contract]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_idx' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract]')))
DROP INDEX [deal_contract_idx] ON [dbo].[deal_contract]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index [deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status] from [dbo].[deal_contract]
Print 'Drop Index [deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status] from [dbo].[deal_contract]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract]')))
DROP INDEX [deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status] ON [dbo].[deal_contract]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Default Constraint [DF_deal_contract_account_IsForSave] from [dbo].[deal_contract_account]
Print 'Drop Default Constraint [DF_deal_contract_account_IsForSave] from [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[dbo].[DF_deal_contract_account_IsForSave]') AND [parent_object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
ALTER TABLE [dbo].[deal_contract_account] DROP CONSTRAINT [DF_deal_contract_account_IsForSave]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index [deal_contract_account_idx3] from [dbo].[deal_contract_account]
Print 'Drop Index [deal_contract_account_idx3] from [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_account_idx3' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
DROP INDEX [deal_contract_account_idx3] ON [dbo].[deal_contract_account]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index [deal_contract_account_idx2] from [dbo].[deal_contract_account]
Print 'Drop Index [deal_contract_account_idx2] from [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_account_idx2' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
DROP INDEX [deal_contract_account_idx2] ON [dbo].[deal_contract_account]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index [deal_contract_account_idx1] from [dbo].[deal_contract_account]
Print 'Drop Index [deal_contract_account_idx1] from [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_account_idx1' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
DROP INDEX [deal_contract_account_idx1] ON [dbo].[deal_contract_account]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop Index [deal_contract_account_idx] from [dbo].[deal_contract_account]
Print 'Drop Index [deal_contract_account_idx] from [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_account_idx' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
DROP INDEX [deal_contract_account_idx] ON [dbo].[deal_contract_account]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Preserve data from [dbo].[deal_contract_account] into a temporary table temp2034822311
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U'))
EXEC sp_rename @objname = N'[dbo].[deal_contract_account]', @newname = N'temp2034822311', @objtype = 'OBJECT'
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[deal_contract_account]
Print 'Create Table [dbo].[deal_contract_account]'
GO
IF NOT (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U'))
CREATE TABLE [dbo].[deal_contract_account] (
		[contract_nbr]                  [char](12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[contract_type]                 [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[account_number]                [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[status]                        [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[account_id]                    [char](12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[retail_mkt_id]                 [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[utility_id]                    [char](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[account_type]                  [int] NULL,
		[product_id]                    [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[rate_id]                       [int] NOT NULL,
		[rate]                          [float] NOT NULL,
		[account_name_link]             [int] NOT NULL,
		[customer_name_link]            [int] NOT NULL,
		[customer_address_link]         [int] NOT NULL,
		[customer_contact_link]         [int] NOT NULL,
		[billing_address_link]          [int] NOT NULL,
		[billing_contact_link]          [int] NOT NULL,
		[owner_name_link]               [int] NOT NULL,
		[service_address_link]          [int] NOT NULL,
		[business_type]                 [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[business_activity]             [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[additional_id_nbr_type]        [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[additional_id_nbr]             [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[contract_eff_start_date]       [datetime] NOT NULL,
		[enrollment_type]               [int] NULL,
		[term_months]                   [int] NOT NULL,
		[date_end]                      [datetime] NOT NULL,
		[date_deal]                     [datetime] NOT NULL,
		[date_created]                  [datetime] NOT NULL,
		[date_submit]                   [datetime] NOT NULL,
		[sales_channel_role]            [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[username]                      [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[sales_rep]                     [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[origin]                        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[grace_period]                  [int] NOT NULL,
		[chgstamp]                      [smallint] NOT NULL,
		[requested_flow_start_date]     [datetime] NULL,
		[deal_type]                     [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[customer_code]                 [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[customer_group]                [char](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SSNClear]                      [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SSNEncrypted]                  [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CreditScoreEncrypted]          [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[HeatIndexSourceID]             [int] NULL,
		[HeatRate]                      [decimal](9, 2) NULL,
		[evergreen_option_id]           [int] NULL,
		[evergreen_commission_end]      [datetime] NULL,
		[residual_option_id]            [int] NULL,
		[residual_commission_end]       [datetime] NULL,
		[initial_pymt_option_id]        [int] NULL,
		[evergreen_commission_rate]     [float] NULL,
		[zone]                          [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TaxStatus]                     [int] NULL,
		[PriceID]                       [bigint] NULL,
		[RatesString]                   [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[IsForSave]                     [bit] NULL,
		[ID]                            [int] IDENTITY(1, 1) NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Add Default Constraint [DF_deal_contract_account_IsForSave] to [dbo].[deal_contract_account]
Print 'Add Default Constraint [DF_deal_contract_account_IsForSave] to [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.objects WHERE [object_id]=OBJECT_ID(N'[dbo].[DF_deal_contract_account_IsForSave]') AND [parent_object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
ALTER TABLE [dbo].[deal_contract_account]
	ADD
	CONSTRAINT [DF_deal_contract_account_IsForSave]
	DEFAULT ((1)) FOR [IsForSave]
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Disable constraints
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U'))
ALTER TABLE [dbo].[deal_contract_account] NOCHECK CONSTRAINT ALL
GO

-- Restore data
IF OBJECT_ID('[dbo].temp2034822311') IS NOT NULL AND EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')
EXEC sp_executesql N'
INSERT INTO [dbo].[deal_contract_account] ([contract_nbr], [contract_type], [account_number], [status], [account_id], [retail_mkt_id], [utility_id], [account_type], [product_id], [rate_id], [rate], [account_name_link], [customer_name_link], [customer_address_link], [customer_contact_link], [billing_address_link], [billing_contact_link], [owner_name_link], [service_address_link], [business_type], [business_activity], [additional_id_nbr_type], [additional_id_nbr], [contract_eff_start_date], [enrollment_type], [term_months], [date_end], [date_deal], [date_created], [date_submit], [sales_channel_role], [username], [sales_rep], [origin], [grace_period], [chgstamp], [requested_flow_start_date], [deal_type], [customer_code], [customer_group], [SSNClear], [SSNEncrypted], [CreditScoreEncrypted], [HeatIndexSourceID], [HeatRate], [evergreen_option_id], [evergreen_commission_end], [residual_option_id], [residual_commission_end], [initial_pymt_option_id], [evergreen_commission_rate], [zone], [TaxStatus], [PriceID], [RatesString], [IsForSave])
   SELECT [contract_nbr], [contract_type], [account_number], [status], [account_id], [retail_mkt_id], [utility_id], [account_type], [product_id], [rate_id], [rate], [account_name_link], [customer_name_link], [customer_address_link], [customer_contact_link], [billing_address_link], [billing_contact_link], [owner_name_link], [service_address_link], [business_type], [business_activity], [additional_id_nbr_type], [additional_id_nbr], [contract_eff_start_date], [enrollment_type], [term_months], [date_end], [date_deal], [date_created], [date_submit], [sales_channel_role], [username], [sales_rep], [origin], [grace_period], [chgstamp], [requested_flow_start_date], [deal_type], [customer_code], [customer_group], [SSNClear], [SSNEncrypted], [CreditScoreEncrypted], [HeatIndexSourceID], [HeatRate], [evergreen_option_id], [evergreen_commission_end], [residual_option_id], [residual_commission_end], [initial_pymt_option_id], [evergreen_commission_rate], [zone], [TaxStatus], [PriceID], [RatesString], [IsForSave] FROM [dbo].temp2034822311
'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Enable backward constraints
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U'))
ALTER TABLE [dbo].[deal_contract_account] CHECK CONSTRAINT ALL
GO

-- Add Primary Key [PK_deal_contract_account] to [dbo].[deal_contract_account]
Print 'Add Primary Key [PK_deal_contract_account] to [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'PK_deal_contract_account' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
ALTER TABLE [dbo].[deal_contract_account]
	ADD
	CONSTRAINT [PK_deal_contract_account]
	PRIMARY KEY
	NONCLUSTERED
	([contract_nbr], [account_number])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [deal_contract_account_idx] on [dbo].[deal_contract_account]
Print 'Create Index [deal_contract_account_idx] on [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_account_idx' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
CREATE UNIQUE CLUSTERED INDEX [deal_contract_account_idx]
	ON [dbo].[deal_contract_account] ([contract_nbr], [account_number])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [deal_contract_account_idx1] on [dbo].[deal_contract_account]
Print 'Create Index [deal_contract_account_idx1] on [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_account_idx1' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
CREATE NONCLUSTERED INDEX [deal_contract_account_idx1]
	ON [dbo].[deal_contract_account] ([account_number], [contract_nbr])
	WITH ( ALLOW_PAGE_LOCKS = OFF)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [deal_contract_account_idx2] on [dbo].[deal_contract_account]
Print 'Create Index [deal_contract_account_idx2] on [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_account_idx2' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
CREATE NONCLUSTERED INDEX [deal_contract_account_idx2]
	ON [dbo].[deal_contract_account] ([account_id], [account_number])
	WITH ( ALLOW_PAGE_LOCKS = OFF)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [deal_contract_account_idx3] on [dbo].[deal_contract_account]
Print 'Create Index [deal_contract_account_idx3] on [dbo].[deal_contract_account]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract_account]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_account_idx3' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract_account]')))
CREATE NONCLUSTERED INDEX [deal_contract_account_idx3]
	ON [dbo].[deal_contract_account] ([sales_channel_role])
	WITH ( ALLOW_PAGE_LOCKS = OFF)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop the temporary table temp2034822311
IF OBJECT_ID('[dbo].temp2034822311') IS NOT NULL DROP TABLE [dbo].temp2034822311
GO

-- Preserve data from [dbo].[deal_contract] into a temporary table temp2018822254
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U'))
EXEC sp_rename @objname = N'[dbo].[deal_contract]', @newname = N'temp2018822254', @objtype = 'OBJECT'
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Table [dbo].[deal_contract]
Print 'Create Table [dbo].[deal_contract]'
GO
IF NOT (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U'))
CREATE TABLE [dbo].[deal_contract] (
		[contract_nbr]                  [char](12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[contract_type]                 [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[status]                        [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[retail_mkt_id]                 [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[utility_id]                    [char](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[account_type]                  [int] NULL,
		[product_id]                    [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[rate_id]                       [int] NOT NULL,
		[rate]                          [float] NOT NULL,
		[customer_name_link]            [int] NOT NULL,
		[customer_address_link]         [int] NOT NULL,
		[customer_contact_link]         [int] NOT NULL,
		[billing_address_link]          [int] NOT NULL,
		[billing_contact_link]          [int] NOT NULL,
		[owner_name_link]               [int] NOT NULL,
		[service_address_link]          [int] NOT NULL,
		[business_type]                 [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[business_activity]             [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[additional_id_nbr_type]        [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[additional_id_nbr]             [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[contract_eff_start_date]       [datetime] NOT NULL,
		[enrollment_type]               [int] NULL,
		[term_months]                   [int] NOT NULL,
		[date_end]                      [datetime] NOT NULL,
		[date_deal]                     [datetime] NOT NULL,
		[date_created]                  [datetime] NOT NULL,
		[date_submit]                   [datetime] NOT NULL,
		[sales_channel_role]            [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[username]                      [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[sales_rep]                     [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[origin]                        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[grace_period]                  [int] NOT NULL,
		[chgstamp]                      [smallint] NOT NULL,
		[contract_rate_type]            [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[requested_flow_start_date]     [datetime] NULL,
		[deal_type]                     [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[customer_code]                 [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[customer_group]                [char](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SSNClear]                      [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SSNEncrypted]                  [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CreditScoreEncrypted]          [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[HeatIndexSourceID]             [int] NULL,
		[HeatRate]                      [decimal](9, 2) NULL,
		[evergreen_option_id]           [int] NULL,
		[evergreen_commission_end]      [datetime] NULL,
		[residual_option_id]            [int] NULL,
		[residual_commission_end]       [datetime] NULL,
		[initial_pymt_option_id]        [int] NULL,
		[sales_manager]                 [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[evergreen_commission_rate]     [float] NULL,
		[TaxStatus]                     [int] NULL,
		[PriceID]                       [bigint] NULL,
		[PriceTier]                     [int] NULL,
		[RatesString]                   [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ID]                            [int] IDENTITY(1, 1) NOT NULL
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Disable constraints
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U'))
ALTER TABLE [dbo].[deal_contract] NOCHECK CONSTRAINT ALL
GO

-- Restore data
IF OBJECT_ID('[dbo].temp2018822254') IS NOT NULL AND EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U')
EXEC sp_executesql N'
INSERT INTO [dbo].[deal_contract] ([contract_nbr], [contract_type], [status], [retail_mkt_id], [utility_id], [account_type], [product_id], [rate_id], [rate], [customer_name_link], [customer_address_link], [customer_contact_link], [billing_address_link], [billing_contact_link], [owner_name_link], [service_address_link], [business_type], [business_activity], [additional_id_nbr_type], [additional_id_nbr], [contract_eff_start_date], [enrollment_type], [term_months], [date_end], [date_deal], [date_created], [date_submit], [sales_channel_role], [username], [sales_rep], [origin], [grace_period], [chgstamp], [contract_rate_type], [requested_flow_start_date], [deal_type], [customer_code], [customer_group], [SSNClear], [SSNEncrypted], [CreditScoreEncrypted], [HeatIndexSourceID], [HeatRate], [evergreen_option_id], [evergreen_commission_end], [residual_option_id], [residual_commission_end], [initial_pymt_option_id], [sales_manager], [evergreen_commission_rate], [TaxStatus], [PriceID], [PriceTier], [RatesString])
   SELECT [contract_nbr], [contract_type], [status], [retail_mkt_id], [utility_id], [account_type], [product_id], [rate_id], [rate], [customer_name_link], [customer_address_link], [customer_contact_link], [billing_address_link], [billing_contact_link], [owner_name_link], [service_address_link], [business_type], [business_activity], [additional_id_nbr_type], [additional_id_nbr], [contract_eff_start_date], [enrollment_type], [term_months], [date_end], [date_deal], [date_created], [date_submit], [sales_channel_role], [username], [sales_rep], [origin], [grace_period], [chgstamp], [contract_rate_type], [requested_flow_start_date], [deal_type], [customer_code], [customer_group], [SSNClear], [SSNEncrypted], [CreditScoreEncrypted], [HeatIndexSourceID], [HeatRate], [evergreen_option_id], [evergreen_commission_end], [residual_option_id], [residual_commission_end], [initial_pymt_option_id], [sales_manager], [evergreen_commission_rate], [TaxStatus], [PriceID], [PriceTier], [RatesString] FROM [dbo].temp2018822254
'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Enable backward constraints
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U'))
ALTER TABLE [dbo].[deal_contract] CHECK CONSTRAINT ALL
GO

-- Add Primary Key [PK_deal_contract] to [dbo].[deal_contract]
Print 'Add Primary Key [PK_deal_contract] to [dbo].[deal_contract]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'PK_deal_contract' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract]')))
ALTER TABLE [dbo].[deal_contract]
	ADD
	CONSTRAINT [PK_deal_contract]
	PRIMARY KEY
	NONCLUSTERED
	([contract_nbr])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status] on [dbo].[deal_contract]
Print 'Create Index [deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status] on [dbo].[deal_contract]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract]')))
CREATE NONCLUSTERED INDEX [deal_contract__sales_channel_role_contract_nbr_I_date_deal_Status]
	ON [dbo].[deal_contract] ([sales_channel_role], [contract_nbr])
	INCLUDE ([status], [date_deal])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [deal_contract_idx] on [dbo].[deal_contract]
Print 'Create Index [deal_contract_idx] on [dbo].[deal_contract]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_idx' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract]')))
CREATE UNIQUE CLUSTERED INDEX [deal_contract_idx]
	ON [dbo].[deal_contract] ([contract_nbr])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Index [deal_contract_idx1] on [dbo].[deal_contract]
Print 'Create Index [deal_contract_idx1] on [dbo].[deal_contract]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[deal_contract]') AND [type]='U')) AND NOT (EXISTS (SELECT * FROM sys.indexes WHERE [name]=N'deal_contract_idx1' AND [object_id]=OBJECT_ID(N'[dbo].[deal_contract]')))
CREATE UNIQUE NONCLUSTERED INDEX [deal_contract_idx1]
	ON [dbo].[deal_contract] ([status], [contract_nbr])
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Drop the temporary table temp2018822254
IF OBJECT_ID('[dbo].temp2018822254') IS NOT NULL DROP TABLE [dbo].temp2018822254
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Trigger [dbo].[trg_deal_contract_account_ins]
Print 'Create Trigger [dbo].[trg_deal_contract_account_ins]'
GO
IF NOT (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[trg_deal_contract_account_ins]') AND [type]='TR'))
EXEC sp_executesql N'-- =============================================
-- Author		: Jose Munoz - SWCS
-- Create date	: 08/19/2010
-- Ticket		:
-- Description	: Validate account number with the utility number definition
-- =============================================
CREATE TRIGGER [dbo].[trg_deal_contract_account_ins]
   ON  [lp_deal_capture].[dbo].[deal_contract_account]
   AFTER INSERT
AS 
BEGIN
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @AccountNumber			varchar(30)
		,@UtilityCode				varchar(15)
		,@message					varchar(200)
		,@FlagErrorLenAccount		bit
		,@FlagErrorLenPrefix		bit
		
	SELECT 	@AccountNumber			= ltrim(rtrim(ins.account_number))
		,@UtilityCode				= ltrim(rtrim(ins.utility_id))
		,@FlagErrorLenAccount		= case when ((LEN(ins.account_number)	<> uti.AccountLength) AND (uti.AccountLength <> 0)) then 1 else 0 end
		,@FlagErrorLenPrefix		= case when ((LEFT(ins.account_number, LEN(uti.AccountNumberPrefix)) <> uti.AccountNumberPrefix)
												AND (LTRIM(RTRIM(uti.AccountNumberPrefix)) <> '''')) then 1 else 0 end
	FROM inserted ins
	INNER JOIN Libertypower..Utility uti WITH(NOLOCK)
	ON uti.UtilityCode				= ins.utility_id
	WHERE ((LEN(ins.account_number)	<> uti.AccountLength) AND (uti.AccountLength <> 0))
	OR  ((LEFT(ins.account_number, LEN(uti.AccountNumberPrefix)) <> uti.AccountNumberPrefix)
		AND (LTRIM(RTRIM(uti.AccountNumberPrefix)) <> ''''))
	
	IF @@ROWCOUNT > 0
	begin
	
		set @message = ''The account number '' + @AccountNumber + ''('' + @UtilityCode + '') does not meet the utility number definition. '' 
					+ case	when	(@FlagErrorLenAccount = 1 and @FlagErrorLenPrefix = 1) then ''(The Account Length and the Account Number Prefix are not valid)''
							when	(@FlagErrorLenAccount = 1 and @FlagErrorLenPrefix = 0) then ''(The Account Length is invalid)''
							when	(@FlagErrorLenAccount = 0 and @FlagErrorLenPrefix = 1) then ''(The Account Number Prefix is invalid)'' end
		rollback
		raiserror 26001 @message
	end

	SET NOCOUNT OFF;
    -- Insert statements for trigger here
END'
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

