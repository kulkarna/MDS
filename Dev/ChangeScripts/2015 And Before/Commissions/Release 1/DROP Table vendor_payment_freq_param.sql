USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_payment_freq_param_is_param_value_fixed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_payment_freq_param] DROP CONSTRAINT [DF_vendor_payment_freq_param_is_param_value_fixed]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_payment_freq_param_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_payment_freq_param] DROP CONSTRAINT [DF_vendor_payment_freq_param_active]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_payment_freq_param_date_created]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_payment_freq_param] DROP CONSTRAINT [DF_vendor_payment_freq_param_date_created]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vendor_payment_freq_param]') AND type in (N'U'))
DROP TABLE [dbo].[vendor_payment_freq_param]
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_zaudit_vendor_payment_freq_param_date_audit]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[zaudit_vendor_payment_freq_param] DROP CONSTRAINT [DF_zaudit_vendor_payment_freq_param_date_audit]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[zaudit_vendor_payment_freq_param]') AND type in (N'U'))
DROP TABLE [dbo].[zaudit_vendor_payment_freq_param]
GO


--USE [lp_commissions]
--GO

--/****** Object:  Table [dbo].[vendor_payment_freq_param]    Script Date: 11/29/2012 00:41:11 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--SET ANSI_PADDING ON
--GO

--CREATE TABLE [dbo].[vendor_payment_freq_param](
--	[freq_param_id] [int] IDENTITY(1,1) NOT NULL,
--	[vendor_payment_freq_id] [int] NOT NULL,
--	[payment_option_param_id] [int] NOT NULL,
--	[payment_option_param_value] [varchar](150) NULL,
--	[is_param_value_fixed] [bit] NOT NULL,
--	[active] [bit] NOT NULL,
--	[date_created] [datetime] NOT NULL,
--	[username] [varchar](50) NOT NULL,
--	[date_modified] [datetime] NULL,
--	[modified_by] [varchar](50) NULL,
--	[param_operator] [int] NULL,
-- CONSTRAINT [PK_vendor_payment_freq_param] PRIMARY KEY CLUSTERED 
--(
--	[freq_param_id] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--SET ANSI_PADDING OFF
--GO

--ALTER TABLE [dbo].[vendor_payment_freq_param] ADD  CONSTRAINT [DF_vendor_payment_freq_param_is_param_value_fixed]  DEFAULT ((0)) FOR [is_param_value_fixed]
--GO

--ALTER TABLE [dbo].[vendor_payment_freq_param] ADD  CONSTRAINT [DF_vendor_payment_freq_param_active]  DEFAULT ((1)) FOR [active]
--GO

--ALTER TABLE [dbo].[vendor_payment_freq_param] ADD  CONSTRAINT [DF_vendor_payment_freq_param_date_created]  DEFAULT (getdate()) FOR [date_created]
--GO


