USE [lp_commissions]
GO

ALTER TABLE dbo.vendor_payment_option
ADD package_id int null 
GO 

ALTER TABLE dbo.vendor_payment_option
ADD interval_type_id int null 
GO 

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__vendor_pa__group__3568C3A6]') AND type = 'D')
BEGIN
ALTER TABLE dbo.vendor_payment_option DROP CONSTRAINT DF__vendor_pa__group__3568C3A6
END
GO

--ALTER TABLE dbo.vendor_payment_option
--DROP COLUMN group_id 
--GO 
