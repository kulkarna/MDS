USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_ins]    Script Date: 10/08/2012 15:37:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_ins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_account_ins]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_ins]    Script Date: 10/08/2012 15:37:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_ins]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/***
********************** usp_account_ins *************************

***/

CREATE procedure [dbo].[usp_account_ins]
(
 @p_username nchar(100) ,
 @p_account_id char(12) ,
 @p_account_number varchar(30) ,
 @p_account_type varchar(25) ,
 @p_status varchar(15) ,
 @p_sub_status varchar(15) ,
 @p_customer_id char(10) ,
 @p_entity_id char(15) ,
 @p_contract_nbr char(12) ,
 @p_contract_type varchar(25) ,
 @p_retail_mkt_id char(02) ,
 @p_utility_id char(15) ,
 @p_product_id char(20) ,
 @p_rate_id int ,
 @p_rate float ,
 @p_account_name_link int ,
 @p_customer_name_link int ,
 @p_customer_address_link int ,
 @p_customer_contact_link int ,
 @p_billing_address_link int ,
 @p_billing_contact_link int ,
 @p_owner_name_link int ,
 @p_service_address_link int ,
 @p_business_type varchar(35) ,
 @p_business_activity varchar(35) ,
 @p_additional_id_nbr_type varchar(10) ,
 @p_additional_id_nbr varchar(30) ,
 @p_contract_eff_start_date datetime ,
 @p_term_months int ,
 @p_date_end datetime ,
 @p_date_deal datetime ,
 @p_date_created datetime ,
 @p_date_submit datetime ,
 @p_sales_channel_role nvarchar(50) ,
 @p_sales_rep varchar(100) ,
 @p_origin varchar(50) ,
 @p_annual_usage int ,
 @p_date_flow_start datetime = ''19000101'' ,
 @p_date_por_enrollment datetime = ''19000101'' ,
 @p_date_deenrollment datetime = ''19000101'' ,
 @p_date_reenrollment datetime = ''19000101'' ,
 @p_tax_status varchar(20) = ''FULL'' ,
 @p_tax_float int = 0 ,
 @p_credit_score real = 0 ,
 @p_credit_agency varchar(30) = ''NONE'' ,
 @p_por_option varchar(03) = '''' ,
 @p_billing_type varchar(15) = '''' ,
 @p_zone varchar(15) = '''' ,
 @p_service_rate_class varchar(15) = '''' ,
 @p_stratum_variable varchar(15) = '''' ,
 @p_billing_group varchar(15) = '''' ,
 @p_icap varchar(15) = '''' ,
 @p_tcap varchar(15) = '''' ,
 @p_load_profile varchar(15) = '''' ,
 @p_loss_code varchar(15) = '''' ,
 @p_meter_type varchar(15) = '''' ,
 @p_requested_flow_start_date datetime = ''19000101'' ,
 @p_deal_type char(20) = '''' ,
 @p_enrollment_type int = 0 OUTPUT,
 @p_customer_code char(05) = '''' ,
 @p_customer_group char(100) = '''' ,
 @p_error char(01) = '''' OUTPUT ,
 @p_msg_id char(08) = '''' OUTPUT ,
 @p_descp varchar(250) = '''' OUTPUT,
 @p_result_ind char(01) = ''Y'',
 @p_paymentTerm int = 0,
 @p_SSNEncrypted nvarchar(100) = '''',
 @p_HeatIndexSourceID	int	= null,			-- Project IT037
 @p_HeatRate			decimal	(9,2) = null -- Project IT037 
 ,@p_sales_manager									varchar(100)  = null -- Project IT021
 ,@p_evergreen_option_id							int = null			-- Project IT021
 ,@p_evergreen_commission_end						datetime = null		-- Project IT021
 ,@p_evergreen_commission_rate						float = null		-- Project IT021
 ,@p_residual_option_id								int = null			-- Project IT021
 ,@p_residual_commission_end						datetime = null		-- Project IT021
 ,@p_initial_pymt_option_id							int = null			-- Project IT021
 ,@p_original_tax_designation						int = null
 ,@EstimatedAnnualUsage int = 0 -- Project IT106
 ,@PriceID bigint = 0 -- Project IT106
)
as
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare	@w_utilityIDR								bit
declare @w_metery_type								varchar(15)

SELECT
    @w_error = ''I''
SELECT
    @w_msg_id = ''00000001''
SELECT
    @w_descp = '' ''
SELECT
    @w_return = 0


--Insert into DebugMessages(DebugMessage) values (''Test'')

-- This is a patch to a problem.  This value was being populated with the same value as @EstimatedAnnualUsage.
-- In all cases however, accounts should start with 0 usage.
SET @p_annual_usage = 0

