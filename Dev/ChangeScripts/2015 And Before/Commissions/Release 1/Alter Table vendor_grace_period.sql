USE [lp_commissions]
GO

ALTER TABLE dbo.vendor_grace_period
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_grace_period
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.vendor_grace_period
ADD date_option int null 
GO 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_vendor_grace_period_grace_period]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_grace_period] DROP CONSTRAINT [DF_vendor_grace_period_grace_period]
END
GO

ALTER TABLE dbo.vendor_grace_period
ALTER COLUMN grace_period float null 
GO 

ALTER TABLE [dbo].[vendor_grace_period] ADD  CONSTRAINT [DF_vendor_grace_period_grace_period]  DEFAULT ((0)) FOR [grace_period]
GO


