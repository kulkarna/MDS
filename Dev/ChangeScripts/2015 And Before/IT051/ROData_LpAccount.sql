USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountSelectByContractNumber]    Script Date: 07/22/2011 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_AccountSelectByContractNumber
 * Get account data
 *
 * History
 *******************************************************************************
 * 5/27/2009 - Rick Deigsler
 * Created.
 * 1/22/2010 - Antonio Jr
 * Inserted select to bring renewal accounts
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_AccountSelectByContractNumber] 
	(@ContractNumber	varchar(50),
	 @GetRenewal char(1) = 'N')
AS
BEGIN
    SET NOCOUNT ON;
		
		IF @GetRenewal = 'Y'
			SELECT	DISTINCT a.contract_nbr, a.account_id, a.account_number, a.account_type, a.status, a.sub_status, 
					a.customer_id, a.entity_id, a.contract_type, a.retail_mkt_id, a.utility_id, a.product_id, 
					a.rate_id, a.rate, a.account_name_link, a.customer_name_link, a.customer_address_link, 
					a.customer_contact_link, a.billing_address_link, a.billing_contact_link, a.owner_name_link, 
					a.service_address_link, a.business_type, a.business_activity, a.additional_id_nbr_type, 
					a.additional_id_nbr, a.contract_eff_start_date, a.term_months, a.date_end, a.date_deal, 
					a.date_created, a.date_submit, a.sales_channel_role, a.username, a.sales_rep, 
					a.origin, IsNull(a.annual_usage,0) as annual_usage, a.date_flow_start, a.date_por_enrollment, a.date_deenrollment, 
					a.date_reenrollment, a.tax_status, a.tax_rate, a.credit_score, a.credit_agency, 
					a.por_option, a.billing_type, b.field_01_value, b.field_02_value, 
					b.field_03_value, IsNull(b.field_04_value,'') as field_04_value, b.field_05_value, 
					b.field_06_value, b.field_07_value, b.field_08_value, 
					b.field_09_value, b.field_10_value
					,c.billing_group, c.zone, c.load_profile, account_name.full_name As BusinessName, 
					c.service_rate_class AS RateClass, c.rate_code as RateCode, c.AccountID, c.ContractID_key, c.stratum_variable as StratumVariable
			FROM	account_renewal a WITH (NOLOCK) 
			LEFT	JOIN account_renewal_additional_info b WITH (NOLOCK) 
			ON		a.account_id = b.account_id 
			JOIN	account c WITH (NOLOCK) 
			ON		c.account_id = a.account_id
			LEFT	OUTER JOIN lp_account..account_name WITH (NOLOCK) 
			ON		account_name.account_id = c.account_id 
			AND		account_name.name_link = c.customer_name_link	
			
			WHERE	a.contract_nbr = @ContractNumber
			
			UNION
			
			SELECT	DISTINCT a.contract_nbr, a.account_id, a.account_number, a.account_type, a.status, a.sub_status, 
					a.customer_id, a.entity_id, a.contract_type, a.retail_mkt_id, a.utility_id, a.product_id, 
					a.rate_id, a.rate, a.account_name_link, a.customer_name_link, a.customer_address_link, 
					a.customer_contact_link, a.billing_address_link, a.billing_contact_link, a.owner_name_link, 
					a.service_address_link, a.business_type, a.business_activity, a.additional_id_nbr_type, 
					a.additional_id_nbr, a.contract_eff_start_date, a.term_months, a.date_end, a.date_deal, 
					a.date_created, a.date_submit, a.sales_channel_role, a.username, a.sales_rep, 
					a.origin, IsNull(a.annual_usage,0) as annual_usage, a.date_flow_start, a.date_por_enrollment, a.date_deenrollment, 
					a.date_reenrollment, a.tax_status, a.tax_rate, a.credit_score, a.credit_agency, 
					a.por_option, a.billing_type, b.field_01_value, b.field_02_value, 
					b.field_03_value, IsNull(b.field_04_value,'') as field_04_value, b.field_05_value, 
					b.field_06_value, b.field_07_value, b.field_08_value, 
					b.field_09_value, b.field_10_value
					,a.billing_group, a.zone, a.load_profile, account_name.full_name As BusinessName,
					a.service_rate_class AS RateClass, a.rate_code as RateCode, a.AccountID, a.ContractID_key, a.stratum_variable as StratumVariable
			FROM	account a WITH (NOLOCK) 
			LEFT	JOIN account_additional_info b WITH (NOLOCK) 
			ON		a.account_id = b.account_id
			LEFT	OUTER JOIN lp_account..account_name WITH (NOLOCK) 
			ON		account_name.account_id = a.account_id 
			AND		account_name.name_link = a.customer_name_link	
			
			WHERE	contract_nbr = @ContractNumber
		ELSE
			SELECT	DISTINCT a.contract_nbr, a.account_id, a.account_number, a.account_type, a.status, a.sub_status, 
					a.customer_id, a.entity_id, a.contract_type, a.retail_mkt_id, a.utility_id, a.product_id, 
					a.rate_id, a.rate, a.account_name_link, a.customer_name_link, a.customer_address_link, 
					a.customer_contact_link, a.billing_address_link, a.billing_contact_link, a.owner_name_link, 
					a.service_address_link, a.business_type, a.business_activity, a.additional_id_nbr_type, 
					a.additional_id_nbr, a.contract_eff_start_date, a.term_months, a.date_end, a.date_deal, 
					a.date_created, a.date_submit, a.sales_channel_role, a.username, a.sales_rep, 
					a.origin, IsNull(a.annual_usage,0) as annual_usage, a.date_flow_start, a.date_por_enrollment, a.date_deenrollment, 
					a.date_reenrollment, a.tax_status, a.tax_rate, a.credit_score, a.credit_agency, 
					a.por_option, a.billing_type, b.field_01_value, b.field_02_value, 
					b.field_03_value, IsNull(b.field_04_value,'') as field_04_value, b.field_05_value, 
					b.field_06_value, b.field_07_value, b.field_08_value, 
					b.field_09_value, b.field_10_value
					,a.billing_group, a.zone, a.load_profile, account_name.full_name As BusinessName,
					a.service_rate_class AS RateClass, a.rate_code as RateCode, a.AccountID, a.ContractID_key, a.stratum_variable as StratumVariable
			FROM	account a WITH (NOLOCK) 
			LEFT	JOIN account_additional_info b WITH (NOLOCK) 
			ON		a.account_id = b.account_id
			LEFT	OUTER JOIN lp_account..account_name WITH (NOLOCK) 
			ON		account_name.account_id = a.account_id 
			AND		account_name.name_link = a.customer_name_link	
			WHERE	contract_nbr = @ContractNumber

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