-- The sales channel enters an expected start date.  In order to hit that date, we have to consider the lead time for the utility.

-- If the enrollment type is non-standard, then we set the "date to send" according to certain busines rules.
declare @w_lead_time                                int
SELECT
    @w_lead_time = 0

declare @w_date_por_enrollment                      datetime
SELECT
    @w_date_por_enrollment = @p_date_por_enrollment


-- The sales channel enters an expected start date.  In order to hit that date, we have to consider the lead time for the utility.
-- We take the expected start date, derive the beginning of that month, then subtract the lead time.
declare @start_date datetime

if @p_retail_mkt_id = ''TX'' and  @p_requested_flow_start_date <> ''19000101'' and @p_requested_flow_start_date is not null
begin
	set @start_date = @p_requested_flow_start_date
end
else
begin
	set @start_date = @p_contract_eff_start_date
end

SELECT @w_date_por_enrollment = dateadd(dd, -enrollment_lead_days, dateadd(m,datediff(m,0,@start_date),0))
FROM lp_common.dbo.common_utility (NOLOCK)
WHERE utility_id = @p_utility_id

-- Ticket 17198, if day lands on Saturday or Sunday, set it to the prior Friday.
if datename(dw,@w_date_por_enrollment) = ''saturday''



	set @w_date_por_enrollment = dateadd(dd,-1,@w_date_por_enrollment)
if datename(dw,@w_date_por_enrollment) = ''sunday''
	set @w_date_por_enrollment = dateadd(dd,-2,@w_date_por_enrollment)

-- Get the meter type: if the utiltiy is IDR EDI and the account number exists in the IDR acocunts table, then meter type should be IDR
SELECT	@w_utilityIDR=u.isIDR_EDI_Capable
FROM	LibertyPower..Utility u
WHERE	u.UtilityCode = @p_utility_id

SELECT	@w_metery_type = ''IDR''
FROM	LibertyPower..IDRAccounts a
WHERE	@w_utilityIDR = 1
AND		a.AccountNumber = @p_account_number
AND		a.UtilityID = ''IDR_'' + @p_utility_id

