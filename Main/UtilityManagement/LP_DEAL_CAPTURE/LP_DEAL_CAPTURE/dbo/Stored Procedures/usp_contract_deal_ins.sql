

CREATE procedure [dbo].[usp_contract_deal_ins]
(@p_username										nCHAR(100)
 ,@p_AccountNumber									VARCHAR(30) = '')
AS
/*
-- =================================================
Modify		: 08/19/2010	- Jose Munoz (SWCS)
Ticket		: 17740	
Description	: Add validation to avoid insert duplicate accounts into 
			lp_deal_capture..deal_contract_account table.
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- Clear code (remove prINT AND put SET notcount)
-- Put WITH (NOLOCK) in the SELECT querys
-- Verify the powermove information FROM EDI transaction
-- Add new column in the query
-- =======================================

*/

/* Ticket 17740	BEGIN */
DECLARE @ProcessDate							DATETIME
	,@ProcessUser								VARCHAR(60)
	,@ErrorText									VARCHAR(300)
	,@FlagError									BIT
	,@w_power_move								VARCHAR(50)
	,@w_ESPCommodityPrice						VARCHAR(100)
	,@w_duns_number_utility						VARCHAR(255)
	,@w_duns_number_entity						VARCHAR(255)
	,@w_account_id								CHAR(12)
	,@w_account_number							VARCHAR(30)
	,@w_account_type							VARCHAR(35)
	,@w_contract_nbr							CHAR(12)
	,@w_contract_type							VARCHAR(25)
	,@w_utility_id								CHAR(15)
	,@w_entity_id								CHAR(15)
	,@w_retail_mkt_id							CHAR(02)
	,@w_product_id								CHAR(20)
	,@w_rate_id									INT
	,@w_rate									FLOAT
	,@w_account_name_link						INT
	,@w_customer_name_link						INT
	,@w_customer_address_link					INT
	,@w_customer_contact_link					INT
	,@w_billing_address_link					INT
	,@w_billing_contact_link					INT
	,@w_owner_name_link							INT
	,@w_service_address_link					INT
	,@w_business_type							VARCHAR(35)
	,@w_business_activity						VARCHAR(35)
	,@w_additional_id_nbr_type					VARCHAR(10)
	,@w_additional_id_nbr						VARCHAR(30)
	,@w_contract_eff_start_date					DATETIME
	,@w_term_months								INT
	,@w_date_end								DATETIME
	,@w_date_deal								DATETIME
	,@w_sales_channel_role						nVARCHAR(50)				 
	,@w_sales_rep								VARCHAR(100)
	,@w_grace_period							INT
	,@w_address_link							INT
	,@w_address									CHAR(50)
	,@w_city									CHAR(28)
	,@w_state									CHAR(02)
	,@w_zip										CHAR(10)
	,@w_CHARINDEX_temp							INT
	,@w_CHARINDEX_start							INT
	,@w_string									VARCHAR(255)
	,@w_address_type							VARCHAR(20)
	,@w_name									VARCHAR(255)
	,@w_serv_addr								VARCHAR(255)
	,@w_bill_addr								VARCHAR(255)
	,@w_return									INT
	,@w_request_id								VARCHAR(50)
	,@w_util_acct								VARCHAR(255)	
	,@t_util_acct								VARCHAR(255)
	,@w_GETDATE									DATETIME
	,@w_trans_eff_date							DATETIME
	,@w_zone									VARCHAR(255)
	
SELECT 	@ProcessDate							= GETDATE()
	,@ProcessUser								= SUSER_SNAME()
	,@ErrorText									= ''
	,@FlagError									= 0
	,@w_return									= 0
	,@w_util_acct								= ''
	,@t_util_acct								= ''
	,@w_GETDATE									= GETDATE()
	,@w_request_id								= 'SALES CHANNEL-'
												+ CONVERT(CHAR(08), GETDATE(), 112)
												+ CONVERT(CHAR(10), GETDATE(), 108)
												+ ':' 
												+ CONVERT(VARCHAR(03), datepart(ms, GETDATE()))

/* Ticket 17740	END */

SET rowcount 1

SELECT @w_util_acct								= util_acct,
		@w_duns_number_utility					= utility,
		@w_duns_number_entity					= esco,
		@w_date_end								= trans_eff_date,
		@w_date_deal							= transmission_date,
		@w_name									= [name],
		@w_serv_addr							= serv_addr,
		@w_bill_addr							= bill_addr,
		@w_zone									= nyiso_area,
		@w_power_move							= power_move,
		@w_ESPCommodityPrice					= ESPCommodityPrice,
		@w_trans_eff_date						= trans_eff_date
FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK INDEX = load_set_number_accepted_idx1)
WHERE process_status = ' ' 
AND util_acct > @t_util_acct
AND NOT (utility LIKE '%006982359%' AND len(util_acct) <> 15) -- CONED accounts of invalid lengths cause the entire process to stop.
AND util_acct = CASE WHEN @p_AccountNumber <> '' THEN @p_AccountNumber ELSE util_acct END


WHILE @@ROWCOUNT <> 0
BEGIN

	PRINT ('procedure usp_contract_deal_ins Account' + LTRIM(RTRIM(@p_AccountNumber)))

	IF @w_duns_number_utility in (SELECT DunsNumber FROM libertypower..utility  WITH (NOLOCK) WHERE MarketID = 1)
		SELECT @w_contract_type = 'POLR'
	ELSE
		SELECT @w_contract_type = 'POWER MOVE'

	SET @w_zone =	CASE 
					WHEN @w_zone = 'MILL WD' THEN 'H' 
					WHEN @w_zone = 'DUNWOD' THEN 'I'
					WHEN @w_zone = 'N.Y.C.' THEN 'J'
					ELSE @w_zone END


	SET ROWCOUNT 0

	SELECT @t_util_acct							= @w_util_acct
		,@w_account_number						= @w_util_acct

	SELECT @w_utility_id						= utility_id,
		  @w_retail_mkt_id						= retail_mkt_id
	FROM lp_common..common_utility WITH (NOLOCK) 
	WHERE @w_duns_number_utility				LIKE '%' + LTRIM(RTRIM(duns_number)) + '%'

	IF @@ROWCOUNT								= 0
	BEGIN
	  UPDATE lp_enrollment..load_set_number_accepted SET process_status = 'E'
	  FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK INDEX = load_set_number_accepted_idx1)
	  WHERE process_status						  = ' '
	  and	util_acct								= @w_account_number

	  goto goto_next_rec
	END

	SELECT @w_entity_id							  = entity_id
	FROM lp_common..common_entity WITH (NOLOCK INDEX = common_entity_idx3)
	WHERE @w_duns_number_entity					LIKE '%' + LTRIM(RTRIM(duns_number)) + '%'

	IF @@ROWCOUNT									= 0
	BEGIN
	  UPDATE lp_enrollment..load_set_number_accepted SET process_status = 'E'
	  FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK INDEX = load_set_number_accepted_idx1)
	  WHERE process_status						  = ' '
	  and	util_acct								= @w_account_number

	  GOTO goto_next_rec
	END

	SELECT @w_account_type						= ' '
		,@w_product_id							= ' '
		,@w_rate_id								= 999999999
		,@w_business_type						= 'NONE'
		,@w_business_activity					= 'NONE'
		,@w_additional_id_nbr_type				= 'NONE'
		,@w_additional_id_nbr					= 'NONE'
		,@w_term_months							= 0
		,@w_date_end							= '19000101'
		,@w_date_deal							= '19000101'
		,@w_sales_channel_role					= 'NONE'
		,@w_sales_rep							= 'NONE'

	
	SELECT @w_account_type			= 1, --account_type,
		  @w_product_id				= product_id,
		  @w_rate_id				= CASE WHEN @w_zone = 'H' THEN 0 WHEN @w_zone = 'I' THEN 1 WHEN @w_zone = 'J' THEN 2 ELSE rate_id END,
		  @w_business_type			= business_type,
		  @w_business_activity		= business_activity,
		  @w_additional_id_nbr_type = additional_id_nbr_type,
		  @w_additional_id_nbr		= additional_id_nbr,
		  @w_term_months			= term_months,
		  @w_sales_channel_role		= sales_channel_role,
		  @w_sales_rep				= sales_rep
	FROM lp_deal_capture..deal_contract_default WITH (NOLOCK INDEX = deal_contract_default_idx)
	WHERE contract_type = @w_contract_type AND utility_id = @w_utility_id 

	SELECT @w_rate								= 0
		,@w_grace_period						= 0
		,@w_contract_eff_start_date				= '19000101'

	SELECT @w_rate								= rate,
			@w_grace_period						= grace_period,
			@w_contract_eff_start_date			= contract_eff_start_date,
			@w_term_months						= term_months
	FROM lp_common..common_product_rate WITH (NOLOCK INDEX = common_product_rate_idx)
	WHERE product_id							= @w_product_id
	and	rate_ID									= @w_rate_id

	IF @@ROWCOUNT = 0
	BEGIN
		UPDATE lp_enrollment..load_set_number_accepted SET process_status = 'E'
		FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK INDEX = load_set_number_accepted_idx1)
		WHERE process_status = ' ' AND util_acct = @w_account_number

		goto goto_next_rec
	END

	IF @w_contract_type = 'POWER MOVE'
	BEGIN
		SELECT TOP 1  @w_product_id		= product_id
			,@w_rate_id					= rate_id
			,@w_rate					= ISNULL(@w_ESPCommodityPrice, @w_rate)
			,@w_term_months				= term_months
			,@w_contract_eff_start_date	= @w_trans_eff_date
		FROM lp_common..common_product_rate WITH (NOLOCK)-- INDEX = common_product_rate_idx)
		WHERE product_id				= LTRIM(RTRIM(@w_utility_id)) + '_VAR'
		AND rate_descp					LIKE '12%' 
		AND rate_descp					LIKE '%Zone '  + LTRIM(RTRIM(@w_zone))
		ORDER BY rate_id DESC			
		print ('@@w_rate >>' + str(@w_rate))
	END
	
	SELECT @w_contract_nbr	= ''
		,@w_return			= 0

	EXEC @w_return = lp_deal_capture..usp_get_key @p_username, 'CONTRACT NBR', @w_contract_nbr OUTPUT, 'N'

	IF @w_return <> 0
	BEGIN
	  UPDATE lp_enrollment..load_set_number_accepted SET process_status = 'E'
	  FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK INDEX = load_set_number_accepted_idx1)
	  WHERE process_status = ' ' AND util_acct = @w_account_number

	  goto goto_next_rec
	END

	SELECT @w_account_id	= ''
		,@w_return			= 0

	EXEC @w_return = lp_deal_capture..usp_get_key @p_username, 'ACCOUNT ID', @w_account_id OUTPUT, 'N'

	IF @w_return <> 0
	BEGIN
		UPDATE lp_enrollment..load_set_number_accepted SET process_status = 'E'
		FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK INDEX = load_set_number_accepted_idx1)
		WHERE process_status = ' ' AND util_acct = @w_account_number

		goto goto_next_rec
	END

	SELECT @w_account_name_link		= 1
		,@w_customer_name_link		= 1
		,@w_owner_name_link			= 1
		,@w_customer_contact_link	= 1
		,@w_billing_contact_link	= 1
		,@w_customer_address_link	= 0
		,@w_billing_address_link	= 0
		,@w_service_address_link	= 0

	SET @w_address_type = 'SERVICES'

	WHILE @w_address_type <> ' '
	BEGIN

	  IF @w_address_type = 'SERVICES'
	  BEGIN
		 SELECT @w_string = @w_serv_addr
	  END

	  IF @w_address_type  = 'BILLING'
	  BEGIN
		 SELECT @w_string = @w_bill_addr
	  END

	  SELECT @w_address = 'NONE', @w_city = 'NONE', @w_state = 'NN', @w_zip = 'NONE'

	  SELECT @w_CHARINDEX_temp		= CHARINDEX('|', @w_string, 1)
		,@w_CHARINDEX_start			= 1
 
	  IF @w_CHARINDEX_temp > 0
	  BEGIN

		 SET @w_address							= SUBSTRING(@w_string, @w_CHARINDEX_start, @w_CHARINDEX_temp - @w_CHARINDEX_start)
		
		 SET  @w_CHARINDEX_start				= @w_CHARINDEX_temp + 1

		 SET @w_CHARINDEX_temp					= CHARINDEX('|', @w_string, @w_CHARINDEX_start)

		 IF @w_CHARINDEX_temp					> 0
		 BEGIN

			SET @w_city							= SUBSTRING(@w_string, @w_CHARINDEX_start, @w_CHARINDEX_temp - @w_CHARINDEX_start)

			SET @w_CHARINDEX_start				= @w_CHARINDEX_temp + 1

			SET @w_CHARINDEX_temp				= CHARINDEX('|', @w_string, @w_CHARINDEX_start)

			IF @w_CHARINDEX_temp				> 0
			BEGIN

				SET @w_state					= SUBSTRING(@w_string, @w_CHARINDEX_start, @w_CHARINDEX_temp - @w_CHARINDEX_start)

				SET @w_CHARINDEX_start			= @w_CHARINDEX_temp + 1

				SET @w_CHARINDEX_temp			= CHARINDEX('|', @w_string, @w_CHARINDEX_start)

				IF @w_CHARINDEX_temp				 > 0
				BEGIN
				  SET @w_zip					= SUBSTRING(@w_string, @w_CHARINDEX_start, @w_CHARINDEX_temp - @w_CHARINDEX_start)
				  
				END
				ELSE
				BEGIN
				  SET @w_zip					 = SUBSTRING(@w_string, @w_CHARINDEX_start, 10)
				END

			END
		 END
	  END

	  IF @w_address_type = 'BILLING'
	  BEGIN
		 SELECT @w_address_type = ' '
		 IF exists(SELECT contract_nbr 
					FROM lp_deal_capture..deal_address WITH (NOLOCK INDEX = deal_address_idx)
					WHERE contract_nbr	= @w_contract_nbr
					AND [address]		= @w_address
					AND city			= @w_city
					AND [state]			= @w_state
					AND zip				= @w_zip)
		 or (@w_address = 'NONE' AND @w_city = 'NONE' AND @w_state = 'NN' AND @w_zip = 'NONE')
		 BEGIN
			SELECT @w_billing_address_link	= 1
				,@w_address_link			= 0
		 END
		 ELSE
		 BEGIN
			SELECT @w_billing_address_link	= 2
				,@w_address_link			= 2
		 END  
	  END

	  IF @w_address_type = 'SERVICES'
	  BEGIN
		SELECT @w_customer_address_link = 1
			,@w_billing_address_link	= 1
			,@w_service_address_link	= 1
			,@w_address_link			= 1
			,@w_address_type			= 'BILLING'
	  END

	  IF @w_address_link <> 0
	  BEGIN
		 INSERT INTO lp_deal_capture..deal_address
		 SELECT @w_contract_nbr,  @w_address_link, @w_address, ' ', @w_city, @w_state, @w_zip, ' ', ' ', ' ', 0
	  END
	 
	END

	INSERT INTO lp_deal_capture..deal_name
	SELECT @w_contract_nbr,
		  1,
		  CASE WHEN @w_name = ' ' or @w_name is null
				THEN 'NONE'
				ELSE SUBSTRING(@w_name, 1, 100)
		  END,
		  0

	INSERT INTO lp_deal_capture..deal_contact
	SELECT @w_contract_nbr,1,'NONE','NONE','NONE','999999','NONE','NONE','01/01', 0
		  
	INSERT INTO lp_deal_capture..deal_contract
		 (contract_nbr	, contract_type	, [status], retail_mkt_id	, utility_id	, account_type	, product_id	, rate_id	, rate	, customer_name_link	, customer_address_link	, customer_contact_link	, billing_address_link	, billing_contact_link	, owner_name_link	, service_address_link	, business_type	, business_activity	, additional_id_nbr_type	, additional_id_nbr	, contract_eff_start_date	, enrollment_type, term_months	, date_end	, date_deal	, date_created, date_submit, sales_channel_role	, username	, sales_rep	, origin , grace_period	, chgstamp)
	SELECT @w_contract_nbr, @w_contract_type, 'RUNNING', @w_retail_mkt_id, @w_utility_id, @w_account_type, @w_product_id, @w_rate_id, @w_rate, @w_customer_name_link, @w_customer_address_link, @w_customer_contact_link, @w_billing_address_link, @w_billing_contact_link, @w_owner_name_link, @w_service_address_link, @w_business_type, @w_business_activity, @w_additional_id_nbr_type, @w_additional_id_nbr, @w_contract_eff_start_date, 1			  , @w_term_months, @w_date_end, @w_GETDATE, @w_GETDATE  , @w_GETDATE , @w_sales_channel_role, @p_username, @w_sales_rep, 'BATCH', @w_grace_period, 0

	/* validation */
	/* Ticket 17740	BEGIN */
	--IF exists (SELECT 1 FROM lp_deal_capture..deal_contract_account WITH (NOLOCK)
	--			WHERE account_number		= @w_account_number
	--			AND utility_id				= @w_utility_id)
	--BEGIN
	--	SELECT @ErrorText					= 'This combination Account/Utility  already exists into deal_capture_account table.'
	--	INSERT INTO lp_deal_capture..tbl_usp_contract_deal_ins_err
	--		(contract_nbr	, contract_type	, account_number  , status, account_id  , retail_mkt_id	, utility_id  , product_id  , rate_id  , rate  , account_name_link	, customer_name_link  , customer_address_link  , customer_contact_link  , billing_address_link  , billing_contact_link  , owner_name_link  , service_address_link  , business_type  , business_activity  , additional_id_nbr_type  , additional_id_nbr  , contract_eff_start_date  , enrollment_type, term_months  , date_end  , date_deal  , date_created, date_submit, sales_channel_role  , username  , sales_rep  , origin, grace_period  , chgstamp, ProcessDate, ProcessUser, ErrorText)
	--	SELECT @w_contract_nbr, @w_contract_type,@w_account_number,' '	,@w_account_id, @w_retail_mkt_id,@w_utility_id,@w_product_id,@w_rate_id,@w_rate, @w_account_name_link,@w_customer_name_link,@w_customer_address_link,@w_customer_contact_link,@w_billing_address_link,@w_billing_contact_link,@w_owner_name_link,@w_service_address_link,@w_business_type,@w_business_activity,@w_additional_id_nbr_type,@w_additional_id_nbr,@w_contract_eff_start_date,1				,@w_term_months,@w_date_end,@w_GETDATE,@w_GETDATE	,@w_GETDATE  ,@w_sales_channel_role,@p_username,@w_sales_rep,'BATCH',@w_grace_period,0, @ProcessDate, @ProcessUser, @ErrorText
	--	SET @FlagError	=	1
	--	goto goto_next_rec
	--END
		/* Ticket 17740	END */
		
		
	IF @w_power_move = 'MANUAL - POWERMOVE' AND 	@w_sales_channel_role = 'NONE'
	BEGIN
		SELECT @w_sales_channel_role	= 'POWERMOVE'
				,@w_sales_rep			= 'NONE'
	END
	INSERT INTO lp_deal_capture..deal_contract_account
		 (contract_nbr	, contract_type	, account_number  , status, account_id  , retail_mkt_id	, utility_id  , account_type	, product_id  , rate_id  , rate  , account_name_link	, customer_name_link  , customer_address_link  , customer_contact_link  , billing_address_link  , billing_contact_link  , owner_name_link  , service_address_link  , business_type  , business_activity  , additional_id_nbr_type  , additional_id_nbr  , contract_eff_start_date  , enrollment_type, term_months  , date_end  , date_deal  , date_created, date_submit, sales_channel_role  , username  , sales_rep  , origin, grace_period  , chgstamp)
	SELECT @w_contract_nbr, @w_contract_type,@w_account_number,' '	,@w_account_id, @w_retail_mkt_id,@w_utility_id, @w_account_type, @w_product_id,@w_rate_id,@w_rate, @w_account_name_link,@w_customer_name_link,@w_customer_address_link,@w_customer_contact_link,@w_billing_address_link,@w_billing_contact_link,@w_owner_name_link,@w_service_address_link,@w_business_type,@w_business_activity,@w_additional_id_nbr_type,@w_additional_id_nbr,@w_contract_eff_start_date,1				,@w_term_months,@w_date_end,@w_GETDATE,@w_GETDATE	,@w_GETDATE  ,@w_sales_channel_role,@p_username,@w_sales_rep,'BATCH',@w_grace_period,0

	UPDATE lp_enrollment..load_set_number_accepted SET process_status = 'C'
	FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK INDEX = load_set_number_accepted_idx1)
	WHERE process_status							 = ' '
	and	util_acct								  = @w_util_acct

	INSERT INTO lp_deal_capture..deal_contract_batch
	SELECT @w_request_id, @w_contract_nbr, @w_contract_type

	goto_next_rec:

	SET ROWCOUNT 1

	SELECT @w_util_acct							= util_acct,
		@w_duns_number_utility					= utility,
		@w_duns_number_entity					= esco,
		@w_date_end								= transmission_date,
		@w_date_deal							= trans_eff_date,
		@w_name									= [name],
		@w_serv_addr							= serv_addr,
		@w_bill_addr							= bill_addr,
		@w_zone									= nyiso_area,
		@w_power_move							= power_move,
		@w_ESPCommodityPrice					= ESPCommodityPrice,
		@w_trans_eff_date						= trans_eff_date
	FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK INDEX = load_set_number_accepted_idx1)
	WHERE process_status = ' ' AND util_acct > @t_util_acct
	AND NOT (utility LIKE '%006982359%' AND len(util_acct) <> 15) -- CONED accounts of invalid lengths cause the entire process to stop.
	AND util_acct = CASE WHEN @p_AccountNumber <> '' THEN @p_AccountNumber ELSE util_acct END


END

SET ROWCOUNT 0
EXEC usp_contract_submit_batch_ins @p_username, @w_request_id
IF @FlagError	=	1
	SELECT * FROM tbl_usp_contract_deal_ins_err WITH (NOLOCK)
	WHERE ProcessDate	= @ProcessDate
	AND ProcessUser		= @ProcessUser
