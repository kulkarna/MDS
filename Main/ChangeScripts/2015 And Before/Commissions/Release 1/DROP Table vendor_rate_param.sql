USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_rate_param_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_rate_param] DROP CONSTRAINT [DF_vendor_rate_param_active]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_rate_param_date_created]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_rate_param] DROP CONSTRAINT [DF_vendor_rate_param_date_created]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[vendor_rate_param]') AND type in (N'U'))
DROP TABLE [dbo].[vendor_rate_param]
GO