IF (@w_metery_type!= '''')
	SET @p_meter_type = @w_metery_type

	
------------------------------------------------------------------------------------------------------------------------------------------
--begin IT0051
DECLARE @w_BillingTypeID int	
DECLARE @w_BillingType varchar(15)
SELECT @w_BillingTypeID = BillingTypeID FROM lp_common..common_product_rate WHERE product_id = @p_product_id and rate_id = @p_rate_id
SELECT @w_BillingType = [Type] FROM libertypower..billingtype where BillingTypeID = @w_BillingTypeID 
SELECT @p_billing_type = ISNULL(@w_BillingType,@p_billing_type)
--end IT0051

--SR1-3213252
IF @p_account_type = ''RESIDENTIAL'' AND @p_utility_id = ''PECO''
	SET @p_por_option = ''YES''

SET @p_additional_id_nbr_type = UPPER(@p_additional_id_nbr_type);  --Upper Added for ticket 17620
SET @p_sales_channel_role = ltrim(rtrim(@p_sales_channel_role));

DECLARE @w_chgstamp SMALLINT;
DECLARE @w_usage_req_status VARCHAR(20);
DECLARE @w_deal_type CHAR(20);

SET @w_chgstamp  = 0;
SET @w_usage_req_status = ''Pending'';
SET @w_deal_type = ''NEW CONTRACT'';


-- ====================================================================================================================================================
-- New Insert Procedure
-- ====================================================================================================================================================



-- MAKE SURE TO ADAPT FOR NON_RENEWAL ONLY !!!!!!


-- Check that all the records are propagated across all accounts:


-- See if we got record in deal capture for the account
--IF OBJECT_ID(''tempdb..#TAccounts'') IS NOT NULL
--	DROP TABLE #TAccounts;
--IF OBJECT_ID(''tempdb..#TIds'') IS NOT NULL
--	DROP TABLE #TIds;
	
---- Get all the other accounts in the same contract, we will use this to add the other addresses
--SELECT account_id INTO #TAccounts 
--from lp_deal_capture..deal_contract_account 
--WHERE LTRIM(RTRIM(contract_nbr)) = LTRIM(RTRIM(@p_contract_nbr))
--AND account_id != @p_account_id;

--SELECT account_id INTO #TIds 
--from lp_deal_capture..deal_contact 
--WHERE LTRIM(RTRIM(contract_nbr)) = LTRIM(RTRIM(@p_contract_nbr))






-- ====================================================================================================================================================
-- Contract Table
-- ====================================================================================================================================================
DECLARE @C_NewContractCreated BIT;
DECLARE @C_RC int
DECLARE @C_ContractID int
DECLARE @C_Number varchar(50)
DECLARE @C_ContractTypeID int
DECLARE @C_ContractDealTypeID int
DECLARE @C_ContractStatusID int
DECLARE @C_ContractTemplateID int
DECLARE @C_ReceiptDate datetime
DECLARE @C_StartDate datetime
DECLARE @C_EndDate datetime
DECLARE @C_SignedDate datetime
DECLARE @C_SubmitDate datetime
DECLARE @C_SalesChannelID int
DECLARE @C_SalesRep varchar(64)
DECLARE @C_SalesManagerID int
DECLARE @C_PricingTypeID int
DECLARE @C_ModifiedBy int
DECLARE @C_CreatedBy int


SET @C_Number = LTRIM(RTRIM(@p_contract_nbr));
SET @C_ContractTypeID = Libertypower.dbo.ufn_GetContractTypeId(@p_contract_type);
SET @C_ContractDealTypeID = Libertypower.dbo.ufn_GetContractDealTypeId(@p_contract_type);
SELECT @C_ContractStatusID = CS.ContractStatusID FROM LibertyPower.dbo.ContractStatus CS (NOLOCK) WHERE LOWER(CS.Descp) = ''pending'';
SET @C_ContractTemplateID = Libertypower.dbo.ufn_GetContractTemplateTypeId(@p_contract_type);
SET @C_ReceiptDate = NULL;
SET @C_StartDate = MIN(lp_enrollment.dbo.ufn_date_format( @p_contract_eff_start_date ,''<YYYY>-<MM>-01''));
SET @C_EndDate  = MIN(DATEADD(mm, @p_term_months, lp_enrollment.dbo.ufn_date_format(@p_contract_eff_start_date,''<YYYY>-<MM>-01'')) - 1) ;
SET @C_SignedDate = @p_date_deal;
SET @C_SubmitDate = @p_date_submit;
SET @C_SalesChannelID = Libertypower.dbo.ufn_GetSalesChannel(@p_sales_channel_role);
SET @C_SalesRep = LTRIM(RTRIM(@p_sales_rep));
SET @C_SalesManagerID = Libertypower.dbo.ufn_GetUserId(@p_sales_manager, 1);
SET @C_PricingTypeID = NULL;
SET @C_ModifiedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);
SET @C_CreatedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);

SELECT @C_ContractID = C.ContractID FROM Libertypower.dbo.[Contract] C (NOLOCK) WHERE C.Number = @C_Number ;
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
	  ,@C_EndDate
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
		
	EXECUTE @C_RC = [Libertypower].[dbo].[usp_ContractUpdate] 
	   @C_ContractID
	  ,@C_Number
	  ,@C_ContractTypeID
	  ,@C_ContractDealTypeID
	  ,@C_ContractStatusID
	  ,@C_ContractTemplateID
	  ,@C_ReceiptDate
	  ,@C_StartDate
	  ,@C_EndDate
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
DECLARE @CUST_RC int
DECLARE @CUST_CustomerID int
DECLARE @CUST_PreferenceID int
DECLARE @CUST_NameID int
DECLARE @CUST_OwnerNameID int
DECLARE @CUST_AddressID int
DECLARE @CUST_ContactID int
DECLARE @CUST_ExternalNumber varchar(64)
DECLARE @CUST_DBA varchar(128)
DECLARE @CUST_Duns varchar(30)
DECLARE @CUST_SsnClear nvarchar(100)
DECLARE @CUST_SsnEncrypted nvarchar(512)
DECLARE @CUST_TaxId varchar(30)
DECLARE @CUST_EmployerId varchar(30)
DECLARE @CUST_CreditAgencyID int
DECLARE @CUST_CreditScoreEncrypted nvarchar(512)
DECLARE @CUST_BusinessTypeID int
DECLARE @CUST_BusinessActivityID int
DECLARE @CUST_ModifiedBy int
DECLARE @CUST_CreatedBy int



SET @CUST_Duns = '''';
SET @CUST_EmployerId = '''';
SET @CUST_TaxId = '''';
SET @CUST_SsnEncrypted = NULL;

IF UPPER(LTRIM(RTRIM(@p_additional_id_nbr_type))) = ''DUNSNBR''
	SET @CUST_Duns = UPPER(@p_additional_id_nbr);
IF UPPER(LTRIM(RTRIM(@p_additional_id_nbr_type))) = ''EMPLID''
	SET @CUST_EmployerId = UPPER(@p_additional_id_nbr);	
IF UPPER(LTRIM(RTRIM(@p_additional_id_nbr_type))) = ''TAX ID''
	SET @CUST_TaxId = UPPER(@p_additional_id_nbr);	
IF UPPER(LTRIM(RTRIM(@p_additional_id_nbr_type))) = ''SSN''
	SET @CUST_SsnEncrypted = @p_SSNEncrypted;
				
SELECT @CUST_CreditAgencyID = CA.CreditAgencyID FROM LibertyPower.dbo.CreditAgency CA (nolock)  WHERE LOWER(CA.Name) = LOWER(LTRIM(RTRIM(@p_credit_agency)));
SELECT @CUST_BusinessTypeID = BT.BusinessTypeID FROM LibertyPower.dbo.BusinessType BT (nolock)  WHERE LOWER(BT.[Type]) = LOWER(LTRIM(RTRIM(@p_business_type)));
SELECT @CUST_BusinessActivityID = BA.BusinessActivityID FROM LibertyPower.dbo.BusinessActivity BA (nolock)  WHERE LOWER(BA.Activity) = LOWER(LTRIM(RTRIM(@p_business_activity)));

SET @CUST_SsnEncrypted = @p_SSNEncrypted;
SET @CUST_ModifiedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);
SET @CUST_CreatedBy = Libertypower.dbo.ufn_GetUserId(@p_username, 0);

