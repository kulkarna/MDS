USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_renewal_ins]    Script Date: 12/14/2012 11:27:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/16/2007
-- Description:	Insert account renewal information
-- =============================================
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 02/18/2010
-- Description	: Add SSNClear, SSNEncrypted and CreditScoreEncrypted columns to insert.
-- Ticket		: IT002
-- =============================================
-- =============================================
-- Modify		: Jaime Forero
-- Date			: 09/24/2011
-- Description	: Completely refactored to account for new schema changes. Project IT079
-- =============================================
-- Modify		: Jose Munoz
-- Date			: 03/01/2012
-- Ticket		: 1-9784943 (Add On Accounts for Renewal Contracts)
-- Description	: For new accounts in a renewal process, the value of the CurrentContractID must be NULL.
-- =============================================
-- Modified Gabor Kovacs 05/9/2012
-- Added a null to the insertion of account_contact, account_address, and account_name.
-- The null is required since those are no longer tables, but views which have an extra field.
-- =============================================
-- Modify : Thiago Nogueira
-- Date : 06/26/2012
-- Ticket : 1-18236238 (Add-on of Accounts to Renewal Contracts Failing)
-- Description : Per Al: System was designed to work that way.
-- =============================================
-- Modify : Rick Deigsler
-- Date : 10/18/2012
-- Description : MD084 - Ad multi-term rate inserts
-- =============================================
-- Modify : Sheri Scott
-- Date : 10/31/2012
-- Ticket : 1-26273501 (Renewal contract usage is not updating)
-- Description : Annual Usage should be set to NULL until it is received from the utility.
--               Modified to set Annual Usage to NULL.
-- =============================================
-- Modify : Agata Studzinska  
-- Date : 11/8/2012  
-- Ticket : 1-27221396 
-- Description : Send Enrollment Date for Add-on Accounts were being set incorrectly. 
-- =============================================

ALTER PROCEDURE [dbo].[usp_account_renewal_ins]
(@p_username                                        nchar(100),
 @p_account_id                                      char(12),
 @p_account_number                                  varchar(30),
 @p_account_type                                    varchar(25),
 @p_status                                          varchar(15),
 @p_sub_status                                      varchar(15),
 @p_customer_id                                     char(10),
 @p_entity_id                                       char(15),
 @p_contract_nbr                                    char(12),
 @p_contract_type                                   varchar(25),
 @p_retail_mkt_id                                   char(02),
 @p_utility_id                                      char(15),
 @p_product_id                                      char(20),
 @p_rate_id                                         int,
 @p_rate                                            float,
 @p_account_name_link                               int,
 @p_customer_name_link                              int,
 @p_customer_address_link                           int,
 @p_customer_contact_link                           int,
 @p_billing_address_link                            int,
 @p_billing_contact_link                            int,
 @p_owner_name_link                                 int,
 @p_service_address_link                            int,
 @p_business_type                                   varchar(35),
 @p_business_activity                               varchar(35),
 @p_additional_id_nbr_type                          varchar(10),
 @p_additional_id_nbr                               varchar(30),
 @p_contract_eff_start_date                         datetime,
 @p_term_months                                     int,
 @p_date_end                                        datetime,
 @p_date_deal                                       datetime,
 @p_date_created                                    datetime,
 @p_date_submit                                     datetime,
 @p_sales_channel_role                              nvarchar(50),
 @p_sales_rep                                       varchar(100),
 @p_origin                                          varchar(50),
 @p_annual_usage                                    int,
 @p_date_flow_start                                 datetime = '19000101',
 @p_date_por_enrollment                             datetime = '19000101',
 @p_date_deenrollment                               datetime = '19000101',
 @p_date_reenrollment                               datetime = '19000101',
 @p_tax_status                                      varchar(20) = 'FULL',
 @p_tax_float                                       int = 0,
 @p_credit_score                                    real = 0,
 @p_credit_agency                                   varchar(30) = 'NONE',
 @p_por_option                                      varchar(03) = ' ',
 @p_billing_type                                    varchar(15) = ' ',
 @p_error                                           char(01) = ' ' output,
 @p_msg_id                                          char(08) = ' ' output,
 @p_descp                                           varchar(250) = ' ' output,
 @p_result_ind                                      char(01) = 'Y'
 ,@p_SSNClear										nvarchar	(100) = ''	-- IT002
 ,@p_SSNEncrypted									nvarchar	(512) = ''	-- IT002
 ,@p_CreditScoreEncrypted							nvarchar	(512) = ''	-- IT002
 ,@p_evergreen_option_id							int = null					-- IT021
 ,@p_evergreen_commission_end						datetime = null				-- IT021
 ,@p_residual_option_id								int = null					-- IT021
 ,@p_residual_commission_end						datetime = null				-- IT021
 ,@p_initial_pymt_option_id							int = null					-- IT021
 ,@p_sales_manager									varchar(100) = null			-- IT021
 ,@p_evergreen_commission_rate						float = null				-- IT021
 ,@PriceID int = 0 -- IT106
 )
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
 
 
-- ====================================================================================================================================================

