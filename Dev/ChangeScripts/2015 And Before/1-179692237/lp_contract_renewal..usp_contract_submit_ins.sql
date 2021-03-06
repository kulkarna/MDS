USE [lp_contract_renewal]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_submit_ins]    Script Date: 07/25/2013 13:36:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modified		5/20/2008
-- Modified By	Rick Deigsler
-- Added code to delete contract FROM check account table

--	Modified:	7/7/2008 per Douglas
--				SD Ticket # 4434
--				SET contract effective start date to be the next meter read date plus 1 month and 3 days

--exec usp_contract_submit_ins 'libertypower\dmarino', 'Contracto A1'
--exec usp_contract_submit_ins @p_username=N'LIBERTYPOWER\dmarino',@p_contract_nbr=N'0104C483'
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 02/18/2010
-- Description	: Add SSNClear, SSNEncrypted and CreditScoreEncrypted columns to insert.
-- Ticket		: IT002
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
-- Modified: Eric Hernandez 9/8/2010
-- Added "ORDER BY" when accessing common_utility_check_type table, so that steps are handled in order.
-- Ticket 17816
-- =============================================
-- Modify		: Lucio Teles /Jose Munoz
-- Date			: 09/21/2010
-- Description	: REMOVE THE @w_contract_eff_start_date CALCULATION 
-- Ticket		: 18209
-- =============================================
-- ===============================================================
-- Modified José Muñoz 01/20/2011
-- Account/ Customer Name should be trimmed when inserting into the Table....  
-- Ticket 20906
-- =============================================
-- Modified Isabelle Tamanini 4/14/2011
-- Adding piece of code that inserts add on accounts in account table
-- Ticket 22541 
-- ===============================================================
-- Modified José Muñoz 06/10/2011
-- Added new table deal_account_address into the query
-- Added new table deal_account_contact into the query
-- Ticket 23125
-- =============================================
-- Modified: Isabelle Tamanini 12/16/2011
-- SR1-4955209
-- Date END will be terms + flow start date - 1 day
-- =============================================
-- Modified: Isabelle Tamanini 05/08/2012
-- SR1-15006521
-- Added utility id to SELECT the account id based on account number
-- =============================================
-- Modified: JAime FOrero 10/4/2012
-- MD084
-- Encapsulated coping of address name and contact data to liberty power
-- using new tables
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- Clear code (remove print)
-- Put WITH (NOLOCK) in the SELECT querys
-- =======================================
-- Modified 12/20/2012 - Rick Deigsler
-- Added code to get link ids for name, address and contact
-- =======================================================
-- Modified: Isabelle Tamanini 04/25/2013
-- SR1-103583802
-- Added transaction code to persist the submission
-- =============================================
-- Modify : Thiago Nogueira
-- Date : 7/25/2013 
-- Ticket: 1-179692237
-- Changed PriceID to BIGINT
-- =============================================
	
ALTER procedure [dbo].[usp_contract_submit_ins]
	(@p_username					NCHAR(100),
	@p_contract_nbr					CHAR(12),
	@p_application					VARCHAR(20) = ' ' OUTPUT,
	@p_error						CHAR(01) = ' ' OUTPUT,
	@p_msg_id						CHAR(08) = ' ' OUTPUT,
	@p_descp_add					VARCHAR(100) = ' ' OUTPUT)
AS

SET NOCOUNT ON

DECLARE @w_error					CHAR(01)
	,@w_msg_id						CHAR(08)
	,@w_return						INT
	,@w_descp_add					VARCHAR(100)
	,@w_duns_number_entity			VARCHAR(255)
	,@w_account_id					CHAR(12)
	,@w_account_number				VARCHAR(30)
	,@w_status						VARCHAR(15)
	,@w_sub_status					VARCHAR(15)
	,@w_entity_id					CHAR(15)
	,@w_contract_nbr				CHAR(12)
	,@w_contract_type				VARCHAR(25)
	,@w_retail_mkt_id				CHAR(02)
	,@w_utility_id					CHAR(15)
	,@w_product_id					CHAR(20)
	,@w_rate_id						INT
	,@w_rate						FLOAT
	,@w_account_name_link			INT
	,@w_customer_name_link			INT
	,@w_customer_address_link		INT
	,@w_customer_contact_link		INT
	,@w_billing_address_link		INT
	,@w_billing_contact_link		INT
	,@w_owner_name_link				INT
	,@w_service_address_link		INT
	,@w_business_type				VARCHAR(35)
	,@w_business_activity			VARCHAR(35)
	,@w_additional_id_nbr_type		VARCHAR(10)
	,@w_additional_id_nbr			VARCHAR(30)
	,@w_contract_eff_start_date		DATETIME
	,@w_term_months					INT
	,@w_date_end					DATETIME
	,@w_date_deal					DATETIME
	,@w_date_created				DATETIME
	,@w_date_submit					DATETIME
	,@w_sales_channel_role			NVARCHAR(50)
	,@w_username					NCHAR(100)
	,@w_sales_rep					VARCHAR(100)
	,@w_origin						VARCHAR(50)
	,@w_annual_usage				MONEY
	,@w_date_flow_start				DATETIME
	,@w_date_por_enrollment			DATETIME
	,@w_date_deenrollment			DATETIME
	,@w_date_reenrollment			DATETIME
	,@w_tax_status					VARCHAR(20)
	,@w_tax_float					INT
	,@w_credit_score				REAL
	,@w_credit_agency				VARCHAR(30)
	,@w_por_option					VARCHAR(03)
	,@w_billing_type				VARCHAR(15)
	,@w_risk_request_id				VARCHAR(50)
	,@w_renew						TINYINT
	,@w_account_type				VARCHAR(50)
	,@w_check_type					CHAR(15)
	,@t_account_number				VARCHAR(30)
	,@w_SSNClear					NVARCHAR(100) 	-- IT002
	,@w_SSNEncrypted				NVARCHAR(512) 	-- IT002
	,@w_CreditScoreEncrypted		NVARCHAR(512) 	-- IT002
	,@w_application					NVARCHAR(20)
	,@w_ROWCOUNT					INT
	,@w_getdate						DATETIME
	,@PriceID						BIGINT -- IT106