IF @C_NewContractCreated = 0
AND 1 = 0 -- This is disabled, for more than 1 insert operations, the first account should have the valid data accounts inserted 
BEGIN
	-- contract was NOT CREATED which implies that a customer record was created already and another account would have this customer assigned to it
	-- this query might return more than one but all should be the same
	DECLARE @Shared_AccountIdLegacy VARCHAR(20);
	
	SELECT @CUST_CustomerID = A.CustomerID, @Shared_AccountIdLegacy = A.AccountIdLegacy FROM LibertyPower.dbo.Account A (nolock) 
	JOIN Libertypower.dbo.AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID AND AC.ContractID = @C_ContractID;
	
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
		RAISERROR(''@CUST_ContactID IS NULL, cannot continue'',11,1)
	
	IF @CUST_AddressID IS NULL OR @CUST_AddressID = 0 OR @CUST_AddressID = -1
		RAISERROR(''@CUST_AddressID IS NULL, cannot continue'',11,1)
	
	IF @CUST_OwnerNameID IS NULL OR @CUST_OwnerNameID = 0 OR @CUST_OwnerNameID = -1
		RAISERROR(''@CUST_OwnerNameID IS NULL, cannot continue'',11,1)
	
	IF @CUST_NameID IS NULL OR @CUST_NameID = 0 OR @CUST_NameID = -1
		RAISERROR(''@CUST_NameID IS NULL, cannot continue'',11,1)
	
	IF @CUST_CustomerID IS NULL OR @CUST_CustomerID = 0 OR @CUST_CustomerID = -1
		RAISERROR(''@CUST_CustomerID IS NULL, cannot continue'',11,1)
	
	
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
		RAISERROR(''@w_CustomerID IS NULL, cannot continue'',11,1)