--					NEW				SCHEMA			CHANGES

-- ==================================================================================================================================================== 
-- ====================================================================================================================================================
-- HERE WE NEED TO CREATE THE acount_address and related inserts for the renewal to work ok, any renewal data will update the exiting values:
-- ====================================================================================================================================================
-- @p_account_name_link                               int,
-- @p_customer_name_link                              int,
-- @p_customer_address_link                           int,
-- @p_customer_contact_link                           int,
-- @p_billing_address_link                            int,
-- @p_billing_contact_link                            int,
-- @p_owner_name_link                                 int,
-- @p_service_address_link                            int,

-- ACCOUNT NAME:

IF NOT EXISTS ( SELECT	account_id
				FROM	lp_account..account_name WITH ( NOLOCK )
				WHERE	account_id	= @p_account_id 
				AND		name_link	= @p_account_name_link )
BEGIN
	INSERT INTO lp_account..account_name
	SELECT	null,account_id, name_link, full_name, 0
	FROM	lp_contract_renewal..deal_account_name with (nolock)
	WHERE	account_id	= @p_account_id 
	AND		name_link	= @p_account_name_link
	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
	END
END

-- CUSTOMER NAME:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_name WITH ( NOLOCK )
                WHERE	account_id	= @p_account_id 
                AND		name_link	= @p_customer_name_link )
BEGIN
	INSERT INTO lp_account..account_name
	SELECT	null,account_id, name_link, full_name, 0
	FROM	lp_contract_renewal..deal_account_name WITH (NOLOCK)
	WHERE	account_id	= @p_account_id 
	AND		name_link	= @p_customer_name_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
	END
END

-- OWNER NAME:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_name WITH ( NOLOCK )
                WHERE	account_id	= @p_account_id 
                AND		name_link	= @p_owner_name_link )
BEGIN
	INSERT INTO lp_account..account_name
	SELECT	null,account_id, name_link, full_name, 0
	FROM	lp_contract_renewal..deal_account_name WITH (NOLOCK)
	WHERE	account_id	= @p_account_id 
	AND		name_link	= @p_owner_name_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
	END
END

-- CUSTOMER ADDRESS

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_address WITH (NOLOCK)
                WHERE	account_id	 = @p_account_id 
                AND		address_link = @p_customer_address_link )
BEGIN
	INSERT INTO lp_account..account_address
	SELECT	null,account_id, address_link, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM	lp_contract_renewal..deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @p_account_id 
	AND		address_link	= @p_customer_address_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_customer_address_link to the account_address table, cannot continue',11,1)
	END
END

-- BILLING ADDRESS:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_address WITH (NOLOCK)
                WHERE	account_id	 = @p_account_id 
                AND		address_link = @p_billing_address_link )
BEGIN
	INSERT INTO lp_account..account_address
	SELECT	null,account_id, address_link, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM	lp_contract_renewal..deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @p_account_id 
	AND		address_link	= @p_billing_address_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_billing_address_link to the account_address table, cannot continue',11,1)
	END
END

-- SERVICE ADDRESS:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_address WITH (NOLOCK)
                WHERE	account_id	 = @p_account_id 
                AND		address_link = @p_service_address_link )
BEGIN
	INSERT INTO lp_account..account_address
	SELECT	null,account_id, address_link, [address], suite, city, [state], zip, county, state_fips, county_fips, 0
	FROM	lp_contract_renewal..deal_account_address WITH ( NOLOCK )
	WHERE	account_id		= @p_account_id 
	AND		address_link	= @p_service_address_link 

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_service_address_link to the account_address table, cannot continue',11,1)
	END
END

-- CUSTOMER CONTACT:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_contact WITH (NOLOCK)
                WHERE	account_id		= @p_account_id 
                AND		contact_link	= @p_customer_contact_link )
BEGIN
	INSERT INTO lp_account..account_contact
	SELECT	null,account_id, contact_link, first_name, last_name, title, phone, fax, email, isnull(birthday , '01/01'), 0
	FROM	lp_contract_renewal..deal_account_contact WITH (NOLOCK)
	WHERE account_id	= @p_account_id  
	AND contact_link	= @p_customer_contact_link

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_customer_contact_link to the account_contact table, cannot continue',11,1)
	END
END

-- BILLING CONTACT:

IF NOT EXISTS ( SELECT	account_id
                FROM	lp_account..account_contact WITH (NOLOCK)
                WHERE	account_id		= @p_account_id 
                AND		contact_link	= @p_billing_contact_link )
