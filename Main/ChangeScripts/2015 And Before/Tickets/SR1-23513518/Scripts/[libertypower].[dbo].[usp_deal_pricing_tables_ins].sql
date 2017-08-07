USE [lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_deal_pricing_tables_ins]    Script Date: 08/21/2012 11:24:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************************************** usp_deal_pricing_tables_ins **********************************************/

ALTER  PROC [dbo].[usp_deal_pricing_tables_ins]
( 
  @p_product_id varchar(20)
, @p_username varchar(50)
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
, @p_detail_id_out int = 0 output  
, @p_Cost DECIMAL(9,6)
, @p_MTM DECIMAL(9,6) = null
, @p_ETP DECIMAL(9,6) = null
, @p_HasPassThrough int
, @p_BackToBack int
, @p_heat_index_source_ID int = null -- Project IT037
, @p_heat_rate float = null -- Project IT037
, @p_expected_term_usage int = null
, @p_expected_accounts_amount int = null
, @p_account_name varchar(50) 
, @p_sales_channel_role varchar(50)
, @p_comm_rate money
, @p_BillingTypeID int = null
, @p_pricing_request_id varchar(50)
, @p_price_id int = null
) 

AS 
BEGIN 

	-- Get rate_id and insert into product rate first 
	-- =========================================================== 
	DECLARE @rate_id int 
	SELECT  @rate_id  =	ISNULL((MAX(rate_id) + 1), 1)
		FROM	lp_common..common_product_rate
		WHERE	product_id = @p_product_id


			DECLARE @RC int
--			DECLARE @p_username nchar(100)
--			DECLARE @p_product_id char(20)
--			DECLARE @p_rate_id int
			DECLARE @p_eff_date datetime
--			DECLARE @p_rate float
--			DECLARE @p_rate_descp varchar(50)
			DECLARE @p_grace_period int
--			DECLARE @p_contract_eff_start_date datetime
			DECLARE @p_due_date datetime
			DECLARE @p_val_01 varchar(10)
			DECLARE @p_input_01 varchar(10)
			DECLARE @p_process_01 varchar(10)
			DECLARE @p_val_02 varchar(10)
			DECLARE @p_input_02 varchar(10)
			DECLARE @p_process_02 varchar(10)
--			DECLARE @p_zone_id int
--			DECLARE @p_service_rate_class_id int
			DECLARE @p_ierror char(1)
			DECLARE @p_imsg_id char(8)
			DECLARE @p_idescp varchar(250)
--			DECLARE @p_result_ind char(1)
--			DECLARE @p_term_months int
			DECLARE @p_fixed_end_date tinyint

			SET @p_eff_date = lp_enrollment.dbo.ufn_date_only(getdate())
--			SET @p_contract_eff_start_date = lp_enrollment.dbo.ufn_date_only(getdate())
	 
			SET @p_due_date = lp_enrollment.dbo.ufn_date_only(@p_date_expired + 1)

			SET @p_val_01 = ''
			SET @p_input_01 = ''
			SET @p_process_01 = ''
			SET @p_val_02 = ''
			SET @p_input_02 = ''
			SET @p_process_02 = '' 
			
			SET @p_fixed_end_date = 0 -- 1 setting to one will cause contract start and end dates on the account to be excatly equal to effective and due dates

			SET @p_grace_period = datediff(dd, getdate(), @p_date_expired ) 

			EXECUTE @RC = [lp_common].[dbo].[usp_product_rate_ins] 
			   @p_username
			  ,@p_product_id
			  ,@rate_id
			  ,@p_eff_date
			  ,@p_rate
			  ,@p_rate_descp
			  ,@p_grace_period
			  ,@p_date_start
			  ,@p_due_date
			  ,@p_val_01
			  ,@p_input_01
			  ,@p_process_01
			  ,@p_val_02
			  ,@p_input_02
			  ,@p_process_02
			  ,0 -- @p_zone_id
			  ,0 -- @p_service_rate_class_id
			  ,@p_ierror
			  ,@p_imsg_id
			  ,@p_idescp
			  ,'N'
			  ,@p_term_months
			  ,@p_fixed_end_date
			  ,@p_GrossMargin
			  ,@p_IndexType
			  ,@p_BillingTypeID
			  
	-- Insert pricing header
	-- ===========================================================
	INSERT INTO [lp_deal_capture].[dbo].[deal_pricing]
           ([account_name]
           ,[sales_channel_role]
           ,[commission_rate]
           ,[date_expired]
           ,[username]
           , pricing_request_id
           )
     VALUES
           (@p_account_name
           ,@p_sales_channel_role
           ,@p_comm_rate
           ,@p_date_expired
           ,@p_username
           ,@p_pricing_request_id
           )

	DECLARE @p_deal_pricing_id int 
	SELECT @p_deal_pricing_id = scope_identity()

	-- Insert pricing detail
	-- =========================================================== 
	INSERT INTO [lp_deal_capture].[dbo].[deal_pricing_detail]
           ([deal_pricing_id]
           ,[product_id]
           ,[rate_id]
           ,[username]
           ,ContractRate
           ,Commission
           ,HasPassThrough
           ,Cost
           ,MTM
           ,ETP
           ,BackToBack
		   ,HeatIndexSourceID -- Project IT037
		   ,HeatRate -- Project IT037
		   ,ExpectedTermUsage
		   ,ExpectedAccountsAmount
		   ,PriceID
           )
     VALUES
           (@p_deal_pricing_id
           ,@p_product_id
           ,@rate_id
           ,@p_username
           ,@p_ContractRate
           ,@p_Commission           
           ,@p_HasPassThrough	
           ,@p_Cost
           ,@p_MTM
           ,@p_ETP
           ,@p_BackToBack
           ,@p_heat_index_source_ID -- Project IT037
           ,@p_heat_rate -- Project IT037
           ,@p_expected_term_usage
           ,@p_expected_accounts_amount
           ,@p_price_id
			)

		SELECT @p_detail_id_out = Scope_Identity()

		SELECT 
				 flag_error = 'I' --@e_flag
				,code_error = '00000001' ---@e_msg_id
				,message_error = 'Process Completed Successfully' --@e_descr
				,deal_pricing_detail_id = @p_detail_id_out
				,@rate_id as rate_id
				,@p_deal_pricing_id as deal_pricing_id
				
END 

