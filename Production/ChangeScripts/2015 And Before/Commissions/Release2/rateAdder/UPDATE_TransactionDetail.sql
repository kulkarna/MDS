USE [Lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_transaction_detail_upd]    Script Date: 01/17/2013 09:44:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 6/30/2008
-- Description:	Update Transaction Detail Record
-- =============================================
-- 9/10/2009 Gail Mangaroo 
-- Added term start and end params
-- =============================================
-- 12/19/2009 Gail Mangaroo Added batch_id, is_primary, comments, contract_term_start and contract_end fields 
-- =============================================
-- 4/12/2010 Gail Mangaroo Added payment_opiton_id and payment_option_seting fields
--=============================================
-- =============================================
-- Author:		Lehem Felican
-- Create date: 1/14/2013
-- Description:	Added 3 AdditionalRate params to update query
-- =============================================

ALTER PROCEDURE [dbo].[usp_transaction_detail_upd] 	
	@p_transaction_detail_id int
	, @p_account_id varchar(30)  
	, @p_contract_nbr varchar(30)
	, @p_product_id varchar(30)
	, @p_utility_id varchar(30)
	, @p_retail_mkt_id varchar(5)
	, @p_vendor_id int
	, @p_date_deal datetime 
	, @p_date_flow_requested datetime 
	, @p_transaction_type_id int
	, @p_approval_status_id int 

	, @p_base_amount money
	, @p_rate float
	, @p_term float 
	, @p_vendor_pct float 
	, @p_house_pct float
	, @p_pro_rate_term bit 
	, @p_amount money

	, @p_rate_setting_id int
	, @p_calculation_rule_id int 
	, @p_date_due datetime 
	, @p_void int
 
	, @p_source varchar(50)
	, @p_reason_code varchar(50)
	, @p_transaction_summary_id int
	, @p_invoice_id int 
	, @p_calculation_freq_id int 
	, @p_assoc_transaction_id int = null

	, @p_username varchar(50)

	, @p_rate_requested float
	, @p_rate_split_point float
	, @p_exception_ind bit 
	, @p_primary_vendor_id int 
	, @p_contract_term float
	, @p_payment_option_id int 
	, @p_nonreversible bit
	
	, @p_pro_rate_factor float = null 
	, @p_rate_cap float = null 
	, @p_is_custom_rate bit = null 
	
	, @p_term_start datetime 
	, @p_term_end datetime 
	
	, @p_transaction_batch_id varchar(50)
	, @p_comments varchar(150) = null 
	, @p_is_primary  bit = 0 
	
	, @p_contract_term_start datetime = null 
	, @p_contract_term_end datetime = null 
	
	, @p_payment_option_setting_id int = 0 
	, @p_payment_option_def_id int = 0
	, @p_report_date_option_id int = 0
	
	, @p_AdditionalRateTypeCalcId int = 0
	, @p_AdditionalRateTypeId int = 0
	, @p_AdditionalRateAmount float = 0
AS
	
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [lp_commissions].[dbo].[transaction_detail]
	   SET [account_id] = @p_account_id
		  ,[contract_nbr] = @p_contract_nbr
		  ,[product_id] = @p_product_id
		  ,[utility_id] = @p_utility_id
		  ,[retail_mkt_id] = @p_retail_mkt_id
		  ,[vendor_id] = @p_vendor_id
		  ,[date_deal] = @p_date_deal
		  ,[date_flow_requested] = @p_date_flow_requested
		  ,[transaction_type_id] = @p_transaction_type_id
		  ,[approval_status_id] = @p_approval_status_id
		  ,[base_amount] = @p_base_amount
		  ,[rate] = @p_rate
		  ,[term] = @p_term
		  ,[vendor_pct] = @p_vendor_pct
		  ,[house_pct] = @p_house_pct
		  ,[pro_rate_term] = @p_pro_rate_term
		  ,[amount] = @p_amount
		  ,[rate_setting_id] = @p_rate_setting_id
		  ,[calculation_rule_id] = @p_calculation_rule_id
		  ,[date_due] = @p_date_due
		  ,[void] = @p_void
		  ,[source] = @p_source
		  ,[reason_code] = @p_reason_code
		  ,[transaction_summary_id] = @p_transaction_summary_id
		  ,[invoice_id] = @p_invoice_id
		  ,[calculation_freq_id] = @p_calculation_freq_id
		  ,[assoc_transaction_id] = @p_assoc_transaction_id
		 
		  ,[date_modified] = getdate()
		  ,[modified_by] = @p_username

			, rate_requested = @p_rate_requested 
			, rate_split_point = @p_rate_split_point
			, exception_ind = @p_exception_ind
			, primary_vendor_id = @p_primary_vendor_id
			, contract_term = @p_contract_term 
			, payment_option_id = @p_payment_option_id
			, nonreversible = @p_nonreversible
			, pro_rate_factor = isnull(@p_pro_rate_factor , pro_rate_factor)
			, rate_cap = isnull(@p_rate_cap, rate_cap ) 
			, is_custom_rate = isnull(@p_is_custom_rate  , is_custom_rate ) 
			
			, date_term_start = @p_term_start 
			, date_term_end = @p_term_end 
			
			, transaction_batch_id  = @p_transaction_batch_id
			, comments = @p_comments
			, is_primary = @p_is_primary
		   
			, date_contract_term_start = @p_contract_term_start 
			, date_contract_term_end = @p_contract_term_end
		   
			, payment_option_setting_id  = @p_payment_option_setting_id
			, payment_option_def_id =  @p_payment_option_def_id 
			, report_date_option_id  = @p_report_date_option_id 
			
			, AdditionalRateTypeCalcId   = @p_AdditionalRateTypeCalcId 
			, AdditionalRateTypeId		 = @p_AdditionalRateTypeId
			, AdditionalRateAmount		 = @p_AdditionalRateAmount
			
	WHERE transaction_detail_id = @p_transaction_detail_id

	RETURN @@ROWCOUNT
END
