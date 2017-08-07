USE [lp_commissions]
GO

ALTER TABLE dbo.zaudit_vendor_payment_option
ADD package_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_option
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_option
ADD date_end datetime null 
GO 
