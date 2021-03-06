USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_ins]    Script Date: 10/23/2013 15:33:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***
********************** usp_account_ins *************************

-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- Clear code (remove print AND put SET nocount)
-- Put WITH (NOLOCK) in the SELECT querys
-- Verify the powermove information FROM EDI transaction
-- =======================================
-- Modified 11/06/2012 - Isabelle Tamanini
-- Ticket # 1-35430251
-- Added code from account insteadof trigger to get the dates
-- from the contract if it already exists on the db
-- =======================================

-- =======================================
-- Modified 08/15/2013 - Sal Tenorio
-- Ticket # 1-177923867 (TFS 16377)
-- The date_por_enrollment should be set to the first of the month
-- regardless of the day of the week this day happens to be
-- =======================================
-- Modified 10/23/2013 - Rick Deigsler
-- Ticket # 1-233737521 (TFS 21092)
-- Added payment terms data selection
-- =======================================

***/

ALTER procedure [dbo].[usp_account_ins]
(
	@p_username						NCHAR(100) ,
	@p_account_id					CHAR(12) ,
	@p_account_number				VARCHAR(30) ,
	@p_account_type					VARCHAR(25) ,
	@p_status						VARCHAR(15) ,
	@p_sub_status					VARCHAR(15) ,
	@p_customer_id					CHAR(10) ,
	@p_entity_id					CHAR(15) ,
	@p_contract_nbr					CHAR(12) ,
	@p_contract_type				VARCHAR(25) ,
	@p_retail_mkt_id				CHAR(02) ,
	@p_utility_id					CHAR(15) ,
	@p_product_id					CHAR(20) ,
	@p_rate_id 						INT ,
	@p_rate 						FLOAT ,
	@p_account_name_link 			INT ,
	@p_customer_name_link 			INT ,
	@p_customer_address_link 		INT ,
	@p_customer_contact_link 		INT ,
	@p_billing_address_link 		INT ,
	@p_billing_contact_link 		INT ,
	@p_owner_name_link 				INT ,
	@p_service_address_link 		INT ,
	@p_business_type 				VARCHAR(35) ,
	@p_business_activity 			VARCHAR(35) ,
	@p_additional_id_nbr_type 		VARCHAR(10) ,
	@p_additional_id_nbr 			VARCHAR(30) ,
	@p_contract_eff_start_date		DATETIME ,
	@p_term_months					INT ,
	@p_date_END						DATETIME ,
	@p_date_deal					DATETIME ,
	@p_date_created					DATETIME ,
	@p_date_submit					DATETIME ,
	@p_sales_channel_role			NVARCHAR(50) ,
	@p_sales_rep					VARCHAR(100) ,
	@p_origin						VARCHAR(50) ,
	@p_annual_usage					INT ,
	@p_date_flow_start				DATETIME = '19000101' ,
	@p_date_por_enrollment			DATETIME = '19000101' ,
	@p_date_deenrollment			DATETIME = '19000101' ,
	@p_date_reenrollment			DATETIME = '19000101' ,
	@p_tax_status					VARCHAR(20) = 'FULL' ,
	@p_tax_float					INT = 0 ,
	@p_credit_score					REAL = 0 ,
	@p_credit_agency				VARCHAR(30) = 'NONE' ,
	@p_por_option					VARCHAR(03) = '' ,
	@p_billing_type					VARCHAR(15) = '' ,
	@p_zone							VARCHAR(15) = '' ,
	@p_service_rate_class			VARCHAR(15) = '' ,
	@p_stratum_variable				VARCHAR(15) = '' ,
	@p_billing_group				VARCHAR(15) = '' ,
	@p_icap							VARCHAR(15) = '' ,
	@p_tcap							VARCHAR(15) = '' ,
	@p_load_profile					VARCHAR(15) = '' ,
	@p_loss_code					VARCHAR(15) = '' ,
	@p_meter_type					VARCHAR(15) = '' ,
	@p_requested_flow_start_date	DATETIME = '19000101' ,
	@p_deal_type					CHAR(20) = '' ,
	@p_enrollment_type				INT = 0 OUTPUT,
	@p_customer_code				CHAR(05) = '' ,
	@p_customer_group				CHAR(100) = '' ,
	@p_error						CHAR(01) = '' OUTPUT ,
	@p_msg_id						CHAR(08) = '' OUTPUT ,
	@p_descp						VARCHAR(250) = '' OUTPUT,
	@p_result_ind					CHAR(01) = 'Y',
	@p_paymentTerm					INT = 0,
	@p_SSNEncrypted					NVARCHAR(100) = '',
	@p_HeatIndexSourceID			INT	= NULL,			-- Project IT037
	@p_HeatRate						DECIMAL	(9,2) = NULL -- Project IT037 
	,@p_sales_manager				VARCHAR(100)  = NULL -- Project IT021
	,@p_evergreen_option_id			INT = NULL			-- Project IT021
	,@p_evergreen_commission_END	DATETIME = NULL		-- Project IT021
	,@p_evergreen_commission_rate	FLOAT = NULL		-- Project IT021
	,@p_residual_option_id			INT = NULL			-- Project IT021
	,@p_residual_commission_END		DATETIME = NULL		-- Project IT021
	,@p_initial_pymt_option_id		INT = NULL			-- Project IT021
	,@p_original_tax_designation	INT = NULL
	,@EstimatedAnnualUsage			INT = 0 -- Project IT106
	,@PriceID						BIGINT = 0 -- Project IT106
)
AS

SET NOCOUNT ON 

DECLARE @w_error								CHAR(01)
	,@w_msg_id									CHAR(08)
	,@w_descp									VARCHAR(250)
	,@w_return									INT
	,@w_utilityIDR								BIT
	,@w_metery_type								VARCHAR(15)
	,@w_ProcessDate								DATETIME
	,@w_lead_time								INT
	,@w_date_por_enrollment						DATETIME
	,@start_date								DATETIME
	,@w_BillingTypeID							INT
	,@w_BillingType								VARCHAR(15)
	,@w_chgstamp								SMALLINT
	,@w_usage_req_status						VARCHAR(20)
	,@w_deal_type								CHAR(20)


