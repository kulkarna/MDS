
/************************************** usp_deal_pricing_tables_upd ***********************************************/

CREATE PROCEDURE [dbo].[usp_deal_pricing_tables_upd]
(
  @p_deal_pricing_detail_id int
, @p_deal_pricing_id int 
, @p_product_id varchar(20)
, @p_username varchar(50)
, @p_rate_id int
, @p_rate float
, @p_rate_descp varchar(250)
, @p_term_months int 
, @p_date_expired datetime 
, @p_date_start datetime = null
, @p_error char(1) = '' output 
, @p_msg_id char(8) = '' output 
, @p_descp varchar(250) = '' output 
, @p_result_ind char(1) = 'N'
, @p_GrossMargin	decimal(9,6)
, @p_ContractRate	decimal(9,6)
, @p_Commission	decimal(9,6)
, @p_IndexType	varchar(50) 
, @p_Cost DECIMAL(9,6)
, @p_MTM DECIMAL(9,6) = null
, @p_ETP DECIMAL(9,6) = null
, @p_HasPassThrough int
, @p_BackToBack int
, @p_heat_index_source_ID int = null 
, @p_heat_rate float = null 
, @p_expected_term_usage int = null
, @p_expected_accounts_amount int = null
, @p_account_name varchar(50) 
, @p_sales_channel_role varchar(50)
, @p_comm_rate money
, @p_BillingTypeID int = null
, @p_pricing_request_id varchar(50)
, @SelfGenerationID int = 3
) 

AS 
BEGIN 

	-- Update common product rate
	-- =========================================================== 		  
	UPDATE [lp_common].[dbo].[common_product_rate]
	   SET [rate]					= @p_rate
		  ,[rate_descp]				= @p_rate_descp
		  ,[term_months]			= @p_term_months
		  ,[GrossMargin]			= @p_GrossMargin
		  ,[IndexType]				= @p_IndexType
		  ,[BillingTypeID]			= @p_BillingTypeID
		  ,[contract_eff_start_date]= @p_date_start
	 WHERE product_id  = @p_product_id
	   AND rate_id     = @p_rate_id
	
	-- Update pricing header
	-- =========================================================== 		  
	UPDATE [lp_deal_capture].[dbo].[deal_pricing]
	   SET [account_name] = @p_account_name
		  ,[sales_channel_role] = @p_sales_channel_role 
		  ,[commission_rate] = @p_comm_rate
		  ,[date_expired] = @p_date_expired
		  ,[modified_by] = @p_username
		  ,pricing_request_id = @p_pricing_request_id
		  ,[date_modified] = getdate()
	 WHERE deal_pricing_id  = @p_deal_pricing_id 

	-- Update pricing detail
	-- =========================================================== 
	UPDATE [lp_deal_capture].[dbo].[deal_pricing_detail]
    SET [deal_pricing_id] = @p_deal_pricing_id
        ,[product_id] = @p_product_id
        ,[rate_id] = @p_rate_id
        ,[username]= @p_username
        ,ContractRate = @p_ContractRate
        ,Commission = @p_Commission
        ,HasPassThrough = @p_HasPassThrough
        ,Cost = @p_Cost
        ,MTM = @p_MTM
        ,ETP = @p_ETP
        ,BackToBack = @p_BackToBack
		,HeatIndexSourceID = @p_heat_index_source_ID
		,HeatRate = @p_heat_rate
		,ExpectedTermUsage = @p_expected_term_usage
		,ExpectedAccountsAmount = @p_expected_accounts_amount
		,SelfGenerationID = @SelfGenerationID
     WHERE deal_pricing_detail_id = @p_deal_pricing_detail_id

	SELECT 
			 flag_error = 'I' --@e_flag
			,code_error = '00000001' ---@e_msg_id
			,message_error = 'Process Completed Successfully'
			,deal_pricing_detail_id = @p_deal_pricing_detail_id
			,@p_rate_id as rate_id
			,@p_deal_pricing_id as deal_pricing_id			
END 

