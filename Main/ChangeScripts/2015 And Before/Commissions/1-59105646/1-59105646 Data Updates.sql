Use lp_commissions 
GO 

update lp_commissions..payment_option_param 
set source_type_name = 'LibertyPower.Business.PartnerManagement.Commissions.TransactionDetail'
	, source_member = 'PaymentOptionID'
where payment_option_param_id = 14

update lp_commissions..payment_option_param 
set source_type_name = 'LibertyPower.Business.PartnerManagement.Commissions.TransactionDetail'
	, source_member = 'PaymentOptionDefinitionID'
	, data_set_type_name = 'LibertyPower.Business.PartnerManagement.Commissions.PaymentOptionDefinitionFactory'
	, data_set_member = 'GetPaymentOptionDefListLookUp'
	--, inactive = 0
where payment_option_param_id = 15


SET IDENTITY_INSERT [lp_commissions].[dbo].[payment_option_param] ON

--INSERT INTO [lp_commissions].[dbo].[payment_option_param]
--           ([payment_option_param_id],[payment_option_param_code],[payment_option_param_descp],[source_type_name],[source_member],[inactive],[dataset_type_name],[dataset_member])
--     VALUES ( 17, 'AccountNumber', 'AccountNumber', 'LibertyPower.Business.PartnerManagement.Commissions.Account', 'AccountNumber',	0 , null , null ) 
--	GO 
	
--INSERT INTO [lp_commissions].[dbo].[payment_option_param]
--           ([payment_option_param_id],[payment_option_param_code],[payment_option_param_descp],[source_type_name],[source_member],[inactive],[dataset_type_name],[dataset_member])
--     VALUES ( 18, 'ContractNumber', 'ContractNumber', 'LibertyPower.Business.PartnerManagement.Commissions.Account', 'ContractNumber',	0 , null , null ) 
--	 GO
	 
INSERT INTO [lp_commissions].[dbo].[payment_option_param]
           ([payment_option_param_id],[payment_option_param_code],[payment_option_param_descp],[source_type_name],[source_member],[inactive],[dataset_type_name],[dataset_member])
     VALUES ( 19, 'PaymentTypeID', 'PaymentType', 'LibertyPower.Business.PartnerManagement.Commissions.TransactionDetail', 'PaymentTypeID',	0 , 'LibertyPower.Business.PartnerManagement.Commissions.PaymentOptionTypeFactory' , 'GetPaymentOptionTypes' ) 
     GO 
     
SET IDENTITY_INSERT [lp_commissions].[dbo].[payment_option_param] OFF     