END
ELSE
BEGIN

	-- We have to set these values here because the customer is shared among accounts
	-- NEW MD084 the link is the actual ID now
	SET @CUST_NameID	  = @p_customer_name_link;
	SET @CUST_OwnerNameID = @p_owner_name_link;
	SET @CUST_AddressID   = @p_customer_address_link;
	SET @CUST_ContactID   = @p_customer_contact_link;

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
		RAISERROR(''@CUST_ContactID IS NULL, cannot continue'',11,1)
	
	IF @CUST_AddressID IS NULL OR @CUST_AddressID = 0 OR @CUST_AddressID = -1
		RAISERROR(''@CUST_AddressID IS NULL, cannot continue'',11,1)
	
	IF @CUST_OwnerNameID IS NULL OR @CUST_OwnerNameID = 0 OR @CUST_OwnerNameID = -1
		RAISERROR(''@CUST_OwnerNameID IS NULL, cannot continue'',11,1)
	
	IF @CUST_NameID IS NULL OR @CUST_NameID = 0 OR @CUST_NameID = -1
		RAISERROR(''@CUST_NameID IS NULL, cannot continue'',11,1)
	

	-- INSERT NEW CUSTOMER PREFERENCE RECORD FIRST

	DECLARE @CUSTPREF_RC int
	DECLARE @CUSTPREF_IsGoGreen bit
	DECLARE @CUSTPREF_OptOutSpecialOffers bit
	DECLARE @CUSTPREF_LanguageID int
	DECLARE @CUSTPREF_Pin varchar(16)
	DECLARE @CUSTPREF_ModifiedBy int
	DECLARE @CUSTPREF_CreatedBy int

	SET @CUSTPREF_IsGoGreen = 0;
	SET @CUSTPREF_OptOutSpecialOffers = 0;
	SET @CUSTPREF_LanguageID = 1; -- ENGLISH
	SET @CUSTPREF_Pin = '''';
	SET @CUSTPREF_ModifiedBy = @CUST_CreatedBy;
	SET @CUSTPREF_CreatedBy = @CUST_CreatedBy;

	EXECUTE @CUSTPREF_RC = [LibertyPower].[dbo].[usp_CustomerPreferenceInsert] 
	   @CUSTPREF_IsGoGreen
	  ,@CUSTPREF_OptOutSpecialOffers
	  ,@CUSTPREF_LanguageID
	  ,@CUSTPREF_Pin
	  ,@CUSTPREF_ModifiedBy
	  ,@CUSTPREF_CreatedBy;

	
	IF @CUSTPREF_RC IS NULL OR @CUSTPREF_RC = 0 OR @CUSTPREF_RC = -1
		RAISERROR(''@CUSTPREF_RC IS NULL, cannot continue'',11,1)
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
		RAISERROR(''@w_CustomerID IS NULL, cannot continue'',11,1)
	SET @CUST_CustomerID = @CUST_RC;

	
END

-- ====================================================================================================================================================
-- Account Table
-- ====================================================================================================================================================

DECLARE @A_RC int
DECLARE @A_AccountID int;
DECLARE @A_AccountIdLegacy char(12)
DECLARE @A_AccountNumber varchar(30)
DECLARE @A_AccountTypeID int
DECLARE @A_CustomerID int
DECLARE @A_CustomerIdLegacy varchar(10)
DECLARE @A_EntityID char(15)
DECLARE @A_RetailMktID int
DECLARE @A_UtilityID int
DECLARE @A_AccountNameID int
DECLARE @A_BillingAddressID int
DECLARE @A_BillingContactID int
DECLARE @A_ServiceAddressID int
DECLARE @A_Origin varchar(50)
DECLARE @A_TaxStatusID int
DECLARE @A_PorOption bit
DECLARE @A_BillingTypeID int
DECLARE @A_Zone varchar(50)
DECLARE @A_ServiceRateClass varchar(50)
DECLARE @A_StratumVariable varchar(15)
DECLARE @A_BillingGroup varchar(15)
DECLARE @A_Icap varchar(15)
DECLARE @A_Tcap varchar(15)
DECLARE @A_LoadProfile varchar(50)
DECLARE @A_LossCode varchar(15)
DECLARE @A_MeterTypeID int
DECLARE @A_CurrentContractID int
DECLARE @A_CurrentRenewalContractID int
DECLARE @A_Modified datetime
DECLARE @A_ModifiedBy int
DECLARE @A_DateCreated datetime
DECLARE @A_CreatedBy int
DECLARE @A_MigrationComplete bit

SET @A_AccountIdLegacy = @p_account_id;
SET @A_AccountNumber = LTRIM(RTRIM(@p_account_number));
IF @p_account_type = ''RESIDENTIAL''
SET @p_account_type = ''RES'';

-- Added to prevent duplicate account_id in the table. 2012-02-25
IF EXISTS (SELECT AccountID FROM LibertyPower..Account WHERE AccountIDLegacy = @A_AccountIdLegacy)
	RAISERROR(''AccountIdLegacy already exists, cannot continue'',11,1)

-- attempt to get service class and zone based on price record
SELECT @p_service_rate_class = ISNULL(s.service_rate_class, ''''), @p_zone = ISNULL(z.zone, '''') 
FROM Libertypower..Price p WITH (NOLOCK)
LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
LEFT JOIN lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
WHERE p.ID = @PriceID

SELECT @A_AccountTypeID = AT.ID FROM LibertyPower.dbo.AccountType AT (NOLOCK) WHERE LOWER(AT.AccountType) = LOWER(LTRIM(RTRIM(@p_account_type)));
--TODO: Check this logic that if account is inserting then this is the current contract
SET @A_CurrentContractID = @C_ContractID; -- This is to make it appear on the account view

-- SET @A_CurrentRenewalContractID = @C_ContractID; -- This is to make it appear on the account_renewal view
SET @A_CustomerID = @CUST_CustomerID;
SET @A_CustomerIdLegacy = @p_customer_id;
SET @A_EntityID = @p_entity_id;
SELECT @A_RetailMktID = M.ID FROM Libertypower.dbo.Market M (NOLOCK) WHERE LTRIM(RTRIM(LOWER(M.MarketCode))) = LTRIM(RTRIM(LOWER(@p_retail_mkt_id))) AND M.InactiveInd = ''0'';
SELECT @A_UtilityID = U.ID FROM LibertyPower.dbo.Utility U (NOLOCK) WHERE LOWER(U.UtilityCode) = LOWER(LTRIM(RTRIM(@p_utility_id))) AND U.InactiveInd = ''0'';

-- NEW MD084 the link is the actual ID now
SET @A_AccountNameID	= @p_account_name_link;
SET @A_BillingAddressID = @p_billing_address_link;
SET @A_BillingContactID = @p_billing_contact_link;
SET @A_ServiceAddressID = @p_service_address_link;
--SELECT @A_AccountNameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (NOLOCK)WHERE AN.account_id = @p_account_id AND AN.name_link = @p_account_name_link;
--SELECT @A_BillingAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @p_account_id AND AA.address_link = @p_billing_address_link;
--SELECT @A_BillingContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (NOLOCK) WHERE AC.account_id = @p_account_id AND AC.contact_link = @p_billing_contact_link;
--SELECT @A_ServiceAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @p_account_id AND AA.address_link = @p_service_address_link;

SET @A_Origin = @p_origin;
SELECT @A_TaxStatusID = T.TaxStatusID FROM LibertyPower.dbo.TaxStatus T (NOLOCK) WHERE LOWER(T.[Status]) = LOWER(LTRIM(RTRIM(@p_tax_status)));
SET @A_PorOption = CASE LOWER(@p_por_option) WHEN ''yes'' THEN 1 ELSE 0 END;
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
SET @A_Modified = GETDATE();
SET @A_DateCreated = GETDATE();
SET @A_ModifiedBy = LibertyPower.dbo.ufn_GetUserId(@p_username,0);
SET @A_MigrationComplete = 1;

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

IF @A_AccountID IS NULL OR @A_AccountID = 0 OR @A_AccountID = -1
		RAISERROR(''@A_AccountID IS NULL, cannot continue'',11,1)


-- ====================================================================================================================================================
-- Account Detail Table
-- ====================================================================================================================================================
DECLARE @AD_RC int
DECLARE @AD_AccountID int
DECLARE @AD_EnrollmentTypeID INT;
DECLARE @AD_OriginalTaxDesignation INT;
DECLARE @AD_ModifiedBy int
DECLARE @AD_CreatedBy int

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
DECLARE @AU_AccountID int
DECLARE @AU_AnnualUsage int
DECLARE @AU_UsageReqStatusID int
DECLARE @AU_EffectiveDate DATETIME;
DECLARE @AU_ModifiedBy int
DECLARE @AU_CreatedBy int

SET @AU_EffectiveDate = @C_StartDate;
SET @AU_AccountID = @A_AccountID;
SET @AU_AnnualUsage = @p_annual_usage;
SELECT @AU_UsageReqStatusID =  URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS WHERE LOWER(URS.[Status]) = ''pending'';
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

DECLARE @AC_RC INT;
DECLARE @AC_AccountContractID INT;
DECLARE @AC_AccountID INT;
DECLARE @AC_ContractID INT;
DECLARE @AC_RequestedStartDate DATETIME;
DECLARE @AC_SendEnrollmentDate DATETIME;
DECLARE @AC_ModifiedBy INT;

SET @AC_AccountID = @A_AccountID;
SET @AC_ContractID = @C_ContractID;
SET @AC_RequestedStartDate = @p_requested_flow_start_date;
SET @AC_SendEnrollmentDate = @w_date_por_enrollment;
SET @AC_ModifiedBy = @C_ModifiedBy;

EXECUTE @AC_RC = [Libertypower].[dbo].[usp_AccountContractInsert] 
   @AC_AccountID
  ,@AC_ContractID
  ,@AC_RequestedStartDate
  ,@AC_SendEnrollmentDate
  ,@AC_ModifiedBy

IF @AC_RC IS NULL OR @AC_RC = 0 OR @AC_RC = -1
	RAISERROR(''@AC_RC IS NULL, cannot continue'',11,1)

SET @AC_AccountContractID = @AC_RC;

-- ====================================================================================================================================================
-- Account Status Table
-- ====================================================================================================================================================
DECLARE @AS_RC int
DECLARE @AS_AccountContractID int
DECLARE @AS_Status varchar(15)
DECLARE @AS_SubStatus varchar(15)
DECLARE @AS_ModifiedBy INT;
DECLARE @AS_CreatedBy INT;

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
DECLARE @ACR_RC INT;
DECLARE @ACR_AccountContractID INT;
DECLARE @ACR_LegacyProductID CHAR(20);
DECLARE @ACR_Term INT;
DECLARE @ACR_RateID INT;
DECLARE @ACR_Rate FLOAT;
DECLARE @ACR_RateCode VARCHAR(50)
DECLARE @ACR_RateStart DATETIME;
DECLARE @ACR_RateEnd DATETIME;
DECLARE @ACR_IsContractedRate BIT;
DECLARE @ACR_HeatIndexSourceID INT;
DECLARE @ACR_HeatRate DECIMAL(9,2);
DECLARE @ACR_TransferRate FLOAT;
DECLARE @ACR_GrossMargin FLOAT;
DECLARE @ACR_CommissionRate FLOAT;
DECLARE @ACR_AdditionalGrossMargin FLOAT;
DECLARE @ACR_ModifiedBy INT;
DECLARE @ACR_CreatedBy INT;

SET @ACR_AccountContractID = @AC_AccountContractID;
SET @ACR_LegacyProductID = @p_product_id;
SET @ACR_Term = @p_term_months;
SET @ACR_RateID = @p_rate_id;
SET @ACR_Rate = @p_rate;
SET @ACR_RateCode = '''';
SET @ACR_RateStart = @p_contract_eff_start_date;
SET @ACR_RateEnd = @p_date_end;
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
DECLARE @ACC_AccountContractID int
DECLARE @ACC_EvergreenOptionID int
DECLARE @ACC_EvergreenCommissionEnd datetime
DECLARE @ACC_EvergreenCommissionRate float
DECLARE @ACC_ResidualOptionID int
DECLARE @ACC_ResidualCommissionEnd datetime
DECLARE @ACC_InitialPymtOptionID int
DECLARE @ACC_ModifiedBy INT;
DECLARE @ACC_CreatedBy INT;