BEGIN
	INSERT INTO lp_account..account_contact
	SELECT	null,account_id, contact_link, first_name, last_name, title, phone, fax, email, isnull(birthday , '01/01'), 0
	FROM	lp_contract_renewal..deal_account_contact WITH (NOLOCK)
	WHERE account_id	= @p_account_id  
	AND contact_link	= @p_billing_contact_link 

	IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error while trying to add record @p_billing_contact_link to the account_contact table, cannot continue',11,1)
	END
END

 
-- ====================================================================================================================================================
-- Contract Table
-- ====================================================================================================================================================
DECLARE @C_WasNewContractCreated BIT;
DECLARE @C_RC int;
DECLARE @C_ContractID int;
DECLARE @C_Number varchar(50);
DECLARE @C_ContractTypeID int;
DECLARE @C_ContractDealTypeID int;
DECLARE @C_ContractStatusID int;
DECLARE @C_ContractTemplateID int;
DECLARE @C_ReceiptDate datetime;
DECLARE @C_StartDate datetime;
DECLARE @C_EndDate datetime;
DECLARE @C_SignedDate datetime;
DECLARE @C_SubmitDate datetime;
DECLARE @C_SubmittedBy int;
DECLARE @C_SalesChannelID int;
DECLARE @C_SalesRep varchar(64);
DECLARE @C_SalesManagerID int;
DECLARE @C_PricingTypeID int;
DECLARE @C_ModifiedBy int;
DECLARE @C_CreatedBy int;

SET @C_Number = LTRIM(RTRIM(@p_contract_nbr));
SET @C_ContractTypeID = Libertypower.dbo.ufn_GetContractTypeId(@p_contract_type);
SET @C_ContractDealTypeID = Libertypower.dbo.ufn_GetContractDealTypeId(@p_contract_type);
SELECT @C_ContractStatusID = CS.ContractStatusID FROM LibertyPower.dbo.ContractStatus CS (NOLOCK) WHERE LOWER(CS.Descp) = 'pending';
SET @C_ContractTemplateID = Libertypower.dbo.ufn_GetContractTemplateTypeId(@p_contract_type);
SET @C_ReceiptDate = NULL;
SET @C_StartDate = MIN(lp_enrollment.dbo.ufn_date_format( @p_contract_eff_start_date ,'<YYYY>-<MM>-01'));
SET @C_EndDate  = MIN(DATEADD(mm, @p_term_months, lp_enrollment.dbo.ufn_date_format(@p_contract_eff_start_date,'<YYYY>-<MM>-01')) - 1) ;
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
	  ,1;
	  
	SELECT @C_ContractID = C.ContractID FROM Libertypower.dbo.[Contract] C (NOLOCK) WHERE C.Number = @C_Number ;
	SET @C_WasNewContractCreated = 1;
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
	  ,@C_CreatedBy 
	  ,1 -- Is silent
	  ,1 -- migration complete
	;
	  
	SET @C_WasNewContractCreated = 0;
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
SET @A_CurrentRenewalContractID = @C_ContractID; -- We are inserting a new renewal so we need to set the new renewal record

-- Get existing data so we dont overwrite values
SELECT @A_AccountID = [AccountID]
      ,@A_AccountTypeID = [AccountTypeID]
      ,@A_CustomerID = [CustomerID]
      ,@A_CustomerIdLegacy = [CustomerIdLegacy]
      ,@A_EntityID = [EntityID]
      ,@A_RetailMktID = [RetailMktID]
      ,@A_UtilityID = [UtilityID]
      ,@A_AccountNameID = [AccountNameID]
      ,@A_BillingAddressID = [BillingAddressID]
      ,@A_BillingContactID = [BillingContactID]
      ,@A_ServiceAddressID = [ServiceAddressID]
      ,@A_Origin = [Origin]
      ,@A_TaxStatusID = [TaxStatusID]
      ,@A_PorOption = [PorOption]
      ,@A_BillingTypeID = [BillingTypeID]
      ,@A_Zone = [Zone]
      ,@A_ServiceRateClass = [ServiceRateClass]
      ,@A_StratumVariable = [StratumVariable]
      ,@A_BillingGroup = [BillingGroup]
      ,@A_Icap = [Icap]
      ,@A_Tcap = [Tcap]
      ,@A_LoadProfile = [LoadProfile]
      ,@A_LossCode = [LossCode]
      ,@A_MeterTypeID = [MeterTypeID]
      ,@A_ModifiedBy = [ModifiedBy]
      ,@A_CurrentContractID = [CurrentContractID]
      ,@A_CreatedBy = [CreatedBy]
  FROM [Libertypower].[dbo].[Account] (NOLOCK)
WHERE  [AccountIdLegacy] = @A_AccountIdLegacy 

IF @A_AccountID IS NULL OR @A_AccountID = 0 OR @A_AccountID = -1
		RAISERROR('@A_AccountID IS NULL, cannot continue',11,1)

-- Keep the same whats on the account table and update only the address:

-- NEW MD084 the link is the actual ID now
SET @A_AccountNameID	= @p_account_name_link;
SET @A_BillingAddressID = @p_billing_address_link;
SET @A_BillingContactID = @p_billing_contact_link;
SET @A_ServiceAddressID = @p_service_address_link;
--SELECT @A_AccountNameID = AN.AccountNameID		 FROM lp_account.dbo.account_name AN (NOLOCK)WHERE AN.account_id = @p_account_id AND AN.name_link = @p_account_name_link;
--SELECT @A_BillingAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @p_account_id AND AA.address_link = @p_billing_address_link;
--SELECT @A_BillingContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (NOLOCK) WHERE AC.account_id = @p_account_id AND AC.contact_link = @p_billing_contact_link;
--SELECT @A_ServiceAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @p_account_id AND AA.address_link = @p_service_address_link;

SELECT @A_AccountTypeID = AT.ID FROM LibertyPower.dbo.AccountType AT (NOLOCK) WHERE LOWER(AT.AccountType) = LOWER(LTRIM(RTRIM(@p_account_type)));

SET @A_MigrationComplete = 1;

/* TICKET 1-18236238 BEGIN */
/* TICKET 1-9784943 BEGIN */
--IF @A_CurrentContractID = @A_CurrentRenewalContractID
--BEGIN
-- SET @A_CurrentContractID = NULL
--END
/* TICKET 1-9784943 END*/
/* TICKET 1-18236238 END */


EXECUTE @A_RC = [Libertypower].[dbo].[usp_AccountUpdate]
   @A_AccountId
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
  ,@A_ModifiedBy
  ,NULL
  ,NULL
  ,NULL
  ,@A_MigrationComplete
  ,1;
  
SET @A_AccountID = @A_RC;


-- ====================================================================================================================================================
-- Account Detail Table
-- ====================================================================================================================================================
/* 
NO UPDATES NEEDED IN THIS TABLE WHEN RENEWAL


DECLARE @AD_RC int
DECLARE @AD_AccountID int
DECLARE @AD_EnrollmentTypeID INT;
DECLARE @AD_OriginalTaxDesignation INT;
DECLARE @AD_ModifiedBy int

SET @AD_AccountID = @A_AccountID;
SET @AD_OriginalTaxDesignation = NULL; --@p_original_tax_designation;
SET @AD_ModifiedBy = @A_ModifiedBy;
--SELECT @AD_EnrollmentTypeID = ET.EnrollmentTypeID FROM LibertyPower.dbo.EnrollmentType ET (NOLOCK) WHERE LOWER(ET.[Type]) =  LOWER(LTRIM(RTRIM(@p_enrollment_type)));


EXECUTE @AD_RC = [Libertypower].[dbo].[usp_AccountDetailInsert] 
   @AD_AccountID
  ,@AD_EnrollmentTypeID
  ,@AD_OriginalTaxDesignation
  ,@AD_ModifiedBy

*/

-- ====================================================================================================================================================
-- Account Usage Table
-- ====================================================================================================================================================
DECLARE @AU_RC int
DECLARE @AU_AccountUsageID int
DECLARE @AU_AccountID int
DECLARE @AU_AnnualUsage int
DECLARE @AU_UsageReqStatusID int
DECLARE @AU_EffectiveDate DATETIME;
DECLARE @AU_ModifiedBy int
DECLARE @AU_CreatedBy int

SET @AU_EffectiveDate = @C_StartDate;
SET @AU_AccountID = @A_AccountID;
SET @AU_AnnualUsage = @p_annual_usage;

SELECT @AU_UsageReqStatusID =  URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS (NOLOCK) WHERE LOWER(URS.[Status]) = 'pending';
SET @AU_ModifiedBy = @C_ModifiedBy;

SELECT @AU_AccountUsageID = AU.AccountUsageID FROM LibertyPower.dbo.AccountUsage AU (NOLOCK)
WHERE AU.AccountID = @AU_AccountID AND AU.EffectiveDate = @AU_EffectiveDate;

IF @AU_AccountUsageID IS NULL
BEGIN 

	EXECUTE @AU_RC = [Libertypower].[dbo].[usp_AccountUsageInsert] 
	   @AU_AccountID
	  ,@AU_AnnualUsage
	  ,@AU_UsageReqStatusID
	  ,@AU_EffectiveDate
	  ,@AU_ModifiedBy 
	  ,@AU_CreatedBy
	  ,1;

	IF @AU_RC IS NULL OR @AU_RC = 0 OR @AU_RC = -1
		RAISERROR('@AU_RC IS NULL, cannot continue',11,1)
	SET @AU_AccountUsageID = @AU_RC ; 
END
ELSE
BEGIN

	EXECUTE @AU_RC = [Libertypower].[dbo].[usp_AccountUsageUpdate] 
	   @AU_AccountUsageID
	  ,@AU_AccountID
	  ,@AU_AnnualUsage
	  ,@AU_UsageReqStatusID
	  ,@AU_EffectiveDate
	  ,@AU_ModifiedBy
	  ,1