-- Start: Added for Overridable Sales Channel settings. IT021
	,@w_evergreen_option_id			INT
	,@w_evergreen_commission_END	DATETIME
	,@w_residual_option_id			INT
	,@w_residual_commission_END		DATETIME
	,@w_initial_pymt_option_id		INT
	,@w_sales_manager				VARCHAR(100)
	,@w_evergreen_commission_rate	FLOAT
	,@RC							INT
	,@Tax							FLOAT
	,@w_AccountID					INT
	,@w_ProcessDate					DATETIME
	,@RetailMktID					INT
	,@UtilityID						INT
	,@CustomerID					INT
	,@NameID						INT
	
		
SELECT @w_getdate		= date_submit
FROM deal_contract WITH (NOLOCK)
WHERE contract_nbr		= @p_contract_nbr
--and   status			= 'RUNNING'

SELECT 
	@w_error						= 'I'
	,@w_msg_id						= '00000001'
	,@w_return						= 0
	,@w_descp_add					= ' ' 
	,@w_application					= 'COMMON'
	,@w_descp_add					= ' '
	,@w_account_id					= ''
	,@w_account_number				= ''
	,@w_entity_id					= ''
	,@w_contract_nbr				= ''
	,@w_contract_type				= ''
	,@w_retail_mkt_id				= ''
	,@w_utility_id					= ''
	,@w_product_id					= ''
	,@w_rate_id						= 0
	,@w_rate						= 0
	,@w_account_name_link			= 0
	,@w_customer_name_link			= 0
	,@w_customer_address_link		= 0
	,@w_customer_contact_link		= 0
	,@w_billing_address_link		= 0
	,@w_billing_contact_link		= 0
	,@w_owner_name_link				= 0
	,@w_service_address_link		= 0
	,@w_business_type				= ''
	,@w_business_activity			= ''
	,@w_additional_id_nbr_type		= ''
	,@w_additional_id_nbr			= ''
	,@w_contract_eff_start_date		= '19000101'
	,@w_term_months					= 0
	,@w_date_end					= '19000101'
	,@w_date_deal					= '19000101'
	,@w_date_created				= '19000101'
	,@w_sales_channel_role			= ''
	,@w_username					= ''
	,@w_sales_rep					= ''
	,@w_origin						= ''
	,@w_date_submit					= @w_getdate
	,@w_annual_usage				= 0
	,@w_date_flow_start				= '19000101'
	,@w_date_por_enrollment			= '19000101'
	,@w_date_deenrollment			= '19000101'
	,@w_date_reenrollment			= '19000101'
	,@w_tax_status					= 'FULL'
	,@w_tax_float					= 0
	,@w_credit_score				= 0
	,@w_credit_agency				= 'NONE'
	,@w_por_option					= 'NO'
	,@w_renew						= 1
	,@w_status						= ''
	,@w_sub_status					= ''
	,@w_entity_id					= ''
	,@w_ProcessDate				= GETDATE()
	
-- BEGIN: Added for Overridable Sales Channel settings.
SELECT 
	@w_evergreen_option_id			= evergreen_option_id
	,@w_evergreen_commission_END	= evergreen_commission_END
	,@w_evergreen_commission_rate	= evergreen_commission_rate
	,@w_residual_option_id			= residual_option_id							
	,@w_residual_commission_END		= residual_commission_END					
	,@w_initial_pymt_option_id		= initial_pymt_option_id						
	,@w_sales_manager				= sales_manager			
FROM lp_contract_renewal.dbo.deal_contract WITH (NOLOCK)
WHERE contract_nbr					= @p_contract_nbr
-- END: Added for Overridable Sales Channel settings.

-- added 5/20/2008
--delete FROM lp_enrollment..check_account 
--WHERE contract_nbr = @p_contract_nbr

-- delete any accounts FROM renewal tables that are not renewing
DELETE deal_contract_account
WHERE	contract_nbr	= @p_contract_nbr
and		renew			= 0

SET @t_account_number = ''

SET ROWCOUNT 1

SELECT @w_account_id				= account_id,
		@w_account_number			= account_number,
		@w_contract_type			= contract_type,
		@w_retail_mkt_id			= retail_mkt_id,
		@w_utility_id				= utility_id,
		@w_product_id				= product_id,
		@w_rate_id					= rate_id,
		@w_rate						= rate,
		@w_account_name_link		= account_name_link,
		@w_customer_name_link		= customer_name_link,
		@w_customer_address_link	= customer_address_link,
		@w_customer_contact_link	= customer_contact_link,
		@w_billing_address_link		= billing_address_link,
		@w_billing_contact_link		= billing_contact_link,
		@w_owner_name_link			= owner_name_link,
		@w_service_address_link		= service_address_link,
		@w_business_type			= business_type,
		@w_business_activity		= business_activity,
		@w_additional_id_nbr_type	= additional_id_nbr_type,
		@w_additional_id_nbr		= additional_id_nbr,
		@w_contract_eff_start_date	= contract_eff_start_date,
		@w_term_months				= term_months,
		@w_date_end					= date_end,
		@w_date_deal				= date_deal,
		@w_date_created				= date_created,
		@w_sales_channel_role		= sales_channel_role,
		@w_username					= username,
		@w_sales_rep				= sales_rep,
		@w_origin					= origin,
		@w_annual_usage				= annual_usage,
		@w_renew					= renew
		,@w_SSNClear				= SSNClear				-- IT002
		,@w_SSNEncrypted			= SSNEncrypted			-- IT002
		,@w_CreditScoreEncrypted	= CreditScoreEncrypted	-- IT002
		,@PriceID					= PriceID -- IT106
