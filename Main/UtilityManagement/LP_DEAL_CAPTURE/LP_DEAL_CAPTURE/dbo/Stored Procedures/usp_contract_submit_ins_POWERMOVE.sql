

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--EXEC usp_contract_submit_ins 'libertypower\dmarino', 'Contracto A1'
--EXEC usp_contract_submit_ins @p_username=N'LIBERTYPOWER\dmarino',@p_contract_nbr=N'0104483'

-- Modified	  5/20/2008
-- Modified By	Rick Deigsler
-- Added code to delete contract FROM check account table

-- =============================================
-- Modify		: Diogo Lima
-- Date			: 04/13/2010
-- Description	: Added a Utility filter
-- Ticket		: 14366
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 02/18/2010
-- Description	: Add SSNEncrypted columns to process.
-- Ticket		: IT002
-- =============================================
-- Modified: Jose Munoz 1/14/2010
-- add HeatIndexSourceID AND HeatRate for UPDATEs in the tables 
-- deal_contract, deal_contract_account AND deal_pricing_detail
-- Project IT037
-- =============================================
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
-- =============================================
-- Modified: Jose Munoz 5/20/2010
-- Ticket : 15959
-- Problem : inserted duplicate rows in account_info table
-- =============================================
-- =============================================
-- Modified: Jose Munoz 5/20/2010
-- Ticket :17130
-- Problem : Fixe a problem with status 911000 AND deenrollment date
-- =============================================
-- =============================================
-- Modified: Jose Munoz 8/17/2010
-- Ticket :17675
-- Problem : Fixe a problem with New contracts appear to be going 
--  to check account as the first step in deal screening process  
-- =============================================
-- Modified: Eric Hernandez 9/8/2010
-- Ticket :17816
-- Problem : Fixed a problem steps being out of order.  Added "ORDER BY" clause on common_utility_check_type queries.
-- =============================================
-- ===============================================================
-- Modified José Muñoz 01/20/2011
-- Account/ Customer Name should be trimmed WHEN inserting into the Table....  
-- Ticket 20906
-- ===============================================================
-- ===============================================================
-- Modified Sofia Melo 02/21/2011
-- Added tracking to identify how many times this procedure is called.
-- using usp_zcheck_account_tracking_ins call
-- ===============================================================
-- Modified Gabor Kovacs 05/9/2012
-- Added a null to the insertion of account_contact, account_address, AND account_name.
-- The null is required since those are no longer tables, but views which have an extra field.
-- ===============================================================
-- Modified José Muñoz 10/17/2012
-- Account/ Customer Name should be trimmed WHEN inserting into the Table....  
-- Ticket 20906
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- Clear code (remove print AND put SET nocount)
-- Put WITH (NOLOCK) in the SELECT querys
-- Verify the powermove information FROM EDI transaction
-- =======================================	
 
CREATE procedure [dbo].[usp_contract_submit_ins_POWERMOVE]
	(@p_username								NCHAR(100),
	@p_contract_nbr								CHAR(12),
	@p_application								VARCHAR(20) = ' ' OUTPUT,
	@p_error									CHAR(01) = ' ' OUTPUT,
	@p_msg_id									CHAR(08) = ' ' OUTPUT,
	@p_descp_add								VARCHAR(100) = ' ' OUTPUT)
AS

SET NOCOUNT ON

DECLARE @w_error							CHAR(01)
	,@w_msg_id								CHAR(08)
	,@w_return								INT
	,@w_descp_add							VARCHAR(100)
	,@w_application							VARCHAR(20)
	,@w_ROWCOUNT							INT
	,@w_getdate								DATETIME
	,@ERROR									INT
	,@ROWCOUNTERROR							INT
	,@EstimatedAnnualUsage					INT	-- Project IT106
	,@PriceID								BIGINT	-- Project IT106
	,@w_duns_number_entity					VARCHAR(255)
	,@w_account_id							CHAR(12)
	,@w_account_number						VARCHAR(30)
	,@w_status								VARCHAR(15)
	,@w_sub_status							VARCHAR(15)
	,@w_entity_id							CHAR(15)
	,@w_contract_nbr						CHAR(12)
	,@w_contract_type						VARCHAR(15)
	,@w_retail_mkt_id						CHAR(02)
	,@w_utility_id							CHAR(15)
	,@w_product_id							CHAR(20)
	,@w_rate_id								INT
	,@w_rate								FLOAT
	,@w_account_name_link					INT
	,@w_customer_name_link					INT
	,@w_customer_address_link				INT
	,@w_customer_contact_link				INT
	,@w_billing_address_link				INT
	,@w_billing_contact_link				INT
	,@w_owner_name_link						INT
	,@w_service_address_link				INT
	,@w_business_type						VARCHAR(35)
	,@w_business_activity					VARCHAR(35)
	,@w_additional_id_nbr_type				VARCHAR(10)
	,@w_additional_id_nbr					VARCHAR(30)
	,@w_contract_eff_start_date				DATETIME
	,@w_term_months							INT
	,@w_date_end							DATETIME
	,@w_date_deal							DATETIME
	,@w_date_created						DATETIME
	,@w_date_submit							DATETIME
	,@w_sales_channel_role					NVARCHAR(50)
	,@w_username							NCHAR(100)
	,@w_sales_rep							VARCHAR(100)
	,@w_origin								VARCHAR(50)
	,@w_annual_usage						MONEY
	,@w_date_flow_start						DATETIME
	,@p_future_enroll_date					DATETIME
	,@p_enrollment_type						INT
	,@w_date_por_enrollment					DATETIME
	,@w_date_deenrollment					DATETIME
	,@w_date_reenrollment					DATETIME
	,@w_tax_status							VARCHAR(20)
	,@w_tax_float							INT
	,@w_credit_score						REAL
	,@w_credit_agency						VARCHAR(30)
	,@w_por_option							VARCHAR(03)
	,@w_billing_type						VARCHAR(15)
	,@w_date_comment						DATETIME
	,@w_comment								VARCHAR(max)
	,@w_account_type						VARCHAR(50)
	,@w_risk_request_id						VARCHAR(50)
	,@w_process_id							VARCHAR(50)
	,@w_add_info							BIT
	,@w_HeatIndexSourceID					INT				-- Project IT037
	,@w_HeatRate							DECIMAL	(9,2)	-- Project IT037			
	,@t_account_number						VARCHAR(30)	
	,@w_contract_is_amendment				VARCHAR(5)
	,@w_contract_nbr_amend					CHAR(12)
	,@w_contract_type_amend					VARCHAR(15)
	,@w_status_amend						VARCHAR(15)
	,@w_sub_status_amend					VARCHAR(15)
	,@w_check_type							CHAR(30)
	,@w_check_type_new_contract				CHAR(30) -- Add Ticket 17675
	,@w_requested_flow_start_date			DATETIME
	,@w_deal_type							CHAR(20)
	,@w_customer_code						CHAR(05)
	,@w_customer_group						CHAR(100)
	,@w_transaction_id						VARCHAR(50)	
	,@w_full_name							VARCHAR(100)
	,@w_service_address						CHAR(50)
	,@w_service_suite						CHAR(50)
	,@w_service_city						CHAR(50)
	,@w_service_state						CHAR(02)
	,@w_service_zip							CHAR(10)
	,@w_billing_address						CHAR(50)
	,@w_billing_suite						CHAR(50)
	,@w_billing_city						CHAR(50)
	,@w_billing_state						CHAR(02)
	,@w_billing_zip							CHAR(10)
	
-- Start: Added for Overridable Sales Channel settings.
	,@w_evergreen_option_id					INT
	,@w_evergreen_commission_end			DATETIME
	,@w_residual_option_id					INT
	,@w_residual_commission_end				DATETIME
	,@w_initial_pymt_option_id				INT
	,@w_sales_manager						VARCHAR(100)
	,@w_evergreen_commission_rate			FLOAT
--BEGIN Ticket 18703
	,@w_TaxStatus							INT
--End Ticket 18703
--Added for IT002
	, @w_SSNEncrypted nVARCHAR(512) -- change to VARCHAR(512) Jose Munoz.