SELECT
	@w_error					= 'I'
	,@w_msg_id					= '00000001'
	,@w_descp					= ' '
	,@w_return					= 0
	,@w_ProcessDate				= GETDATE()
	,@w_lead_time				= 0
	,@p_annual_usage			= 0	
	,@w_date_por_enrollment		= @p_date_por_enrollment


-- The sales channel enters an expected start date.  In order to hit that date, we have to consider the lead time for the utility.
-- We take the expected start date, derive the BEGINning of that month, then subtract the lead time.

IF @p_retail_mkt_id = 'TX' AND  @p_requested_flow_start_date <> '19000101' AND @p_requested_flow_start_date is not NULL
BEGIN
	SET @start_date = @p_requested_flow_start_date
END
ELSE
BEGIN
	SET @start_date = @p_contract_eff_start_date
END

SELECT @w_date_por_enrollment = DATEADD(dd, -enrollment_lead_days, DATEADD(m,DATEDIFF(m,0,@start_date),0))
FROM lp_common.dbo.common_utility WITH (NOLOCK)
WHERE utility_id = @p_utility_id

-- TFS 16377. Per Siara's request, we do not want to adjust back to Friday but leave it on the first of the month
-- Ticket 17198, IF day lands on Saturday or Sunday, SET it to the prior Friday.
--IF DATENAME(dw,@w_date_por_enrollment) = 'saturday'
--	SET @w_date_por_enrollment = DATEADD(dd,-1,@w_date_por_enrollment)
--IF DATENAME(dw,@w_date_por_enrollment) = 'sunday'
--	SET @w_date_por_enrollment = DATEADD(dd,-2,@w_date_por_enrollment)

-- Get the meter type: IF the utiltiy is IDR EDI AND the account number exists in the IDR acocunts table, then meter type should be IDR
SELECT	@w_utilityIDR=u.isIDR_EDI_Capable
FROM	LibertyPower..Utility u WITH (NOLOCK)
WHERE	u.UtilityCode = @p_utility_id

SELECT	@w_metery_type = 'IDR'
FROM	LibertyPower..IDRAccounts a WITH (NOLOCK)
WHERE	@w_utilityIDR = 1
AND		a.AccountNumber = @p_account_number
AND		a.UtilityID = 'IDR_' + @p_utility_id

IF (@w_metery_type!= '')
	SET @p_meter_type = @w_metery_type

------------------------------------------------------------------------------------------------------------------------------------------
--BEGIN IT0051
SELECT @w_BillingTypeID = BillingTypeID FROM lp_common..common_product_rate WITH (NOLOCK) WHERE product_id = @p_product_id AND rate_id = @p_rate_id
SELECT @w_BillingType = [Type] FROM libertypower..billingtype WITH (NOLOCK) WHERE BillingTypeID = @w_BillingTypeID 
SELECT @p_billing_type = ISNULL(@w_BillingType,@p_billing_type)
--END IT0051

--SR1-3213252
IF @p_account_type = 'RESIDENTIAL' AND @p_utility_id = 'PECO'
	SET @p_por_option = 'YES'

SELECT @p_additional_id_nbr_type	= UPPER(@p_additional_id_nbr_type)  --Upper Added for ticket 17620
	,@p_sales_channel_role			= LTRIM(RTRIM(@p_sales_channel_role))
	,@w_chgstamp					= 0
	,@w_usage_req_status			= 'Pending'
	,@w_deal_type					= 'NEW CONTRACT'


-- ====================================================================================================================================================
-- New Insert Procedure
-- ====================================================================================================================================================



-- MAKE SURE TO ADAPT FOR NON_RENEWAL ONLY !!!!!!


-- Check that all the records are propagated across all accounts:


-- See IF we got record in deal capture for the account
--IF OBJECT_ID('tempdb..#TAccounts') IS NOT NULL
--	DROP TABLE #TAccounts;
--IF OBJECT_ID('tempdb..#TIds') IS NOT NULL
--	DROP TABLE #TIds;
	
---- Get all the other accounts in the same contract, we will use this to add the other addresses
--SELECT account_id INTO #TAccounts 
--FROM lp_deal_capture..deal_contract_account 
--WHERE LTRIM(RTRIM(contract_nbr)) = LTRIM(RTRIM(@p_contract_nbr))
--AND account_id != @p_account_id;

--SELECT account_id INTO #TIds 
--FROM lp_deal_capture..deal_contact 
--WHERE LTRIM(RTRIM(contract_nbr)) = LTRIM(RTRIM(@p_contract_nbr))






-- ====================================================================================================================================================
-- Contract Table
-- ====================================================================================================================================================
DECLARE @C_NewContractCreated	BIT
	,@C_RC						INT
	,@C_ContractID				INT
	,@C_Number					VARCHAR(50)
	,@C_ContractTypeID			INT
	,@C_ContractDealTypeID		INT
	,@C_ContractStatusID		INT
	,@C_ContractTemplateID		INT
	,@C_ReceiptDate				DATETIME
	,@C_StartDate				DATETIME
	,@C_ENDDate					DATETIME
	,@C_SignedDate				DATETIME
	,@C_SubmitDate				DATETIME
	,@C_SalesChannelID			INT
	,@C_SalesRep				VARCHAR(64)
	,@C_SalesManagerID			INT
	,@C_PricingTypeID			INT
	,@C_ModifiedBy				INT
	,@C_CreatedBy				INT


