
-- =============================================
-- Created by: Isabelle Tamanini 11/30/2011
-- IT079
-- Usp that gathers proc calls and scripts to perform a
-- complete testing of the system's main functionalities
-- =============================================     
-- SELECT TOP(100) * from lp_account..account_bak where account_id = '2011-00586011'
-- SELECT TOP(100) * from libertypower..account where accountidlegacy = '2011-00586011'
-- SELECT TOP(100) * from libertypower..account where accountidlegacy = '2011-0586011'

CREATE PROC [dbo].[usp_DevApplicationsTest](
	@p_ContractNumber   CHAR(12)      = 'TEST1',
	@p_AccountNumber1   VARCHAR(30)   = '10443720005273213',
	@p_AccountNumber2   VARCHAR(30)   = '10443720005273214',	
	@p_AccountId1       VARCHAR(30)   = '2011-0586011',
	@p_AccountId2       VARCHAR(30)   = '2011-0586012',
	@p_UsernameDefault  NVARCHAR(100) = 'LIBERTYPOWER\itamanini', 	
	@p_AccountNumberAddOn VARCHAR(30) = '10443720005273215',
	@p_AccountIdAddOn	  VARCHAR(30) = '2011-0586013',
	@p_TestDealEntry         BIT	  = 1,
	@p_TestDealScreening     BIT	  = 1,
	@p_TestChangeOfOwnership BIT      = 1,
	@p_TestRenewal			 BIT      = 1
)
AS
BEGIN

	IF (@p_TestDealEntry = 1)
	BEGIN
		--INSERT CONTRACT IN DEAL CAPTURE'S DATABASE
		exec lp_deal_capture..usp_contract_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber, @p_contract_type=N'VOICE',@p_result_ind=N'Y',@p_contract_rate_type=default
			 
		exec lp_deal_capture..usp_contract_comment_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_comment=N''

		exec lp_deal_capture..usp_contract_general_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_business_type=N'CORPORATION',@p_business_activity=N'NONE',@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'',@p_sales_channel_role=N'Sales Channel/outboundtelesales',@p_sales_rep=N'Al Tafur',@p_account_number=N'CONTRACT',@p_date_submit=default,@p_deal_type=default,@p_result_ind=N'Y',@p_ssnClear=default,@p_ssnEncrypted=default,@p_sales_mgr=N'Dennis Manning',@p_initial_pymt_option_id=2,@p_residual_option_id=5,@p_evergreen_option_id=0,@p_residual_commission_end=default,@p_evergreen_commission_end=default,@p_evergreen_commission_rate=default,@p_tax_exempt=2

		exec lp_deal_capture..usp_contract_comment_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_comment=N''

		exec lp_deal_capture..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_name_type=N'CUSTOMER',@p_name_link=0,@p_full_name=N'C name',@p_account_number=N'CONTRACT',@p_result_ind=N'Y'

		exec lp_deal_capture..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_contact_link=N'0',@p_first_name=N'f name',@p_last_name=N'l name',@p_title=N'test',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'test@test.com',@p_birthday=N'NONE',@p_contact_type=N'CUSTOMER',@p_account_number=N'CONTRACT'

		exec lp_deal_capture..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_address_link=N'0',@p_address=N'test',@p_suite=N'1',@p_city=N'test',@p_state=N'NY',@p_zip=N'55555',@p_address_type=N'CUSTOMER',@p_account_number=N'CONTRACT'

		--ACCOUNT 1
		exec lp_deal_capture..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_address_link=N'0',@p_address=N'TEST                                              ',@p_suite=N'1                                                 ',@p_city=N'TEST                                              ',@p_state=N'TX',@p_zip=N'55555     ',@p_address_type=N'SERVICE',@p_account_number=@p_AccountNumber1

		exec lp_deal_capture..usp_contract_comment_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_comment=N''

		exec lp_deal_capture..usp_contract_pricing_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_account_type=N'1',@p_product_id=N'ONCOR_FS_ABC',@p_rate_id=N'114010301',@p_rate=N'0.05169',@p_contract_eff_start_date=N'01/01/2012',@p_enrollment_type=N'1',@p_requested_flow_start_date=N'01/02/2012',@p_term_months=N'3',@p_account_number=N'CONTRACT',@p_customer_code=N'',@p_customer_group=N'',@p_transfer_rate=N'0.05169',@p_HeatIndexSourceID=default,@p_HeatRate=default,@p_comm_cap=N'0.02',@p_contract_date=N'12/13/2011 12:00:00 AM'

		exec lp_deal_capture..usp_contract_account_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_account_number=@p_AccountNumber1,@p_utility_id=N'ONCOR',@p_zone=N'',@p_meter_number=NULL

		exec lp_deal_capture..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_name_type=N'ACCOUNT',@p_name_link=0,@p_full_name=N'C NAME',@p_account_number=@p_AccountNumber1,@p_result_ind=N'Y'

		exec lp_deal_capture..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_address_link=N'0',@p_address=N'TEST',@p_suite=N'1',@p_city=N'TEST',@p_state=N'NY',@p_zip=N'55555',@p_address_type=N'BILLING',@p_account_number=@p_AccountNumber1

		exec lp_deal_capture..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_contact_link=N'0',@p_first_name=N'F NAME',@p_last_name=N'L NAME',@p_title=N'NONE',@p_phone=N'1234567890',@p_fax=N'NONE',@p_email=N'NONE',@p_birthday=N'NONE',@p_contact_type=N'CUSTOMER',@p_account_number=@p_AccountNumber1

		--ACCOUNT 2
		exec lp_deal_capture..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_address_link=N'0',@p_address=N'TEST                                              ',@p_suite=N'1                                                 ',@p_city=N'TEST                                              ',@p_state=N'TX',@p_zip=N'55555     ',@p_address_type=N'SERVICE',@p_account_number=@p_AccountNumber2

		exec lp_deal_capture..usp_contract_comment_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_comment=N''

		exec lp_deal_capture..usp_contract_pricing_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_account_type=N'1',@p_product_id=N'ONCOR_FS_ABC',@p_rate_id=N'114010301',@p_rate=N'0.05169',@p_contract_eff_start_date=N'01/01/2012',@p_enrollment_type=N'1',@p_requested_flow_start_date=N'01/02/2012',@p_term_months=N'3',@p_account_number=N'CONTRACT',@p_customer_code=N'',@p_customer_group=N'',@p_transfer_rate=N'0.05169',@p_HeatIndexSourceID=default,@p_HeatRate=default,@p_comm_cap=N'0.02',@p_contract_date=N'12/13/2011 12:00:00 AM'

		exec lp_deal_capture..usp_contract_account_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_account_number=@p_AccountNumber2,@p_utility_id=N'ONCOR',@p_zone=N'',@p_meter_number=NULL

		exec lp_deal_capture..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_name_type=N'ACCOUNT',@p_name_link=0,@p_full_name=N'C NAME',@p_account_number=@p_AccountNumber2,@p_result_ind=N'Y'

		exec lp_deal_capture..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_address_link=N'0',@p_address=N'TEST',@p_suite=N'1',@p_city=N'TEST',@p_state=N'NY',@p_zip=N'55555',@p_address_type=N'BILLING',@p_account_number=@p_AccountNumber2

		exec lp_deal_capture..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_contact_link=N'0',@p_first_name=N'F NAME',@p_last_name=N'L NAME',@p_title=N'NONE',@p_phone=N'1234567890',@p_fax=N'NONE',@p_email=N'NONE',@p_birthday=N'NONE',@p_contact_type=N'CUSTOMER',@p_account_number=@p_AccountNumber2

		--SELECTS TO TEST CONTRACT IN DC
		select * from lp_deal_capture..deal_contract
		where contract_nbr = @p_ContractNumber

		select * from lp_deal_capture..deal_contract_account
		where contract_nbr = @p_ContractNumber
		
		--set @p_AccountId1 = (select account_id from lp_deal_capture..deal_contract_account
		--					 where account_number = @p_AccountNumber1 and utility_id = 'ONCOR')
							
		--set @p_AccountId2 = (select account_id from lp_deal_capture..deal_contract_account
		--					 where account_number = @p_AccountNumber2 and utility_id = 'ONCOR')

		--SEND CONTRACT TO LIBERTY POWER
		exec lp_deal_capture..usp_contract_comment_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_comment=N''

		exec lp_deal_capture..usp_contract_pricing_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_account_type=N'1',@p_product_id=N'ONCOR_FS_ABC',@p_rate_id=N'114010301',@p_rate=N'0.05169',@p_contract_eff_start_date=N'01/01/2012',@p_enrollment_type=N'1',@p_requested_flow_start_date=N'01/02/2012',@p_term_months=N'3',@p_account_number=N'CONTRACT',@p_customer_code=N'',@p_customer_group=N'',@p_transfer_rate=N'0.05169',@p_HeatIndexSourceID=default,@p_HeatRate=default,@p_comm_cap=N'0.02',@p_contract_date=N'12/13/2011 12:00:00 AM'

		exec lp_enrollment..usp_check_account_del_all @p_contract_nbr=@p_ContractNumber
		
		--INSERT ACCOUNT2	
		print 'ACCOUNT 2 ' + @p_AccountId2; 
		
		exec lp_account..usp_account_additional_info_ins @p_username=@p_UsernameDefault,@p_account_id=@p_AccountId2,@p_result_ind=N'N'
		
		exec lp_account..usp_account_name_insert @p_account_id=@p_AccountId2,@p_name_link=3,@p_full_name=N'C NAME'
		
		exec lp_account..usp_account_name_insert @p_account_id=@p_AccountId2,@p_name_link=1,@p_full_name=N'C NAME'
		
		exec lp_account..usp_account_address_insert @p_account_id=@p_AccountId2,@p_address_link=1,@p_address=N'D',@p_suite=N'1',@p_city=N'E',@p_state=N'NY',@p_zip=N'55555'
		
		exec lp_account..usp_account_address_insert @p_account_id=@p_AccountId2,@p_address_link=5,@p_address=N'D',@p_suite=N'1',@p_city=N'E',@p_state=N'NY',@p_zip=N'55555'
		
		exec lp_account..usp_account_address_insert @p_account_id=@p_AccountId2,@p_address_link=4,@p_address=N'D',@p_suite=N'1',@p_city=N'E',@p_state=N'NY',@p_zip=N'55555'
		
		exec lp_account..usp_account_contact_insert @p_account_id=@p_AccountId2,@p_contact_link=3,@p_first_name=N'A',@p_last_name=N'B',@p_title=N'C',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01'
		
		exec lp_account..usp_account_contact_insert @p_account_id=@p_AccountId2,@p_contact_link=1,@p_first_name=N'A',@p_last_name=N'B',@p_title=N'C',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01'
		
		exec lp_account..usp_account_status_history_ins @p_username=@p_UsernameDefault,@p_account_id=@p_AccountId2,@p_status=N'03000',@p_sub_status=N'10',@p_date_created='Dec 13 2011  2:27:51:000PM',@p_process_id=N'DEAL CAPTURE',@p_param_01=N'ONCOR',@p_param_02=N'',@p_param_03=N'',@p_param_04=N'',@p_param_05=N'',@p_param_06=N'',@p_param_07=N'',@p_param_08=N'',@p_date_eff='Dec 13 2011  2:27:51:000PM',@p_result_ind=N'N'
		
		exec lp_account..usp_account_ins @p_username=@p_UsernameDefault,@p_account_id=@p_AccountId2,@p_account_number=@p_AccountNumber2,
		@p_account_type=N'SMB',@p_status=N'03000',@p_sub_status=N'10',@p_customer_id=N' ',@p_entity_id=N'LPT',
		@p_contract_nbr=@p_ContractNumber,@p_contract_type=N'VOICE',@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',
		@p_product_id=N'ONCOR_FS_ABC',@p_rate_id=114010301,@p_rate=0.05169,
		@p_account_name_link=1,@p_customer_name_link=1,
		@p_customer_address_link=1,@p_customer_contact_link=1,
		@p_billing_address_link=1,@p_billing_contact_link=1,
		@p_owner_name_link=1,@p_service_address_link=5,
		@p_business_type=N'CORPORATION',@p_business_activity=N'CORPORATION',
		@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'',@p_contract_eff_start_date='Jan  1 2012 12:00:00:000AM',
		@p_term_months=3,@p_date_end='Apr  1 2012 12:00:00:000AM',@p_date_deal='Dec 13 2011 12:00:00:000AM',
		@p_date_created='Dec 13 2011 10:47:37:000AM',@p_date_submit='Dec 13 2011 10:47:40:000AM',
		@p_sales_channel_role=N'Sales Channel/outboundtelesales',@p_sales_rep=N'AL TAFUR',@p_origin=N'ONLINE',
		@p_annual_usage=0,@p_date_flow_start='Jan  1 1900 12:00:00:000AM',@p_date_por_enrollment='Dec 13 2011 12:00:00:000AM',
		@p_date_deenrollment='Jan  1 1900 12:00:00:000AM',@p_date_reenrollment='Jan  1 1900 12:00:00:000AM',@p_tax_status=N'FULL',
		@p_tax_float=0,@p_credit_score=0,@p_credit_agency=N'NONE',@p_por_option=N'NO',@p_billing_type=N'SC',@p_zone=N'',
		@p_service_rate_class=N'',@p_stratum_variable=N'',@p_billing_group=N'',@p_icap=N'',@p_tcap=N'',@p_load_profile=N'',
		@p_loss_code=N'',@p_meter_type=N'',@p_requested_flow_start_date='Jan  2 2012 12:00:00:000AM',@p_deal_type=N'',
		@p_enrollment_type=1,@p_customer_code=N'',@p_customer_group=N'',@p_paymentTerm=default,@p_SSNEncrypted=N'',
		@p_HeatIndexSourceID=0,@p_HeatRate=0,@p_sales_manager=N'Dennis Manning',@p_evergreen_option_id=0,
		@p_evergreen_commission_end=default,@p_evergreen_commission_rate=0,@p_residual_option_id=5,@p_residual_commission_end=default,
		@p_initial_pymt_option_id=2,@p_original_tax_designation=0
		
		exec lp_account..usp_account_meters_insert @p_account_id=@p_AccountId2,@p_meter=N''
		
		--INSERT ACCOUNT1
		print 'ACCOUNT 1 ' + @p_AccountId1
		
		exec lp_account..usp_account_additional_info_ins @p_username=@p_UsernameDefault,@p_account_id=@p_AccountId1,@p_result_ind=N'N'
		
		exec lp_account..usp_account_name_insert @p_account_id=@p_AccountId1,@p_name_link=2,@p_full_name=N'C NAME'
		
		exec lp_account..usp_account_name_insert @p_account_id=@p_AccountId1,@p_name_link=1,@p_full_name=N'C NAME'
		
		exec lp_account..usp_account_address_insert @p_account_id=@p_AccountId1,@p_address_link=1,@p_address=N'D',@p_suite=N'1',@p_city=N'E',@p_state=N'NY',@p_zip=N'55555'
		
		exec lp_account..usp_account_address_insert @p_account_id=@p_AccountId1,@p_address_link=3,@p_address=N'D',@p_suite=N'1',@p_city=N'E',@p_state=N'NY',@p_zip=N'55555'
		
		exec lp_account..usp_account_address_insert @p_account_id=@p_AccountId1,@p_address_link=2,@p_address=N'D',@p_suite=N'1',@p_city=N'E',@p_state=N'NY',@p_zip=N'55555'
		
		exec lp_account..usp_account_contact_insert @p_account_id=@p_AccountId1,@p_contact_link=2,@p_first_name=N'A',@p_last_name=N'B',@p_title=N'C',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01'
		
		exec lp_account..usp_account_contact_insert @p_account_id=@p_AccountId1,@p_contact_link=1,@p_first_name=N'A',@p_last_name=N'B',@p_title=N'C',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01'
		
		exec lp_account..usp_account_status_history_ins @p_username=@p_UsernameDefault,@p_account_id=@p_AccountId1,@p_status=N'03000',@p_sub_status=N'10',@p_date_created='Dec 13 2011  2:27:51:000PM',@p_process_id=N'DEAL CAPTURE',@p_param_01=N'ONCOR',@p_param_02=N'',@p_param_03=N'',@p_param_04=N'',@p_param_05=N'',@p_param_06=N'',@p_param_07=N'',@p_param_08=N'',@p_date_eff='Dec 13 2011  2:27:51:000PM',@p_result_ind=N'N'
		
		exec lp_account..usp_account_ins @p_username=@p_UsernameDefault,@p_account_id=@p_AccountId1,@p_account_number=@p_AccountNumber1,
		@p_account_type=N'SMB',@p_status=N'03000',@p_sub_status=N'10',@p_customer_id=N' ',@p_entity_id=N'LPT',@p_contract_nbr=@p_ContractNumber,
		@p_contract_type=N'VOICE',@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC',@p_rate_id=114010301,@p_rate=0.05169,
		@p_account_name_link=1,@p_customer_name_link=1,@p_customer_address_link=1,@p_customer_contact_link=1,@p_billing_address_link=1,
		@p_billing_contact_link=1,@p_owner_name_link=1,@p_service_address_link=2,@p_business_type=N'CORPORATION',@p_business_activity=N'CORPORATION',
		@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'',@p_contract_eff_start_date='Jan  1 2012 12:00:00:000AM',@p_term_months=3,
		@p_date_end='Apr  1 2012 12:00:00:000AM',@p_date_deal='Dec 13 2011 12:00:00:000AM',@p_date_created='Dec 13 2011 10:47:37:000AM',
		@p_date_submit='Dec 13 2011 10:47:40:000AM',@p_sales_channel_role=N'Sales Channel/outboundtelesales',@p_sales_rep=N'AL TAFUR',
		@p_origin=N'ONLINE',@p_annual_usage=0,@p_date_flow_start='Jan  1 1900 12:00:00:000AM',@p_date_por_enrollment='Dec 13 2011 12:00:00:000AM',
		@p_date_deenrollment='Jan  1 1900 12:00:00:000AM',@p_date_reenrollment='Jan  1 1900 12:00:00:000AM',@p_tax_status=N'FULL',@p_tax_float=0,
		@p_credit_score=0,@p_credit_agency=N'NONE',@p_por_option=N'NO',@p_billing_type=N'SC',@p_zone=N'',@p_service_rate_class=N'',
		@p_stratum_variable=N'',@p_billing_group=N'',@p_icap=N'',@p_tcap=N'',@p_load_profile=N'',@p_loss_code=N'',@p_meter_type=N'',
		@p_requested_flow_start_date='Jan 2 2012 12:00:00:000AM',@p_deal_type=N'',@p_enrollment_type=1,@p_customer_code=N'',@p_customer_group=N'',
		@p_paymentTerm=default,@p_SSNEncrypted=N'',@p_HeatIndexSourceID=0,@p_HeatRate=0,@p_sales_manager=N'Dennis Manning',@p_evergreen_option_id=0,
		@p_evergreen_commission_end=default,@p_evergreen_commission_rate=0,@p_residual_option_id=5,@p_residual_commission_end=default,
		@p_initial_pymt_option_id=2,@p_original_tax_designation=0	
		
		exec lp_account..usp_account_meters_insert @p_account_id=@p_AccountId1,@p_meter=N''

		--INSERT CHECK ACCOUN RECORD
		exec lp_enrollment..usp_check_account_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_account_id=N' ',
		@p_check_type=N'TPV',@p_check_request_id=N'ENROLLMENT',@p_approval_status=N'PENDING',@p_approval_status_date='Dec 13 2011 10:47:40:537AM',
		@p_approval_comments=N' ',@p_approval_eff_date='Jan  1 1900 12:00:00:000AM',@p_origin=N'ONLINE',@p_userfield_text_01=N' ',
		@p_userfield_text_02=N' ',@p_userfield_date_03='Jan  1 1900 12:00:00:000AM',@p_userfield_text_04=N' ',@p_userfield_date_05='Jan  1 1900 12:00:00:000AM',
		@p_userfield_date_06='Jan  1 1900 12:00:00:000AM',@p_userfield_amt_07=0,@p_result_ind=N'N'

		--EVENT HISTORY FOR ACCOUNT1
		exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId1,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  2 1900 12:00:00:000AM',@EventID=1,@EventEffectiveDate='Jan 2 2012 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec 13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=162.500000,@TermGrossProfit=40.62500000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=1242.75000,@TermRevenue=310.6875000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'
		
		--EVENT HISTORY FOR ACCOUNT2
		exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId2,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=1,@EventEffectiveDate='Jan 2 2012 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec  13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=162.500000,@TermGrossProfit=40.62500000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=1242.75000,@TermRevenue=310.6875000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'

		--SELECTS TO TEST CONTRACT AFTER SEND TO LP
		select * from lp_deal_capture..deal_contract
		where contract_nbr = @p_ContractNumber

		select * from lp_deal_capture..deal_contract_account
		where contract_nbr = @p_ContractNumber

		select * from lp_account..account
		where contract_nbr = @p_ContractNumber

		select * from lp_enrollment..check_account
		where contract_nbr = @p_ContractNumber
	END

	IF(@p_TestDealScreening = 1)
	BEGIN
		--CHECK AND APPROVAL
		exec lp_enrollment..usp_check_account_approval_reject @p_username=@p_UsernameDefault,@p_check_request_id=N'ENROLLMENT               ',@p_contract_nbr=@p_ContractNumber,@p_account_id=N'NONE',@p_account_number=N'',@p_check_type=N'TPV',@p_approval_status=N'APPROVED',@p_comment=N'test'

			--SAVE CREDIT CHECK INFO
			exec LibertyPower..usp_CreditScoreHistoryInsert @p_CustomerName=NULL,@p_StreetAddress=NULL,@p_City=NULL,@p_State=NULL,@p_ZipCode=NULL,@p_DateAcquired='Dec 14 2011  9:44:18:073AM',@p_AgencyReferenceID=0,@p_CreditAgencyID=3,@p_Score=85,@p_ScoreType=N'Commercial Service',@p_FullXMLReport=NULL,@p_Source=N'Manual',@p_CustomerID=0,@p_Contract_nbr=@p_ContractNumber,@p_Account_nbr=N'',@p_Username=@p_UsernameDefault,@p_DateCreated='Dec 14 2011 12:00:00:000AM'
			exec lp_enrollment..usp_check_account_upd @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_credit_agency=N'EXPERIAN',@p_credit_score_encrypted=N'Pd/FDEbCpPN8mDTJ5zc5mw=='
			
			--REJECT STEP: TEST REJECT A STEP AND APPROVE IT LATER
			exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=197,@Username=@p_UsernameDefault,@State=2
			exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=200,@Username=@p_UsernameDefault,@State=4
			exec LibertyPower..usp_ReasonCodeContractCheckListInsert @ContractNumber=@p_ContractNumber,@Step=2,@CheckListID=200,@ReasonCodeID=N'7'
			exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=203,@Username=@p_UsernameDefault,@State=2
			exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=206,@Username=@p_UsernameDefault,@State=2
			exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=209,@Username=@p_UsernameDefault,@State=2
			exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=212,@Username=@p_UsernameDefault,@State=2
			
			exec lp_enrollment..usp_check_account_approval_reject @p_username=@p_UsernameDefault,@p_check_request_id=N'ENROLLMENT               ',@p_contract_nbr=@p_ContractNumber,@p_account_id=N'NONE',@p_account_number=N'',@p_check_type=N'CREDIT CHECK',@p_approval_status=N'REJECTED',@p_comment=N'test'
			
			exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId1,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Dec  15 2011 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec  13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=0,@TermGrossProfit=0,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=40.6250,@AnnualRevenue=0,@TermRevenue=0,@AnnualRevenueAdj=0,@TermRevenueAdj=310.6875,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'
			exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId2,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Dec  15 2011 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec  13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=0,@TermGrossProfit=0,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=40.6250,@AnnualRevenue=0,@TermRevenue=0,@AnnualRevenueAdj=0,@TermRevenueAdj=310.6875,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'

		exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=197,@Username=@p_UsernameDefault,@State=2
		exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=200,@Username=@p_UsernameDefault,@State=2
		exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=203,@Username=@p_UsernameDefault,@State=2
		exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=206,@Username=@p_UsernameDefault,@State=2
		exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=209,@Username=@p_UsernameDefault,@State=2
		exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=2,@Disposition=N'APPROVED',@CheckListID=212,@Username=@p_UsernameDefault,@State=2
		--maybe not needed
		--exec lp_account..usp_contract_usage_acquired_check @p_contract_nbr=@p_ContractNumber

		exec lp_enrollment..usp_check_account_approval_reject @p_reason_code=N'1032',@p_username=@p_UsernameDefault,@p_check_request_id=N'ENROLLMENT               ',@p_contract_nbr=@p_ContractNumber,@p_account_id=N'NONE',@p_account_number=N'',@p_check_type=N'CREDIT CHECK',@p_approval_status=N'APPROVED',@p_comment=N'test'

		exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId1,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Dec  15 2011 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec  13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=162.500000,@TermGrossProfit=40.62500000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=1242.75000,@TermRevenue=310.6875000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'
		exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId2,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Dec  15 2011 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec  13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=162.500000,@TermGrossProfit=40.62500000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=1242.75000,@TermRevenue=310.6875000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'

		exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=14,@Disposition=N'APPROVED',@CheckListID=215,@Username=@p_UsernameDefault,@State=2
		exec LibertyPower..usp_CheckListContractInsert @ContractNumber=@p_ContractNumber,@Step=14,@Disposition=N'APPROVED',@CheckListID=218,@Username=@p_UsernameDefault,@State=2
		
			--set usage on the contract
			update lp_account..account set annual_usage = 3252 where contract_nbr = @p_ContractNumber
			
			declare @p_waitVar datetime
			set @p_waitVar = getdate()
			while (datediff(mi,@p_waitVar,getdate()) <= 1 )
			begin
				print 'wait'
			end
			
			--autoprocess usage
			exec lp_enrollment..usp_dealscreening_autoprocessing @RecordAgeInMinutes = NULL
			
		BEGIN
			exec lp_enrollment..usp_check_account_approval_reject @p_username=@p_UsernameDefault,@p_check_request_id=N'ENROLLMENT               ',@p_contract_nbr=@p_ContractNumber,@p_account_id=N'NONE',@p_account_number=N'',@p_check_type=N'PRICE VALIDATION',@p_approval_status=N'APPROVED',@p_comment=N'test'

			exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId1,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Dec  15 2011 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec  13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=162.500000,@TermGrossProfit=40.62500000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=1242.75000,@TermRevenue=310.6875000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'
			exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId2,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Dec  15 2011 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec  13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=162.500000,@TermGrossProfit=40.62500000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=1242.75000,@TermRevenue=310.6875000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'

			exec lp_enrollment..usp_check_account_approval_reject @p_username=@p_UsernameDefault,@p_check_request_id=N'ENROLLMENT               ',@p_contract_nbr=@p_ContractNumber,@p_account_id=N'NONE',@p_account_number=N'',@p_check_type=N'POST-USAGE CREDIT CHECK',@p_approval_status=N'APPROVED',@p_comment=N'test'
		
			exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId1,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Jan 1 2012 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec 13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=3252,@GrossMarginValue=6.500000,@AnnualGrossProfit=21.138000,@TermGrossProfit=5.28450000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=161.65692,@TermRevenue=40.4142300,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'
			exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId2,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Jan 1 2012 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec 13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=3252,@GrossMarginValue=6.500000,@AnnualGrossProfit=21.138000,@TermGrossProfit=5.28450000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=161.65692,@TermRevenue=40.4142300,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'

			exec lp_enrollment..usp_check_account_approval_reject @p_username=@p_UsernameDefault,@p_check_request_id=N'ENROLLMENT               ',@p_contract_nbr=@p_ContractNumber,@p_account_id=N'NONE',@p_account_number=N'',@p_check_type=N'LETTER',@p_approval_status=N'APPROVED',@p_comment=N'test'

			exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId1,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Jan 1 2012 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec 13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=3252,@GrossMarginValue=6.500000,@AnnualGrossProfit=21.138000,@TermGrossProfit=5.28450000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=161.65692,@TermRevenue=40.4142300,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'
			exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumber,@AccountId=@p_AccountId2,@ProductId=N'ONCOR_FS_ABC',@RateID=114010301,@Rate=0.05169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=7,@EventEffectiveDate='Jan 1 2012 12:00:00:000AM',@ContractType=N'VOICE',@ContractDate='Dec 13 2011 12:00:00:000AM',@ContractEndDate='Apr 2 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=3252,@GrossMarginValue=6.500000,@AnnualGrossProfit=21.138000,@TermGrossProfit=5.28450000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=161.65692,@TermRevenue=40.4142300,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011 10:47:40:000AM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'
		END
		--SELECTS TO TEST CONTRACT AFTER CHECK AND APPROVAL
		select * from lp_account..account
		where contract_nbr = @p_ContractNumber

		select * from lp_enrollment..check_account
		where contract_nbr = @p_ContractNumber
		order by approval_status_date

		select * from lp_common..common_utility_check_type
		where utility_id = (select top 1 utility_id from lp_account..account
							where contract_nbr = @p_ContractNumber)
		and contract_type = (select top 1 contract_type from lp_account..account
							 where contract_nbr = @p_ContractNumber)
		order by [order]
	END
	
	DECLARE @p_ContractNumberOT CHAR(12)
	SET @p_ContractNumberOT = rtrim(ltrim(substring(@p_ContractNumber, 0, 11)))+'OT'

	IF(@p_TestChangeOfOwnership = 1)
	BEGIN
		--TRANSFER OF OWNERSHIP
			--set status of the contract to enrolled
		update lp_account..account set [status] = '905000', sub_status = '10' where contract_nbr = @p_ContractNumber
		 
		exec lp_contract_renewal..usp_contract_transfer_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_contract_type=N'VOICE',@p_original_contract_nbr=@p_ContractNumber

		exec lp_contract_renewal..usp_contract_renewal_name_ins @p_account_id=@p_AccountId1,@p_name_link=1,@p_full_name=N'C NAME',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_name_ins @p_account_id=@p_AccountId2,@p_name_link=1,@p_full_name=N'C NAME',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_contact_ins @p_account_id=@p_AccountId1,@p_contact_link=1,@p_first_name=N'F NAME',@p_last_name=N'L NAME',@p_title=N'TEST',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_contact_ins @p_account_id=@p_AccountId2,@p_contact_link=1,@p_first_name=N'F NAME',@p_last_name=N'L NAME',@p_title=N'TEST',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId1,@p_address_link=1,@p_address=N'TEST                                              ',@p_suite=N'1         ',@p_city=N'TEST                        ',@p_state=N'NY',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId1,@p_address_link=2,@p_address=N'TEST                                              ',@p_suite=N'1         ',@p_city=N'TEST                        ',@p_state=N'TX',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId2,@p_address_link=1,@p_address=N'TEST                                              ',@p_suite=N'1         ',@p_city=N'TEST                        ',@p_state=N'NY',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId2,@p_address_link=5,@p_address=N'TEST                                              ',@p_suite=N'1         ',@p_city=N'TEST                        ',@p_state=N'TX',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_transfer_contract_upd @p_username=@p_UsernameDefault,@p_original_contract_nbr=@p_ContractNumber,@p_contract_nbr=@p_ContractNumberOT,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC        ',@p_rate_id=114010301,@p_rate=0.05269,@p_customer_name_link =1,@p_customer_address_link=1,@p_customer_contact_link=1,@p_billing_address_link=1,@p_billing_contact_link=1,@p_owner_name_link=1,@p_service_address_link=5,@p_business_type=N'CORPORATION',@p_business_activity=N'CORPORATION',@p_additional_id_nbr=N'',@p_date_end='Apr  2 2012 12:00:00:000AM',@p_term_months=3,@p_sales_channel_role=N'SALES CHANNEL/OUTBOUNDTELESALES',@p_sales_rep=N'AL TAFUR',@p_date_submit='Dec 13 2011 10:47:40:000AM'

		exec lp_contract_renewal..usp_contract_transfer_account_ins @p_contract_nbr=@p_ContractNumberOT,@p_contract_type=N'VOICE',@p_account_number=@p_AccountNumber2,@p_status=N'905000',@p_account_id=@p_AccountId2,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC        ',@p_rate_id=114010301,@p_rate=0.05269,@p_account_name_link=1,@p_customer_name_link =1,@p_customer_address_link=1,@p_customer_contact_link=1,@p_billing_address_link=1,@p_billing_contact_link=1,@p_owner_name_link=1,@p_service_address_link=5,@p_business_type=N'CORPORATION',@p_business_activity=N'CORPORATION',@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'',@p_contract_eff_start_date='Jan 2 2012 12:00:00:000AM',@p_term_months=3,@p_date_end='Apr  2 2012 12:00:00:000AM',@p_date_deal=N'2011-12-13',@p_date_created='Dec 13 2011  4:18:15:873PM',@p_date_submit='Dec 13 2011 10:47:40:000AM',@p_sales_channel_role=N'SALES CHANNEL/OUTBOUNDTELESALES',@p_username=@p_UsernameDefault,@p_sales_rep=N'AL TAFUR',@p_origin=N'ONLINE',@p_annual_usage=3252,@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_transfer_account_ins @p_contract_nbr=@p_ContractNumberOT,@p_contract_type=N'VOICE',@p_account_number=@p_AccountNumber1,@p_status=N'905000',@p_account_id=@p_AccountId1,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC        ',@p_rate_id=114010301,@p_rate=0.05269,@p_account_name_link=1,@p_customer_name_link =1,@p_customer_address_link=1,@p_customer_contact_link=1,@p_billing_address_link=1,@p_billing_contact_link=1,@p_owner_name_link=1,@p_service_address_link=2,@p_business_type=N'CORPORATION',@p_business_activity=N'CORPORATION',@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'',@p_contract_eff_start_date='Jan 2 2012 12:00:00:000AM',@p_term_months=3,@p_date_end='Apr  2 2012 12:00:00:000AM',@p_date_deal=N'2011-12-13',@p_date_created='Dec 13 2011  4:18:20:300PM',@p_date_submit='Dec 13 2011 10:47:40:000AM',@p_sales_channel_role=N'SALES CHANNEL/OUTBOUNDTELESALES',@p_username=@p_UsernameDefault,@p_sales_rep=N'AL TAFUR',@p_origin=N'ONLINE',@p_annual_usage=3252,@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_transfer_general_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC',@p_rate_id=114010301,@p_rate=N'0.05269',@p_business_type=N'CORPORATION',@p_business_activity=N'NONE',@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'',@p_contract_eff_start_date=N'01/01/2012',@p_term_months=N'3',@p_sales_channel_role=N'Sales Channel/outboundtelesales',@p_sales_rep=N'AL TAFUR',@p_account_number=@p_AccountNumber1,@p_date_submit='Dec 13 2011  6:15:09:597PM',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y',@p_sales_mgr=N'Dennis Manning',@p_initial_pymt_option_id=NULL,@p_residual_option_id=N'2',@p_evergreen_option_id=N'5',@p_evergreen_commission_rate=N'0'

		exec lp_contract_renewal..usp_contract_transfer_general_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC',@p_rate_id=114010301,@p_rate=N'0.05269',@p_business_type=N'CORPORATION',@p_business_activity=N'NONE',@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'',@p_contract_eff_start_date=N'01/01/2012',@p_term_months=N'3',@p_sales_channel_role=N'Sales Channel/outboundtelesales',@p_sales_rep=N'AL TAFUR',@p_account_number=@p_AccountNumber2,@p_date_submit='Dec 13 2011  6:15:24:423PM',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y',@p_sales_mgr=N'Dennis Manning',@p_initial_pymt_option_id=NULL,@p_residual_option_id=N'2',@p_evergreen_option_id=N'5',@p_evergreen_commission_rate=N'0'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_name_link=N'0',@p_full_name=N'C NAME1',@p_name_type=N'CUSTOMER',@p_account_number=@p_AccountNumber2,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_contact_type=N'CUSTOMER',@p_contact_link=N'0',@p_first_name=N'F NAME1',@p_last_name=N'L NAME1',@p_title=N'TEST1',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=@p_AccountNumber2,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'CUSTOMER',@p_address_link=N'0',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber2,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_name_link=N'0',@p_full_name=N'C NAME1',@p_name_type=N'CUSTOMER',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_contact_type=N'CUSTOMER',@p_contact_link=N'0',@p_first_name=N'F NAME1',@p_last_name=N'L NAME1',@p_title=N'TEST1',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'CUSTOMER',@p_address_link=N'0',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_name_link=N'2',@p_full_name=N'C NAME1',@p_name_type=N'CUSTOMER',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_contact_type=N'CUSTOMER',@p_contact_link=N'2',@p_first_name=N'F NAME1',@p_last_name=N'L NAME1',@p_title=N'TEST1',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'CUSTOMER',@p_address_link=N'3',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_contact_type=N'BILLING',@p_contact_link=N'2',@p_first_name=N'F NAME1',@p_last_name=N'L NAME1',@p_title=N'TEST1',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'BILLING',@p_address_link=N'3',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_contact_type=N'BILLING',@p_contact_link=N'2',@p_first_name=N'F NAME1',@p_last_name=N'L NAME1',@p_title=N'TEST1',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=@p_AccountNumber2,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'BILLING',@p_address_link=N'6',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber2,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_contact_type=N'BILLING',@p_contact_link=N'2',@p_first_name=N'F NAME1',@p_last_name=N'L NAME1',@p_title=N'TEST1',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'BILLING',@p_address_link=N'3',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'SERVICE',@p_address_link=N'3',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'SERVICE',@p_address_link=N'6',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber2,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_address_type=N'SERVICE',@p_address_link=N'6',@p_address=N'TEST1',@p_suite=N'11',@p_city=N'TEST1',@p_state=N'NY',@p_zip=N'55555',@p_account_number=@p_AccountNumber2,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_name_link=N'2',@p_full_name=N'C NAME1',@p_name_type=N'OWNER',@p_account_number=@p_AccountNumber2,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberOT,@p_name_link=N'2',@p_full_name=N'C NAME1',@p_name_type=N'OWNER',@p_account_number=@p_AccountNumber1,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'
		
		exec lp_account..usp_account_history_transfer_ins @p_contract_nbr=@p_ContractNumber
		
		exec lp_contract_renewal..usp_contract_submit_transfer @p_contract_nbr=@p_ContractNumberOT,@p_username=@p_UsernameDefault,@p_process=N'TRANSFER',@p_enrollment_type=N'3'
		
	END
	
	--check if a transfer of ownership was performed
	IF EXISTS(select contract_nbr from lp_account..account where contract_nbr = @p_ContractNumberOT)
	BEGIN
		SET @p_ContractNumber = @p_ContractNumberOT
	END
	
	DECLARE @p_ContractNumberR CHAR(12)
	SET @p_ContractNumberR = rtrim(ltrim(substring(@p_ContractNumber, 0, 11)))+'R'
	
	IF(@p_TestRenewal = 1)
	BEGIN
		--RENEWAL
		--set status of the contract to enrolled
		update lp_account..account set [status] = '905000', sub_status = '10' where contract_nbr = @p_ContractNumber
		
		exec lp_contract_renewal..usp_contract_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_contract_type=N'VOICE RENEWAL',@p_original_contract_nbr=@p_ContractNumber

		exec lp_contract_renewal..usp_contract_renewal_name_ins @p_account_id=@p_AccountId1,@p_name_link=1,@p_full_name=N'C NAME',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_name_ins @p_account_id=@p_AccountId1,@p_name_link=2,@p_full_name=N'C NAME1',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_name_ins @p_account_id=@p_AccountId2,@p_name_link=1,@p_full_name=N'C NAME',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_name_ins @p_account_id=@p_AccountId2,@p_name_link=2,@p_full_name=N'C NAME1',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_contact_ins @p_account_id=@p_AccountId1,@p_contact_link=1,@p_first_name=N'F NAME',@p_last_name=N'L NAME',@p_title=N'TEST',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_contact_ins @p_account_id=@p_AccountId1,@p_contact_link=2,@p_first_name=N'F NAME1',@p_last_name=N'L NAME1',@p_title=N'TEST1',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_contact_ins @p_account_id=@p_AccountId2,@p_contact_link=1,@p_first_name=N'F NAME',@p_last_name=N'L NAME',@p_title=N'TEST',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_contact_ins @p_account_id=@p_AccountId2,@p_contact_link=2,@p_first_name=N'F NAME1',@p_last_name=N'L NAME1',@p_title=N'TEST1',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId1,@p_address_link=1,@p_address=N'TEST                                              ',@p_suite=N'1         ',@p_city=N'TEST                        ',@p_state=N'NY',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId1,@p_address_link=2,@p_address=N'TEST                                              ',@p_suite=N'1         ',@p_city=N'TEST                        ',@p_state=N'TX',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId1,@p_address_link=3,@p_address=N'TEST1                                             ',@p_suite=N'11        ',@p_city=N'TEST1                       ',@p_state=N'NY',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId2,@p_address_link=1,@p_address=N'TEST                                              ',@p_suite=N'1         ',@p_city=N'TEST                        ',@p_state=N'NY',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId2,@p_address_link=5,@p_address=N'TEST                                              ',@p_suite=N'1         ',@p_city=N'TEST                        ',@p_state=N'TX',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_address_ins @p_account_id=@p_AccountId2,@p_address_link=6,@p_address=N'TEST1                                             ',@p_suite=N'11        ',@p_city=N'TEST1                       ',@p_state=N'NY',@p_zip=N'55555     ',@p_county=N'          ',@p_state_fips=N'  ',@p_county_fips=N'   ',@p_chgstamp=0

		exec lp_contract_renewal..usp_contract_renewal_contract_upd @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC        ',@p_rate_id=114030303,@p_rate=0.06169,@p_customer_name_link =2,@p_customer_address_link=3,@p_customer_contact_link=2,@p_billing_address_link=3,@p_billing_contact_link=2,@p_owner_name_link=2,@p_service_address_link=3,@p_business_type=N'CORPORATION',@p_business_activity=N'NONE',@p_additional_id_nbr=N'NONE',@p_additional_id_nbr_type=N'NONE',@p_date_end=N'07/01/2012',@p_term_months=3,@p_sales_channel_role=N'SALES CHANNEL/OUTBOUNDTELESALES',@p_sales_rep=N'AL TAFUR',@p_date_submit='Dec 13 2011 10:28:43:637AM',@p_SSNClear=NULL,@p_SSNEncrypted=NULL,@p_CreditScoreEncrypted=N'Pd/FDEbCpPN8mDTJ5zc5mw==',@p_contract_eff_start_date='Apr 2 2012 12:00:00:000AM'

		exec lp_contract_renewal..usp_contract_renewal_account_ins @p_contract_nbr=@p_ContractNumberR,@p_contract_type=N'VOICE RENEWAL',@p_account_number=@p_AccountNumber1,@p_status=N'905000',@p_account_id=@p_AccountId1,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC        ',@p_rate_id=114030303,@p_rate=0.06169,@p_account_name_link=2,@p_customer_name_link =2,@p_customer_address_link=3,@p_customer_contact_link=2,@p_billing_address_link=3,@p_billing_contact_link=2,@p_owner_name_link=2,@p_service_address_link=3,@p_business_type=N'CORPORATION',@p_business_activity=N'NONE',@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'NONE',@p_contract_eff_start_date='Apr 2 2012 12:00:00:000AM',@p_term_months=3,@p_date_end=N'06/01/2012',@p_date_deal='Dec 13 2011 12:00:00:000AM',@p_date_created='Dec 13 2011  4:18:20:300PM',@p_date_submit='Dec 13 2011 10:28:43:637AM',@p_sales_channel_role=N'SALES CHANNEL/OUTBOUNDTELESALES',@p_username=@p_UsernameDefault,@p_sales_rep=N'AL TA',@p_sales_mgr=N'Dennis Manning',@p_initial_pymt_option_id=2,@p_residual_option_id=5,@p_evergreen_option_id=0,@p_residual_commission_end=NULL,@p_evergreen_commission_end=NULL,@p_evergreen_commission_rate=0,@p_origin=N'ONLINE',@p_annual_usage=3252,@p_chgstamp=0,@p_SSNClear=NULL,@p_SSNEncrypted=NULL,@p_CreditScoreEncrypted=N'Pd/FDEbCpPN8mDTJ5zc5mw==',@p_account_eff_start_date='Apr  3 2012 12:00:00:000AM'

		exec lp_contract_renewal..usp_contract_renewal_account_ins @p_contract_nbr=@p_ContractNumberR,@p_contract_type=N'VOICE RENEWAL',@p_account_number=@p_AccountNumber2,@p_status=N'905000',@p_account_id=@p_AccountId2,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_product_id=N'ONCOR_FS_ABC        ',@p_rate_id=114030303,@p_rate=0.04710,@p_account_name_link=2,@p_customer_name_link =2,@p_customer_address_link=6,@p_customer_contact_link=2,@p_billing_address_link=6,@p_billing_contact_link=2,@p_owner_name_link=2,@p_service_address_link=6,@p_business_type=N'CORPORATION',@p_business_activity=N'NONE',@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'NONE',@p_contract_eff_start_date='Apr 2 2012 12:00:00:000AM',@p_term_months=3,@p_date_end=N'07/01/2012',@p_date_deal='Dec 13 2011 12:00:00:000AM',@p_date_created='Dec 13 2011  4:18:15:873PM',@p_date_submit='Dec 13 2011 10:28:43:637AM',@p_sales_channel_role=N'SALES CHANNEL/OUTBOUNDTELESALES',@p_username=@p_UsernameDefault,@p_sales_rep=N'AL TAFUR',@p_sales_mgr=N'Dennis Manning',@p_initial_pymt_option_id=2,@p_residual_option_id=5,@p_evergreen_option_id=0,@p_residual_commission_end=NULL,@p_evergreen_commission_end=NULL,@p_evergreen_commission_rate=0,@p_origin=N'ONLINE',@p_annual_usage=3252,@p_chgstamp=0,@p_SSNClear=NULL,@p_SSNEncrypted=NULL,@p_CreditScoreEncrypted=N'Pd/FDEbCpPN8mDTJ5zc5mw==',@p_account_eff_start_date='Apr  3 2012 12:00:00:000AM'

		--ADD ON ACCOUNT
		exec lp_contract_renewal..usp_contract_account_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_account_number=@p_AccountNumberAddOn,@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_general_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_retail_mkt_id=N'TX',@p_utility_id=N'ONCOR',@p_account_type=N'1',@p_product_id=N'ONCOR_FS_ABC',@p_rate_id=114030303,@p_rate=N'0.06169',@p_business_type=N'CORPORATION',@p_business_activity=N'NONE',@p_additional_id_nbr_type=N'NONE',@p_additional_id_nbr=N'',@p_ssnClear=N'',@p_ssnEncrypted=N'',@p_contract_eff_start_date=N'04/02/2012',@p_term_months=N'3',@p_sales_channel_role=N'Sales Channel/outboundtelesales',@p_sales_rep=N'Al Tafur',@p_sales_mgr=N'Dennis Manning',@p_initial_pymt_option_id=NULL,@p_residual_option_id=NULL,@p_evergreen_option_id=NULL,@p_residual_commission_end=NULL,@p_evergreen_commission_end=NULL,@p_evergreen_commission_rate=NULL,@p_account_number=N'CONTRACT',@p_date_submit='Dec 13 2011  3:54:02:043PM',@p_ContractDate=N'12/13/2011',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_name_link=N'0',@p_full_name=N'C NAME2',@p_name_type=N'CUSTOMER',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_contact_type=N'CUSTOMER',@p_contact_link=N'0',@p_first_name=N'F NAME2',@p_last_name=N'L NAME2',@p_title=N'TEST2',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_address_type=N'CUSTOMER',@p_address_link=N'0',@p_address=N'TEST2',@p_suite=N'12',@p_city=N'TEST2',@p_state=N'NY',@p_zip=N'55555',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_name_link=N'3',@p_full_name=N'C NAME2',@p_name_type=N'CUSTOMER',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_contact_type=N'CUSTOMER',@p_contact_link=N'3',@p_first_name=N'F NAME2',@p_last_name=N'L NAME2',@p_title=N'TEST2',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_address_type=N'CUSTOMER',@p_address_link=N'7',@p_address=N'TEST2',@p_suite=N'12',@p_city=N'TEST2',@p_state=N'NY',@p_zip=N'55555',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_name_link=N'3',@p_full_name=N'C NAME2',@p_name_type=N'CUSTOMER',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_contact_type=N'CUSTOMER',@p_contact_link=N'3',@p_first_name=N'F NAME2',@p_last_name=N'L NAME2',@p_title=N'TEST2',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_address_type=N'CUSTOMER',@p_address_link=N'7',@p_address=N'TEST2',@p_suite=N'12',@p_city=N'TEST2',@p_state=N'NY',@p_zip=N'55555',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_contact_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_contact_type=N'BILLING',@p_contact_link=N'3',@p_first_name=N'F NAME2',@p_last_name=N'L NAME2',@p_title=N'TEST2',@p_phone=N'1234567890',@p_fax=N'',@p_email=N'TEST@TEST.COM',@p_birthday=N'01/01',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_address_type=N'BILLING',@p_address_link=N'7',@p_address=N'TEST2',@p_suite=N'12',@p_city=N'TEST2',@p_state=N'NY',@p_zip=N'55555',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_address_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_address_type=N'SERVICE',@p_address_link=N'7',@p_address=N'TEST2',@p_suite=N'12',@p_city=N'TEST2',@p_state=N'NY',@p_zip=N'55555',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'

		exec lp_contract_renewal..usp_contract_name_ins @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_name_link=N'3',@p_full_name=N'C NAME2',@p_name_type=N'OWNER',@p_account_number=N'CONTRACT',@p_error=N'',@p_msg_id=N'',@p_descp=N'',@p_result_ind=N'Y'


		--SEND TO LIBERTY POWER
		exec lp_contract_renewal..usp_contract_submit @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumberR,@p_process=N'ONLINE'

		exec lp_account..usp_account_history_ins @p_contract_nbr=@p_ContractNumber

		exec lp_contract_renewal..usp_renewal_detail_upd @p_username=@p_UsernameDefault,@p_contract_nbr=@p_ContractNumber,@p_call_status=N'S',@p_call_reason_code=N'1023',@p_assigned_to_username=@p_UsernameDefault,@p_action_type=N'NONE',@p_date_resolved='Dec 13 2011  5:06:11:007PM',@p_nextcalldate=N'',@p_comments=N'Contract renewed',@p_old_chgstamp=N'0',@p_reason_code_sub_array=N''

		--exec lp_contract_renewal..usp_GrossMarginErrorInsert @AccountId=@p_AccountId1,@ErrorLocation=N'AccountEventHistoryFactory',@ErrorMessage=N'No Meter Read Date',@ErrorDate='Dec 13 2011  5:06:13:757PM'

		exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumberR,@AccountId=@p_AccountId1,@ProductId=N'ONCOR_FS_ABC',@RateID=114030303,@Rate=0.06169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=2,@EventEffectiveDate='Apr  3 2012 12:00:00:000AM',@ContractType=N'VOICE RENEWAL',@ContractDate='Apr  3 2012 12:00:00:000AM',@ContractEndDate='Jul  3 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=3252,@GrossMarginValue=6.500000,@AnnualGrossProfit=21.138000,@TermGrossProfit=5.28450000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=155.12040,@TermRevenue=38.7801000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011  5:05:54:893PM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'

		--exec usp_GrossMarginErrorInsert @AccountId=@p_AccountId2,@ErrorLocation=N'AccountEventHistoryFactory',@ErrorMessage=N'No Meter Read Date',@ErrorDate='Dec 13 2011  5:06:14:897PM'

		exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumberR,@AccountId=@p_AccountId2,@ProductId=N'ONCOR_FS_ABC',@RateID=114030303,@Rate=0.06169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=2,@EventEffectiveDate='Apr  3 2012 12:00:00:000AM',@ContractType=N'VOICE RENEWAL',@ContractDate='Apr  3 2012 12:00:00:000AM',@ContractEndDate='Jul  3 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=3252,@GrossMarginValue=6.500000,@AnnualGrossProfit=21.138000,@TermGrossProfit=5.28450000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=155.12040,@TermRevenue=38.7801000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011  5:05:54:893PM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'

		--exec usp_GrossMarginErrorInsert @AccountId=@p_AccountIdAddOn,@ErrorLocation=N'AccountEventHistoryFactory',@ErrorMessage=N'No Meter Read Date',@ErrorDate='Dec 13 2011  5:06:15:023PM'

		exec LibertyPower..usp_AccountEventHistoryInsert @ContractNumber=@p_ContractNumberR,@AccountId=@p_AccountIdAddOn,@ProductId=N'ONCOR_FS_ABC',@RateID=114030303,@Rate=0.06169,@RateEndDate='Jan  1 1900 12:00:00:000AM',@EventID=2,@EventEffectiveDate='Mar  3 2012 12:00:00:000AM',@ContractType=N'VOICE RENEWAL',@ContractDate='Mar  3 2012 12:00:00:000AM',@ContractEndDate='Jun  3 2012 12:00:00:000AM',@DateFlowStart='Jan  1 1900 12:00:00:000AM',@Term=3,@AnnualUsage=25000,@GrossMarginValue=6.500000,@AnnualGrossProfit=162.500000,@TermGrossProfit=40.62500000,@AnnualGrossProfitAdj=0,@TermGrossProfitAdj=0,@AnnualRevenue=1192.50000,@TermRevenue=298.1250000,@AnnualRevenueAdj=0,@TermRevenueAdj=0,@AdditionalGrossMargin=0,@SubmitDate='Dec 13 2011  5:05:54:893PM',@DealDate='Dec 13 2011 12:00:00:000AM',@SalesChannelId=N'SALES CHANNEL/OUTBOUNDTELESALES',@SalesRep=N'AL TAFUR'
	END	
	
END
