USE [lp_commissions]
GO

ALTER TABLE dbo.vendor_report_date_option
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_report_date_option
ADD interval_type_id int null 
GO 


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__vendor_re__grace__12F3B011]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[vendor_report_date_option] DROP CONSTRAINT [DF__vendor_re__grace__12F3B011]
END
GO

ALTER TABLE dbo.vendor_report_date_option
ALTER COLUMN grace_period float null 
GO 

ALTER TABLE [dbo].[vendor_report_date_option] ADD  DEFAULT ((0)) FOR [grace_period]
GO