SET @ACC_AccountContractID = @AC_AccountContractID;
SET @ACC_EvergreenOptionID = @p_evergreen_option_id;
SET @ACC_EvergreenCommissionEnd = @p_evergreen_commission_end;
SET @ACC_EvergreenCommissionRate = @p_evergreen_commission_rate;
SET @ACC_ResidualOptionID = @p_residual_option_id;
SET @ACC_ResidualCommissionEnd = @p_residual_commission_end;
SET @ACC_InitialPymtOptionID = @p_initial_pymt_option_id;
SET @ACC_ModifiedBy = @C_ModifiedBy;
SET @ACC_CreatedBy  = @C_ModifiedBy;

EXECUTE @ACC_RC = [Libertypower].[dbo].[usp_AccountContractCommissionInsert] 
   @ACC_AccountContractID
  ,@ACC_EvergreenOptionID
  ,@ACC_EvergreenCommissionEnd
  ,@ACC_EvergreenCommissionRate
  ,@ACC_ResidualOptionID
  ,@ACC_ResidualCommissionEnd
  ,@ACC_InitialPymtOptionID
  ,@ACC_ModifiedBy
  ,@ACC_CreatedBy
 ;

--IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END


---- COMMITTING TRANSACTION
--IF @@TRANCOUNT>0
--	COMMIT TRANSACTION _INSERT_ACCOUNT_