END


-- ====================================================================================================================================================
-- Customer Table
-- ====================================================================================================================================================
DECLARE @CUST_RC int
DECLARE @CUST_CustomerID int
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

-- The customer MUST HAVE BEEN created already!
SET @CUST_CustomerID  = @A_CustomerID; 

IF @CUST_CustomerID IS NULL OR @CUST_CustomerID = 0 OR @CUST_CustomerID = -1
	RAISERROR('@CUST_CustomerID IS NULL, cannot continue',11,1)

-- GET THE CURRENT VALUES
SELECT 
       @CUST_NameID = [NameID]
      ,@CUST_OwnerNameID = [OwnerNameID]
      ,@CUST_AddressID = [AddressID]
      ,@CUST_ContactID = [ContactID]
      ,@CUST_DBA = [DBA]
      ,@CUST_Duns = [Duns]
      ,@CUST_SsnClear = [SsnClear]
      ,@CUST_SsnEncrypted = [SsnEncrypted]
      ,@CUST_TaxId = [TaxId]
      ,@CUST_EmployerId = [EmployerId]
      ,@CUST_CreditAgencyID = [CreditAgencyID]
      ,@CUST_CreditScoreEncrypted = [CreditScoreEncrypted]
      ,@CUST_BusinessTypeID = [BusinessTypeID]
      ,@CUST_BusinessActivityID = [BusinessActivityID]
      ,@CUST_ModifiedBy = [ModifiedBy]
      ,@CUST_CreatedBy = [CreatedBy]
FROM [Libertypower].[dbo].[Customer] (NOLOCK)
WHERE [CustomerID] = @CUST_CustomerID;

-- SET VALUES:
SELECT @CUST_NameID = AN.AccountNameID		 FROM lp_account.dbo.account_name AN (nolock)	 WHERE AN.account_id = @p_account_id AND AN.name_link    = @p_customer_name_link;
SELECT @CUST_OwnerNameID = AN.AccountNameID	 FROM lp_account.dbo.account_name AN (nolock)	 WHERE AN.account_id = @p_account_id AND AN.name_link    = @p_owner_name_link;
SELECT @CUST_AddressID = A.AccountAddressID	 FROM lp_account.dbo.account_address A (nolock)  WHERE A.account_id  = @p_account_id AND A.address_link  = @p_customer_address_link;
SELECT @CUST_ContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (nolock) WHERE AC.account_id = @p_account_id AND AC.contact_link = @p_customer_contact_link;


IF @CUST_NameID IS NULL OR @CUST_NameID = 0 OR @CUST_NameID = -1
	RAISERROR('@@CUST_NameID IS NULL, cannot continue',11,1)

IF @CUST_OwnerNameID IS NULL OR @CUST_OwnerNameID = 0 OR @CUST_OwnerNameID = -1
	RAISERROR('@@CUST_OwnerNameID IS NULL, cannot continue',11,1)

IF @CUST_AddressID IS NULL OR @CUST_AddressID = 0 OR @CUST_AddressID = -1
	RAISERROR('@@CUST_AddressID IS NULL, cannot continue',11,1)

IF @CUST_ContactID IS NULL OR @CUST_ContactID = 0 OR @CUST_ContactID = -1
	RAISERROR('@@CUST_ContactID IS NULL, cannot continue',11,1)

-- SELECT @CUST_CreditAgencyID = CA.CreditAgencyID FROM LibertyPower.dbo.CreditAgency CA (nolock)  WHERE LOWER(CA.Name) = LOWER(LTRIM(RTRIM(@p_credit_agency)));
IF @p_business_type IS NOT NULL
	SELECT @CUST_BusinessTypeID = BT.BusinessTypeID FROM LibertyPower.dbo.BusinessType BT (nolock)  WHERE LOWER(BT.[Type]) = LOWER(LTRIM(RTRIM(@p_business_type)));

IF @p_business_activity IS NOT NULL
	SELECT @CUST_BusinessActivityID = BA.BusinessActivityID FROM LibertyPower.dbo.BusinessActivity BA (nolock)  WHERE LOWER(BA.Activity) = LOWER(LTRIM(RTRIM(@p_business_activity)));

-- Always the customer should already be there
-- This query might return more than one but all should be the same

EXECUTE @CUST_RC = [Libertypower].[dbo].[usp_CustomerUpdate] 
   @CUST_CustomerID
  ,@CUST_NameID
  ,@CUST_OwnerNameID
  ,@CUST_AddressID
  ,NULL -- CUSTOMER PREFERENCE
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
  ,1
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
SET @AC_RequestedStartDate = NULL; -- @p_requested_flow_start_date;
SET @AC_SendEnrollmentDate = @p_date_por_enrollment;
SET @AC_ModifiedBy = @C_ModifiedBy;

-- When we have add on accounts in renewal, the inserted account would take care of the AccountContract record so we need to check if that happened

