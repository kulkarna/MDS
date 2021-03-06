USE [Lp_commissions]
GO
/****** Object:  StoredProcedure [dbo].[usp_transaction_detail_ins]    Script Date: 01/17/2013 09:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 6/30/2008
-- Description:	Inserts new transaction detail record and returns the new transaction_detail_id
-- =============================================
-- 9/10/2009 Gail Mangaroo Added Term Start and End Dates 
-- =============================================
-- 12/19/2009 Gail Mangaroo Added batch_id, is_primary, comments, contract_term_start and contract_end fields 
-- =============================================
-- 4/12/2010 Gail Mangaroo Added payment_opiton_id and payment_option_seting fields
--=============================================
-- 11/23/2011 Gail Mangaroo Changed data type of @p_contract_term param to allow decimal
-- ============================================
-- =============================================
-- Author:		Lehem Felican
-- Create date: 1/14/2013
-- Description:	Added 3 AdditionalRate params to update query
-- =============================================
ALTER PROCEDURE [dbo].[usp_transaction_detail_ins] 
	-- Add the parameters for the stored procedure here
	@p_account_id varchar(30)  
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
	, @p_primary_vendor_id int = 0
	, @p_contract_term float = 0 
	, @p_payment_option_id int = 0 
	, @p_nonreversible bit = 0
	
	, @p_pro_rate_factor float = 1
	, @p_rate_cap float = 0 
	, @p_is_custom_rate bit = 0 
	
	, @p_term_start datetime = null 
	, @p_term_end datetime = null 
	
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

	INSERT INTO [lp_commissions].[dbo].[transaction_detail]
           ([account_id]
           ,[contract_nbr]
           ,[product_id]
           ,[utility_id]
           ,[retail_mkt_id]
           ,[vendor_id]
           ,[date_deal]
           ,[date_flow_requested]

           ,[transaction_type_id]
           ,[approval_status_id]

           ,[base_amount]
           ,[rate]
           ,[term]
           ,[vendor_pct]
           ,[house_pct]
           ,[pro_rate_term]
           ,[amount]
           ,[rate_setting_id]
           ,[calculation_rule_id]

           ,[date_due]
           ,[void]
           ,[source]
           ,[reason_code]

           ,[transaction_summary_id]
           ,[invoice_id]
           ,[calculation_freq_id]
           ,[assoc_transaction_id]
           
			,[date_created]
           ,[username]

	
			, rate_requested 
			, rate_split_point 
			, exception_ind  
			, primary_vendor_id
			
			, contract_term
			, payment_option_id
			, nonreversible
			
			, pro_rate_factor 
			, rate_cap 
			, is_custom_rate 
			
			, date_term_start
			, date_term_end 
			
			, transaction_batch_id 
			, comments 
			, is_primary  
			
			, date_contract_term_start
			, date_contract_term_end
			
			,payment_option_setting_id
			,payment_option_def_id
			,report_date_option_id
			
			, AdditionalRateTypeCalcId
			, AdditionalRateTypeId
			, AdditionalRateAmount
           )

     VALUES
           (@p_account_id
           ,@p_contract_nbr
			,@p_product_id 
           ,@p_utility_id
			,@p_retail_mkt_id
           ,@p_vendor_id 
			,@p_date_deal
			,@p_date_flow_requested

			,@p_transaction_type_id
			,@p_approval_status_id

           ,@p_base_amount
           ,@p_rate
			, @p_term 
			, @p_vendor_pct 
			, @p_house_pct 
			, @p_pro_rate_term 
			, @p_amount
           ,@p_rate_setting_id
           ,@p_calculation_rule_id
           
			,@p_date_due
           ,@p_void
           ,@p_source
           ,@p_reason_code 

           ,@p_transaction_summary_id
			, @p_invoice_id
			, @p_calculation_freq_id 
			, @p_assoc_transaction_id

           ,getdate()
           ,@p_username

	
			, @p_rate_requested  
			, @p_rate_split_point 
			, @p_exception_ind 
			, @p_primary_vendor_id
		   
		   , @p_contract_term
		   , @p_payment_option_id
		   , @p_nonreversible
		   
		   , @p_pro_rate_factor 
		   , @p_rate_cap 
		   , @p_is_custom_rate 
		   
		   , @p_term_start 
		   , @p_term_end 
		   
		   	, @p_transaction_batch_id 
			, @p_comments 
			, @p_is_primary 
			
			, @p_contract_term_start
			, @p_contract_term_end
			
			, @p_payment_option_setting_id
			, @p_payment_option_def_id
			, @p_report_date_option_id 
			
			, @p_AdditionalRateTypeCalcId
			, @p_AdditionalRateTypeId
			, @p_AdditionalRateAmount
		)

	RETURN ISNULL(Scope_Identity(), 0)
	
END