--INSERT INTO
--    lp_account..account
--     (
--		[account_id],
--		[account_number],
--		[account_type],
--		[status] ,
--		[sub_status],
--		[customer_id],
--		[entity_id] ,
--		[contract_nbr],
--		[contract_type],
--		[retail_mkt_id] ,
--		[utility_id] ,
--		[product_id] ,
--		[rate_id] ,
--		[rate] ,
--		[account_name_link] ,
--		[customer_name_link] ,
--		[customer_address_link],
--		[customer_contact_link] ,
--		[billing_address_link] ,
--		[billing_contact_link] ,
--		[owner_name_link] ,
--		[service_address_link],
--		[business_type] ,
--		[business_activity],
--		[additional_id_nbr_type] ,
--		[additional_id_nbr],
--		[contract_eff_start_date] ,
--		[term_months],
--		[date_end],
--		[date_deal],
--		[date_created],
--		[date_submit] ,
--		[sales_channel_role] ,
--		[username],
--		[sales_rep],
--		[origin] ,
--		[annual_usage],
--		[date_flow_start],
--		[date_por_enrollment],
--		[date_deenrollment],
--		[date_reenrollment] ,
--		[tax_status],
--		[tax_rate] ,
--		[credit_score] ,
--		[credit_agency],
--		[por_option],
--		[billing_type] ,
--		[chgstamp] ,
--		[usage_req_status],
--		[Created],
--		[CreatedBy],
--		[Modified],
--		[ModifiedBy],
--		[rate_code] ,
--		[zone],
--		[service_rate_class] ,
--		[stratum_variable],
--		[billing_group],
--		[icap] ,
--		[tcap],
--		[load_profile],
--		[loss_code] ,
--		[meter_type] ,
--		[requested_flow_start_date],
--		[deal_type],
--		[enrollment_type],
--		[customer_code],
--		[customer_group],
--		[SSNEncrypted],
--		HeatIndexSourceID,
--		HeatRate,
--		evergreen_option_id,
--		evergreen_commission_end, 
--		residual_option_id, 
--		residual_commission_end, 
--		initial_pymt_option_id, 
--		sales_manager, 
--		evergreen_commission_rate,
--		original_tax_designation
--    )