FROM deal_contract_account WITH (NOLOCK)
WHERE contract_nbr					= @p_contract_nbr
and   account_number				> @t_account_number
and  ([status]						= ' '
or	  [status]						= 'DRAFT'
or	[status]						= 'RUNNING')
and	  renew							= 1

SET @w_ROWCOUNT		= @@ROWCOUNT

SELECT @w_entity_id			= entity_id,
	   @w_por_option		= por_option,
	   @w_billing_type		= billing_type
FROM lp_common..common_utility b WITH (NOLOCK)
WHERE utility_id			= @w_utility_id

SELECT	TOP 1 @w_status = CASE WHEN wait_status is null THEN '01000' ELSE wait_status END, 
		@w_sub_status	= CASE WHEN wait_sub_status is null THEN '10' ELSE wait_sub_status END
FROM lp_common..common_utility_check_type WITH (NOLOCK)
WHERE utility_id		= @w_utility_id
and contract_type		= @w_contract_type
ORDER BY [order]

BEGIN TRAN Submission

WHILE @w_ROWCOUNT <> 0
BEGIN

	SET ROWCOUNT 0

	SET @t_account_number = @w_account_number

	UPDATE deal_contract_account SET [status] = 'RUNNING'
	WHERE contract_nbr		= @p_contract_nbr
	AND account_number		= @t_account_number

	SELECT @w_account_id					= account_id,
		   @w_account_number				= account_number,
		   @w_contract_type					= contract_type,
		   @w_retail_mkt_id					= retail_mkt_id,
		   @w_utility_id					= utility_id,
		   @w_product_id					= product_id,
		   @w_rate_id						= rate_id,
		   @w_rate							= rate,
		   @w_account_name_link				= account_name_link,
		   @w_customer_name_link			= customer_name_link,
		   @w_customer_address_link			= customer_address_link,
		   @w_customer_contact_link			= customer_contact_link,
		   @w_billing_address_link			= billing_address_link,
		   @w_billing_contact_link			= billing_contact_link,
		   @w_owner_name_link				= owner_name_link,
		   @w_service_address_link			= service_address_link,
		   @w_business_type					= business_type,
		   @w_business_activity				= business_activity,
		   @w_additional_id_nbr_type		= additional_id_nbr_type,
		   @w_additional_id_nbr				= additional_id_nbr,
		   @w_contract_eff_start_date		= contract_eff_start_date,
		   @w_term_months					= term_months,
		   @w_date_end						= date_end,
		   @w_date_deal						= date_deal,
		   @w_date_created					= date_created,
		   @w_sales_channel_role			= sales_channel_role,
		   @w_username						= username,
		   @w_sales_rep						= sales_rep,
		   @w_origin						= origin,
		   @w_annual_usage					= annual_usage,
			@PriceID						= PriceID -- IT106
	FROM deal_contract_account WITH (NOLOCK)
	WHERE contract_nbr		= @p_contract_nbr
	and account_number		= @t_account_number
	and renew				= 1

	SELECT top 1
		   @w_check_type = CASE WHEN b.check_type is null THEN 'USAGE ACQUIRE' ELSE b.check_type END
	FROM deal_contract a WITH (NOLOCK)
	INNER JOIN  lp_common..common_utility_check_type b WITH (NOLOCK)
	ON b.utility_id			= a.utility_id
	AND b.contract_type		= a.contract_type
	WHERE a.contract_nbr	= @p_contract_nbr
	AND b.[order]			> 1   
	ORDER BY [order]

	BEGIN TRAN val

	SELECT @w_descp_add		= ' '
		,@w_return			= 1

	IF exists(SELECT status
		 FROM lp_account..account_renewal WITH (NOLOCK)
		 WHERE account_number				   = @w_account_number
		 and ((ltrim(rtrim(status))			 
		 +	 ltrim(rtrim(sub_status))		 = '0700080')
		 or   (ltrim(rtrim(status))		  
		 +	 ltrim(rtrim(sub_status))		 = '0700090') ))
	BEGIN
		SELECT @w_status		= [status],
			 @w_sub_status		= sub_status,
			 @w_account_id		= account_id,
			 @w_date_created	= date_created
		FROM lp_account..account_renewal WITH (NOLOCK)
		WHERE account_number	= @w_account_number
		and utility_id			= @w_utility_id --SR1-15006521

		DELETE lp_account..account_renewal
		FROM lp_account..account_renewal WITH (NOLOCK)
		WHERE account_id		= @w_account_id

		DELETE lp_account..account_renewal_additional_info
		FROM lp_account..account_renewal_additional_info WITH (NOLOCK)
		WHERE account_id		= @w_account_id

		DELETE lp_account..account_renewal_contact
		FROM lp_account..account_renewal_contact WITH (NOLOCK)
		WHERE account_id		= @w_account_id

		DELETE lp_account..account_renewal_name
		FROM lp_account..account_renewal_name WITH (NOLOCK)
		WHERE account_id		= @w_account_id

		DELETE lp_account..account_renewal_address
		FROM lp_account..account_renewal_address WITH (NOLOCK)
		WHERE account_id		= @w_account_id
	END

	SET @w_return = 1

	EXEC @w_return = lp_account..usp_account_renewal_additional_info_ins @p_username,
																@w_account_id,
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																' ',
																@w_error OUTPUT,
																@w_msg_id OUTPUT, 
																' ',
																'N'

	IF @w_return <> 0
	BEGIN
		ROLLBACK TRAN val
		SELECT @w_application		= 'COMMON'
			,@w_error				= 'E'
			,@w_msg_id				= '00000051'
			,@w_return				= 1
			,@w_descp_add			= ' (Insert Account Additional Info) '

		EXEC usp_contract_error_ins 'RENEWAL',
							  @p_contract_nbr,
							  @w_account_number,
							  @w_application,
							  @w_error,
							  @w_msg_id,
							  @w_descp_add
		goto goto_SELECT
	END

	/* Ticket # 1-34030211 BEGIN */
	
	
	IF NOT EXISTS (	SELECT	contract_nbr
			FROM	lp_account..account
			WHERE	account_id = @w_account_id )
	BEGIN
		-- =================  BEGIN  =============================
		-- Modified 12/20/2012 - Rick Deigsler
		-- Added code to get link ids for name, address and contact
		-- =======================================================

		-- add new account  ----------------------------------------------------------------------------------------------------------		
		EXEC @w_return = usp_account_added_ins @p_username, @w_account_number, @w_application OUTPUT, @w_error OUTPUT, @w_msg_id OUTPUT
		IF @w_return <> 0
			BEGIN
				goto goto_account_error
			END
		ELSE -- will need to select link ids again
			BEGIN
				SELECT @w_account_id					= account_id,
					   @w_account_number				= account_number,
					   @w_contract_type					= contract_type,
					   @w_retail_mkt_id					= retail_mkt_id,
					   @w_utility_id					= utility_id,
					   @w_product_id					= product_id,
					   @w_rate_id						= rate_id,
					   @w_rate							= rate,
					   @w_account_name_link				= account_name_link,
					   @w_customer_name_link			= customer_name_link,
					   @w_customer_address_link			= customer_address_link,
					   @w_customer_contact_link			= customer_contact_link,
					   @w_billing_address_link			= billing_address_link,
					   @w_billing_contact_link			= billing_contact_link,
					   @w_owner_name_link				= owner_name_link,
					   @w_service_address_link			= service_address_link,
					   @w_business_type					= business_type,
					   @w_business_activity				= business_activity,
					   @w_additional_id_nbr_type		= additional_id_nbr_type,
					   @w_additional_id_nbr				= additional_id_nbr,
					   @w_contract_eff_start_date		= contract_eff_start_date,
					   @w_term_months					= term_months,
					   @w_date_end						= date_end,
					   @w_date_deal						= date_deal,
					   @w_date_created					= date_created,
					   @w_sales_channel_role			= sales_channel_role,
					   @w_username						= username,
					   @w_sales_rep						= sales_rep,
					   @w_origin						= origin,
					   @w_annual_usage					= annual_usage,
						@PriceID						= PriceID -- IT106
				FROM deal_contract_account WITH (NOLOCK)
				WHERE contract_nbr		= @p_contract_nbr
				and account_number		= @t_account_number
				and renew				= 1			
			END
		-- ==================  END  ==============================
		-- Modified 12/20/2012 - Rick Deigsler
		-- Added code to get link ids for name, address and contact
		-- =======================================================		
				
		/* CREATE CUSTOMER */
		EXEC @CustomerID	= [Libertypower].[dbo].[usp_CustomerInsert]
				@w_customer_name_link		-- @NameID INT,
				,@w_owner_name_link			-- @OwnerNameID INT = null,
				,@w_customer_address_link	-- @AddressID INT = null,
				,NULL						-- @CustomerPreferenceID INT = null,
				,@w_customer_contact_link	-- @ContactID INT = null,
				,NULL						-- @ExternalNumber VARCHAR(64) = null,
				,NULL						-- @DBA VARCHAR(128) = null,
				,NULL						-- @Duns VARCHAR(30) = null,
				,NULL						-- @SsnClear NVARCHAR(100) = null,
				,NULL						-- @SsnEncrypted NVARCHAR(512) = null,
				,NULL						-- @TaxId VARCHAR(30) = null,
				,NULL						-- @EmployerId varchar(30) = null,
				,NULL						-- @CreditAgencyID INT = null,
				,NULL						-- @CreditScoreEncrypted NVARCHAR(512) = null,
				,NULL						-- @BusinessTypeID INT = null,
				,NULL						-- @BusinessActivityID INT = null,
				,1029						-- @ModifiedBy INT,
				,1029						-- @CreatedBy INT,
				,1							-- @IsSilent BIT = 0

			
		UPDATE Libertypower..Account
		SET CustomerId			= @CustomerID
		WHERE AccountIDLegacy	= @w_account_id
		
	END		
	
	--/* Ticket # 1-34030211 END */
	
	

	-- =======================================================================================================================================
	-- MD084 changes copy name contact address data to LP
	-- =======================================================================================================================================
	-- REPLACED BY MD084

		--DECLARE @MSG VARCHAR(1000);			
		--SET @MSG = '@w_account_name_link: ' + CAST(@w_account_name_link AS VARCHAR) ;
		--SET @MSG = @MSG + '@w_customer_name_link: ' + CAST(@w_customer_name_link AS VARCHAR) ;
		--SET @MSG = @MSG + '@w_owner_name_link: ' + CAST(@w_owner_name_link AS VARCHAR) ;
		--SET @MSG = @MSG + '@w_customer_address_link: ' + CAST(@w_customer_address_link AS VARCHAR) ;
		--SET @MSG = @MSG + '@w_billing_address_link: ' + CAST(@w_billing_address_link AS VARCHAR) ;
		--SET @MSG = @MSG + '@w_service_address_link: ' + CAST(@w_service_address_link AS VARCHAR) ;
		--SET @MSG = @MSG + '@w_customer_contact_link: ' + CAST(@w_customer_contact_link AS VARCHAR) ;
		--SET @MSG = @MSG + '@w_billing_contact_link: ' + CAST(@w_billing_contact_link AS VARCHAR) ;
		--INSERT INTO [Libertypower].[dbo].[TraceLog] ([Message], Content) VALUES ('Before AccountID: ' + @w_account_id,@MSG);



	EXECUTE @RC = [lp_contract_renewal].[dbo].[usp_CopyRenewalNameAddressContactDataToLp] 
		@w_account_id
		,@w_account_name_link		OUTPUT
		,@w_customer_name_link		OUTPUT
		,@w_owner_name_link			OUTPUT
		,@w_customer_address_link	OUTPUT
		,@w_billing_address_link	OUTPUT
		,@w_service_address_link	OUTPUT
		,@w_customer_contact_link	OUTPUT
		,@w_billing_contact_link	OUTPUT
		,@w_username;


	--SET @MSG = '@w_account_name_link: ' + CAST(@w_account_name_link AS VARCHAR) ;
	--SET @MSG = @MSG + '@w_customer_name_link: ' + CAST(@w_customer_name_link AS VARCHAR) ;
	--SET @MSG = @MSG + '@w_owner_name_link: ' + CAST(@w_owner_name_link AS VARCHAR) ;
	--SET @MSG = @MSG + '@w_customer_address_link: ' + CAST(@w_customer_address_link AS VARCHAR) ;
	--SET @MSG = @MSG + '@w_billing_address_link: ' + CAST(@w_billing_address_link AS VARCHAR) ;
	--SET @MSG = @MSG + '@w_service_address_link: ' + CAST(@w_service_address_link AS VARCHAR) ;
	--SET @MSG = @MSG + '@w_customer_contact_link: ' + CAST(@w_customer_contact_link AS VARCHAR) ;
	--SET @MSG = @MSG + '@w_billing_contact_link: ' + CAST(@w_billing_contact_link AS VARCHAR) ;

	--INSERT INTO [Libertypower].[dbo].[TraceLog] ([Message], Content) VALUES ('After AccountID: ' + @w_account_id,@MSG);