----
		,@w_request_DATETIME				VARCHAR(20) 
		,@w_header_enrollment_1				VARCHAR(08)
		,@w_header_enrollment_2				VARCHAR(08)
		,@w_getdate_h						VARCHAR(08)	
		,@w_getdate_d						VARCHAR(08)		
	,@w_ProcessDate							DATETIME
	,@RetailMktID							INT
	,@UtilityID								INT 
	,@CustomerID							INT
	,@NameID								INT
		,@w_AccountID						INT
		
SELECT @w_error									= 'I'
	,@w_msg_id									= '00000001'
	,@w_return									= 0
	,@w_descp_add								= ' ' 
	,@w_application								= 'COMMON'
	,@EstimatedAnnualUsage						= 0		
	,@w_descp_add								= ' '
	,@w_account_id								= ''
	,@w_account_number							= ''
	,@w_entity_id								= ''
	,@w_contract_nbr							= ''
	,@w_contract_type							= ''
	,@w_retail_mkt_id							= ''
	,@w_utility_id								= ''
	,@w_product_id								= ''
	,@w_rate_id									= 0
	,@w_rate									= 0
	,@w_account_name_link						= 0
	,@w_customer_name_link						= 0
	,@w_customer_address_link					= 0
	,@w_customer_contact_link					= 0
	,@w_billing_address_link					= 0
	,@w_billing_contact_link					= 0
	,@w_owner_name_link							= 0
	,@w_service_address_link					= 0
	,@w_business_type							= ''
	,@w_business_activity						= ''
	,@w_additional_id_nbr_type					= ''
	,@w_additional_id_nbr						= ''
	,@w_contract_eff_start_date					= '19000101'
	,@w_term_months								= 0
	,@w_date_end								= '19000101'
	,@w_date_deal								= '19000101'
	,@w_date_created							= '19000101'
	,@w_sales_channel_role						= ''
	,@w_username								= ''
	,@w_sales_rep								= ''
	,@w_origin									= ''
	,@w_date_submit								= @w_getdate
	,@w_annual_usage							= 0
	,@w_date_flow_start							= '19000101'
	,@w_date_por_enrollment						= '19000101'
	,@p_future_enroll_date						= '19000101'
	,@p_enrollment_type							= 1
	,@w_date_deenrollment						= '19000101'
	,@w_date_reenrollment						= '19000101'
	,@w_tax_status								= 'FULL'
	,@w_tax_float								= 0
	,@w_credit_score							= 0
	,@w_credit_agency							= 'NONE'
	,@w_por_option								= 'NO'
	,@w_status									= ''
	,@w_sub_status								= ''
	,@w_entity_id								= ''
	,@t_account_number							= ''
	,@w_full_name								= ''
	,@w_service_address							= ''
	,@w_service_suite							= ''
	,@w_service_city							= ''
	,@w_service_state							= ''
	,@w_service_zip								= ''
	,@w_billing_address							= ''
	,@w_billing_suite							= ''
	,@w_billing_city							= ''
	,@w_billing_state							= ''
	,@w_billing_zip								= ''
	,@w_ProcessDate								= GETDATE()
	
	
SELECT @w_getdate			= date_submit
FROM deal_contract WITH (NOLOCK)
WHERE contract_nbr			= @p_contract_nbr
--and	status										= 'RUNNING'

SELECT @w_transaction_id							= 'DEAL_CAPTURE' 
													+ '_' 
													+ CONVERT(CHAR(08), getdate(), 112) 
													+ '_'
													+ LTRIM(RTRIM(replace(CONVERT(CHAR(12), getdate(), 114), ':', '')))

SELECT 
	@w_evergreen_option_id				= evergreen_option_id
	,@w_evergreen_commission_end		= evergreen_commission_end
	,@w_evergreen_commission_rate		= evergreen_commission_rate
	,@w_residual_option_id				= residual_option_id							
	,@w_residual_commission_end			= residual_commission_end					
	,@w_initial_pymt_option_id			= initial_pymt_option_id						
	,@w_sales_manager					= sales_manager								
FROM deal_contract WITH (NOLOCK)
WHERE contract_nbr	=	@p_contract_nbr
-- End: Added for Overridable Sales Channel settings.

--IT043
-- added 5/20/2008
--delete FROM lp_enrollment..check_account 
--WHERE contract_nbr = @p_contract_nbr

SELECT TOP 1
		@w_check_type		= b.check_type
FROM deal_contract a WITH (NOLOCK),
	 lp_common..common_utility_check_type b WITH (NOLOCK)
WHERE a.contract_nbr		= @p_contract_nbr
and	a.utility_id			= b.utility_id
and	CASE WHEN a.contract_type = 'PRE-PRINTED' 
			THEN 'PAPER' 
			ELSE a.contract_type 
	  END					= b.contract_type
AND b.[order]				> 1	
ORDER BY b.[order]


SET ROWCOUNT 1

SELECT @w_account_id						= account_id,
		@w_account_number					= account_number,
		@w_contract_type					= CASE WHEN contract_type = 'PRE-PRINTED' THEN 'PAPER' ELSE contract_type END,
		@w_retail_mkt_id					= retail_mkt_id,
		@w_utility_id						= utility_id,
		@w_product_id						= product_id,
		@w_rate_id							= rate_id,
		@w_rate								= rate,
		@w_account_name_link				= account_name_link,
		@w_customer_name_link				= customer_name_link,
		@w_customer_address_link			= customer_address_link,
		@w_customer_contact_link			= customer_contact_link,
		@w_billing_address_link				= billing_address_link,
		@w_billing_contact_link				= billing_contact_link,
		@w_owner_name_link					= owner_name_link,
		@w_service_address_link				= service_address_link,
		@w_business_type					= business_type,
		@w_business_activity				= business_activity,
		@w_additional_id_nbr_type			= additional_id_nbr_type,
		@w_additional_id_nbr				= additional_id_nbr,
		@p_enrollment_type					= enrollment_type,
		@w_contract_eff_start_date			= contract_eff_start_date,
		@w_term_months						= term_months,
		@w_date_end							= date_end,
		@w_date_deal						= date_deal,
		@w_date_created						= date_created,
		@w_sales_channel_role				= sales_channel_role,
		@w_username							= username,
		@w_sales_rep						= sales_rep,
		@w_origin							= origin,
		@w_requested_flow_start_date		= ISNULL(requested_flow_start_date, '19000101'),
		@w_deal_type						= ISNULL(deal_type, ''),
		@w_customer_code					= ISNULL(customer_code, ''),
		@w_customer_group					= ISNULL(customer_group, ''),
		@w_SSNEncrypted						= SSNEncrypted --Added for IT002
		,@w_HeatIndexSourceID				= HeatIndexSourceID		-- Project IT037			
		,@w_HeatRate						= HeatRate				-- Project IT037			
		,@w_evergreen_option_id				= ISNULL(evergreen_option_id,@w_evergreen_option_id)				-- Added for IT021
		,@w_evergreen_commission_end		= ISNULL(evergreen_commission_end, @w_evergreen_commission_end)		-- Added for IT021
		,@w_evergreen_commission_rate		= ISNULL(evergreen_commission_rate, @w_evergreen_commission_rate)	-- Added for IT021
		,@w_residual_option_id				= ISNULL(residual_option_id, @w_residual_option_id)					-- Added for IT021				
		,@w_residual_commission_end			= ISNULL(residual_commission_end, @w_residual_commission_end)		-- Added for IT021					
		,@w_initial_pymt_option_id			= ISNULL(initial_pymt_option_id, @w_initial_pymt_option_id)			-- Added for IT021								
		--BEGIN Ticket 18703
		,@w_TaxStatus						= TaxStatus
		--End Ticket 18703
		,@PriceID							= PriceID
FROM deal_contract_account WITH (NOLOCK)
WHERE contract_nbr							= @p_contract_nbr
AND account_number							> @t_account_number
AND (status									= ' '
or	status									= 'RUNNING')

SET @w_ROWCOUNT								= @@ROWCOUNT

