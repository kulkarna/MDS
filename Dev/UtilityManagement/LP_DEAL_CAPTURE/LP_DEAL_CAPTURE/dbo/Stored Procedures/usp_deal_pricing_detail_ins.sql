
-- =============================================
-- Modified: Jose Munoz 1/28/2010
-- add HeatIndexSourceID and HeatRate for account table  
-- Project IT037
-- =============================================


CREATE PROC [dbo].[usp_deal_pricing_detail_ins]
( 
  @p_deal_pricing_id int 
, @p_product_id varchar(20)
, @p_username varchar(50)
, @p_rate float
, @p_rate_descp varchar(250)
, @p_term_months int 
, @p_date_expired datetime 
, @p_error char(1) = '' output 
, @p_msg_id char(8) = '' output 
, @p_descp varchar(250) = '' output 
, @p_result_ind char(1) = 'N'
, @GrossMargin	decimal(9,6)
, @ContractRate	decimal(9,6)
, @Commission	decimal(9,6)
, @IndexType	varchar(50)
, @p_detail_id_out int = 0 output  
, @Cost DECIMAL(9,6)
, @MTM DECIMAL(9,6) = null
, @HasPassThrough int
, @BackToBack int
, @p_heat_index_source_ID int = null -- Project IT037
, @p_heat_rate float = null -- Project IT037

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
			DECLARE @p_contract_eff_start_date datetime
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
			SET @p_contract_eff_start_date = lp_enrollment.dbo.ufn_date_only(getdate())
	 
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
			  ,@p_contract_eff_start_date
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
			  ,@GrossMargin
			  ,@IndexType

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
           ,BackToBack
           ,HeatIndexSourceID -- Project IT037
           ,HeatRate -- Project IT037
           )
     VALUES
           (@p_deal_pricing_id
           ,@p_product_id
           ,@rate_id
           ,@p_username
           ,@ContractRate
           ,@Commission           
           ,@HasPassThrough	
           ,@Cost
           ,@MTM
           ,@BackToBack
           ,@p_heat_index_source_ID -- Project IT037
           ,@p_heat_rate -- Project IT037
			)

		SELECT @p_detail_id_out = Scope_Identity()

		SELECT 
				 flag_error = 'I' --@e_flag
				,code_error = '00000001' ---@e_msg_id
				,message_error = 'Process Completed Successfully' --@e_descr
				,deal_pricing_detail_id = @p_detail_id_out
END 