-- =======================================================================================================================================
-- END MD084 changes copy name contact address data to LP
-- =======================================================================================================================================

	SET @w_return = 1

	EXEC @w_return = lp_account..usp_account_status_history_ins @w_username,
														   @w_account_id,
														   @w_status,
														   @w_sub_status,
														   @w_getdate,
														   'RENEWAL',
														   @w_utility_id,
														   ' ',
														   ' ',
														   ' ',
														   ' ',
														   ' ',
														   ' ',
														   ' ',
														   @w_getdate,
														   @w_error OUTPUT,
														   @p_msg_id OUTPUT,
														   ' ',
														   'N'


	IF @w_return									<> 0
	BEGIN
		ROLLBACK TRAN val
		SELECT @w_application		= 'COMMON'
			,@w_error				= 'E'
			,@w_msg_id				= '00000051'
			,@w_return				= 1
			,@w_descp_add			= ' (Insert History Account) '

		EXEC usp_contract_error_ins 'RENEWAL',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add

		goto goto_SELECT
	END

	IF (ltrim(rtrim(@w_status))	+ ltrim(rtrim(@w_sub_status)) = '91100010')
	or (ltrim(rtrim(@w_status))	+ ltrim(rtrim(@w_sub_status)) = '99999810') 
	or (ltrim(rtrim(@w_status))	+ ltrim(rtrim(@w_sub_status)) = '99999910') 
	BEGIN
		IF NOT EXISTS(SELECT contract_nbr
					FROM lp_enrollment..check_account WITH (NOLOCK)
					WHERE contract_nbr	= @p_contract_nbr
					AND check_type	= 'TPV')
		BEGIN

			INSERT INTO lp_account..account_renewal_sales_channel_hist
			SELECT @w_account_id,
				@w_getdate,
				@w_sales_channel_role,
				'TPV',	
				@w_username,
				0

			IF @@error								<> 0
			or @@ROWCOUNT							  = 0
			BEGIN
				ROLLBACK TRAN val
				SELECT @w_application			= 'COMMON'
					,@w_error					= 'E'
					,@w_msg_id					= '00000051'
					,@w_return					= 1
					,@w_descp_add				= ' (Insert History Sales Channel) '

				EXEC usp_contract_error_ins 'RENEWAL',
										@p_contract_nbr,
										@w_account_number,
										@w_application,
										@w_error,
										@w_msg_id,
										@w_descp_add
		 
				goto goto_SELECT
			END
													  
			SET @w_return = 1

			EXEC @w_return = lp_enrollment..usp_check_account_ins @p_username,
													   @p_contract_nbr,
													   ' ',
													   @w_check_type,
													   'RENEWAL',
													   'PENDING',
													   @w_getdate,
													   ' ',
													   '19000101',
													   'ONLINE',
													   ' ',
													   ' ',
													   '19000101',
													   ' ',
													   '19000101',
													   '19000101',
													   0,
													   @w_error OUTPUT,
													   @w_msg_id OUTPUT, 
													   ' ',
													   'N'
		   
			IF @w_return							  <> 0
			BEGIN
				ROLLBACK TRAN val
				SELECT @w_application				   = 'COMMON'
					,@w_error						 = 'E'
					,@w_msg_id						= '00000051'
					,@w_return						= 1
					,@w_descp_add					 = ' (Insert Renewal) '

				EXEC usp_contract_error_ins 'RENEWAL',
								@p_contract_nbr,
								@w_account_number,
								@w_application,
								@w_error,
								@w_msg_id,
								@w_descp_add

				goto goto_SELECT
			END
		END
	END

	SET @w_return = 1
	
	IF @w_contract_type = 'POWER MOVE' 
	BEGIN
		SET @w_date_flow_start	= @w_date_end
		SET @w_date_end = dateadd(mm, @w_term_months,dateadd(dd, -1, @w_date_flow_start))

		SELECT @w_duns_number_entity	= esco
		FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK)
		WHERE process_status			= 'C'
		and   util_acct					= @w_account_number

		SELECT @w_entity_id				= entity_id
		FROM lp_common..common_entity WITH (NOLOCK)
		WHERE @w_duns_number_entity		like '%' + ltrim(rtrim(duns_number)) + '%'
	END	   
	ELSE
	BEGIN
		SELECT	@w_date_flow_start	= date_flow_start
		FROM	lp_account..account WITH (NOLOCK)
		WHERE	account_id			= @w_account_id
		IF @w_date_flow_start is null
			SET @w_date_flow_start = getdate()
	END

	EXEC @w_return = lp_common..usp_product_account_type_sel @w_product_id, @w_account_type OUTPUT
	
	-- IF there was an error, default to SMB
	IF @w_return <> 0
		SET @w_account_type = 'SMB'


	SELECT	top 1 @w_status = CASE WHEN wait_status is null THEN '01000' ELSE wait_status END, 
		@w_sub_status		= CASE WHEN wait_sub_status is null THEN '10' ELSE wait_sub_status END
	FROM lp_common..common_utility_check_type WITH (NOLOCK)
	WHERE utility_id		= @w_utility_id
	AND contract_type		= @w_contract_type
	ORDER BY [order]

	-- added 7/7/2008 per Douglas
	-- SD Ticket # 4434
	-- SET contract effective start date to be the next meter read date plus 1 month and 3 days

	-- REMOVE THE @w_contract_eff_start_date CALCULATION 
	-- TICKET 18209 BEGIN
	-- SET @w_contract_eff_start_date = dateadd(dd, 3, dateadd(mm, datediff(mm, dateadd(yyyy, datediff(yyyy, @w_date_flow_start, getdate()), @w_date_flow_start), getdate()) + 1, dateadd(yyyy, datediff(yyyy, @w_date_flow_start, getdate()), @w_date_flow_start)))
	-- TICKET 18209 END

	--22541
	--IF NOT EXISTS (	SELECT	contract_nbr
	--		FROM	lp_account..account
	--		WHERE	account_id = @w_account_id )
	--BEGIN
	--	EXEC @w_return = usp_account_added_ins @p_username, @w_account_number, @w_application OUTPUT, @w_error OUTPUT, @w_msg_id OUTPUT
	--	IF @w_return										<> 0
	--		goto goto_account_error
	--END		

	-- Change made for NJ tax laws.
	SELECT @Tax			= SalesTax
	FROM LibertyPower..Market M WITH (NOLOCK)
	JOIN LibertyPower..MarketSalesTax MST WITH (NOLOCK)
	ON M.ID				= MST.MarketID
	WHERE M.MarketCode = @w_retail_mkt_id
	
	IF @Tax IS NULL
		SET @Tax = 0.0
		
	SET @w_rate = ROUND(@w_rate / (1 + @Tax),5)
	-- END NJ tax change.

	
	EXEC @w_return = lp_account..usp_account_renewal_ins @p_username,
										@w_account_id,
										@w_account_number,
										@w_account_type,
										@w_status,
										@w_sub_status,
										' ',
										@w_entity_id,
										@p_contract_nbr,
										@w_contract_type,
										@w_retail_mkt_id,
										@w_utility_id,
										@w_product_id,
										@w_rate_id,
										@w_rate,
										@w_account_name_link,
										@w_customer_name_link,
										@w_customer_address_link,
										@w_customer_contact_link,
										@w_billing_address_link,
										@w_billing_contact_link,
										@w_owner_name_link,
										@w_service_address_link,
										@w_business_type,
										@w_business_activity,
										@w_additional_id_nbr_type,
										@w_additional_id_nbr,
										@w_contract_eff_start_date,
										@w_term_months,
										@w_date_end,
										@w_date_deal,
										@w_date_created,
										@w_date_submit,
										@w_sales_channel_role,
										@w_sales_rep,
										@w_origin,
										@w_annual_usage,
										@w_date_flow_start,
										@w_date_por_enrollment,
										@w_date_deenrollment,
										@w_date_reenrollment,
										@w_tax_status,
										@w_tax_float,
										@w_credit_score,
										@w_credit_agency,
										@w_por_option,
										@w_billing_type,
										@w_error OUTPUT,
										@w_msg_id OUTPUT, 
										' ',
										'N'
										,@w_SSNClear				-- IT002
										,@w_SSNEncrypted			-- IT002
										,@w_CreditScoreEncrypted	-- IT002
										,@w_evergreen_option_id			-- IT021
										,@w_evergreen_commission_END	-- IT021
										,@w_residual_option_id			-- IT021
										,@w_residual_commission_END		-- IT021
										,@w_initial_pymt_option_id		-- IT021
										,@w_sales_manager				-- IT021
										,@w_evergreen_commission_rate	-- IT021
										,@PriceID						-- IT106
	
			
	goto_account_error:
	IF @w_return <> 0
	BEGIN
		ROLLBACK TRAN val
		SELECT @w_application		= 'COMMON'
			,@w_error				= 'E'
			,@w_msg_id				= '00000051'
			,@w_return				= 1
			,@w_descp_add			= ' (Insert Account) '

		EXEC usp_contract_error_ins 'RENEWAL',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add
		goto goto_SELECT
	END

	INSERT INTO	lp_account..account_meters
	SELECT account_id, meter_number
	FROM account_meters WITH (NOLOCK)
	WHERE account_id	= @w_account_id

	DELETE FROM	lp_contract_renewal..account_meters
	WHERE account_id = @w_account_id

	UPDATE deal_contract_account 
	SET [status] = 'SENT'
	WHERE contract_nbr		= @p_contract_nbr
	and   account_number	= @t_account_number