SET @C_Number = LTRIM(RTRIM(@p_contract_nbr));
SET @C_ContractTypeID = Libertypower.dbo.ufn_GetContractTypeId(@p_contract_type);
SET @C_ContractDealTypeID = Libertypower.dbo.ufn_GetContractDealTypeId(@p_contract_type);
SELECT @C_ContractStatusID	= CS.ContractStatusID FROM LibertyPower.dbo.ContractStatus CS WITH (NOLOCK) WHERE LOWER(CS.Descp) = 'pENDing';
SET @C_ContractTemplateID = Libertypower.dbo.ufn_GetContractTemplateTypeId(@p_contract_type);
SET @C_ReceiptDate = NULL;
SET @C_StartDate = MIN(lp_enrollment.dbo.ufn_date_format( @p_contract_eff_start_date ,'<YYYY>-<MM>-01'));
SET @C_ENDDate				= MIN(DATEADD(mm, @p_term_months, lp_enrollment.dbo.ufn_date_format(@p_contract_eff_start_date,'<YYYY>-<MM>-01')) - 1) ;
SET @C_SignedDate = @p_date_deal;
SET @C_SubmitDate = @p_date_submit;
SET @C_SalesChannelID = Libertypower.dbo.ufn_GetSalesChannel(@p_sales_channel_role);
SET @C_SalesRep = LTRIM(RTRIM(@p_sales_rep));
SET @C_SalesManagerID = Libertypower.dbo.ufn_GetUserId(@p_sales_manager, 1);
SET @C_PricingTypeID = NULL;
SET @C_ModifiedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);
SET @C_CreatedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);

SELECT @C_ContractID = C.ContractID FROM Libertypower.dbo.[Contract] C WITH (NOLOCK) WHERE C.Number = @C_Number ;
IF @C_ContractID IS NULL 
BEGIN
	EXECUTE @C_RC = [Libertypower].[dbo].[usp_ContractInsert] 
	   @C_Number
	  ,@C_ContractTypeID
	  ,@C_ContractDealTypeID
	  ,@C_ContractStatusID
	  ,@C_ContractTemplateID
	  ,@C_ReceiptDate
	  ,@C_StartDate
	  ,@C_ENDDate
	  ,@C_SignedDate
	  ,@C_SubmitDate
	  ,@C_SalesChannelID
	  ,@C_SalesRep
	  ,@C_SalesManagerID
	  ,@C_PricingTypeID
	  ,@C_ModifiedBy
	  ,@C_CreatedBy
	  ,0
	  ,@EstimatedAnnualUsage ;
	 
	SELECT @C_ContractID = C.ContractID FROM Libertypower.dbo.[Contract] C (NOLOCK) WHERE C.Number = @C_Number ;
	SET @C_NewContractCreated = 1;
END
ELSE
BEGIN
	SELECT  @C_ContractID = ContractID, @C_StartDate = StartDate,  @C_EndDate =  EndDate
	FROM LibertyPower.dbo.[Contract] C (NOLOCK) 
	WHERE C.ContractID = @C_ContractID
		
	EXECUTE @C_RC = [Libertypower].[dbo].[usp_ContractUpdate] 
	   @C_ContractID
	  ,@C_Number
	  ,@C_ContractTypeID
	  ,@C_ContractDealTypeID
	  ,@C_ContractStatusID
	  ,@C_ContractTemplateID
	  ,@C_ReceiptDate
	  ,@C_StartDate
	  ,@C_ENDDate
	  ,@C_SignedDate
	  ,@C_SubmitDate
	  ,@C_SalesChannelID
	  ,@C_SalesRep
	  ,@C_SalesManagerID
	  ,@C_PricingTypeID
	  ,@C_ModifiedBy
	  ,0 -- IsSilent
	  ,1 -- Migration Complete
	  ,@EstimatedAnnualUsage ;
 ;
	  
	SET @C_NewContractCreated = 0;
END


-- ====================================================================================================================================================
-- Customer Table
-- ====================================================================================================================================================
DECLARE @CUST_RC				INT
	,@CUST_CustomerID			INT
	,@CUST_PreferenceID			INT
	,@CUST_NameID				INT
	,@CUST_OwnerNameID			INT
	,@CUST_AddressID			INT
	,@CUST_ContactID			INT
	,@CUST_ExternalNumber		VARCHAR(64)
	,@CUST_DBA					VARCHAR(128)
	,@CUST_Duns					VARCHAR(30)
	,@CUST_SsnClear				NVARCHAR(100)
	,@CUST_SsnEncrypted			NVARCHAR(512)
	,@CUST_TaxId				VARCHAR(30)
	,@CUST_EmployerId			VARCHAR(30)
	,@CUST_CreditAgencyID		INT
	,@CUST_CreditScoreEncrypted NVARCHAR(512)
	,@CUST_BusinessTypeID		INT
	,@CUST_BusinessActivityID	INT
	,@CUST_ModifiedBy			INT
	,@CUST_CreatedBy			INT



SELECT @CUST_Duns			= ''
	,@CUST_EmployerId		= ''
	,@CUST_TaxId			= ''
	,@CUST_SsnEncrypted		= NULL

IF UPPER(LTRIM(RTRIM(@p_additional_id_nbr_type))) = 'DUNSNBR'
	SET @CUST_Duns = UPPER(@p_additional_id_nbr);
IF UPPER(LTRIM(RTRIM(@p_additional_id_nbr_type))) = 'EMPLID'
	SET @CUST_EmployerId = UPPER(@p_additional_id_nbr);	
IF UPPER(LTRIM(RTRIM(@p_additional_id_nbr_type))) = 'TAX ID'
	SET @CUST_TaxId = UPPER(@p_additional_id_nbr);	
IF UPPER(LTRIM(RTRIM(@p_additional_id_nbr_type))) = 'SSN'
	SET @CUST_SsnEncrypted = @p_SSNEncrypted;
				
SELECT @CUST_CreditAgencyID = CA.CreditAgencyID FROM LibertyPower.dbo.CreditAgency CA WITH (NOLOCK)  WHERE LOWER(CA.Name) = LOWER(LTRIM(RTRIM(@p_credit_agency)));
SELECT @CUST_BusinessTypeID = BT.BusinessTypeID FROM LibertyPower.dbo.BusinessType BT WITH (NOLOCK)  WHERE LOWER(BT.[Type]) = LOWER(LTRIM(RTRIM(@p_business_type)));
SELECT @CUST_BusinessActivityID = BA.BusinessActivityID FROM LibertyPower.dbo.BusinessActivity BA WITH (NOLOCK)  WHERE LOWER(BA.Activity) = LOWER(LTRIM(RTRIM(@p_business_activity)));

SET @CUST_SsnEncrypted = @p_SSNEncrypted;
SET @CUST_ModifiedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);
SET @CUST_CreatedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);

