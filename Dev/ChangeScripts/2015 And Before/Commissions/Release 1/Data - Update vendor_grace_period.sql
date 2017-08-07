USE Lp_commissions
GO

UPDATE Lp_commissions..vendor_grace_period
SET date_option = 3 , date_modified = GETDATE() , modified_by = 'System'
WHERE date_option is null 
GO