--			SET usage_req_status to pENDing to prepare for UPDATEd usage
	UPDATE	lp_account..account
	SET usage_req_status	= 'Pending'
	WHERE account_id		= @w_account_id

	-- delete account FROM queue since they are renewing
	DELETE lp_account..account_auto_renewal_queue WHERE account_id = @w_account_id

	COMMIT TRAN val

	SET ROWCOUNT 1

	SELECT @w_account_id				= account_id,
		@w_account_number				= account_number,
		@w_contract_type				= contract_type,
		@w_retail_mkt_id				= retail_mkt_id,
		@w_utility_id					= utility_id,
		@w_product_id					= product_id,
		@w_rate_id						= rate_id,
		@w_rate							= rate,
		@w_account_name_link			= account_name_link,
		@w_customer_name_link			= customer_name_link,
		@w_customer_address_link		= customer_address_link,
		@w_customer_contact_link		= customer_contact_link,
		@w_billing_address_link			= billing_address_link,
		@w_billing_contact_link			= billing_contact_link,
		@w_owner_name_link				= owner_name_link,
		@w_service_address_link			= service_address_link,
		@w_business_type				= business_type,
		@w_business_activity			= business_activity,
		@w_additional_id_nbr_type		= additional_id_nbr_type,
		@w_additional_id_nbr			= additional_id_nbr,
		@w_contract_eff_start_date		= contract_eff_start_date,
		@w_term_months					= term_months,
		@w_date_end						= date_end,
		@w_date_deal					= date_deal,
		@w_date_created					= date_created,
		@w_sales_channel_role			= sales_channel_role,
		@w_username						= username,
		@w_sales_rep					= sales_rep,
		@w_origin						= origin,
		@w_renew						= renew,
		@PriceID						= PriceID -- IT106
	FROM deal_contract_account WITH (NOLOCK)
	WHERE contract_nbr				= @p_contract_nbr
	and   account_number			> @t_account_number
	and  ([status]					= ' '
	or	 [status]					= 'DRAFT'
	or	[status]					= 'RUNNING')
	and	  renew						= 1

	SET @w_ROWCOUNT		= @@ROWCOUNT

	SELECT @w_entity_id		= entity_id,
		@w_por_option		= por_option,
		@w_billing_type		= billing_type
	FROM lp_common..common_utility b WITH (NOLOCK)
	WHERE utility_id		= @w_utility_id
	
