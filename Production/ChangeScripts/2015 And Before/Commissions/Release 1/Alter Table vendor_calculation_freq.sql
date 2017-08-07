USE [lp_commissions]
GO


--ALTER TABLE dbo.vendor_calculation_freq
--DROP COLUMN group_id 
--GO 

ALTER TABLE dbo.vendor_calculation_freq
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_calculation_freq
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.vendor_calculation_freq
ADD interval float null 
GO 

--ALTER TABLE dbo.vendor_calculation_freq
--ALTER COLUMN interval float null 
--GO 