SELECT @AC_AccountContractID =  AC.AccountContractID 
FROM [Libertypower].[dbo].[AccountContract] AC with (nolock)
WHERE  AC.AccountID = @AC_AccountID AND AC.ContractID = @AC_ContractID;

IF @AC_AccountContractID  IS NULL -- This is most likely will always NOT happen since the insertion usually happens in the account table first
BEGIN

	EXECUTE @AC_RC = [Libertypower].[dbo].[usp_AccountContractInsert] 
	   @AC_AccountID
	  ,@AC_ContractID
	  ,@AC_RequestedStartDate
	  ,@AC_SendEnrollmentDate
	  ,@AC_ModifiedBy
	  ,1
	  
	IF @AC_RC IS NULL OR @AC_RC = 0 OR @AC_RC = -1
		RAISERROR('@AC_RC IS NULL, cannot continue',11,1)

	SET @AC_AccountContractID = @AC_RC;
END
--Ticket 1-27221396
--ELSE
--BEGIN

--	EXECUTE @AC_RC = [Libertypower].[dbo].[usp_AccountContractUpdate] 
--	   @AC_AccountContractID
--	  ,@AC_AccountID
--	  ,@AC_ContractID
--	  ,@AC_RequestedStartDate
--	  ,@AC_SendEnrollmentDate
--	  ,@AC_ModifiedBy
--	  ,1 -- SILENT
	  
--	IF @AC_RC IS NULL OR @AC_RC = 0 OR @AC_RC = -1
--		RAISERROR('@AC_RC IS NULL, cannot continue',11,1)

--END


-- ====================================================================================================================================================
-- Account Status Table
-- ====================================================================================================================================================
DECLARE @AS_RC int
DECLARE @AS_AccountStatusID int
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

-- See if there are records already for this status (most likely)
SELECT @AS_AccountStatusID = ASS.AccountStatusID FROM LibertyPower.dbo.AccountStatus ASS (NOLOCK)
WHERE ASS.AccountContractID = @AS_AccountContractID;

IF @AS_AccountStatusID IS NULL
BEGIN

	EXECUTE @AS_RC = [Libertypower].[dbo].[usp_AccountStatusInsert] 
	   @AS_AccountContractID
	  ,@AS_Status
	  ,@AS_SubStatus
	  ,@AS_CreatedBy
	  ,@AS_ModifiedBy 
	  ,1
	  
	IF @AS_RC IS NULL OR @AS_RC = 0 OR @AS_RC = -1
		RAISERROR('@AS_RC IS NULL, cannot continue',11,1)

	SET @AS_AccountStatusID = @AS_RC;
END
ELSE
BEGIN
	EXECUTE @AS_RC = [Libertypower].[dbo].[usp_AccountStatusUpdate] 
	 @AS_AccountStatusID
	,@AS_AccountContractID
	,@AS_Status
	,@AS_SubStatus
	,@AS_ModifiedBy
	,1


END
-- ====================================================================================================================================================
-- AccountContractRate Table
-- ====================================================================================================================================================
DECLARE @ACR_RC INT;
DECLARE @ACR_AccountContractRateID INT;
DECLARE @ACR_AccountContractID INT;
DECLARE @ACR_LegacyProductID CHAR(20);
DECLARE @ACR_Term INT;
DECLARE @ACR_RateID INT;
DECLARE @ACR_Rate decimal(9,5);
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
SET @ACR_Rate = CAST(@p_rate AS decimal(9,5));
SET @ACR_RateCode = '';
SET @ACR_RateStart = @p_contract_eff_start_date;
SET @ACR_RateEnd = @p_date_end;
SET @ACR_IsContractedRate = 1;
SET @ACR_HeatIndexSourceID = NULL; -- @p_HeatIndexSourceID;
SET @ACR_HeatRate = NULL; -- @p_HeatRate;
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
DECLARE	@MultiTermID	int,
		@MultiTermCount	int,
		@MultiTermRate	decimal(9,5),
		@RateDiff		decimal(9,5)

INSERT INTO	@MultiTermTable
EXEC		Libertypower..usp_MultiTermByPriceIDSelect @PriceID

SELECT @MultiTermCount = COUNT(MultiTermID) FROM @MultiTermTable
-- ====================================================================================================================================================

-- Remove existing rate records
DELETE FROM LibertyPower.dbo.AccountContractRate
WHERE AccountContractID = @ACR_AccountContractID;