END

SET ROWCOUNT 0

BEGIN tran cont

IF exists(SELECT contract_nbr
		  FROM lp_enrollment..check_account WITH (NOLOCK)
		  WHERE contract_nbr	= @p_contract_nbr
		  and   check_type		IN ('TPV','DOCUMENTS'))
BEGIN
   goto goto_sent
END					  

SELECT top 1
	@w_check_type		= CASE WHEN b.check_type is null THEN 'USAGE ACQUIRE' ELSE b.check_type END
FROM deal_contract a WITH (NOLOCK),
	 lp_common..common_utility_check_type b WITH (NOLOCK)
WHERE a.contract_nbr	= @p_contract_nbr
and   a.utility_id		= b.utility_id
and   a.contract_type	= b.contract_type
and   b.[order]			> 1   
ORDER BY [order]								   

IF @@ROWCOUNT									  <> 0
BEGIN
   IF exists(SELECT contract_nbr
			 FROM lp_enrollment..check_account WITH (NOLOCK)
			 WHERE contract_nbr					 = @p_contract_nbr
			 and   check_type					   = @w_check_type)
   BEGIN
	  goto goto_sent
   END
END
ELSE
BEGIN
	SELECT top 1
		   @w_check_type	= CASE WHEN b.check_type is null THEN 'USAGE ACQUIRE' ELSE b.check_type END
	FROM deal_contract_account a WITH (NOLOCK),
		 lp_common..common_utility_check_type b WITH (NOLOCK)
	WHERE a.contract_nbr	= @p_contract_nbr
	and   a.utility_id		= b.utility_id
	and   a.contract_type	= b.contract_type
	and   b.[order]			> 1  
	ORDER BY [order]

	IF @@ROWCOUNT									  <> 0
	BEGIN
	   IF exists(SELECT contract_nbr
				 FROM lp_enrollment..check_account WITH (NOLOCK)
				 WHERE contract_nbr		= @p_contract_nbr
				 and   check_type		= @w_check_type)
	   BEGIN
		  goto goto_sent
	   END
	END  