--BEGIN Ticket 18703
IF @w_TaxStatus = 1 
BEGIN 
	INSERT INTO lp_account..account_comments values (@w_account_id,GETDATE(),'DEAL ENTRY','Account was originally submitted as Tax Exempt.',@p_username,0)
	IF EXISTS(SELECT *
				FROM lp_documents..document_history WITH (NOLOCK)
				WHERE document_type_id = 9 -- tax exempt doc
				AND (account_id = @w_account_id or contract_nbr = @p_contract_nbr))
	BEGIN 
		SELECT @w_tax_status = 'EXEMPT'		
	END
END
ELSE 
BEGIN
	SELECT @w_tax_status = 'FULL'			
END
--End Ticket 18703

-- tracking to identify how many times this procedure is called.
EXEC lp_enrollment..usp_zcheck_account_tracking_ins @p_username, @p_contract_nbr, @w_account_id, @w_account_number, '', '', 'INSERT', 'usp_check_account_ins', 1, '@w_utility_id', @w_utility_id

SELECT @w_entity_id						= entity_id,
		@w_por_option					= por_option,
		@w_billing_type					= billing_type,
		@w_date_por_enrollment			= dateadd(d, -enrollment_lead_days, @w_requested_flow_start_date) --WV 2010/01/12
FROM lp_common..common_utility b WITH (NOLOCK)
WHERE utility_id						= @w_utility_id

while @w_ROWCOUNT						<> 0
BEGIN
	SET ROWCOUNT 0

	SELECT @w_add_info					= 0
		,@t_account_number				= @w_account_number

	UPDATE deal_contract_account SET status = 'RUNNING'
	WHERE contract_nbr					= @p_contract_nbr
	AND account_number					= @t_account_number

	BEGIN tran val

	-- BEGIN SET amendment variables  ------------------------
	SET @w_contract_is_amendment		= 'FALSE'

	IF @w_contract_type					= 'AMENDMENT' 
	BEGIN
		-- SET amendment flag
		SET @w_contract_is_amendment	= 'TRUE'

		-- get contract number to be amended
		SELECT @w_contract_nbr_amend	= contract_nbr_amend 
		FROM deal_contract_amend WITH (NOLOCK)
		WHERE	contract_nbr			= @p_contract_nbr

		IF @@error						<> 0
		or @@ROWCOUNT					= 0
		BEGIN
			SELECT @w_application		= 'DEAL'
				,@w_error				= 'E'
				,@w_msg_id				= '00000049'
				,@w_return				= 1
				,@w_descp_add			= ''
			goto goto_SELECT
		end

		-- get contract type of contract to be amended
		SELECT top 1 
			 @w_contract_type_amend		= contract_type
		FROM lp_account..account  WITH (NOLOCK)
		WHERE contract_nbr				= @w_contract_nbr_amend

		IF @@error						<> 0
		or @@ROWCOUNT					= 0
		BEGIN
			SELECT @w_application		= 'DEAL'
				,@w_error				= 'E'
				,@w_msg_id				= '00000049'
				,@w_return				= 1
				,@w_descp_add			= ''
			goto goto_SELECT
		end

		-- get status AND sub status of contract to be amended
		SELECT top 1 
			 @w_status_amend			= [status], 
			 @w_sub_status_amend		= sub_status
		FROM lp_account..account WITH (NOLOCK)
		WHERE contract_nbr				= @w_contract_nbr_amend
		ORDER BY [status]

		IF @@error						<> 0
		or @@ROWCOUNT					= 0
		BEGIN
			SELECT @w_application		= 'DEAL'
				,@w_error				= 'E'
				,@w_msg_id				= '00000049'
				,@w_return				= 1
				,@w_descp_add			= ''
			goto goto_SELECT
		end

		-- IF account is enrolled or pending enrollment (confirmed), SET status pending enrollment
		IF @w_status_amend				in ('05000','06000','07000','08000','09000','905000','906000')
		BEGIN
			IF (SELECT	top 1 LTRIM(RTRIM(por_option))
				FROM lp_account..account WITH (NOLOCK)
				WHERE contract_nbr		= @w_contract_nbr_amend ) = 'NO'
			BEGIN
				SET @w_status_amend		= '05000'
			END
			ELSE
			BEGIN
				SET @w_status_amend		= '06000'
			END	  
			SET @w_sub_status_amend		= '10'	  
		END
	END

	-- end SET amendment variables  --------------------------
	SELECT @w_process_id				= CASE WHEN @w_contract_is_amendment = 'TRUE' 
										THEN 'CONTRACT AMENDMENT' 
										ELSE 'DEAL CAPTURE' 
										END

	SELECT @w_contract_nbr				= CASE WHEN @w_contract_is_amendment = 'TRUE' 
										THEN @w_contract_nbr_amend 
										ELSE @p_contract_nbr 
										END

	IF @w_contract_is_amendment = 'TRUE'
	BEGIN
		SELECT @w_status				= @w_status_amend
			,@w_sub_status				= @w_sub_status_amend
	END
	ELSE
	BEGIN
		SELECT top 1 
			@w_status					= CASE WHEN wait_status is null THEN '01000' 
															ELSE wait_status END
			,@w_sub_status				= CASE WHEN @w_check_type = 'SCRAPER RESPONSE' THEN '20' 
															WHEN wait_sub_status IS NULL THEN '10' 
															ELSE wait_sub_status END
		FROM lp_common..common_utility_check_type WITH (NOLOCK)
		WHERE utility_id				= @w_utility_id 
		AND contract_type				= @w_contract_type 
		AND wait_status					<> '*'
		ORDER BY [order]
	END

	SELECT @w_descp_add					= ' '
		,@w_return						= 1

	IF EXISTS(SELECT a.status
			 FROM lp_account..account a WITH (NOLOCK),
				  lp_account..ufn_account_check(@p_username) b
			 WHERE a.account_number		= @w_account_number
			 and	a.utility_id			= @w_utility_id 
			 and	LTRIM(RTRIM(a.status)) +	 LTRIM(RTRIM(a.sub_status))		= b.status_substatus)
	BEGIN

		SET @w_add_info					= 1
		SELECT @w_status				= CASE WHEN @w_contract_is_amendment = 'TRUE' 
										THEN @w_status_amend 
										ELSE status 
										END,
			 @w_sub_status				= CASE WHEN @w_contract_is_amendment = 'TRUE' 
										THEN @w_sub_status_amend 
										ELSE sub_status 
										END,
			 @w_account_id				= account_id,
			 @w_date_created			= date_created
		FROM lp_account..account WITH (NOLOCK)
		WHERE account_number			= @w_account_number
		and	utility_id					= @w_utility_id 

	  --delete lp_account..account
	  --FROM lp_account..account WITH (NOLOCK)
	  --WHERE account_id							  = @w_account_id