IF @MultiTermCount > 0 -- multi-rate
	BEGIN
		DECLARE @MtCounter	int
		SET		@MtCounter	= 0
		SET		@RateDiff	= 1

		WHILE (SELECT COUNT(MultiTermID) FROM @MultiTermTable) > 0
			BEGIN
				SELECT TOP 1 @MultiTermID = MultiTermID FROM @MultiTermTable ORDER BY StartDate
				
				SELECT	@ACR_RateStart		= StartDate,
						@ACR_RateEnd		= DATEADD(dd, -1, DATEADD(mm, Term, StartDate)),
						@MultiTermRate		= Price, 
						@ACR_Term			= Term,
						@ACR_GrossMargin	= MarkupRate
				FROM	@MultiTermTable
				WHERE	MultiTermID			= @MultiTermID
				
				IF @MtCounter = 0 -- first term rate can be adjusted by ABC channels
					BEGIN
						SET	@RateDiff = @ACR_Rate / @MultiTermRate
						SET	@MultiTermRate = @ACR_Rate
					END	
				ELSE
					BEGIN -- adjust additional multi-terms if first rate was changed
						SET	@MultiTermRate = @MultiTermRate * @RateDiff
					END
					
				EXECUTE @ACR_RC = [Libertypower].[dbo].[usp_AccountContractRateInsert] 
				   @ACR_AccountContractID
				  ,@ACR_LegacyProductID
				  ,@ACR_Term 
				  ,@ACR_RateID
				  ,@MultiTermRate
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
				  ,@MultiTermID;

				SET @ACR_AccountContractRateID = @ACR_RC;
				SET @MtCounter = @MtCounter + 1							
				DELETE FROM @MultiTermTable WHERE MultiTermID = @MultiTermID
			END					
	END
ELSE -- single rate
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
		
		IF @ACR_RC IS NULL OR @ACR_RC = 0 OR @ACR_RC = -1
			RAISERROR('@ACR_RC IS NULL, cannot continue',11,1)

		SET @ACR_AccountContractRateID = @ACR_RC;
	END

-- ====================================================================================================================================================
-- AccountContractCommission Table
-- ====================================================================================================================================================


DECLARE @ACC_RC int;
DECLARE @ACC_AccountContractCommissionID INT;
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

-- See if there are records already for this status (most likely)
SELECT @ACC_AccountContractCommissionID = ACC.AccountContractCommissionID FROM LibertyPower.dbo.AccountContractCommission ACC (NOLOCK)
WHERE ACC.AccountContractID = @ACC_AccountContractID;

IF @ACC_AccountContractCommissionID IS NULL
BEGIN

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
	  ,1;
	 
	IF @ACC_RC IS NULL OR @ACC_RC = 0 OR @ACC_RC = -1
		RAISERROR('@ACC_RC IS NULL, cannot continue',11,1)

	SET @ACC_AccountContractCommissionID = @ACC_RC;
END
ELSE
BEGIN

	EXECUTE @ACC_RC = [Libertypower].[dbo].[usp_AccountContractCommissionUpdate] 
	   @ACC_AccountContractCommissionID
	  ,@ACC_AccountContractID
	  ,@ACC_EvergreenOptionID
	  ,@ACC_EvergreenCommissionEnd
	  ,@ACC_EvergreenCommissionRate
	  ,@ACC_ResidualOptionID
	  ,@ACC_ResidualCommissionEnd
	  ,@ACC_InitialPymtOptionID
	  ,@ACC_ModifiedBy
	  ,1


END	 
	 
 
 