END

IF @w_check_type									= 'PROFITABILITY'
BEGIN

-- PROFITABILITY

   DECLARE @w_request_DATETIME					 VARCHAR(20)

   DECLARE @w_header_enrollment_1				  VARCHAR(08)
   DECLARE @w_header_enrollment_2				  VARCHAR(08)

   SELECT @w_header_enrollment_1				   = header_enrollment_1,
		  @w_header_enrollment_2				   = header_enrollment_2
   FROM deal_config

   DECLARE @w_getdate_h							 VARCHAR(08)
   SELECT @w_getdate_h							  = convert(VARCHAR(08), getdate(), 108)

   DECLARE @w_getdate_d							 VARCHAR(08)
   SELECT @w_getdate_d							  = convert(VARCHAR(08), getdate(), 112)

   IF @w_getdate_h								  > @w_header_enrollment_2
   BEGIN
	  SELECT @w_getdate_h						   = @w_header_enrollment_1
	  SELECT @w_getdate_d						   = convert(VARCHAR(08), dateadd(dd, 1, @w_getdate_d), 112)
   END

   IF @w_getdate_h								 <= @w_header_enrollment_1
   BEGIN
	  SELECT @w_request_DATETIME					= @w_getdate_d
													+ ' '
													+ @w_header_enrollment_1
	  SELECT @w_risk_request_id					 = upper('DEAL-CAPTURE-' + @w_request_DATETIME)
   END
   ELSE
   BEGIN
	  SELECT @w_request_DATETIME					= @w_getdate_d
													+ ' '
													+ @w_header_enrollment_2
	  SELECT @w_risk_request_id					 = upper('DEAL-CAPTURE-' + @w_request_DATETIME)
   END

   IF not exists(SELECT request_id
				 FROM lp_risk..web_header_enrollment WITH (NOLOCK)
				 WHERE request_id				   = @w_risk_request_id)
   BEGIN
	  INSERT INTO lp_risk..web_header_enrollment
	  SELECT @w_risk_request_id,
			 @w_request_DATETIME,
			 'BATCH',
			 'RENEWAL BATCH LOAD',
			 getdate(),
			 @p_username

	  IF  @@error								  <> 0
	  and @@ROWCOUNT								= 0
	  BEGIN
		 ROLLBACK tran cont
		 SELECT @w_application					  = 'COMMON'
		 SELECT @w_error							= 'E'
		 SELECT @w_msg_id						   = '00000051'
		 SELECT @w_return						   = 1
		 SELECT @w_descp_add						= ' (Insert Scraper Header) '

		 exec usp_contract_error_ins 'RENEWAL',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
		 goto goto_SELECT
	  END
   END

   INSERT INTO lp_risk..web_detail
   SELECT @w_risk_request_id,
		  account_number,
		  'BATCH'
   FROM deal_contract_account WITH (NOLOCK)
   WHERE contract_nbr							   = @p_contract_nbr

   IF  @@error									 <> 0
   and @@ROWCOUNT								   = 0
   BEGIN
	  ROLLBACK tran cont
	  SELECT @w_application						 = 'COMMON'
	  SELECT @w_error							   = 'E'
	  SELECT @w_msg_id							  = '00000051'
	  SELECT @w_return							  = 1
	  SELECT @w_descp_add						   = ' (Insert Scraper Detail) '

	  exec usp_contract_error_ins 'RENEWAL',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add

	  goto goto_SELECT
   END

   SELECT @w_return								 = 1
   
   exec @w_return = lp_enrollment..usp_check_account_ins @p_username,
														 @p_contract_nbr,
														 ' ',
														 @w_check_type,
														 'RENEWAL',
														 'PENDING',
														 @w_getdate,
														 ' ',
														 '19000101',
														 'ONLINE',
														 ' ',
														 @w_risk_request_id,
														 '19000101',
														 ' ',
														 '19000101',
														 '19000101',
														 0,
														 @w_error OUTPUT,
														 @w_msg_id OUTPUT, 
														 ' ',
														 'N'

   IF @w_return									<> 0
   BEGIN
	  ROLLBACK tran cont
	  SELECT @w_application						 = 'COMMON'
	  SELECT @w_error							   = 'E'
	  SELECT @w_msg_id							  = '00000051'
	  SELECT @w_return							  = 1
	  SELECT @w_descp_add						   = ' (Insert Check Profitability) '

	  exec usp_contract_error_ins 'RENEWAL',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add

	  goto goto_SELECT
   END