IF @C_NewContractCreated = 0
AND 1 = 0 -- This is disabled, for more than 1 insert operations, the first account should have the valid data accounts inserted 
BEGIN
	-- contract was NOT CREATED which implies that a customer record was created already AND another account would have this customer assigned to it
	-- this query might return more than one but all should be the same
	DECLARE @Shared_AccountIdLegacy VARCHAR(20);
	
	SELECT @CUST_CustomerID = A.CustomerID, @Shared_AccountIdLegacy = A.AccountIdLegacy FROM LibertyPower.dbo.Account A WITH (NOLOCK)
	JOIN Libertypower.dbo.AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND AC.ContractID = @C_ContractID;
	
	-- NEW MD084 the link is the actual ID now
	SET @CUST_NameID	  = @p_customer_name_link;
	SET @CUST_OwnerNameID = @p_owner_name_link;
	SET @CUST_AddressID   = @p_customer_address_link;
	SET @CUST_ContactID   = @p_customer_contact_link;

	--SELECT @CUST_NameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (nolock)  
	--	WHERE AN.account_id = @p_account_id AND AN.name_link = @p_customer_name_link;

	--SELECT @CUST_OwnerNameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (nolock)  
	--	WHERE AN.account_id = @p_account_id AND AN.name_link = @p_owner_name_link;

	--SELECT @CUST_AddressID = A.AccountAddressID FROM lp_account.dbo.account_address A (nolock) 
	--	WHERE A.account_id = @p_account_id AND A.address_link = @p_customer_address_link;

	--SELECT @CUST_ContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (nolock)  
	--	WHERE AC.account_id = @p_account_id AND AC.contact_link = @p_customer_contact_link;
	
		
	IF @CUST_ContactID IS NULL OR @CUST_ContactID = 0 OR @CUST_ContactID = -1
		RAISERROR('@CUST_ContactID IS NULL, cannot continue',11,1)
	
	IF @CUST_AddressID IS NULL OR @CUST_AddressID = 0 OR @CUST_AddressID = -1
		RAISERROR('@CUST_AddressID IS NULL, cannot continue',11,1)
	
	IF @CUST_OwnerNameID IS NULL OR @CUST_OwnerNameID = 0 OR @CUST_OwnerNameID = -1
		RAISERROR('@CUST_OwnerNameID IS NULL, cannot continue',11,1)
	
	IF @CUST_NameID IS NULL OR @CUST_NameID = 0 OR @CUST_NameID = -1
		RAISERROR('@CUST_NameID IS NULL, cannot continue',11,1)
	
	IF @CUST_CustomerID IS NULL OR @CUST_CustomerID = 0 OR @CUST_CustomerID = -1
		RAISERROR('@CUST_CustomerID IS NULL, cannot continue',11,1)
	
	
	EXECUTE @CUST_RC = [Libertypower].[dbo].[usp_CustomerUpdate]  
	   @CUST_CustomerID
	  ,@CUST_NameID
	  ,@CUST_OwnerNameID
	  ,@CUST_AddressID
	  ,@CUST_ContactID
	  ,@CUST_ExternalNumber
	  ,@CUST_DBA
	  ,@CUST_Duns
	  ,@CUST_SsnClear
	  ,@CUST_SsnEncrypted
	  ,@CUST_TaxId
	  ,@CUST_EmployerId
	  ,@CUST_CreditAgencyID
	  ,@CUST_CreditScoreEncrypted
	  ,@CUST_BusinessTypeID
	  ,@CUST_BusinessActivityID
	  ,@CUST_ModifiedBy
	  
	IF @CUST_RC IS NULL OR @CUST_RC = 0 OR @CUST_RC = -1
		RAISERROR('@w_CustomerID IS NULL, cannot continue',11,1)
END
ELSE
BEGIN

	-- We have to SET these values here because the customer is shared among accounts
	-- NEW MD084 the link is the actual ID now
	SELECT @CUST_NameID			= @p_customer_name_link
		,@CUST_OwnerNameID		= @p_owner_name_link
		,@CUST_AddressID		= @p_customer_address_link
		,@CUST_ContactID		= @p_customer_contact_link

	-- SET VALUES:
	--SELECT @CUST_NameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (nolock)  
	--	WHERE AN.account_id = @p_account_id AND AN.name_link = @p_customer_name_link;
	--SELECT @CUST_OwnerNameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (nolock)  
	--	WHERE AN.account_id = @p_account_id AND AN.name_link = @p_owner_name_link;
	--SELECT @CUST_AddressID = A.AccountAddressID FROM lp_account.dbo.account_address A (nolock) 
	--	WHERE A.account_id = @p_account_id AND A.address_link = @p_customer_address_link;
	--SELECT @CUST_ContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (nolock)  
	--	WHERE AC.account_id = @p_account_id AND AC.contact_link = @p_customer_contact_link;
	
	IF @CUST_ContactID IS NULL OR @CUST_ContactID = 0 OR @CUST_ContactID = -1
		RAISERROR('@CUST_ContactID IS NULL, cannot continue',11,1)
	
	IF @CUST_AddressID IS NULL OR @CUST_AddressID = 0 OR @CUST_AddressID = -1
		RAISERROR('@CUST_AddressID IS NULL, cannot continue',11,1)
	
	IF @CUST_OwnerNameID IS NULL OR @CUST_OwnerNameID = 0 OR @CUST_OwnerNameID = -1
		RAISERROR('@CUST_OwnerNameID IS NULL, cannot continue',11,1)
	
	IF @CUST_NameID IS NULL OR @CUST_NameID = 0 OR @CUST_NameID = -1
		RAISERROR('@CUST_NameID IS NULL, cannot continue',11,1)
	

	-- INSERT NEW CUSTOMER PREFERENCE RECORD FIRST

	DECLARE @CUSTPREF_RC				INT
		,@CUSTPREF_IsGoGreen			BIT
		,@CUSTPREF_OptOutSpecialOffers	BIT
		,@CUSTPREF_LanguageID			INT
		,@CUSTPREF_Pin					VARCHAR(16)
		,@CUSTPREF_ModifiedBy			INT
		,@CUSTPREF_CreatedBy			INT

	SELECT @CUSTPREF_IsGoGreen				= 0
		,@CUSTPREF_OptOutSpecialOffers		= 0
		,@CUSTPREF_LanguageID				= 1 -- ENGLISH
		,@CUSTPREF_Pin						= ''
		,@CUSTPREF_ModifiedBy				= @CUST_CreatedBy
		,@CUSTPREF_CreatedBy				= @CUST_CreatedBy

	EXECUTE @CUSTPREF_RC = [LibertyPower].[dbo].[usp_CustomerPreferenceInsert] 
	   @CUSTPREF_IsGoGreen
	  ,@CUSTPREF_OptOutSpecialOffers
	  ,@CUSTPREF_LanguageID
	  ,@CUSTPREF_Pin
	  ,@CUSTPREF_ModifiedBy
	  ,@CUSTPREF_CreatedBy;

	
	IF @CUSTPREF_RC IS NULL OR @CUSTPREF_RC = 0 OR @CUSTPREF_RC = -1
		RAISERROR('@CUSTPREF_RC IS NULL, cannot continue',11,1)
	SET @CUST_PreferenceID = @CUSTPREF_RC;


	EXECUTE @CUST_RC = [Libertypower].[dbo].[usp_CustomerInsert] 
	   @CUST_NameID
	  ,@CUST_OwnerNameID
	  ,@CUST_AddressID
	  ,@CUST_PreferenceID
	  ,@CUST_ContactID
	  ,@CUST_ExternalNumber
	  ,@CUST_DBA
	  ,@CUST_Duns
	  ,@CUST_SsnClear
	  ,@CUST_SsnEncrypted
	  ,@CUST_TaxId
	  ,@CUST_EmployerId
	  ,@CUST_CreditAgencyID
	  ,@CUST_CreditScoreEncrypted
	  ,@CUST_BusinessTypeID
	  ,@CUST_BusinessActivityID
	  ,@CUST_ModifiedBy
	  ,@CUST_CreatedBy

	IF @CUST_RC IS NULL OR @CUST_RC = 0 OR @CUST_RC = -1
		RAISERROR('@w_CustomerID IS NULL, cannot continue',11,1)
	SET @CUST_CustomerID = @CUST_RC;

