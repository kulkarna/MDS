USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_report_date_param_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_report_date_option_param] DROP CONSTRAINT [DF_vendor_report_date_param_active]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_report_date_param_date_created]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_report_date_option_param] DROP CONSTRAINT [DF_vendor_report_date_param_date_created]
END

GO

USE [lp_commissions]
GO

/****** Object:  Table [dbo].[vendor_report_date_option_param]    Script Date: 11/29/2012 00:41:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vendor_report_date_option_param]') AND type in (N'U'))
DROP TABLE [dbo].[vendor_report_date_option_param]
GO


