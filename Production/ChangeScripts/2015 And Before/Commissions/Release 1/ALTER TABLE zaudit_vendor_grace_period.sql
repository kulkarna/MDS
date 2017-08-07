USE [lp_commissions]
GO

ALTER TABLE dbo.zaudit_vendor_grace_period
ADD package_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_grace_period
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_grace_period
ADD date_option int null 
GO 

ALTER TABLE dbo.zaudit_vendor_grace_period
ALTER COLUMN grace_period float null 
GO 

ALTER TABLE dbo.zaudit_vendor_grace_period
ADD date_end datetime null 
GO 