END

-- ====================================================================================================================================================
-- Account Table
-- ====================================================================================================================================================

DECLARE @A_RC						INT
	,@A_AccountID					INT
	,@A_AccountIdLegacy				CHAR(12)
	,@A_AccountNumber				VARCHAR(30)
	,@A_AccountTypeID				INT
	,@A_CustomerID					INT
	,@A_CustomerIdLegacy			VARCHAR(10)
	,@A_EntityID					CHAR(15)
	,@A_RetailMktID					INT
	,@A_UtilityID					INT
	,@A_AccountNameID				INT
	,@A_BillingAddressID			INT
	,@A_BillingContactID			INT
	,@A_ServiceAddressID			INT
	,@A_Origin						VARCHAR(50)
	,@A_TaxStatusID					INT
	,@A_PorOption					BIT
	,@A_BillingTypeID				INT
	,@A_Zone						VARCHAR(50)
	,@A_ServiceRateClass			VARCHAR(50)
	,@A_StratumVariable				VARCHAR(15)
	,@A_BillingGroup				VARCHAR(15)
	,@A_Icap						VARCHAR(15)
	,@A_Tcap						VARCHAR(15)
	,@A_LoadProfile					VARCHAR(50)
	,@A_LossCode					VARCHAR(15)
	,@A_MeterTypeID					INT
	,@A_CurrentContractID			INT
	,@A_CurrentRenewalContractID	INT
	,@A_Modified					DATETIME
	,@A_ModifiedBy					INT
	,@A_DateCreated					DATETIME
	,@A_CreatedBy					INT
	,@A_MigrationComplete			BIT

SELECT @A_AccountIdLegacy	= @p_account_id
	,@A_AccountNumber		= LTRIM(RTRIM(@p_account_number))

IF @p_account_type = 'RESIDENTIAL'
	SET @p_account_type = 'RES'

-- Added to prevent duplicate account_id in the table. 2012-02-25
--IF EXISTS (SELECT AccountID FROM LibertyPower..Account WHERE AccountIDLegacy = @A_AccountIdLegacy)
--	RAISERROR('AccountIdLegacy already exists, cannot continue',11,1)

-- attempt to get service class AND zone based on price record
SELECT @p_service_rate_class = ISNULL(s.service_rate_class, ''), @p_zone = ISNULL(z.zone, '') 
FROM Libertypower..Price p WITH (NOLOCK)
LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
LEFT JOIN lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
WHERE p.ID = @PriceID

SELECT @A_AccountTypeID = AT.ID FROM LibertyPower.dbo.AccountType AT (NOLOCK) WHERE LOWER(AT.AccountType) = LOWER(LTRIM(RTRIM(@p_account_type)));
--TODO: Check this logic that IF account is inserting then this is the current contract
SET @A_CurrentContractID = @C_ContractID; -- This is to make it appear on the account view

-- SET @A_CurrentRenewalContractID = @C_ContractID; -- This is to make it appear on the account_renewal view
SELECT @A_CustomerID		= @CUST_CustomerID
	,@A_CustomerIdLegacy	= @p_customer_id
	,@A_EntityID			= @p_entity_id

SELECT @A_RetailMktID = M.ID FROM Libertypower.dbo.Market M (NOLOCK) WHERE LTRIM(RTRIM(LOWER(M.MarketCode))) = LTRIM(RTRIM(LOWER(@p_retail_mkt_id))) AND M.InactiveInd = '0';
SELECT @A_UtilityID = U.ID FROM LibertyPower.dbo.Utility U (NOLOCK) WHERE LOWER(U.UtilityCode) = LOWER(LTRIM(RTRIM(@p_utility_id))) AND U.InactiveInd = '0';

-- NEW MD084 the link is the actual ID now
SELECT @A_AccountNameID		= @p_account_name_link
	,@A_BillingAddressID	= @p_billing_address_link
	,@A_BillingContactID	= @p_billing_contact_link
	,@A_ServiceAddressID	= @p_service_address_link

