USE [lp_commissions]
GO

ALTER TABLE dbo.zaudit_vendor_payment_freq
ADD package_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_freq
ADD interval_type_id int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_freq
ADD interval int null 
GO 

ALTER TABLE dbo.zaudit_vendor_payment_freq
ADD date_end datetime null 
GO 
