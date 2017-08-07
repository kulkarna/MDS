USE [Lp_commissions]
GO

INSERT INTO [dbo].[reason_code]
           ([reason_code],[reason_code_descp])
     VALUES
           ('C6000','Bonus Payment')
GO

INSERT INTO [dbo].[payment_option]
           ([payment_option_code],[payment_option_value],[payment_option_descp],[active],[payment_option_type_id],[date_created],[username])
     VALUES
           ('Bonus','0','Bonus Payment',1,1,getdate(),'sjarvis')
GO

alter table vendor_report_date_option add [ForBonusTransaction] bit 
GO 

UPDATE       vendor_report_date_option
SET                ForBonusTransaction = 0
GO


alter table vendor_payment_option add [ForBonusTransaction] bit 
GO 

UPDATE       vendor_payment_option
SET                ForBonusTransaction = 0
GO

INSERT INTO [dbo].[payment_option_setting]
           ([payment_option_id], [payment_option_param_id], [payment_option_param_value], [payment_option_def_id], [calculation_freq_id], [payment_freq_id] ,[active], [priority], [date_created], [username])
     VALUES (30 ,0 ,null ,11 ,0 ,0 ,1 ,0 ,getdate() ,'sjarvis')
GO