--    SELECT
--        @p_account_id ,
--       @p_account_number,
--       @p_account_type,
--       @p_status,
--       @p_sub_status,
--       @p_customer_id,
--       @p_entity_id,
--       @p_contract_nbr,
--       @p_contract_type,
--       @p_retail_mkt_id,
--       @p_utility_id,
--       @p_product_id,
--       @p_rate_id,
--       @p_rate,
--       @p_account_name_link,
--       @p_customer_name_link,
--       @p_customer_address_link,
--       @p_customer_contact_link,
--       @p_billing_address_link,
--       @p_billing_contact_link,
--       @p_owner_name_link,
--       @p_service_address_link,
--       @p_business_type,
--       @p_business_activity,
--       upper(@p_additional_id_nbr_type), --Upper Added for ticket 17620
--       @p_additional_id_nbr,
--       @p_contract_eff_start_date,
--       @p_term_months,
--       @p_date_end,
--       @p_date_deal,
--       @p_date_created,
--       @p_date_submit,
--       ltrim(rtrim(@p_sales_channel_role)),
--       @p_username,
--       @p_sales_rep,
--       @p_origin,
--       @p_annual_usage,
--       @p_date_flow_start,
--        @w_date_por_enrollment,
--       @p_date_deenrollment,
--       @p_date_reenrollment,
--       @p_tax_status,
--       @p_tax_float,
--       @p_credit_score,
--       @p_credit_agency,
--       @p_por_option,
--       @p_billing_type,
--       @w_chgstamp,
--	   @w_usage_req_status,	
--	   getdate(),	
-- 	   @p_username,	
--        ''19000101'' ,
--	   '' '',	
--	   '' '',
--       @p_zone,
--       @p_service_rate_class,
--       @p_stratum_variable,
--       @p_billing_group,
--       @p_icap,
--       @p_tcap,
--       @p_load_profile,
--       @p_loss_code,
--       @p_meter_type,
--       @p_requested_flow_start_date,
--       @w_deal_type,
--       @p_enrollment_type,
--       @p_customer_code,
--       @p_customer_group,
--       @p_SSNEncrypted,
--	   @p_HeatIndexSourceID,
--	   @p_HeatRate, 
--	   @p_evergreen_option_id,
--	   @p_evergreen_commission_end,
--	   @p_residual_option_id,
--	   @p_residual_commission_end,
--	   @p_initial_pymt_option_id,
--       @p_sales_manager,
--       @p_evergreen_commission_rate,
--       @p_original_tax_designation
       

       
IF @@error <> 0 OR @@rowcount = 0
begin
         SELECT
             @w_error = ''E''
         SELECT
             @w_msg_id = ''00000002''
         SELECT
             @w_return = 1
end

       
--mark the custom rate as used (rate_submit_ind = 1)
UPDATE lp_deal_capture..deal_pricing_detail 
SET rate_submit_ind = 1, date_modified = getdate(), modified_by = @p_username
WHERE product_id = @p_product_id and rate_id = @p_rate_id

--If its custom, update the effective date so it matches the contract''s deal date.  6/22/2011
IF EXISTS (select * from lp_common..common_product where product_id = @p_product_id and IsCustom = 1)
BEGIN
	UPDATE lp_common..common_product_rate
	SET eff_date = @p_date_deal
	WHERE product_id = @p_product_id and rate_id = @p_rate_id
END

INSERT INTO AccountPaymentTerm
VALUES
(@p_account_id,@p_paymentTerm,getdate())
       
 
if @w_error                                        <> ''N''
begin
         EXEC lp_common..usp_messages_sel @w_msg_id , @w_descp OUTPUT
end
 
if @p_result_ind                                    = ''Y''
begin
         SELECT
             flag_error = @w_error ,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end
 
SELECT
    @p_error = @w_error ,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:
return @w_return
' 
END
GO