--SELECT @A_AccountNameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (NOLOCK)WHERE AN.account_id = @p_account_id AND AN.name_link = @p_account_name_link;
--SELECT @A_BillingAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @p_account_id AND AA.address_link = @p_billing_address_link;
--SELECT @A_BillingContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (NOLOCK) WHERE AC.account_id = @p_account_id AND AC.contact_link = @p_billing_contact_link;
--SELECT @A_ServiceAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @p_account_id AND AA.address_link = @p_service_address_link;

SET @A_Origin = @p_origin;
SELECT @A_TaxStatusID = T.TaxStatusID FROM LibertyPower.dbo.TaxStatus T (NOLOCK) WHERE LOWER(T.[Status]) = LOWER(LTRIM(RTRIM(@p_tax_status)));
SET @A_PorOption = CASE LOWER(@p_por_option) WHEN 'yes' THEN 1 ELSE 0 END;
SELECT @A_BillingTypeID = B.BillingTypeID FROM LibertyPower.dbo.BillingType B (NOLOCK) WHERE LOWER(B.[Type]) = LOWER(LTRIM(RTRIM(@p_billing_type)));
SET @A_Zone = @p_zone
SET @A_ServiceRateClass = @p_service_rate_class;
SET @A_StratumVariable = @p_stratum_variable;
SET @A_BillingGroup = @p_billing_group;
SET @A_Icap = @p_icap;
SET @A_Tcap = @p_tcap;
SET @A_LoadProfile = @p_load_profile;
SET @A_LossCode = @p_loss_code;
SELECT @A_MeterTypeID = MT.ID FROM LibertyPower.dbo.MeterType MT (NOLOCK) WHERE LOWER(MT.MeterTypeCode) =  LOWER(LTRIM(RTRIM(@p_meter_type)));

SET @A_CreatedBy = LibertyPower.dbo.ufn_GetUserId(@p_username ,0);
SET @A_ModifiedBy = LibertyPower.dbo.ufn_GetUserId(@p_username,0);

SELECT @A_Modified			= GETDATE()
	,@A_DateCreated			= GETDATE()
	,@A_MigrationComplete	= 1

SET @A_AccountID = NULL

SELECT @A_AccountID =  AccountID FROM Libertypower..Account WITH (NOLOCK)
WHERE AccountIDLegacy	= @A_AccountIdLegacy

IF @A_AccountID IS NULL
BEGIN
EXECUTE @A_RC = [Libertypower].[dbo].[usp_AccountInsert]  
   @A_AccountIdLegacy
  ,@A_AccountNumber
  ,@A_AccountTypeID
  ,@A_CurrentContractID
  ,@A_CurrentRenewalContractID
  ,@A_CustomerID
  ,@A_CustomerIdLegacy
  ,@A_EntityID
  ,@A_RetailMktID
  ,@A_UtilityID
  ,@A_AccountNameID
  ,@A_BillingAddressID
  ,@A_BillingContactID
  ,@A_ServiceAddressID
  ,@A_Origin
  ,@A_TaxStatusID
  ,@A_PorOption
  ,@A_BillingTypeID
  ,@A_Zone
  ,@A_ServiceRateClass
  ,@A_StratumVariable
  ,@A_BillingGroup
  ,@A_Icap
  ,@A_Tcap
  ,@A_LoadProfile
  ,@A_LossCode
  ,@A_MeterTypeID
  ,@A_ModifiedBy
  ,@A_Modified
  ,@A_DateCreated
  ,@A_CreatedBy
  ,@A_MigrationComplete
  ;
SET @A_AccountID = @A_RC;
END
ELSE
BEGIN

	EXECUTE @A_RC = [Libertypower].[dbo].[usp_AccountUpdate] 
		@A_AccountID	 
	  ,@A_AccountIdLegacy
	  ,@A_AccountNumber
	  ,@A_AccountTypeID
	  ,@A_CurrentContractID
	  ,@A_CurrentRenewalContractID
	  ,@A_CustomerID
	  ,@A_CustomerIdLegacy
	  ,@A_EntityID
	  ,@A_RetailMktID
	  ,@A_UtilityID
	  ,@A_AccountNameID
	  ,@A_BillingAddressID
	  ,@A_BillingContactID
	  ,@A_ServiceAddressID
	  ,@A_Origin
	  ,@A_TaxStatusID
	  ,@A_PorOption
	  ,@A_BillingTypeID
	  ,@A_Zone
	  ,@A_ServiceRateClass
	  ,@A_StratumVariable
	  ,@A_BillingGroup
	  ,@A_Icap
	  ,@A_Tcap
	  ,@A_LoadProfile
	  ,@A_LossCode
	  ,@A_MeterTypeID
	  ,@w_ProcessDate
	  ,@A_ModifiedBy
	  ,@A_DateCreated
	  ,@A_CreatedBy
	  ,@A_MigrationComplete
	  ,1;
END	

IF @A_AccountID IS NULL OR @A_AccountID = 0 OR @A_AccountID = -1
		RAISERROR('@A_AccountID IS NULL, cannot continue',11,1)


-- ====================================================================================================================================================
-- Account Detail Table
-- ====================================================================================================================================================
DECLARE @AD_RC int
	,@AD_AccountID int
	,@AD_EnrollmentTypeID INT
	,@AD_OriginalTaxDesignation INT
	,@AD_ModifiedBy int
	,@AD_CreatedBy int

SET @AD_AccountID = @A_AccountID;
SET @AD_OriginalTaxDesignation = @p_original_tax_designation;
SET @AD_ModifiedBy = @A_ModifiedBy;
SET @AD_CreatedBy = @A_ModifiedBy;
SET @AD_EnrollmentTypeID = @p_enrollment_type; 

-- SELECT @AD_EnrollmentTypeID = ET.EnrollmentTypeID FROM LibertyPower.dbo.EnrollmentType ET (NOLOCK) WHERE LOWER(ET.[Type]) =  LOWER(LTRIM(RTRIM(@p_enrollment_type)));


EXECUTE @AD_RC = [Libertypower].[dbo].[usp_AccountDetailInsert] 
   @AD_AccountID
  ,@AD_EnrollmentTypeID
  ,@AD_OriginalTaxDesignation
  ,@AD_ModifiedBy
  ,@AD_CreatedBy