END
ELSE
BEGIN

   SELECT @w_return								 = 1

   exec @w_return = lp_enrollment..usp_check_account_ins @p_username,
														 @p_contract_nbr,
														 ' ',
														 @w_check_type,
														 'RENEWAL',
														 'PENDING',
														 @w_getdate,
														 ' ',
														 '19000101',
														 'ONLINE',
														 ' ',
														 ' ',
														 '19000101',
														 ' ',
														 '19000101',
														 '19000101',
														 0,
														 @w_error OUTPUT,
														 @w_msg_id OUTPUT, 
														 ' ',
														 'N'

   IF @w_return									<> 0
   BEGIN
	  ROLLBACK tran cont
	  SELECT @w_application						 = 'COMMON'
	  SELECT @w_error							   = 'E'
	  SELECT @w_msg_id							  = '00000051'
	  SELECT @w_return							  = 1
	  SELECT @w_descp_add						   = ' (Insert Credit Check) '

	  exec usp_contract_error_ins 'RENEWAL',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add

	  goto goto_SELECT
   END
END

goto_sent:

SET ROWCOUNT 0

delete deal_contract
FROM deal_contract WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

delete deal_contract_account
FROM deal_contract_account WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

delete deal_address
FROM deal_address WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

delete deal_contact
FROM deal_contact WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

delete deal_name
FROM deal_name WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

delete deal_contract_error
FROM deal_contract_error WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

commit tran cont

commit tran Submission

goto_SELECT:

SET ROWCOUNT 0

IF(@p_error = 'E')
BEGIN
	rollback tran Submission
END

UPDATE deal_contract SET status = 'DRAFT - ERROR'
FROM deal_contract WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

SELECT @p_application							   = @w_application,
	   @p_error									 = @w_error,
	   @p_msg_id									= @w_msg_id,
	   @p_descp_add								 = @w_descp_add

return @w_return

SET NOCOUNT OFF