-- ====================================================================================================================================================
-- END OF NEW SCHEMA CHANGES
-- ====================================================================================================================================================

 
 
 
--insert into account_renewal
--([account_id] ,[account_number],[account_type] ,[status] ,[sub_status] ,[customer_id] ,[entity_id] 
--,[contract_nbr],[contract_type] ,[retail_mkt_id] ,[utility_id] ,[product_id] ,[rate_id] ,[rate] 
--,[account_name_link],[customer_name_link] ,[customer_address_link],[customer_contact_link],[billing_address_link] 
--,[billing_contact_link] ,[owner_name_link] ,[service_address_link] ,[business_type] ,[business_activity] ,[additional_id_nbr_type] 
--,[additional_id_nbr] ,[contract_eff_start_date] ,[term_months] ,[date_end] ,[date_deal],[date_created] ,[date_submit] ,[sales_channel_role] 
--,[username] ,[sales_rep] ,[origin] ,[annual_usage] ,[date_flow_start] ,[date_por_enrollment],[date_deenrollment],[date_reenrollment] 
--,[tax_status] ,[tax_rate] ,[credit_score] ,[credit_agency] ,[por_option] ,[billing_type],[chgstamp] ,[rate_code] 
--,SSNClear,SSNEncrypted,CreditScoreEncrypted
--,evergreen_option_id 
--,evergreen_commission_end ,residual_option_id ,residual_commission_end ,initial_pymt_option_id ,sales_manager ,evergreen_commission_rate )
--select @p_account_id,					      -- [account_id] 
--		@p_account_number,				      -- [account_number]
--		@p_account_type,				      -- [account_type] 
--		@p_status,							  -- [status] 
--		@p_sub_status,						  -- [sub_status] 
--		@p_customer_id,					      -- [customer_id] 
--		@p_entity_id,					      -- [entity_id] 
--		@p_contract_nbr,					-- [contract_nbr]
--		@p_contract_type,				      -- [contract_type] 
--		@p_retail_mkt_id,					 -- [retail_mkt_id] 
--		@p_utility_id,						-- [utility_id] 
--		@p_product_id,						-- [product_id] 
--		@p_rate_id,							-- [rate_id] 
--		@p_rate,							-- [rate] 
--		@p_account_name_link,			      -- [account_name_link]
--		@p_customer_name_link,			      -- [customer_name_link] 
--		@p_customer_address_link,		      -- [customer_address_link]
--		@p_customer_contact_link,		      -- [customer_contact_link]
--		@p_billing_address_link,		      -- [billing_address_link] 
--		@p_billing_contact_link,		      -- [billing_contact_link] 
--		@p_owner_name_link,					  -- [owner_name_link] 
--		@p_service_address_link,		      -- [service_address_link] 
--		@p_business_type,					  -- [business_type] 
--		@p_business_activity,			      -- [business_activity] 
--		@p_additional_id_nbr_type,		      -- [additional_id_nbr_type] 
--		@p_additional_id_nbr,			      -- [additional_id_nbr] 
--		@p_contract_eff_start_date,		      -- [contract_eff_start_date] 
--		@p_term_months,						    -- [term_months] 
--		@p_date_end,						    -- [date_end] 
--		@p_date_deal,						   -- [date_deal]
--		@p_date_created,					   -- [date_created] 
--		@p_date_submit,						   -- [date_submit] 
--		ltrim(rtrim(@p_sales_channel_role)),	      -- [sales_channel_role] 
--		@p_username,							  -- [username] 
--		@p_sales_rep,							-- [sales_rep] 
--		@p_origin,								-- [origin] 
--		null, --@p_annual_usage						-- [annual_usage] 
--		@p_date_flow_start,						-- [date_flow_start] 
--		@p_date_por_enrollment,			      -- [date_por_enrollment]
--		@p_date_deenrollment,			      -- [date_deenrollment]
--		@p_date_reenrollment,			      -- [date_reenrollment] 
--		@p_tax_status,				      -- [tax_status] 
--		@p_tax_float,				      -- [tax_rate] 
--		@p_credit_score,			      -- [credit_score] 
--		@p_credit_agency,			      -- [credit_agency] 
--		@p_por_option,				      -- [por_option] 
--		@p_billing_type,			      -- [billing_type]
--		0,								-- [chgstamp] 
--		''							-- [rate_code] 
--		,@p_SSNClear, 
--		@p_SSNEncrypted, 
--		@p_CreditScoreEncrypted
--		,@p_evergreen_option_id			-- evergreen_option_id 
--		,@p_evergreen_commission_end		-- evergreen_commission_end 
--		,@p_residual_option_id			-- residual_option_id 
--		,@p_residual_commission_end		-- residual_commission_end 
--		,@p_initial_pymt_option_id		-- initial_pymt_option_id 
--		,@p_sales_manager				-- sales_manager 
--		,@p_evergreen_commission_rate	-- evergreen_commission_rate 		
		
/*		
select @p_account_id, @p_account_number, @p_account_type, @p_status, @p_sub_status, @p_customer_id,
       @p_entity_id, @p_contract_nbr, @p_contract_type, @p_retail_mkt_id, @p_utility_id, @p_product_id,

       @p_rate_id, @p_rate, @p_account_name_link, @p_customer_name_link, @p_customer_address_link,
       @p_customer_contact_link, @p_billing_address_link, @p_billing_contact_link, @p_owner_name_link,
       @p_service_address_link, @p_business_type, @p_business_activity, @p_additional_id_nbr_type,
       @p_additional_id_nbr, @p_contract_eff_start_date, @p_term_months, @p_date_end, @p_date_deal,
       @p_date_created, @p_date_submit, ltrim(rtrim(@p_sales_channel_role)), @p_username, @p_sales_rep,
       @p_origin, null --@p_annual_usage
       , @p_date_flow_start, @p_date_por_enrollment, @p_date_deenrollment,
       @p_date_reenrollment, @p_tax_status, @p_tax_float, @p_credit_score, @p_credit_agency,
       @p_por_option, @p_billing_type, 0, '', @p_SSNClear, @p_SSNEncrypted, @p_CreditScoreEncrypted -- IT002
*/		
 
if @@error                                         <> 0
or @@rowcount                                       = 0
begin
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000002'
   select @w_return                                 = 1
end
 
if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output
end
 
if @p_result_ind                                    = 'Y'
begin
   select flag_error                                = @w_error,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end


--mark the custom rate as used (rate_submit_ind = 1)
UPDATE lp_deal_capture..deal_pricing_detail 
set rate_submit_ind = 1, date_modified = getdate(), modified_by = @p_username
WHERE product_id = @p_product_id and rate_id = @p_rate_id
 
select @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:
return @w_return