-- ====================================================================================================================================================
-- Account Usage Table
-- ====================================================================================================================================================
DECLARE @AU_RC int
	,@AU_AccountID int
	,@AU_AnnualUsage int
	,@AU_UsageReqStatusID int
	,@AU_EffectiveDate DATETIME
	,@AU_ModifiedBy int
	,@AU_CreatedBy int

SET @AU_EffectiveDate = @C_StartDate;
SET @AU_AccountID = @A_AccountID;
SET @AU_AnnualUsage = @p_annual_usage;
SELECT @AU_UsageReqStatusID =  URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS WHERE LOWER(URS.[Status]) = 'pENDing';
SET @AU_ModifiedBy = @C_ModifiedBy;

EXECUTE @AU_RC = [Libertypower].[dbo].[usp_AccountUsageInsert] 
   @AU_AccountID
  ,@AU_AnnualUsage
  ,@AU_UsageReqStatusID
  ,@AU_EffectiveDate
  ,@AU_ModifiedBy 
  ,@AU_CreatedBy
 ;

-- ====================================================================================================================================================
-- Account Contract Table
-- ====================================================================================================================================================

DECLARE @AC_RC INT
	,@AC_AccountContractID INT
	,@AC_AccountID INT
	,@AC_ContractID INT
	,@AC_RequestedStartDate DATETIME
	,@AC_SENDEnrollmentDate DATETIME
	,@AC_ModifiedBy INT

SET @AC_AccountID = @A_AccountID;
SET @AC_ContractID = @C_ContractID;
SET @AC_RequestedStartDate = @p_requested_flow_start_date;
SET @AC_SENDEnrollmentDate = @w_date_por_enrollment;
SET @AC_ModifiedBy = @C_ModifiedBy;

EXECUTE @AC_RC = [Libertypower].[dbo].[usp_AccountContractInsert] 
   @AC_AccountID
  ,@AC_ContractID
  ,@AC_RequestedStartDate
  ,@AC_SENDEnrollmentDate
  ,@AC_ModifiedBy

IF @AC_RC IS NULL OR @AC_RC = 0 OR @AC_RC = -1
	RAISERROR('@AC_RC IS NULL, cannot continue',11,1)

SET @AC_AccountContractID = @AC_RC;

-- ====================================================================================================================================================
-- Account Status Table
-- ====================================================================================================================================================
DECLARE @AS_RC int
	,@AS_AccountContractID int
	,@AS_Status VARCHAR(15)
	,@AS_SubStatus VARCHAR(15)
	,@AS_ModifiedBy INT
	,@AS_CreatedBy INT

SET @AS_AccountContractID = @AC_AccountContractID;
SET @AS_Status = @p_status;
SET @AS_SubStatus = @p_sub_status;
SET @AS_ModifiedBy = @C_ModifiedBy;
SET @AS_CreatedBy = @C_ModifiedBy;

EXECUTE @AS_RC = [Libertypower].[dbo].[usp_AccountStatusInsert] 
   @AS_AccountContractID
  ,@AS_Status
  ,@AS_SubStatus
  ,@AS_ModifiedBy 
  ,@AS_CreatedBy

-- ====================================================================================================================================================
-- AccountContractRate Table
-- ====================================================================================================================================================
DECLARE @ACR_RC INT
	,@ACR_AccountContractID INT
	,@ACR_LegacyProductID CHAR(20)
	,@ACR_Term INT
	,@ACR_RateID INT
	,@ACR_Rate FLOAT
	,@ACR_RateCode VARCHAR(50)
	,@ACR_RateStart DATETIME
	,@ACR_RateEND DATETIME
	,@ACR_IsContractedRate BIT
	,@ACR_HeatIndexSourceID INT
	,@ACR_HeatRate DECIMAL(9,2)
	,@ACR_TransferRate FLOAT
	,@ACR_GrossMargin FLOAT
	,@ACR_CommissionRate FLOAT
	,@ACR_AdditionalGrossMargin FLOAT
	,@ACR_ModifiedBy INT
	,@ACR_CreatedBy INT

SET @ACR_AccountContractID = @AC_AccountContractID;
SET @ACR_LegacyProductID = @p_product_id;
SET @ACR_Term = @p_term_months;
SET @ACR_RateID = @p_rate_id;
SET @ACR_Rate = @p_rate;
SET @ACR_RateCode = '';
SET @ACR_RateStart = @p_contract_eff_start_date;
SET @ACR_RateEND = @p_date_END;
SET @ACR_IsContractedRate = 1;
SET @ACR_HeatIndexSourceID = @p_HeatIndexSourceID;
SET @ACR_HeatRate = @p_HeatRate;
SET @ACR_TransferRate = NULL;
SET @ACR_GrossMargin = NULL;
SET @ACR_CommissionRate = NULL;
SET @ACR_AdditionalGrossMargin = NULL;
SET @ACR_ModifiedBy = @C_ModifiedBy;
SET @ACR_CreatedBy = @C_ModifiedBy;

-- ====================================================================================================================================================
-- Multi-term MD084  **********************************************************************************************************************************
-- Insert account contract rate record for each multi-term
-- ====================================================================================================================================================
DECLARE	@MultiTermTable TABLE (MultiTermID int, ProductCrossPriceID int, StartDate datetime, Term int, MarkupRate decimal(13,5), Price decimal(13,5))
DECLARE	@MultiTermID int

INSERT INTO	@MultiTermTable
EXEC		Libertypower..usp_MultiTermByPriceIDSelect @PriceID

