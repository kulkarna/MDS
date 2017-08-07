USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_deal_pricing_tables_sel]    Script Date: 06/24/2011 16:36:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*************************************************************************************************************/

ALTER TABLE deal_pricing_detail 
	ADD ETP DECIMAL(9,6)
	
GO

/*******************************************************************************************************************/

ALTER PROCEDURE [dbo].[usp_deal_pricing_tables_sel]
( 
  @p_deal_pricing_detail_id		 int = 0
) 
AS 
BEGIN 

	SET NOCOUNT ON;
	
	SELECT 
		 d.[deal_pricing_detail_id]
		,d.[deal_pricing_id]
		,d.[product_id]
		,d.[rate_id]
		,d.[date_created]
		,d.[username]
		,d.[date_modified]
		,d.[modified_by]
		,d.[MTM]
		,d.ContractRate
		,CASE WHEN d.HasPassThrough = '1' THEN '1' ELSE '0' END AS HasPassThrough
		,CASE WHEN d.BackToBack = '1' THEN '1' ELSE '0' END AS BackToBack
		,d.HeatIndexSourceID -- Project IT037
		,d.HeatRate -- Project IT037
		,d.ExpectedTermUsage
		,d.ExpectedAccountsAmount
		,CASE WHEN d.rate_submit_ind = '1' THEN '1' ELSE '0' END AS rate_submit_ind
		,d.Commission
		,d.Cost
		,d.ETP --added for project IT051: MtM
		,r.GrossMargin
		,r.IndexType
		,r.rate_descp
		,r.rate
		,r.term_months
		,p.account_type_id
		,p.utility_id
		,p.product_descp
		,u.UtilityCode
		,u.MarketID
		,m.MarketCode
		,dp.sales_channel_role
		,at.AccountType
		,dp.account_name
		,dp.date_expired
		,dp.commission_rate
		,r.contract_eff_start_date as date_start
		,r.BillingTypeID as BillingType
	FROM [lp_deal_capture].[dbo].[deal_pricing_detail] d
		JOIN lp_deal_capture..deal_pricing dp ON dp.deal_pricing_id = d.deal_pricing_id
		JOIN lp_common.dbo.common_product_rate r ON d.product_id = r.product_id AND d.rate_id = r.rate_id 
		JOIN lp_common.dbo.common_product p ON d.product_id = p.product_id 
		JOIN LibertyPower..Utility u ON p.utility_id = u.utilityCode
		JOIN LibertyPower..Market m ON u.MarketID = m.ID  
		JOIN LibertyPower..AccountType at on p.account_type_id = at.ID                
	WHERE d.deal_pricing_detail_id = @p_deal_pricing_detail_id
   
END 
GO
/********************************************************************************************************************************************************/

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
           )
     VALUES
           (@p_account_name
           ,@p_sales_channel_role
           ,@p_comm_rate
           ,@p_date_expired
           ,@p_username
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

GO
/*******************************************************************************************************************************************/

ALTER PROCEDURE [dbo].[usp_deal_pricing_tables_upd]
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
     WHERE deal_pricing_detail_id = @p_deal_pricing_detail_id

	SELECT 
			 flag_error = 'I' --@e_flag
			,code_error = '00000001' ---@e_msg_id
			,message_error = 'Process Completed Successfully'
			,deal_pricing_detail_id = @p_deal_pricing_detail_id
			,@p_rate_id as rate_id
			,@p_deal_pricing_id as deal_pricing_id
			
END 

GO