--	  delete lp_account..account_additional_info
--	  FROM lp_account..account_additional_info WITH (NOLOCK)
--	  WHERE account_id							  = @w_account_id

	  -- MD084 Commented out the contact , name, AND address since they are views now

	  --delete lp_account..account_contact
	  --FROM lp_account..account_contact WITH (NOLOCK)
	  --WHERE account_id							  = @w_account_id

	  --delete lp_account..account_name
	  --FROM lp_account..account_name WITH (NOLOCK)
	  --WHERE account_id							  = @w_account_id

	  --delete lp_account..account_address
	  --FROM lp_account..account_address WITH (NOLOCK)
	  --WHERE account_id							  = @w_account_id

	END

	SET @w_return = 1
	
	IF @w_add_info						= 0
	BEGIN
		
		EXEC @w_return = lp_account..usp_account_additional_info_ins @p_username,
																	@w_account_id,
																	'',
																	'',
								'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
				'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	'',
																	@w_error OUTPUT,
																	@w_msg_id OUTPUT, 
																	' ',
																	'N'
		



		IF @w_return					<> 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application		= 'COMMON'
				,@w_error				= 'E'
				,@w_msg_id				= '00000051'
				,@w_return				= 1
				,@w_descp_add			= ' (Insert Account Additional Info) '

			EXEC usp_contract_error_ins 'ENROLLMENT',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add
			goto goto_SELECT
		END
	END

	/* Ticket # 1-34030211 BEGIN */
	IF NOT EXISTS (	SELECT	NULL
			FROM	lp_account..account WITH (NOLOCK)
			WHERE	account_id = @w_account_id )
	BEGIN

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
				,NULL						-- @EmployerId VARCHAR(30) = null,
				,NULL						-- @CreditAgencyID INT = null,
				,NULL						-- @CreditScoreEncrypted NVARCHAR(512) = null,
				,NULL						-- @BusinessTypeID INT = null,
				,NULL						-- @BusinessActivityID INT = null,
				,1029						-- @ModifiedBy INT,
				,1029						-- @CreatedBy INT,
				,1							-- @IsSilent BIT = 0

			
		SELECT @RetailMktID = ID FROM Libertypower..Market WITH (NOLOCK) WHERE MarketCode = @w_retail_mkt_id
		SELECT @UtilityID = ID FROM Libertypower..Utility WITH (NOLOCK) WHERE UtilityCode= @w_Utility_id
		
		EXEC @w_AccountID = [LibertyPower].[dbo].[usp_AccountInsert]
				@w_account_id				-- @AccountIdLegacy CHAR(12),
				,@w_account_number			-- @AccountNumber VARCHAR(30),
				,NULL						-- @AccountTypeID INT,
				,NULL						-- @CurrentContractID INT = NULL,
				,NULL						-- @CurrentRenewalContractID INT = NULL,
				,@CustomerID				-- @CustomerID INT = NULL,
				,NULL						-- @CustomerIdLegacy VARCHAR(10) = NULL,
				,NULL						-- @EntityID CHAR(15),
				,@RetailMktID				-- INT,
				,@UtilityID					-- INT,
				,@w_account_name_link		-- @AccountNameID INT,
				,@w_billing_address_link	-- @BillingAddressID INT,
				,@w_billing_contact_link	-- @BillingContactID INT,
				,@w_service_address_link	-- @ServiceAddressID INT,
				,@w_origin					-- @Origin VARCHAR(50),
				,NULL						-- @TaxStatusID INT,
				,NULL						-- @PorOption BIT,
				,NULL						-- @BillingTypeID INT,
				,NULL						-- @Zone VARCHAR(50) = '',
				,NULL						-- @ServiceRateClass VARCHAR(50) = '',
				,NULL						-- @StratumVariable VARCHAR(15) = '',
				,NULL						-- @BillingGroup VARCHAR(15) = '',
				,NULL						-- @Icap VARCHAR(15) = '',
				,NULL						-- @Tcap VARCHAR(15) = '',
				,NULL						-- @LoadProfile VARCHAR(50) = '',
				,NULL						-- @LossCode VARCHAR(15) = '',
				,NULL						-- @MeterTypeID INT = NULL,
				,1029						-- @ModifiedBy INT,
				,@w_ProcessDate				-- @Modified DATETIME,
				,@w_ProcessDate				-- @DateCreated DATETIME,
				,1029						-- @CreatedBy INT,
				,1							-- @MigrationComplete BIT = 1,
				,1							-- @IsSilent BIT = 0

	END					
	
	/* Ticket # 1-34030211 END */
	
	IF NOT EXISTS(SELECT account_id
				 FROM lp_account..account_name WITH (NOLOCK)
				 WHERE (account_id					= @w_account_id
				 AND name_link						= @w_account_name_link))
				 OR (@w_account_name_link			= 1)
	BEGIN

		EXEC lp_deal_capture.dbo.[usp_GenieNameCopy] @p_contract_nbr, @w_account_id, @w_account_name_link;
	
		IF @@error									<> 0
		OR (@@ROWCOUNT								= 0
		AND NOT EXISTS (SELECT A.CustomerID FROM LibertyPower..CustomerName A WITH (NOLOCK)
				INNER JOIN LibertyPower..Account B WITH (NOLOCK) 
				ON A.CustomerID				= B.CustomerId
				WHERE B.AccountIDLegacy		= @w_account_id))
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Account Name)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									@w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
									 
			goto goto_SELECT
		END
		
	END

	IF NOT EXISTS(SELECT account_id
			 FROM lp_account..account_name WITH (NOLOCK)
			 WHERE account_id					= @w_account_id
			 AND name_link						= @w_customer_name_link)
			 OR (@w_customer_name_link			= 1)
	BEGIN

		EXEC lp_deal_capture.dbo.[usp_GenieNameCopy] @p_contract_nbr, @w_account_id, @w_customer_name_link;

		IF @@error											  <> 0
		or @@ROWCOUNT										 = 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Customer Name)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
			goto goto_SELECT
		END
	END

	IF NOT EXISTS(SELECT account_id
				 FROM lp_account..account_name WITH (NOLOCK)
				 WHERE account_id				= @w_account_id
				 and	name_link				= @w_owner_name_link)
				 or (@w_owner_name_link			= 1)
	BEGIN

		EXEC lp_deal_capture.dbo.[usp_GenieNameCopy] @p_contract_nbr, @w_account_id, @w_owner_name_link;

		IF @@error									<> 0
		or @@ROWCOUNT								 = 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Owner Name)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
			goto goto_SELECT
		END
	END

	IF NOT EXISTS(SELECT account_id
				 FROM lp_account..account_address WITH (NOLOCK)
				 WHERE account_id				= @w_account_id
				 AND address_link				= @w_customer_address_link)
				 OR (@w_customer_address_link	= 1)
	BEGIN

		EXEC lp_deal_capture.[dbo].[usp_GenieAddressCopy] @p_contract_nbr, @w_account_id, @w_customer_address_link;

		IF @@error									<> 0
		or @@ROWCOUNT								 = 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Customer Address)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
			goto goto_SELECT
		END
	END

	IF NOT EXISTS(SELECT account_id
				 FROM lp_account..account_address WITH (NOLOCK)
				 WHERE account_id				= @w_account_id
				 AND address_link				= @w_billing_address_link)
				 OR (@w_billing_address_link	= 1)
	BEGIN
		EXEC lp_deal_capture.[dbo].[usp_GenieAddressCopy] @p_contract_nbr, @w_account_id, @w_billing_address_link;

		IF @@error									<> 0
		or @@ROWCOUNT								 = 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Billing Address)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
								 @p_contract_nbr,
								 @w_account_number,
								 @w_application,
								 @w_error,
								 @w_msg_id,
								 @w_descp_add
			goto goto_SELECT
		END
	END

	IF NOT EXISTS(SELECT account_id
			 FROM lp_account..account_address WITH (NOLOCK)
			 WHERE account_id					= @w_account_id
			 AND address_link					= @w_service_address_link)
			 OR (@w_service_address_link		= 1)
	BEGIN

		EXEC lp_deal_capture.[dbo].[usp_GenieAddressCopy] @p_contract_nbr, @w_account_id, @w_service_address_link;

		IF @@error									<> 0
		or @@ROWCOUNT								 = 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Services Address)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									@w_error,
									 @w_msg_id,
									 @w_descp_add
			goto goto_SELECT
		END
	END

	IF NOT EXISTS(SELECT account_id
				 FROM lp_account..account_contact WITH (NOLOCK)
				 WHERE account_id				= @w_account_id
				 AND contact_link				= @w_customer_contact_link)
				 OR (@w_customer_contact_link	= 1)
	BEGIN

		EXEC lp_deal_capture.dbo.usp_GenieContactCopy @p_contract_nbr, @w_account_id, @w_customer_contact_link;

		IF @@error									<> 0
		or @@ROWCOUNT								 = 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Customer Contact)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
			goto goto_SELECT
		END
	END

	IF NOT EXISTS(SELECT account_id
				 FROM lp_account..account_contact WITH (NOLOCK)
				 WHERE account_id				= @w_account_id
				 AND contact_link				= @w_billing_contact_link)
				 OR (@w_billing_contact_link	= 1)
	BEGIN
		
		EXEC lp_deal_capture.dbo.usp_GenieContactCopy @p_contract_nbr, @w_account_id, @w_billing_contact_link;

		IF @@error									<> 0
		or @@ROWCOUNT								 = 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Billing Contact)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
			goto goto_SELECT
		END
	END

	

	-- BEGIN comments
	IF NOT EXISTS(SELECT account_id
			 FROM lp_account..account_comments WITH (NOLOCK)
			 WHERE account_id				= @w_account_id
			 AND process_id					= @w_process_id)
	BEGIN

		SELECT @w_date_comment				= date_comment, 
			 @w_comment						= comment
		FROM deal_contract_comment WITH (NOLOCK)
		WHERE contract_nbr					= @p_contract_nbr

		IF LEN(LTRIM(RTRIM(@w_comment)))			  > 0
		BEGIN

			INSERT INTO lp_account..account_comments	  
			SELECT @w_account_id, 
				@w_date_comment, 
				@w_process_id, 
				@w_comment, 
				@w_username, 0

			 IF @@error								<> 0
			 or @@ROWCOUNT							= 0
			 BEGIN
				ROLLBACK TRAN val
				SELECT @w_application				= 'COMMON'
					,@w_error						= 'E'
					,@w_msg_id						= '00000051'
					,@w_return						= 1
					,@w_descp_add					= '(Insert Billing Contact)'

				EXEC usp_contract_error_ins 'ENROLLMENT',
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

	-- end comments

	SELECT @w_return								 = 1

	EXEC @w_return = lp_account..usp_account_status_history_ins @w_username,
																@w_account_id,
																@w_status,
																@w_sub_status,
																@w_getdate,
																@w_process_id,
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
		SELECT @w_application						 = 'COMMON'
			,@w_error								= 'E'
			,@w_msg_id							  = '00000051'
			,@w_return							  = 1
			,@w_descp_add							= ' (Insert History Account) '

		EXEC usp_contract_error_ins 'ENROLLMENT',
							  @p_contract_nbr,
							  @w_account_number,
							  @w_application,
							  @w_error,
							  @w_msg_id,
							  @w_descp_add

		goto goto_SELECT
	END

	IF  EXISTS(SELECT status_substatus
			  FROM lp_account..ufn_account_check(@p_username) 
			  WHERE status_substatus				= LTRIM(RTRIM(@w_status))			 
													+ LTRIM(RTRIM(@w_sub_status)))
	AND @w_contract_is_amendment					 = 'FALSE'
	BEGIN
		/* Ticket 17675 BEGIN */
		IF NOT EXISTS (SELECT 1 FROM lp_account..account WITH (NOLOCK)
				WHERE account_id = @w_account_id)
		BEGIN
			SELECT @w_check_type_new_contract = ch.Check_Type
			FROM lp_common..common_utility_check_type ch WITH (NOLOCK)
			WHERE ch.contract_type		= @w_contract_type
			and	ch.utility_id			= @w_utility_id
			AND ch.[order]				= (SELECT MIN([order]) 
											FROM lp_common..common_utility_check_type chm WITH (NOLOCK)
											WHERE chm.contract_type		= ch.contract_type
											AND chm.utility_id			= ch.utility_id
											AND chm.Check_Type			<> 'CHECK ACCOUNT')
			ORDER BY [order]					
		END			
		ELSE
		BEGIN
			SET @w_check_type_new_contract = 'CHECK ACCOUNT'
		END 
		
		/* Ticket 17675 end */
		
		IF NOT EXISTS(SELECT contract_nbr
				FROM lp_enrollment..check_account WITH (NOLOCK)
				WHERE contract_nbr			  = @p_contract_nbr
				AND check_type				  = @w_check_type_new_contract)
		BEGIN

			INSERT INTO lp_account..account_sales_channel_hist
			SELECT @w_account_id,
				@w_getdate,
				@w_sales_channel_role,
				@w_check_type_new_contract,	---'CHECK ACCOUNT',	
				@w_username,
				0

			IF @@error								<> 0
			or @@ROWCOUNT							  = 0
			BEGIN
				ROLLBACK TRAN val
				SELECT @w_application				 = 'COMMON'
					,@w_error						 = 'E'
					,@w_msg_id						= '00000051'
					,@w_return						= 1
					,@w_descp_add					 = ' (Insert History Sales Channel) '

				EXEC usp_contract_error_ins 'ENROLLMENT',
										@p_contract_nbr,
										@w_account_number,
										@w_application,
										@w_error,
										@w_msg_id,
										@w_descp_add

				goto goto_SELECT
			END
											  
			SET @w_return							= 1

			EXEC @w_return = lp_enrollment..usp_check_account_ins @p_username,
																@p_contract_nbr,
																' ',
																@w_check_type_new_contract, --'CHECK ACCOUNT', ADD Ticket 17675
																'ENROLLMENT',
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
				SELECT @w_application			= 'COMMON'
					,@w_error					= 'E'
					,@w_msg_id					= '00000051'
					,@w_return					= 1
					,@w_descp_add				= ' (Insert ' + LTRIM(RTRIM(@w_check_type_new_contract)) + ') '

				EXEC usp_contract_error_ins 'ENROLLMENT',
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

	SET @w_return								 = 1

	
	IF @w_contract_type							= 'POWER MOVE' 
	BEGIN
	
		--SET @w_date_flow_start					= @w_date_end
		SET @w_date_flow_start					= @w_contract_eff_start_date
		SET @w_date_end							= dateadd(mm, @w_term_months,@w_date_flow_start)

		SELECT @w_duns_number_entity			= esco
		FROM lp_enrollment..load_set_number_accepted WITH (NOLOCK)
		WHERE process_status					= 'C'
		and	util_acct							= @w_account_number

		SELECT @w_entity_id						= entity_id
		FROM lp_common..common_entity WITH (NOLOCK)
		WHERE @w_duns_number_entity				like '%' + LTRIM(RTRIM(duns_number)) + '%'
	END 

	SELECT @w_contract_type						  = CASE WHEN @w_contract_is_amendment = 'TRUE' 
															THEN @w_contract_type_amend 
															ELSE @w_contract_type END

	EXEC @w_return = lp_common..usp_product_account_type_sel @w_product_id, 
															@w_account_type OUTPUT

	-- IF there was an error, default to SMB
	IF @w_return <> 0
		SET @w_account_type = 'SMB'


	/* Ticket 17130 BEGIN */
	IF @w_status = '911000' AND  @w_sub_status = '10' AND @w_date_deenrollment = '19000101'
		SET @w_status = '01000'
	/* Ticket 17130 End */	
	
	/* Ticket 17675 BEGIN */
	IF not EXISTS (SELECT 1 FROM lp_account..account WITH (NOLOCK)
				WHERE account_id = @w_account_id)
	BEGIN
		SELECT @w_status				= wait_status
			,@w_sub_status				= wait_sub_status
			,@w_check_type_new_contract = ch.Check_Type
		FROM lp_common..common_utility_check_type ch WITH (NOLOCK)
		WHERE ch.contract_type		= @w_contract_type
		and	ch.utility_id			= @w_utility_id
		AND ch.[order]				= (SELECT min([order]) 
										FROM lp_common..common_utility_check_type chm WITH (NOLOCK)
										WHERE chm.contract_type		= ch.contract_type
										AND chm.utility_id			= ch.utility_id
										AND chm.Check_Type			<> 'CHECK ACCOUNT')
		ORDER BY [order]
	END
	/* Ticket 17675 end */
	
	
	IF @w_date_submit IS NULL 
		SET @w_date_submit = @w_date_deal

	/* Ticket # 1-34030211 BEGIN */
	IF @w_contract_type = 'POWER MOVE'
	BEGIN
		
		SELECT @w_account_name_link			= A.NameID
			,@w_customer_name_link			= A.NameID
			,@w_owner_name_link				= A.NameID
		FROM LibertyPower..CustomerName A WITH (NOLOCK)	
		INNER JOIN LibertyPower..Account B WITH (NOLOCK)	
		ON B.CustomerID				= A.CustomerID
		WHERE B.AccountIdLegacy		= @w_account_id

		SELECT @w_customer_address_link		= A.AddressID
			,@w_billing_address_link		= A.AddressID
			,@w_service_address_link		= A.AddressID
		FROM LibertyPower..CustomerAddress A WITH (NOLOCK)	
		INNER JOIN LibertyPower..Account B WITH (NOLOCK)	
		ON B.CustomerID				= A.CustomerID
		WHERE B.AccountIdLegacy		= @w_account_id
			
		SELECT @w_customer_contact_link		= A.ContactID
			,@w_billing_contact_link		= A.ContactID
		FROM LibertyPower..CustomerContact A WITH (NOLOCK)	
		INNER JOIN LibertyPower..Account B WITH (NOLOCK)	
		ON B.CustomerID				= A.CustomerID
		WHERE B.AccountIdLegacy		= @w_account_id	
		
	END
	/* Ticket # 1-34030211 End */
	
	/*		
	SELECT p_username						= @p_username,
			p_account_id					= @w_account_id,
			p_account_number				= @w_account_number,
			p_account_type					= @w_account_type,
			p_status						= @w_status,
			p_sub_status					= @w_sub_status,
			p_customer_id					= ' ',
			p_entity_id						= @w_entity_id,
			p_contract_nbr					= @w_contract_nbr,
			p_contract_type					= @w_contract_type,
			p_retail_mkt_id					= @w_retail_mkt_id,
			p_utility_id					= @w_utility_id,
			p_product_id					= @w_product_id,
			p_rate_id						= @w_rate_id,
			p_rate							= @w_rate,
			
			p_account_name_link				= @w_account_name_link,
			p_customer_name_link			= @w_customer_name_link,
			p_customer_address_link			= @w_customer_address_link,
			p_customer_contact_link			= @w_customer_contact_link,
			p_billing_address_link			= @w_billing_address_link,
			p_billing_contact_link			= @w_billing_contact_link,
			p_owner_name_link				= @w_owner_name_link,
			p_service_address_link			= @w_service_address_link,
			
			p_business_type					= @w_business_type,
			p_business_activity				= @w_business_activity,
			p_additional_id_nbr_type		= @w_additional_id_nbr_type,
			p_additional_id_nbr				= @w_additional_id_nbr,
			p_contract_eff_start_date		= @w_contract_eff_start_date,
			p_term_months					= @w_term_months,
			p_date_end						= @w_date_end,
			p_date_deal						= @w_date_deal,
			p_date_created					= @w_date_created,
			p_date_submit					= @w_date_submit,
			p_sales_channel_role			= @w_sales_channel_role,
			p_sales_rep						= @w_sales_rep,
			p_origin						= @w_origin,
			p_annual_usage					= @w_annual_usage,
			p_date_flow_start				= @w_date_flow_start,
			p_date_por_enrollment			= @w_date_por_enrollment,
			p_date_deenrollment				= @w_date_deenrollment,
			p_date_reenrollment				= @w_date_reenrollment,
			p_tax_status					= @w_tax_status,
			p_tax_float						= @w_tax_float,
			p_credit_score					= @w_credit_score,
			p_credit_agency					= @w_credit_agency,
			p_por_option					= @w_por_option,
			p_billing_type					= @w_billing_type,
			p_zone							= '',
			p_service_rate_class			= '',
			p_stratum_variable				= '',
			p_billing_group					= '',
			p_icap							= '',
			p_tcap							= '',
			p_load_profile					= '',
			p_loss_code						= '',
			p_meter_type					= '',
			p_requested_flow_start_date		= @w_requested_flow_start_date,
			p_deal_type						= @w_deal_type,
			p_enrollment_type				= @p_enrollment_type,
			p_customer_code					= @w_customer_code,
			p_customer_group				= @w_customer_group,
			p_error							= @w_error ,
			p_msg_id						= @w_msg_id , 
			p_descp							= ' ',
			p_result_ind					= 'N',
			p_paymentTerm					= 0,
			p_SSNEncrypted					= @w_SSNEncrypted, --Added for IT002
			p_HeatIndexSourceID				= @w_HeatIndexSourceID,  -- Project IT037
			p_HeatRate						= @w_HeatRate,			-- Project IT037 
			p_sales_manager					= @w_sales_manager,
			p_evergreen_option_id			= @w_evergreen_option_id ,				--Added for IT021
			p_evergreen_commission_end		= @w_evergreen_commission_end ,		--Added for IT021
			p_evergreen_commission_rate		= @w_evergreen_commission_rate ,	--Added for IT021
			p_residual_option_id			= @w_residual_option_id ,					--Added for IT021
			p_residual_commission_end		= @w_residual_commission_end ,		--Added for IT021
			p_initial_pymt_option_id		= @w_initial_pymt_option_id, 			--Added for IT021
			p_original_tax_designation		= @w_TaxStatus,
			EstimatedAnnualUsage			= @EstimatedAnnualUsage,
			PriceID							= @PriceID												
	*/
	
	EXEC @w_return = lp_account..usp_account_ins @p_username				= @p_username,
												@p_account_id				= @w_account_id,
												@p_account_number			= @w_account_number,
												@p_account_type				= @w_account_type,
												@p_status					= @w_status,
												@p_sub_status				= @w_sub_status,
												@p_customer_id				= ' ',
												@p_entity_id				= @w_entity_id,
												@p_contract_nbr				= @w_contract_nbr,
												@p_contract_type			= @w_contract_type,
												@p_retail_mkt_id			= @w_retail_mkt_id,
												@p_utility_id				= @w_utility_id,
												@p_product_id				= @w_product_id,
												@p_rate_id					= @w_rate_id,
												@p_rate						= @w_rate,
												@p_account_name_link		= @w_account_name_link,
												@p_customer_name_link		= @w_customer_name_link,
												@p_customer_address_link	= @w_customer_address_link,
												@p_customer_contact_link	= @w_customer_contact_link,
												@p_billing_address_link		= @w_billing_address_link,
												@p_billing_contact_link		= @w_billing_contact_link,
												@p_owner_name_link			= @w_owner_name_link,
												@p_service_address_link		= @w_service_address_link,
												@p_business_type			= @w_business_type,
												@p_business_activity		= @w_business_activity,
												@p_additional_id_nbr_type	= @w_additional_id_nbr_type,
												@p_additional_id_nbr		= @w_additional_id_nbr,
												@p_contract_eff_start_date	= @w_contract_eff_start_date,
												@p_term_months				= @w_term_months,
												@p_date_end					= @w_date_end,
												@p_date_deal				= @w_date_deal,
												@p_date_created				= @w_date_created,
												@p_date_submit				= @w_date_submit,
												@p_sales_channel_role		= @w_sales_channel_role,
												@p_sales_rep				= @w_sales_rep,
												@p_origin					= @w_origin,
												@p_annual_usage				= @w_annual_usage,
												@p_date_flow_start			= @w_date_flow_start,
												@p_date_por_enrollment		= @w_date_por_enrollment,
												@p_date_deenrollment		= @w_date_deenrollment,
												@p_date_reenrollment		= @w_date_reenrollment,
												@p_tax_status				= @w_tax_status,
												@p_tax_float				= @w_tax_float,
												@p_credit_score				= @w_credit_score,
												@p_credit_agency			= @w_credit_agency,
												@p_por_option				= @w_por_option,
												@p_billing_type				= @w_billing_type,
												@p_zone						= '',
												@p_service_rate_class		= '',
												@p_stratum_variable			= '',
												@p_billing_group			= '',
												@p_icap						= '',
												@p_tcap						= '',
												@p_load_profile				= '',
												@p_loss_code				= '',
												@p_meter_type				= '',
												@p_requested_flow_start_date = @w_requested_flow_start_date,
												@p_deal_type				= @w_deal_type,
												@p_enrollment_type			= @p_enrollment_type,
												@p_customer_code			= @w_customer_code,
												@p_customer_group			= @w_customer_group,
												@p_error					= @w_error OUTPUT,
												@p_msg_id					= @w_msg_id OUTPUT, 
												@p_descp					= ' ',
												@p_result_ind				= 'N',
												@p_paymentTerm				= 0,
												@p_SSNEncrypted				= @w_SSNEncrypted --Added for IT002
												,@p_HeatIndexSourceID		= @w_HeatIndexSourceID  -- Project IT037
												,@p_HeatRate				= @w_HeatRate,			-- Project IT037 
												@p_sales_manager			= @w_sales_manager,
												@p_evergreen_option_id		= @w_evergreen_option_id ,				--Added for IT021
												@p_evergreen_commission_end = @w_evergreen_commission_end ,		--Added for IT021
												@p_evergreen_commission_rate = @w_evergreen_commission_rate ,	--Added for IT021
												@p_residual_option_id		= @w_residual_option_id ,					--Added for IT021
												@p_residual_commission_end	= @w_residual_commission_end ,		--Added for IT021
												@p_initial_pymt_option_id	= @w_initial_pymt_option_id, 			--Added for IT021
												@p_original_tax_designation = @w_TaxStatus,
												@EstimatedAnnualUsage		= @EstimatedAnnualUsage,
												@PriceID					= @PriceID												

		
	IF @w_return									<> 0
	BEGIN
		ROLLBACK TRAN val
		SELECT @w_application						 = 'COMMON'
			,@w_error								= 'E'
			,@w_msg_id							  = '00000051'
			,@w_return							  = 1
			,@w_descp_add							= ' (Insert Account) '

		EXEC usp_contract_error_ins 'ENROLLMENT',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add
		goto goto_SELECT
	END

	-- IT106 add product rate AND history IF it does not EXISTS. (will occur WHEN coming FROM Genie)
	DECLARE	@PriceIDMapping		bigint,
			@RateDescription	VARCHAR(250),
			@GrossMargin		decimal(18,10),
			@ExpirationDate		DATETIME,
			@ZoneID				int,
			@ServiceClassID		int,
			@Today				DATETIME
			
	SET		@Today	= GETDATE()
				
	SELECT	@PriceIDMapping = ISNULL(PriceID, 0), @RateDescription = ISNULL(RateDescription, '''')
	FROM	Libertypower..GeniePriceMapping WITH (NOLOCK)
	WHERE	ProductID			= @w_product_id
	AND		RateID				= @w_rate_id

	IF @PriceIDMapping > 0
	BEGIN
		SELECT	@GrossMargin = ISNULL(GrossMargin, 0), @ExpirationDate = CostRateExpirationDate,
			@ZoneID = ZoneID, @ServiceClassID = ServiceClassID
		FROM	Libertypower..Price WITH(NOLOCK)
		WHERE	ID = @PriceIDMapping


		EXEC lp_common..usp_ProductRateAdd	@ProductId		= @w_product_id,
										@RateId			= @w_rate_id,
										@Rate			= @w_rate,
										@Description	= @RateDescription,
										@Term			= @w_term_months,
										@GrossMargin	= @GrossMargin,
										@IndexType		= '''',
										@BillingTypeID	= 0,
										@StartDate		= @w_date_flow_start,
										@EffDate		= @w_contract_eff_start_date,
										@DueDate		= @ExpirationDate,
										@GracePeriod	= 365,
										@ZoneID			= @ZoneID,
										@ServiceClassID	= @ServiceClassID,
										@ActiveDate		= @Today,
										@DateCreated	= @Today,
										@Username		= @p_username
							
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN val
			SELECT @w_application					= 'COMMON'
				,@w_error							= 'E'
				,@w_msg_id							= '00000051'
				,@w_return							= 1
				,@w_descp_add						= '(Insert Product Rate)'

			EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
			GOTO goto_SELECT
		END				
	END						
  ---------------------------------------------------------------------------------------------------------------	
  
	IF len(LTRIM(RTRIM(@w_customer_code)))		  <> 0
	BEGIN
	  /* Ticket : 15959 BEGIN */
	  IF EXISTS (SELECT 1 FROM lp_account..account_info WITH (NOLOCK)
				WHERE account_id = @w_account_id)
	  BEGIN
			UPDATE lp_account..account_info
			SET utility_id			= @w_utility_id
				,name_key			= @w_customer_code 
			WHERE account_id		= @w_account_id
	  END
	  ELSE
	  BEGIN	
		  INSERT INTO lp_account..account_info
		  SELECT @w_account_id,
				 @w_utility_id,
				 @w_customer_code,
				 '',
				 @w_date_created
				 ,suser_sname()
				 ,null
				 ,null
				 ,null
				 ,null
				 ,null
				 ,null
	  END			 
	  /* Ticket : 15959 End */
	  
	  IF @@error									<> 0
	  or @@ROWCOUNT								 = 0
	  BEGIN
		 ROLLBACK TRAN val
		 SELECT @w_application					  = 'COMMON'
			,@w_error							= 'E'
			,@w_msg_id							= '00000051'
		 	,@w_return							= 1
		 	,@w_descp_add						= '(Insert Account Info)'

		 EXEC usp_contract_error_ins 'ENROLLMENT',
									 @p_contract_nbr,
									 @w_account_number,
									 @w_application,
									 @w_error,
									 @w_msg_id,
									 @w_descp_add
		 goto goto_SELECT
	  END
	END

	SELECT @w_full_name								= full_name
	FROM deal_name WITH (NOLOCK)
	WHERE contract_nbr								= @p_contract_nbr
	AND name_link									= @w_account_name_link

	SELECT @w_service_address						= address,
		  @w_service_suite							= suite,
		  @w_service_city							= city,
		  @w_service_state							= state,
		  @w_service_zip							= zip
	FROM deal_address WITH (NOLOCK)
	WHERE contract_nbr								= @p_contract_nbr
	AND address_link								= @w_service_address_link

	SELECT @w_billing_address						= address,
		  @w_billing_suite							= suite,
		  @w_billing_city							= city,
		  @w_billing_state							= state,
		  @w_billing_zip							= zip
	FROM deal_address WITH (NOLOCK)
	WHERE contract_nbr								= @p_contract_nbr
	AND address_link								= @w_billing_address_link

	EXEC @w_return = lp_deal_capture..usp_contract_tracking_details_ins @p_username,
																		@w_transaction_id,
																		@w_account_number,
																		@w_full_name,
																		@w_retail_mkt_id,
																		@w_utility_id,
																		@w_entity_id,
																		@w_product_id,
																		@w_rate_id,
																		@w_rate,
																		@w_por_option,
																		@w_account_type,
																		@w_business_activity,
																		'',
																		@w_contract_type,
																		@w_contract_nbr,
																		@w_sales_rep,
																		@w_sales_channel_role,
																		@w_contract_eff_start_date,
																		@w_date_end,
																		@w_term_months,
																		@w_date_deal,
																		@w_date_submit,
																		@w_date_flow_start,
																		@p_enrollment_type,
																		@w_tax_status,
																		@w_tax_float,
																		@w_annual_usage,
																		@w_getdate,
																		@w_service_address,
																		@w_service_suite,
																		@w_service_city,
																		@w_service_state,
																		@w_service_zip,
																		@w_billing_address,
																		@w_billing_suite,
																		@w_billing_city,
																		@w_billing_state,
																		@w_billing_zip,
																		'DEAL CAPTURE',
																		'COMPLETE'

	IF @w_return									<> 0
	BEGIN
		ROLLBACK TRAN val
		SELECT @w_application						= 'COMMON'
			,@w_error								= 'E'
			,@w_msg_id								= '00000051'
			,@w_return								= 1
			,@w_descp_add							= ' (Insert Account Traking) '

		EXEC usp_contract_error_ins 'ENROLLMENT',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add
		goto goto_SELECT
	END

	INSERT INTO lp_account..account_meters
	SELECT account_id, 
		  meter_number
	FROM lp_deal_capture..account_meters WITH (NOLOCK)
	WHERE account_id								 = @w_account_id

	DELETE FROM account_meters
	WHERE account_id								 = @w_account_id

	UPDATE deal_contract_account SET status = 'SENT'
	FROM deal_contract_account WITH (NOLOCK)
	WHERE contract_nbr							= @p_contract_nbr
	AND account_number							= @t_account_number

	COMMIT TRAN val
	
	SET ROWCOUNT 1

	SELECT @w_account_id						= account_id,
		  @w_account_number						= account_number,
		  @w_contract_type						= CASE WHEN contract_type = 'PRE-PRINTED' 
															THEN 'PAPER' 
															ELSE contract_type 
													END,
		  @w_retail_mkt_id						= retail_mkt_id,
		  @w_utility_id							= utility_id,
		  @w_product_id							= product_id,
		  @w_rate_id							= rate_id,
		  @w_rate								= rate,
		  @w_account_name_link					= account_name_link,
		  @w_customer_name_link					= customer_name_link,
		  @w_customer_address_link				= customer_address_link,
		  @w_customer_contact_link				= customer_contact_link,
		  @w_billing_address_link				= billing_address_link,
		  @w_billing_contact_link				= billing_contact_link,
		  @w_owner_name_link					= owner_name_link,
		  @w_service_address_link				= service_address_link,
		  @w_business_type						= business_type,
		  @w_business_activity					= business_activity,
		  @w_additional_id_nbr_type				= additional_id_nbr_type,
		  @w_additional_id_nbr					= additional_id_nbr,
		  @w_contract_eff_start_date			= contract_eff_start_date,
		  @w_term_months						= term_months,
		  @w_date_end							= date_end,
		  @w_date_deal							= date_deal,
		  @w_date_created						= date_created,
		  @w_sales_channel_role					= sales_channel_role,
		  @w_username							= username,
		  @w_sales_rep							= sales_rep,
		  @w_origin								= origin,
		  @w_requested_flow_start_date			= ISNULL(requested_flow_start_date, '19000101'),
		  @w_deal_type							= ISNULL(deal_type, ''),
		  @w_customer_code						= ISNULL(customer_code, ''),
		  @w_customer_group						= ISNULL(customer_group, ''),
		  @PriceID								= PriceID		  
	FROM deal_contract_account WITH (NOLOCK)
	WHERE contract_nbr							= @p_contract_nbr
	AND account_number							 > @t_account_number
	AND (status									 = ' '
	OR status									 = 'RUNNING')

	SET @w_ROWCOUNT								= @@ROWCOUNT

END

SET ROWCOUNT 0

BEGIN tran cont

IF EXISTS(SELECT contract_nbr
		  FROM lp_enrollment..check_account WITH (NOLOCK)
		  WHERE contract_nbr					= @w_contract_nbr
		  AND check_type						= 'CHECK ACCOUNT')
BEGIN
	goto goto_sent
END		  

SELECT TOP 1
		@w_check_type							= b.check_type
FROM deal_contract a WITH (NOLOCK),
	 lp_common..common_utility_check_type b WITH (NOLOCK)
WHERE a.contract_nbr							= @p_contract_nbr
AND a.utility_id								= b.utility_id
AND CASE WHEN a.contract_type = 'PRE-PRINTED' 
			THEN 'PAPER' 
			ELSE a.contract_type 
	  end											= b.contract_type
AND b.[order]									 > 1	 
ORDER BY b.[order]								 

IF @@ROWCOUNT									  <> 0
BEGIN
	IF EXISTS(SELECT contract_nbr
			 FROM lp_enrollment..check_account WITH (NOLOCK)
			 WHERE contract_nbr					 = @w_contract_nbr
			 and	check_type						= @w_check_type)
	BEGIN
	  goto goto_sent
	END
END

IF  @w_check_type									= 'PROFITABILITY' 
AND @w_contract_is_amendment						= 'FALSE'
BEGIN

-- PROFITABILITY
	SELECT @w_header_enrollment_1					= header_enrollment_1,
		  @w_header_enrollment_2					= header_enrollment_2
	FROM deal_config WITH (NOLOCK)

	SELECT @w_getdate_h							  = CONVERT(VARCHAR(08), getdate(), 108)
		,@w_getdate_d							  = CONVERT(VARCHAR(08), getdate(), 112)

	IF @w_getdate_h								  > @w_header_enrollment_2
	BEGIN
	  SELECT @w_getdate_h							= @w_header_enrollment_1
	  SELECT @w_getdate_d							= CONVERT(VARCHAR(08), dateadd(dd, 1, @w_getdate_d), 112)
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

	IF NOT EXISTS(SELECT request_id
				 FROM lp_risk..web_header_enrollment WITH (NOLOCK)
				 WHERE request_id					= @w_risk_request_id)
	BEGIN
	  INSERT INTO lp_risk..web_header_enrollment
	  SELECT @w_risk_request_id,
			 @w_request_DATETIME,
			 'BATCH',
			 'DEAL CAPTURE BATCH LOAD',
			 getdate(),
			 @p_username

	  IF  @@error								  <> 0
	  AND @@ROWCOUNT								= 0
	  BEGIN
		 ROLLBACK TRAN cont
		 SELECT @w_application					  = 'COMMON'
			,@w_error							= 'E'
		 	,@w_msg_id							= '00000051'
		 	,@w_return							= 1
		 	,@w_descp_add						= ' (Insert Scraper Header) '

		 EXEC usp_contract_error_ins 'ENROLLMENT',
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
	WHERE contract_nbr								= @p_contract_nbr

	IF  @@error									 <> 0
	AND @@ROWCOUNT									= 0
	BEGIN
	  ROLLBACK TRAN cont
	  SELECT @w_application						= 'COMMON'
	  		,@w_error							= 'E'
	  		,@w_msg_id							= '00000051'
	  		,@w_return							= 1
	  		,@w_descp_add						= ' (Insert Scraper Detail) '

	  EXEC usp_contract_error_ins 'ENROLLMENT',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add

	  goto goto_SELECT
	END

	SET @w_return								 = 1
	
	EXEC @w_return = lp_enrollment..usp_check_account_ins @p_username,
														 @p_contract_nbr,
														 ' ',
														 'PROFITABILITY',
														 'ENROLLMENT',
														 'AWSCR',
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

	IF @w_return					 <> 0
	BEGIN
	  ROLLBACK TRAN cont
	  SELECT @w_application						= 'COMMON'
	  		,@w_error							= 'E'
	  		,@w_msg_id							= '00000051'
	  		,@w_return							= 1
	  		,@w_descp_add						= ' (Insert Check Profitability) '

	  EXEC usp_contract_error_ins 'ENROLLMENT',
								  @p_contract_nbr,
								  @w_account_number,
								  @w_application,
								  @w_error,
								  @w_msg_id,
								  @w_descp_add

	  goto goto_SELECT
	END

END
ELSE IF @w_contract_is_amendment = 'FALSE'
BEGIN

	SET @w_return								 = 1
	
	/* Add Ticket 17675 BEGIN */
	IF @w_check_type_new_contract is null or @w_check_type_new_contract = ''
		SET @w_check_type_new_contract = @w_check_type
	/* Add Ticket 17675  end */
	
	EXEC @w_return = lp_enrollment..usp_check_account_ins @p_username,
														 @p_contract_nbr,
														 ' ',
														 @w_check_type_new_contract, --@w_check_typ Add Ticket 17675,
														 'ENROLLMENT',
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
	  ROLLBACK TRAN cont
	  SELECT @w_application						= 'COMMON'
	  		,@w_error							= 'E'
	  		,@w_msg_id							= '00000051'
	  		,@w_return							= 1
	  		,@w_descp_add						= ' (Insert Credit Check) '

	  EXEC usp_contract_error_ins 'ENROLLMENT',
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

DELETE deal_contract
FROM deal_contract WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

DELETE deal_contract_account
FROM deal_contract_account WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

DELETE deal_address
FROM deal_address WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

DELETE deal_contact
FROM deal_contact WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

DELETE deal_name
FROM deal_name WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

DELETE deal_contract_error
FROM deal_contract_error WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

DELETE
FROM	deal_contract_comment
WHERE	contract_nbr = @p_contract_nbr

DELETE
FROM	deal_contract_amend
WHERE	contract_nbr	  = @p_contract_nbr
AND contract_nbr_amend	= @w_contract_nbr_amend

COMMIT TRAN cont

goto_SELECT:

SET ROWCOUNT 0

UPDATE deal_contract SET status = 'DRAFT - ERROR'
FROM deal_contract WITH (NOLOCK)
WHERE contract_nbr								  = @p_contract_nbr

SELECT @p_application								= @w_application,
		@p_error									 = @w_error,
		@p_msg_id									= @w_msg_id,
		@p_descp_add								 = @w_descp_add

SET NOCOUNT OFF

RETURN @w_return

---- End of procedure [dbo].[usp_contract_submit_ins] -----------------------------------------------------------