IF (SELECT COUNT(MultiTermID) FROM @MultiTermTable) > 0
	BEGIN
		WHILE (SELECT COUNT(MultiTermID) FROM @MultiTermTable) > 0
			BEGIN
				SELECT TOP 1 @MultiTermID = MultiTermID FROM @MultiTermTable
				
				SELECT	@ACR_RateStart		= StartDate,
						@ACR_RateEnd		= DATEADD(dd, -1, DATEADD(mm, Term, StartDate)),
						@ACR_Rate			= Price,
						@ACR_Term			= Term,
						@ACR_GrossMargin	= MarkupRate
				FROM	@MultiTermTable
				WHERE	MultiTermID			= @MultiTermID
								
				EXECUTE @ACR_RC = [Libertypower].[dbo].[usp_AccountContractRateInsert] 
				   @ACR_AccountContractID
				  ,@ACR_LegacyProductID
				  ,@ACR_Term 
				  ,@ACR_RateID
				  ,@ACR_Rate
				  ,@ACR_RateCode
				  ,@ACR_RateStart
				  ,@ACR_RateEnd
				  ,@ACR_IsContractedRate
				  ,@ACR_HeatIndexSourceID
				  ,@ACR_HeatRate
				  ,@ACR_TransferRate
				  ,@ACR_GrossMargin
				  ,@ACR_CommissionRate
				  ,@ACR_AdditionalGrossMargin
				  ,@ACR_CreatedBy
				  ,@ACR_ModifiedBy
				  ,1
				  ,@PriceID
				  ;	
				  
				  DELETE FROM @MultiTermTable WHERE MultiTermID = @MultiTermID
			END
	END
-- ====================================================================================================================================================
-- ****************************************************************************************************************************************************
-- ====================================================================================================================================================	
ELSE -- Single term
	BEGIN
		EXECUTE @ACR_RC = [Libertypower].[dbo].[usp_AccountContractRateInsert] 
		   @ACR_AccountContractID
		  ,@ACR_LegacyProductID
		  ,@ACR_Term 
		  ,@ACR_RateID
		  ,@ACR_Rate
		  ,@ACR_RateCode
		  ,@ACR_RateStart
		  ,@ACR_RateEnd
		  ,@ACR_IsContractedRate
		  ,@ACR_HeatIndexSourceID
		  ,@ACR_HeatRate
		  ,@ACR_TransferRate
		  ,@ACR_GrossMargin
		  ,@ACR_CommissionRate
		  ,@ACR_AdditionalGrossMargin
		  ,@ACR_CreatedBy
		  ,@ACR_ModifiedBy
		  ,1
		  ,@PriceID
		  ;
	END
-- ====================================================================================================================================================
-- AccountContractCommission Table
-- ====================================================================================================================================================
DECLARE @ACC_RC int
	,@ACC_AccountContractID int
	,@ACC_EvergreenOptionID int
	,@ACC_EvergreenCommissionEND DATETIME
	,@ACC_EvergreenCommissionRate float
	,@ACC_ResidualOptionID int
	,@ACC_ResidualCommissionEND DATETIME
	,@ACC_InitialPymtOptionID int
	,@ACC_ModifiedBy INT
	,@ACC_CreatedBy INT

SET @ACC_AccountContractID = @AC_AccountContractID;
SET @ACC_EvergreenOptionID = @p_evergreen_option_id;
SET @ACC_EvergreenCommissionEND = @p_evergreen_commission_END;
SET @ACC_EvergreenCommissionRate = @p_evergreen_commission_rate;
SET @ACC_ResidualOptionID = @p_residual_option_id;
SET @ACC_ResidualCommissionEND = @p_residual_commission_END;
SET @ACC_InitialPymtOptionID = @p_initial_pymt_option_id;
SET @ACC_ModifiedBy = @C_ModifiedBy;
SET @ACC_CreatedBy  = @C_ModifiedBy;

EXECUTE @ACC_RC = [Libertypower].[dbo].[usp_AccountContractCommissionInsert] 
   @ACC_AccountContractID
  ,@ACC_EvergreenOptionID
  ,@ACC_EvergreenCommissionEND
  ,@ACC_EvergreenCommissionRate
  ,@ACC_ResidualOptionID
  ,@ACC_ResidualCommissionEND
  ,@ACC_InitialPymtOptionID
  ,@ACC_ModifiedBy
  ,@ACC_CreatedBy
 ;

IF @@error <> 0 OR @@rowcount = 0
BEGIN
         SELECT
             @w_error = 'E'
         SELECT
             @w_msg_id = '00000002'
         SELECT
             @w_return = 1
END

       
--mark the custom rate as used (rate_submit_ind = 1)
UPDATE lp_deal_capture..deal_pricing_detail 
SET rate_submit_ind = 1, date_modified = getdate(), modified_by = @p_username
WHERE product_id = @p_product_id AND rate_id = @p_rate_id

--IF its custom, update the effective date so it matches the contract's deal date.  6/22/2011
IF EXISTS (SELECT * FROM lp_common..common_product WHERE product_id = @p_product_id AND IsCustom = 1)
BEGIN
	UPDATE lp_common..common_product_rate
	SET eff_date = @p_date_deal
	WHERE product_id = @p_product_id AND rate_id = @p_rate_id
END

-- Ticket # 1-233737521 (TFS 21092)  ---------------------------------
IF @p_paymentTerm = 0 AND LEN(@p_billing_type) > 0
	BEGIN
		DECLARE	@BillingTypeID	int,
				@UtilityID		int
				
		SELECT	@BillingTypeID = BillingTypeID FROM LibertyPower..BillingType WITH (NOLOCK) WHERE LOWER([Type]) = LOWER(LTRIM(RTRIM(@p_billing_type)))
		SELECT	@UtilityID = ID FROM LibertyPower..Utility WITH (NOLOCK) WHERE UtilityCode = @p_utility_id
		
		IF @BillingTypeID > 0 AND @UtilityID > 0
			BEGIN
				SELECT	@p_paymentTerm = ISNULL(ARTerms, @p_paymentTerm)
				FROM	Libertypower..UtilityPaymentTerms WITH (NOLOCK)
				WHERE	UtilityId = @UtilityID
				AND		((@BillingTypeID = BillingTypeID) OR (BillingTypeID IS NULL))
			END	
	END
----------------------------------------------------------------------

INSERT INTO AccountPaymentTerm
VALUES
(@p_account_id,@p_paymentTerm,getdate())
       
 
IF @w_error										<> 'N'
BEGIN
         EXEC lp_common..usp_messages_sel @w_msg_id , @w_descp OUTPUT
END
 
IF @p_result_ind									= 'Y'
BEGIN
         SELECT
             flag_error = @w_error ,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
END
 
SELECT
    @p_error = @w_error ,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:

SET NOCOUNT OFF;

RETURN @w_return
