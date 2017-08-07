USE [Lp_Account]
GO

/****** Object:  Trigger [dbo].[tr_AccountInsteadOfUpdate]    Script Date: 11/12/2012 17:26:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Jaime Forero
-- Create date: 6/17/2011
-- Description:	Instead of trigger to handle backwards compatibility
-- =============================================
-- Modified: Isabelle Tamanini
-- Date: 3/15/2012
-- Description: Added logic to add AccountContract and AccountContractCommission
-- records if a new Contract record is added on transfer of ownership.
-- SR1-10750920
-- =============================================
-- Modified: Isabelle Tamanini
-- Date: 04/05/2012
-- Description: Added logic to add AccountStatus record if a new Contract record
-- added, and to set @AU_AccountUsageID to NULL before retrieving it
-- SR1-12006449
-- =============================================
-- Modified: Rick Deigsler
-- 11/12/2012
-- removed usp_AccountContractRateUpdate block as it being handled in another proces
-- =============================================

ALTER TRIGGER [dbo].[tr_AccountInsteadOfUpdate]
   ON  [dbo].[account]
   INSTEAD OF UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- GLOBAL VARIABLES FOR THE NEW RECORDS:
	DECLARE @w_InternalCounter INT;
	DECLARE @w_NewContractCreated BIT;
	SET @w_InternalCounter = 0;
	-- ====================================================================================================
	-- CONTRACT TABLE
	-- ====================================================================================================
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
	-- END CONTRACT TABLE
	
	-- ====================================================================================================
	-- CUSTOMER TABLE
	-- ====================================================================================================
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
	-- END CUSTOMER TABLE
	
	-- ====================================================================================================
	-- ACCOUNT TABLE
	-- ====================================================================================================
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
	-- END ACCOUNT TABLE
	
	-- ====================================================================================================
	-- ACCOUNT DETAIL TABLE
	-- ====================================================================================================
	DECLARE @AD_AccountID int
	DECLARE @AD_EnrollmentTypeID INT;
	DECLARE @AD_OriginalTaxDesignation INT;
	DECLARE @AD_ModifiedBy int
	
	-- ====================================================================================================
	-- ACCOUNT Usage
	-- ====================================================================================================
	DECLARE @AU_AccountUsageID int
	DECLARE @AU_AccountID int
	DECLARE @AU_AnnualUsage int
	DECLARE @AU_UsageReqStatusID int
	DECLARE @AU_EffectiveDate DATETIME;
	DECLARE @AU_ModifiedBy int
	-- END ACCOUNT Usage TABLE
	
	-- ====================================================================================================
	-- ACCOUNT CONTRACT TABLE
	-- ====================================================================================================
	DECLARE @AC_AccountContractID INT;
	DECLARE @AC_AccountID INT;
	DECLARE @AC_ContractID INT;
	DECLARE @AC_RequestedStartDate DATETIME;
	DECLARE @AC_SendEnrollmentDate DATETIME;
	DECLARE @AC_ModifiedBy INT;
	-- END ACCOUNT CONTRACT TABLE

	-- ====================================================================================================
	-- ACCOUNT CONTRACT COMISSION TABLE
	-- ====================================================================================================
	DECLARE @ACC_AccountContractID int
	DECLARE @ACC_EvergreenOptionID int
	DECLARE @ACC_EvergreenCommissionEnd datetime
	DECLARE @ACC_EvergreenCommissionRate float
	DECLARE @ACC_ResidualOptionID int
	DECLARE @ACC_ResidualCommissionEnd datetime
	DECLARE @ACC_InitialPymtOptionID int
	DECLARE @ACC_ModifiedBy INT;
	-- END ACCOUNT CONTRACT COMISSION TABLE
	
	-- ====================================================================================================================================================
	-- ACCOUNT STATUS TABLE
	-- ====================================================================================================================================================
	DECLARE @AS_AccountContractID int
	DECLARE @AS_Status varchar(15)
	DECLARE @AS_SubStatus varchar(15)
	DECLARE @AS_ModifiedBy INT;
	-- END ACCOUNT STATUS TABLE
	
	-- ====================================================================================================================================================	
	-- ACCOUNT CONTRACT RATE TABLE
	-- ====================================================================================================================================================
	DECLARE @ACR_AccountContractRateID INT;
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
	-- END ACCOUNT CONTRACT RATE TABLE
	
	-- UPDATED COLUMN VARIABLES
	DECLARE @w_account_id char(12);
	DECLARE @w_account_number varchar(30);
	DECLARE @w_account_type varchar(35);
	DECLARE @w_status varchar(15);
	DECLARE @w_sub_status varchar(15);
	DECLARE @w_customer_id varchar(10);
	DECLARE @w_entity_id char(15);
	DECLARE @w_contract_nbr char(12);
	DECLARE @w_contract_type varchar(25);
	DECLARE @w_retail_mkt_id char(2);
	DECLARE @w_utility_id char(15);
	DECLARE @w_product_id char(20);
	DECLARE @w_rate_id int;
	DECLARE @w_rate float;
	DECLARE @w_account_name_link int;
	DECLARE @w_customer_name_link int;
	DECLARE @w_customer_address_link int;
	DECLARE @w_customer_contact_link int;
	DECLARE @w_billing_address_link int;
	DECLARE @w_billing_contact_link int;
	DECLARE @w_owner_name_link int;
	DECLARE @w_service_address_link int;
	DECLARE @w_business_type varchar(35);
	DECLARE @w_business_activity varchar(35);
	DECLARE @w_additional_id_nbr_type varchar(10);
	DECLARE @w_additional_id_nbr varchar(30);
	DECLARE @w_contract_eff_start_date datetime;
	DECLARE @w_term_months int;
	DECLARE @w_date_end datetime;
	DECLARE @w_date_deal datetime;
	DECLARE @w_date_created datetime;
    DECLARE @w_date_submit datetime;
    DECLARE @w_sales_channel_role nvarchar(50);
    DECLARE @w_username nchar(100);
    DECLARE @w_sales_rep varchar(100);
    DECLARE @w_origin varchar(50);
    DECLARE @w_annual_usage int;
    DECLARE @w_date_flow_start datetime;
	DECLARE @w_date_por_enrollment datetime;
	DECLARE @w_date_deenrollment datetime;
	DECLARE @w_date_reenrollment datetime;
	DECLARE @w_tax_status varchar(20);
	DECLARE @w_tax_rate float;
	DECLARE @w_credit_score real;
	DECLARE @w_credit_agency varchar(30);
	DECLARE @w_por_option varchar(50);
	DECLARE @w_billing_type varchar(15);
	DECLARE @w_chgstamp smallint;
	DECLARE @w_usage_req_status varchar(20);
	DECLARE @w_Created datetime;
	DECLARE @w_CreatedBy nvarchar(100);
	DECLARE @w_Modified datetime;
	DECLARE @w_ModifiedBy nvarchar(100);
	DECLARE @w_rate_code varchar(50);
	DECLARE @w_zone varchar(50);
	DECLARE @w_service_rate_class varchar(50);
	DECLARE @w_stratum_variable varchar(15);
	DECLARE @w_billing_group varchar(15);
	DECLARE @w_icap varchar(15);
	DECLARE @w_tcap varchar(15);
	DECLARE @w_load_profile varchar(50);
	DECLARE @w_loss_code varchar(15);
	DECLARE @w_meter_type varchar(15);
	DECLARE @w_requested_flow_start_date datetime;
	DECLARE @w_deal_type char(20);
	DECLARE @w_enrollment_type int;
	DECLARE @w_customer_code char(5);
	DECLARE @w_customer_group char(100);
	DECLARE @w_AccountID INT;
	DECLARE @w_SSNClear nvarchar(100);
	DECLARE @w_SSNEncrypted nvarchar(512);
	DECLARE @w_CreditScoreEncrypted nvarchar(512);
    DECLARE @w_HeatIndexSourceID int;
    DECLARE @w_HeatRate decimal(9,2);
    DECLARE @w_evergreen_option_id int;
    DECLARE @w_evergreen_commission_end datetime;
    DECLARE @w_residual_option_id int;
    DECLARE @w_residual_commission_end datetime;
    DECLARE @w_initial_pymt_option_id int;
    DECLARE @w_sales_manager varchar(100);
    DECLARE @w_evergreen_commission_rate float;
    DECLARE @w_original_tax_designation INT;
	
	DECLARE inserted_cursor CURSOR FOR 
	SELECT [account_id]
      ,[account_number]
      ,[account_type]
      ,[status]
      ,[sub_status]
      ,[customer_id]
      ,[entity_id]
      ,[contract_nbr]
      ,[contract_type]
      ,[retail_mkt_id]
      ,[utility_id]
      ,[product_id]
      ,[rate_id]
      ,[rate]
      ,[account_name_link]
      ,[customer_name_link]
      ,[customer_address_link]
      ,[customer_contact_link]
      ,[billing_address_link]
      ,[billing_contact_link]
      ,[owner_name_link]
      ,[service_address_link]
      ,[business_type]
      ,[business_activity]
      ,[additional_id_nbr_type]
      ,[additional_id_nbr]
      ,[contract_eff_start_date]
      ,[term_months]
      ,[date_end]
      ,[date_deal]
      ,[date_created]
      ,[date_submit]
      ,[sales_channel_role]
      ,[username]
      ,[sales_rep]
      ,[origin]
      ,[annual_usage]
      ,[date_flow_start]
      ,[date_por_enrollment]
      ,[date_deenrollment]
      ,[date_reenrollment]
      ,[tax_status]
      ,[tax_rate]
      ,[credit_score]
      ,[credit_agency]
      ,[por_option]
      ,[billing_type]
      ,[chgstamp]
      ,[usage_req_status]
      ,[Created]
      ,[CreatedBy]
      ,[Modified]
      ,[ModifiedBy]
      ,[rate_code]
      ,[zone]
      ,[service_rate_class]
      ,[stratum_variable]
      ,[billing_group]
      ,[icap]
      ,[tcap]
      ,[load_profile]
      ,[loss_code]
      ,[meter_type]
      ,[requested_flow_start_date]
      ,[deal_type]
      ,[enrollment_type]
      ,[customer_code]
      ,[customer_group]
      ,[AccountID]
      ,[SSNClear]
      ,[SSNEncrypted]
      ,[CreditScoreEncrypted]
      ,[HeatIndexSourceID]
      ,[HeatRate]
      ,[evergreen_option_id]
      ,[evergreen_commission_end]
      ,[residual_option_id]
      ,[residual_commission_end]
      ,[initial_pymt_option_id]
      ,[sales_manager]
      ,[evergreen_commission_rate]
      ,[original_tax_designation]
  FROM inserted
	;
	
	-- ================================================================================================================================================
	-- Global checks and trigger overrides
	-- ================================================================================================================================================
	
	-- ========================================
	-- tr_account_upd_ins: IMPORTANT !!! This block of code must match with the logic on AfterUpdateCheckDeenrollment.
	-- ========================================
	DECLARE @tmp_AccountNumber	VARCHAR(50);
	DECLARE @tmp_UtilityId		VARCHAR(50);
	DECLARE @tmp_Message		VARCHAR(50);
	SELECT TOP 1
		 @tmp_AccountNumber			= account_number
		,@tmp_UtilityId				= utility_id
	FROM inserted
	WHERE   ([status]				= '911000'	and sub_status = '10' and date_deenrollment = '19000101')
		OR 	([status]				= '11000'	and sub_status = '50' and date_deenrollment = '19000101')	
	IF @@ROWCOUNT > 0
	BEGIN
		ROLLBACK
		SET @tmp_Message	=	'The Account number ' + LTRIM(RTRIM(@tmp_AccountNumber)) + '(' + LTRIM(RTRIM(@tmp_UtilityId)) + ') is in De-Enrollement Done status or Pending De-enrollment Confirmed status and the De-Enrollment date is invalid.' 
		SET NOCOUNT OFF;
		RAISERROR 26001 @tmp_Message;
	END
	-- ========================================
	-- END tr_account_upd_ins
	-- ========================================
	
	OPEN inserted_cursor;
	
	FETCH NEXT FROM inserted_cursor 
	INTO @w_account_id  
	  , @w_account_number
	  , @w_account_type 
	  , @w_status 
	  , @w_sub_status 
	  , @w_customer_id 
	  , @w_entity_id 
	  , @w_contract_nbr  
	  , @w_contract_type 
	  , @w_retail_mkt_id 
	  , @w_utility_id 
	  , @w_product_id 
	  , @w_rate_id 
	  , @w_rate 
	  , @w_account_name_link 
	  , @w_customer_name_link 
	  , @w_customer_address_link 
	  , @w_customer_contact_link 
	  , @w_billing_address_link 
	  , @w_billing_contact_link 
	  , @w_owner_name_link 
	  , @w_service_address_link 
	  , @w_business_type 
	  , @w_business_activity 
	  , @w_additional_id_nbr_type 
	  , @w_additional_id_nbr 
	  , @w_contract_eff_start_date 
	  , @w_term_months 
	  , @w_date_end  
	  , @w_date_deal 
	  , @w_date_created 
	  , @w_date_submit 
	  , @w_sales_channel_role 
	  , @w_username  
	  , @w_sales_rep 
	  , @w_origin 
	  , @w_annual_usage 
	  , @w_date_flow_start 
	  , @w_date_por_enrollment 
	  , @w_date_deenrollment 
	  , @w_date_reenrollment 
	  , @w_tax_status 
	  , @w_tax_rate 
	  , @w_credit_score 
	  , @w_credit_agency 
	  , @w_por_option 
	  , @w_billing_type 
	  , @w_chgstamp 
	  , @w_usage_req_status 
	  , @w_Created 
	  , @w_CreatedBy 
	  , @w_Modified 
	  , @w_ModifiedBy 
	  , @w_rate_code 
	  , @w_zone 
	  , @w_service_rate_class 
	  , @w_stratum_variable 
	  , @w_billing_group 
	  , @w_icap 
	  , @w_tcap 
	  , @w_load_profile
	  , @w_loss_code 
	  , @w_meter_type 
	  , @w_requested_flow_start_date 
	  , @w_deal_type 
	  , @w_enrollment_type 
	  , @w_customer_code 
	  , @w_customer_group 
	  , @w_AccountID 
	  , @w_SSNClear 
	  , @w_SSNEncrypted 
	  , @w_CreditScoreEncrypted 
	  , @w_HeatIndexSourceID 
	  , @w_HeatRate 
	  , @w_evergreen_option_id 
	  , @w_evergreen_commission_end 
	  , @w_residual_option_id 
	  , @w_residual_commission_end 
	  , @w_initial_pymt_option_id 
	  , @w_sales_manager 
	  , @w_evergreen_commission_rate 
	  , @w_original_tax_designation
	;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'account..[tr_AccountInsteadOfUpdate]=>Starting update ' + CAST(@w_InternalCounter as VARCHAR) + ' => ' + CAST( @w_account_id AS VARCHAR );
		SET @w_InternalCounter = @w_InternalCounter +1;
		SET @w_NewContractCreated = 0;
		-- ====================================================================================================================================================

		--					NEW				SCHEMA			CHANGES

		-- ==================================================================================================================================================== 
		-- ====================================================================================================================================================
		-- HERE WE NEED TO CREATE THE acount_address and related inserts for the renewal to work ok, any renewal data will update the exiting values:
		-- ====================================================================================================================================================
		-- @w_account_name_link 
		-- @w_customer_name_link 
		-- @w_customer_address_link 
		-- @w_customer_contact_link 
		-- @w_billing_address_link 
		-- @w_billing_contact_link 
		-- @w_owner_name_link 
		-- @w_service_address_link 

		-- ACCOUNT NAME:
		IF NOT EXISTS ( SELECT	account_id
						FROM	lp_account..account_renewal_name WITH ( NOLOCK )
						WHERE	account_id	= @w_account_id 
						AND		name_link	= @w_account_name_link )
		BEGIN
			INSERT INTO lp_account..account_renewal_name
			SELECT	account_id, name_link, full_name, 0
			FROM	lp_account..account_name with (NOLOCK)
			WHERE	account_id	= @w_account_id 
			AND		name_link	= @w_account_name_link
			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				PRINT 'Missing link info';
				-- RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
			END
		END

		-- CUSTOMER NAME:

		IF NOT EXISTS ( SELECT	account_id
						FROM	lp_account..account_renewal_name WITH ( NOLOCK )
						WHERE	account_id	= @w_account_id 
						AND		name_link	= @w_customer_name_link )
		BEGIN
			INSERT INTO lp_account..account_renewal_name
			SELECT	account_id, name_link, full_name, 0
			FROM	lp_account..account_name WITH (NOLOCK)
			WHERE	account_id	= @w_account_id 
			AND		name_link	= @w_customer_name_link

			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				PRINT 'Missing link info';
				-- RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
			END
		END

		-- OWNER NAME:

		IF NOT EXISTS ( SELECT	account_id
						FROM	lp_account..account_renewal_name WITH ( NOLOCK )
						WHERE	account_id	= @w_account_id 
						AND		name_link	= @w_owner_name_link )
		BEGIN
			INSERT INTO lp_account..account_renewal_name
			SELECT	account_id, name_link, full_name, 0
			FROM	lp_account..account_name WITH (NOLOCK)
			WHERE	account_id	= @w_account_id 
			AND		name_link	= @w_owner_name_link

			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				PRINT 'Missing link info';
				-- RAISERROR('Error while trying to add record to the account_name table, cannot continue',11,1)
			END
		END

		-- CUSTOMER ADDRESS

		IF NOT EXISTS ( SELECT	account_id
						FROM	lp_account..account_renewal_address WITH (NOLOCK)
						WHERE	account_id	 = @w_account_id 
						AND		address_link = @w_customer_address_link )
		BEGIN
			INSERT INTO lp_account..account_renewal_address
			SELECT	account_id, address_link, [address], CAST(suite AS CHAR(10) ), city, [state], zip, county, state_fips, county_fips, 0
			FROM	lp_account..account_address WITH ( NOLOCK )
			WHERE	account_id		= @w_account_id 
			AND		address_link	= @w_customer_address_link

			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				PRINT 'Missing link info';
				-- RAISERROR('Error while trying to add record @p_customer_address_link to the account_address table, cannot continue',11,1)
			END
		END

		-- BILLING ADDRESS:

		IF NOT EXISTS ( SELECT	account_id
						FROM	lp_account..account_renewal_address WITH (NOLOCK)
						WHERE	account_id	 = @w_account_id 
						AND		address_link = @w_billing_address_link )
		BEGIN
			INSERT INTO lp_account..account_renewal_address
			SELECT	account_id, address_link, [address], CAST(suite AS CHAR(10) ), city, [state], zip, county, state_fips, county_fips, 0
			FROM	lp_account..account_address WITH ( NOLOCK )
			WHERE	account_id		= @w_account_id 
			AND		address_link	= @w_billing_address_link

			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				PRINT 'Missing link info';
				-- RAISERROR('Error while trying to add record @p_billing_address_link to the account_address table, cannot continue',11,1)
			END
		END

		-- SERVICE ADDRESS:

		IF NOT EXISTS ( SELECT	account_id
						FROM	lp_account..account_renewal_address WITH (NOLOCK)
						WHERE	account_id	 = @w_account_id 
						AND		address_link = @w_service_address_link )
		BEGIN
			INSERT INTO lp_account..account_renewal_address
			SELECT	account_id, address_link, [address], CAST(suite AS CHAR(10) ), city, [state], zip, county, state_fips, county_fips, 0
			FROM	lp_account..account_address WITH ( NOLOCK )
			WHERE	account_id		= @w_account_id 
			AND		address_link	= @w_service_address_link 

			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				PRINT 'Missing link info';
				-- RAISERROR('Error while trying to add record @p_service_address_link to the account_address table, cannot continue',11,1)
			END
		END

		-- CUSTOMER CONTACT:

		IF NOT EXISTS ( SELECT	account_id
						FROM	lp_account..account_renewal_contact WITH (NOLOCK)
						WHERE	account_id		= @w_account_id 
						AND		contact_link	= @w_customer_contact_link )
		BEGIN
		
			INSERT INTO lp_account..account_renewal_contact
			SELECT	account_id, contact_link, first_name, last_name, title, phone, fax, email, isnull(birthday , '01/01'), 0
			FROM	lp_account..account_contact WITH (NOLOCK)
			WHERE account_id	= @w_account_id  
			AND contact_link	= @w_customer_contact_link
			
			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				DECLARE @E_MSG VARCHAR(500);
				SET @E_MSG = 'Error while trying to add record @w_customer_contact_link [' + CAST(@w_customer_contact_link as VARCHAR ) + '] account_id ['+CAST(@w_account_id AS VARCHAR)+'] to the account_contact table, cannot continue'; 
				--RAISERROR(@E_MSG,11,1)
			END
		END

		-- BILLING CONTACT:

		IF NOT EXISTS ( SELECT	account_id
						FROM	lp_account..account_renewal_contact WITH (NOLOCK)
						WHERE	account_id		= @w_account_id 
						AND		contact_link	= @w_billing_contact_link )
		BEGIN
			INSERT INTO lp_account..account_renewal_contact
			SELECT	account_id, contact_link, first_name, last_name, title, phone, fax, email, isnull(birthday , '01/01'), 0
			FROM	lp_account..account_contact WITH (NOLOCK)
			WHERE account_id	= @w_account_id  
			AND contact_link	= @w_billing_contact_link 

			IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			BEGIN
				PRINT 'Missing link info';
				-- RAISERROR('Error while trying to add record @p_billing_contact_link to the account_contact table, cannot continue',11,1)
			END
		END
		
		
		
		
		-- SOME DATA CLEAN UP AND NORMALIZATION, MUST BE FIRST THING AFTER BEGIN:
		-- This was performed in a trigger tr_account_strip_special_characters_after_ins_upd
		SET @w_additional_id_nbr = lp_account.dbo.ufn_strip_special_characters(@w_additional_id_nbr);
		SET @w_sales_rep		 = lp_account.dbo.ufn_strip_special_characters(@w_sales_rep);
		SET @w_contract_nbr		 = LTRIM(RTRIM(@w_contract_nbr));
		SET @w_account_number	 = LTRIM(RTRIM(@w_account_number));
		
		-- Get Modified by user:
		
		-- SET @w_ModifiedByUserID = Libertypower.dbo.ufn_GetUserId(@w_ModifiedBy, 0);
		
		
		-- END DATA CLEANUP
		IF UPDATE(contract_nbr)
		--OR UPDATE(contract_type)
		--OR UPDATE(date_deal)
		--OR UPDATE(date_submit)
		--OR UPDATE(sales_channel_role)
		--OR UPDATE(sales_rep)
		--OR UPDATE(sales_manager)
		--OR UPDATE(username)
		--OR UPDATE(contract_eff_start_date)
		--OR UPDATE(term_months)
		OR 1 = 1 -- do this since we can also always try to update, we could list all the possible columns in case we want more performance
		BEGIN
			-- ===============================================================================================================================================================
			PRINT 'Process Contract record';
			-- ===============================================================================================================================================================
		
			SET @C_Number = LTRIM(RTRIM(@w_contract_nbr));
			SET @C_ContractTypeID = Libertypower.dbo.ufn_GetContractTypeId(@w_contract_type);
			SET @C_ContractDealTypeID = Libertypower.dbo.ufn_GetContractDealTypeId(@w_contract_type);
			SELECT @C_ContractStatusID = CS.ContractStatusID FROM LibertyPower.dbo.ContractStatus CS (NOLOCK) WHERE LOWER(CS.Descp) = 'pending';
			SET @C_ContractTemplateID = Libertypower.dbo.ufn_GetContractTemplateTypeId(@w_contract_type);
			SET @C_ReceiptDate = NULL;
			
			SET @C_SignedDate = @w_date_deal;
			SET @C_SubmitDate = @w_date_submit;
			SET @C_SalesChannelID = Libertypower.dbo.ufn_GetSalesChannel(@w_sales_channel_role);
			SET @C_SalesRep = LTRIM(RTRIM(@w_sales_rep));
			SET @C_SalesManagerID = Libertypower.dbo.ufn_GetUserId(@w_sales_manager, 1);
			SET @C_PricingTypeID = NULL;
			SET @C_ModifiedBy = Libertypower.dbo.ufn_GetUserId(@w_username, 0);
			SET @C_CreatedBy = Libertypower.dbo.ufn_GetUserId(@w_username, 0);
			
			SELECT  @C_ContractID = ContractID, @AU_EffectiveDate = C.StartDate,
					@C_StartDate = StartDate,  @C_EndDate =  EndDate
			FROM LibertyPower.dbo.[Contract] C (NOLOCK) 
			WHERE C.Number = LTRIM(RTRIM(@w_contract_nbr));
			-- REMOVED: by Eric, contract dates are set ONLY during contract creation, and cannot change since thesr are just future dates
			-- Changing the contract dates might have consequences with pricing and the account usage records
			--SET @C_StartDate = MIN(lp_enrollment.dbo.ufn_date_format( @w_contract_eff_start_date ,'<YYYY>-<MM>-01'));
			--SET @C_EndDate  = MIN(DATEADD(mm, @w_term_months, lp_enrollment.dbo.ufn_date_format(@w_contract_eff_start_date,'<YYYY>-<MM>-01')) - 1) ;
			
			
			IF @C_ContractID IS NULL 
			BEGIN
				-- The "old" contract doesnt exist, we need to create one contract record:
				-- Normally there is no contract number change in the normal flow of the application logic.
				-- A use of this is when there is transfer of ownership, the new contract number will be sent here
				SET @C_StartDate = MIN(lp_enrollment.dbo.ufn_date_format( @w_contract_eff_start_date ,'<YYYY>-<MM>-01'));
				SET @C_EndDate  = MIN(DATEADD(mm, @w_term_months, lp_enrollment.dbo.ufn_date_format(@w_contract_eff_start_date,'<YYYY>-<MM>-01')) - 1) ;
			
				EXECUTE @C_ContractID = Libertypower.dbo.usp_ContractInsert @C_Number, @C_ContractTypeID, @C_ContractDealTypeID, @C_ContractStatusID, @C_ContractTemplateID,
																		    @C_ReceiptDate, @C_StartDate, @C_EndDate, @C_SignedDate, @C_SubmitDate, @C_SalesChannelID, @C_SalesRep,
																		    @C_SalesManagerID, @C_PricingTypeID, @C_ModifiedBy, @C_CreatedBy, 1 ;
				
				SET @AU_EffectiveDate = @C_StartDate;
				IF @C_ContractID IS NULL
					RAISERROR('Could not create new contract.',11,1);
					
				SET @w_NewContractCreated = 1;
			END
			ELSE
			BEGIN 
				EXECUTE [Libertypower].[dbo].[usp_ContractUpdate] 
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
												  ,@C_CreatedBy , 1;
				
			END
			
		END -- END OF CASE WHEN IS A NOT A NEW CONTRACT RECORD
		
		IF UPDATE(account_id)
		OR UPDATE(account_number)
		OR UPDATE(account_type)
		OR 1 = 1 -- do this since we can also always try to update
		BEGIN
		
			-- ===============================================================================================================================================================
			PRINT 'Process Account Record';
			-- ===============================================================================================================================================================	
		
		
			SET @A_AccountID = @w_AccountID;		
			-- GEt Current Customer ID:
			
			SELECT @CUST_CustomerID =  A.CustomerID, @A_CurrentRenewalContractID = A.CurrentRenewalContractID FROM Libertypower.dbo.Account A WHERE AccountID = @A_AccountID;
			
			SET @A_AccountIdLegacy = @w_account_id;
			SET @A_AccountNumber = LTRIM(RTRIM(@w_account_number));
			SELECT @A_AccountTypeID = AT.ID FROM LibertyPower.dbo.AccountType AT (NOLOCK) WHERE LOWER(AT.AccountType) = LOWER(LTRIM(RTRIM(@w_account_type)));
			SET @A_CurrentContractID = @C_ContractID;
			SET @A_CustomerID = @CUST_CustomerID;
			SET @A_CustomerIdLegacy = @w_customer_id;
			SET @A_EntityID = @w_entity_id; 
			SELECT @A_RetailMktID = M.ID FROM Libertypower.dbo.Market M (NOLOCK) WHERE LTRIM(RTRIM(LOWER(M.MarketCode))) = LTRIM(RTRIM(LOWER(@w_retail_mkt_id)));
			SELECT @A_UtilityID = U.ID FROM LibertyPower.dbo.Utility U (NOLOCK) WHERE LOWER(U.UtilityCode) = LOWER(LTRIM(RTRIM(@w_utility_id)));
			SELECT @A_AccountNameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (NOLOCK)WHERE AN.account_id = @w_account_id AND AN.name_link = @w_account_name_link;
			SELECT @A_BillingAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @w_account_id AND AA.address_link = @w_billing_address_link;
			SELECT @A_BillingContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (NOLOCK) WHERE AC.account_id = @w_account_id AND AC.contact_link = @w_billing_contact_link;
			SELECT @A_ServiceAddressID = AA.AccountAddressID FROM lp_account.dbo.account_address AA (NOLOCK) WHERE AA.account_id = @w_account_id AND AA.address_link = @w_service_address_link;
			SET @A_Origin = @w_origin;
			SELECT @A_TaxStatusID = T.TaxStatusID FROM LibertyPower.dbo.TaxStatus T (NOLOCK) WHERE LOWER(T.[Status]) = LOWER(LTRIM(RTRIM(@w_tax_status)));
			SET @A_PorOption = CASE LOWER(@w_por_option) WHEN 'yes' THEN 1 ELSE 0 END;
			SELECT @A_BillingTypeID = B.BillingTypeID FROM LibertyPower.dbo.BillingType B (NOLOCK) WHERE LOWER(B.[Type]) = LOWER(LTRIM(RTRIM(@w_billing_type)));
			SET @A_Zone = @w_zone
			SET @A_ServiceRateClass = @w_service_rate_class;
			SET @A_StratumVariable = @w_stratum_variable;
			SET @A_BillingGroup = @w_billing_group;
			SET @A_Icap = @w_icap;
			SET @A_Tcap = @w_tcap;
			SET @A_LoadProfile = @w_load_profile;
			SET @A_LossCode = @w_loss_code;
			SELECT @A_MeterTypeID = MT.ID FROM LibertyPower.dbo.MeterType MT (NOLOCK) WHERE LOWER(MT.MeterTypeCode) =  LOWER(LTRIM(RTRIM(@w_meter_type)));

			SET @A_CreatedBy = LibertyPower.dbo.ufn_GetUserId(@w_username ,0);
			SET @A_Modified = GETDATE();
			SET @A_DateCreated = GETDATE();
			SET @A_ModifiedBy = LibertyPower.dbo.ufn_GetUserId(@w_username, 0);
			SET @A_MigrationComplete = 1;
			
			--TODO: Need to review fields that are not sent from this update trigger and should remain the same, such as new CurrentContractID and other new fields that should not be affected or set to null
			-- TODO: Make sure current contract and such are taken care of
			-- TODO: Make sure to review the date created since this will be taken out
			EXEC LibertyPower.dbo.usp_AccountUpdate @A_AccountID, @A_AccountIdLegacy, @A_AccountNumber, @A_AccountTypeID, @A_CurrentContractID,@A_CurrentRenewalContractID, @A_CustomerID, @A_CustomerIdLegacy,
													@A_EntityID, @A_RetailMktID, @A_UtilityID, @A_AccountNameID,@A_BillingAddressID, @A_BillingContactID, @A_ServiceAddressID, @A_Origin,
													@A_TaxStatusID, @A_PorOption, @A_BillingTypeID, @A_Zone, @A_ServiceRateClass, @A_StratumVariable, @A_BillingGroup, @A_Icap, @A_Tcap, 
													@A_LoadProfile, @A_LossCode, @A_MeterTypeID, @A_Modified, @A_ModifiedBy, NULL, NULL, @A_MigrationComplete,1; 
		END -- END Account
		
		-- Check ContractID since its required, this is a check in case script is modified without looking
		IF @C_ContractID IS NULL OR @C_ContractID = 0
				RAISERROR('@w_ContractID IS NULL, cannot continue',11,1)
		
		
		
		
		IF UPDATE(enrollment_Type)
		OR UPDATE(original_tax_designation)
		--IF UPDATE(enrollment_Type)
		--OR 1 = 1 -- do this since we can also always try to update 
		BEGIN
			-- ===============================================================================================================================================================
			PRINT 'Process AccountDetail Record';
			-- ===============================================================================================================================================================	
			SET @AD_AccountID = @A_AccountID;
			SET @AD_OriginalTaxDesignation = @w_original_tax_designation;
			SET @AD_ModifiedBy = @A_ModifiedBy;
			SET @AD_EnrollmentTypeID = @w_enrollment_type; 
			
			-- The value is integer and doesnt need translation
			--SELECT @AD_EnrollmentTypeID = ET.EnrollmentTypeID 
			--FROM LibertyPower.dbo.EnrollmentType ET (NOLOCK) 
			-- WHERE LOWER(ET.[Type]) =  LOWER(LTRIM(RTRIM(@w_enrollment_type)));
			-- PRINT 'Value of enrollmenttype: ' + CAST(@AD_EnrollmentTypeID as VARCHAR);
			
			EXECUTE [Libertypower].[dbo].[usp_AccountDetailUpdate] 
			   NULL  
			  ,@AD_AccountID
			  ,@AD_EnrollmentTypeID
			  ,@AD_OriginalTaxDesignation
			  ,@AD_ModifiedBy, 1
		END
		
		-- This is for the transfer of ownership workaround
		-- We need to detect if the contract number changed:
		-- GET THE OLD Value of the contract
		DECLARE @OldContract_nbr VARCHAR(20);
		
		SELECT @OldContract_nbr = contract_nbr FROM DELETED WHERE AccountID = @A_AccountID;
		
		IF @OldContract_nbr != @C_Number AND @w_NewContractCreated = 0
		BEGIN
			PRINT 'New Contract created';
			SET @w_NewContractCreated = 1;
		END
		
		-- IF UPDATE(contract_nbr) AND @w_NewContractCreated = 0
			-- SET @w_NewContractCreated = 1;
		
		
		--TODO: Make sure to include the fields that need to be tested for tthe AccountContract table
		IF UPDATE (requested_flow_start_date)
		OR UPDATE (date_por_enrollment)
		OR @w_NewContractCreated = 1 -- do this since we can also always try to update
		BEGIN
			-- ===============================================================================================================================================================
			PRINT 'Process AccountContract Record';
			-- ===============================================================================================================================================================	
		
			SET @AC_AccountID = @A_AccountID;
			SET @AC_ContractID = @C_ContractID;
			SET @AC_RequestedStartDate = @w_requested_flow_start_date;
			SET @AC_SendEnrollmentDate = @w_date_por_enrollment;
			SET @AC_ModifiedBy = @C_ModifiedBy;
			
			
			IF @w_NewContractCreated = 1 
			BEGIN
				EXECUTE @AC_AccountContractID = [Libertypower].[dbo].[usp_AccountContractInsert] 
				   @AC_AccountID
				  ,@AC_ContractID
				  ,@AC_RequestedStartDate
				  ,@AC_SendEnrollmentDate
				  ,@AC_ModifiedBy, 1
			END
			ELSE 
			BEGIN
				SELECT	@AC_AccountContractID = AC.AccountContractID
				FROM LibertyPower.dbo.AccountContract AC (NOLOCK) 
				WHERE AC.AccountID = @A_AccountID AND AC.ContractID = @C_ContractID;
				
				EXEC LibertyPower.dbo.usp_AccountContractUpdate @AC_AccountContractID, @AC_AccountID, 
																@AC_ContractID, @AC_RequestedStartDate, 
																@AC_SendEnrollmentDate, @AC_ModifiedBy, 1;
																
			END
			IF @AC_AccountContractID IS NULL OR @AC_AccountContractID = 0
				RAISERROR('@AC_AccountContractID IS NULL, cannot continue',11,1)
				
		END -- END AccountContract
		ELSE
		BEGIN
			IF @w_NewContractCreated = 0
			BEGIN 
				SELECT	@AC_AccountContractID = AC.AccountContractID
				FROM LibertyPower.dbo.AccountContract AC (NOLOCK) 
				WHERE AC.AccountID = @A_AccountID AND AC.ContractID = @C_ContractID;
			END
		END 
		
		
		IF UPDATE (evergreen_option_id)
		OR UPDATE (evergreen_commission_end)
		OR UPDATE (evergreen_commission_rate)
		OR UPDATE (residual_option_id)
		OR UPDATE (residual_commission_end)
		OR UPDATE (initial_pymt_option_id)
		OR @w_NewContractCreated = 1
		--OR 1 = 1 -- do this since we can also always try to update
		BEGIN
			-- ===============================================================================================================================================================
			PRINT 'Process AccountContractCommission Record';
			-- ===============================================================================================================================================================	
		
			SET @ACC_AccountContractID = @AC_AccountContractID;
			SET @ACC_EvergreenOptionID = @w_evergreen_option_id ;
			SET @ACC_EvergreenCommissionEnd = @w_evergreen_commission_end;
			SET @ACC_EvergreenCommissionRate = @w_evergreen_commission_rate;
			SET @ACC_ResidualOptionID = @w_residual_option_id;
			SET @ACC_ResidualCommissionEnd = @w_residual_commission_end;
			SET @ACC_InitialPymtOptionID = @w_initial_pymt_option_id;
			SET @ACC_ModifiedBy = @C_ModifiedBy;
			
			IF @w_NewContractCreated = 1 
			BEGIN
				EXECUTE [Libertypower].[dbo].[usp_AccountContractCommissionInsert] 
										   @ACC_AccountContractID
										  ,@ACC_EvergreenOptionID
										  ,@ACC_EvergreenCommissionEnd
										  ,@ACC_EvergreenCommissionRate
										  ,@ACC_ResidualOptionID
										  ,@ACC_ResidualCommissionEnd
										  ,@ACC_InitialPymtOptionID
										  ,@ACC_ModifiedBy,@ACC_ModifiedBy ,1
										 ;
			END
			ELSE
			BEGIN
				EXEC LibertyPower.dbo.usp_AccountContractCommissionUpdate NULL, @ACC_AccountContractID, @ACC_EvergreenOptionID, 
															@ACC_EvergreenCommissionEnd, @ACC_EvergreenCommissionRate, @ACC_ResidualOptionID, 
															@ACC_ResidualCommissionEnd, @ACC_InitialPymtOptionID, @ACC_ModifiedBy,1;							
			END
					
			
		END -- END AccountContractCommission 

		
		IF 1 = 1 -- do this since we can also always try to update
		BEGIN	
			-- ===============================================================================================================================================================
			PRINT 'Process AccountUsage Record';
			-- ===============================================================================================================================================================	
		
			-- SET @AU_EffectiveDate = @C_StartDate; this is gathered in the contract select query because we want the old value to bring the new record and then update it
			SET @AU_AccountID = @A_AccountID;
			SET @AU_AnnualUsage = @w_annual_usage;
			
			SELECT @AU_UsageReqStatusID = URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS WHERE LOWER(URS.[Status]) = LOWER(LTRIM(RTRIM(@w_usage_req_status)));			
			
			IF @AU_UsageReqStatusID  IS NULL 
				SELECT @AU_UsageReqStatusID = URS.UsageReqStatusID FROM Libertypower.dbo.UsageReqStatus URS WHERE LOWER(URS.[Status]) = 'pending';
				
			SET @AU_ModifiedBy = @C_ModifiedBy;
			SET @AU_AccountUsageID = NULL
			-- MAKE SURE TO GET THE USAGE RECORD BASED ON THE CURRENT CONTRACT:
			SELECT @AU_AccountUsageID = AU.AccountUsageID FROM [Libertypower].[dbo].[AccountUsage] AU 
				WHERE AU.AccountID = @AU_AccountID AND AU.EffectiveDate = @AU_EffectiveDate;
			
			IF @AU_AccountUsageID IS NULL
			BEGIN
				IF  @w_NewContractCreated = 1
				BEGIN
					-- SET @AU_EffectiveDate = @C_StartDate;
					EXECUTE @AU_AccountUsageID = [Libertypower].[dbo].[usp_AccountUsageInsert] 
										   @AU_AccountID
										  ,@AU_AnnualUsage
										  ,@AU_UsageReqStatusID
										  ,@AU_EffectiveDate
										  ,@AU_ModifiedBy,@AU_ModifiedBy, 1 ;
				END
				IF @AU_AccountUsageID IS NULL 
					RAISERROR('Could not find AccountUsageID record ',11,1);
			END
			ELSE
			BEGIN 
				-- Now since we have the id of the record to update, we can set the new value of the effective date in case the contract number changed
				-- disabled SET @AU_EffectiveDate = @C_StartDate;
				EXECUTE [Libertypower].[dbo].[usp_AccountUsageUpdate]  
						   @AU_AccountUsageID 
						  ,@AU_AccountID
						  ,@AU_AnnualUsage
						  ,@AU_UsageReqStatusID
						  ,@AU_EffectiveDate
						  ,@AU_ModifiedBy ,1;
				--PRINT 'here update'
				
			END
		END -- END AccountUsage 
		
		
		IF UPDATE ([status])
		OR UPDATE ([sub_status])
		OR @w_NewContractCreated = 1
		-- OR 1 = 1
		BEGIN	
			-- ===============================================================================================================================================================
			PRINT 'Process AccountStatus Record';
			-- ===============================================================================================================================================================	
		
			-- TODO: This might need refactoring later, its using max in case more than one record exists in the table so assumes latest row update
			SET @AS_AccountContractID = @AC_AccountContractID;
			SET @AS_Status = @w_status;
			SET @AS_SubStatus = @w_sub_status;
			SET @AS_ModifiedBy = @C_ModifiedBy;
			
			IF @w_NewContractCreated = 1 
			BEGIN
				EXECUTE [Libertypower].[dbo].[usp_AccountStatusInsert] 
					   @AS_AccountContractID
					  ,@AS_Status
					  ,@AS_SubStatus
					  ,@AS_ModifiedBy
					  ,@AS_ModifiedBy,1;
			END
			ELSE
			BEGIN
				EXECUTE [Libertypower].[dbo].[usp_AccountStatusUpdate] 
					   NULL
					  ,@AS_AccountContractID
					  ,@AS_Status
					  ,@AS_SubStatus
					  ,@AS_ModifiedBy ,1;
			END
						
		END -- END AccountStatus

		IF UPDATE (rate)
		OR UPDATE (rate_id)
		OR 1 = 1
		BEGIN
			-- ===============================================================================================================================================================
			PRINT 'Process AccountContractRate Record';
			-- ===============================================================================================================================================================	
		
			SET @ACR_AccountContractID = @AC_AccountContractID;
			SET @ACR_LegacyProductID = @w_product_id;
			SET @ACR_Term = @w_term_months;
			SET @ACR_RateID = @w_rate_id;
			SET @ACR_Rate = @w_rate;
			IF @w_rate_code IS NULL 
				SET @w_rate_code = '';
			SET @ACR_RateCode = @w_rate_code;
			SET @ACR_RateStart = @w_contract_eff_start_date;
			SET @ACR_RateEnd = @w_date_end;
			
			SET @ACR_HeatIndexSourceID = @w_HeatIndexSourceID;
			SET @ACR_HeatRate = @w_HeatRate;
			SET @ACR_TransferRate = NULL;
			SET @ACR_GrossMargin = NULL;
			SET @ACR_CommissionRate = NULL;
			SET @ACR_AdditionalGrossMargin = NULL;
			SET @ACR_ModifiedBy = @C_ModifiedBy;

			IF @w_NewContractCreated = 1 
			BEGIN
				SET @ACR_IsContractedRate = 1;
			
				EXECUTE [Libertypower].[dbo].[usp_AccountContractRateInsert] 
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
							  ,@ACR_ModifiedBy
							  ,@ACR_ModifiedBy, 1 ;
							  
							  
			END
			-- modified 11/12/12 Rick Deigsler
			-- removed this block as it being handled in another proces
			--ELSE
			--BEGIN
			--	-- GET THE LATEST RATE RECORD to update:
			--	SELECT	TOP(1) @ACR_AccountContractRateID = AccountContractRateID 
			--	FROM	LibertyPower.dbo.AccountContractRate ACR (NOLOCK)
			--	WHERE	ACR.AccountContractID = @AC_AccountContractID
			--	ORDER BY DateCreated DESC;
			--	-- PRINT 'SELECTED VALUES';
			--	--PRINT @ACR_AccountContractRateID ;
			--	--PRINT @AC_AccountContractID ;
			--	-- set this to null so we dont change the current value
			--	SET @ACR_IsContractedRate = NULL;
			
			--	EXECUTE [Libertypower].[dbo].[usp_AccountContractRateUpdate]  
			--				   @ACR_AccountContractRateID
			--				  ,@ACR_AccountContractID
			--				  ,@ACR_LegacyProductID
			--				  ,@ACR_Term 
			--				  ,@ACR_RateID
			--				  ,@ACR_Rate
			--				  ,@ACR_RateCode
			--				  ,@ACR_RateStart
			--				  ,@ACR_RateEnd
			--				  ,@ACR_IsContractedRate
			--				  ,@ACR_HeatIndexSourceID
			--				  ,@ACR_HeatRate
			--				  ,@ACR_TransferRate
			--				  ,@ACR_GrossMargin
			--				  ,@ACR_CommissionRate
			--				  ,@ACR_AdditionalGrossMargin
			--				  ,@ACR_ModifiedBy,1,NULL
			--				;
			--END
		END -- END AccountContractRate
		
		
		IF UPDATE (customer_name_link)
		OR UPDATE (owner_name_link)
		OR UPDATE (customer_address_link)
		OR UPDATE (customer_contact_link)
		OR UPDATE (additional_id_nbr)
		OR UPDATE (additional_id_nbr_type)
		OR UPDATE (additional_id_nbr)
		OR UPDATE (credit_agency)
		OR UPDATE (business_type)
		OR UPDATE (business_activity)
		OR UPDATE (CreditScoreEncrypted)
		-- OR 1 = 1
		BEGIN			
			-- ===============================================================================================================================================================
			PRINT 'Process Customer Record';
			-- ===============================================================================================================================================================	
		
			-- SET VALUES:
			SELECT @CUST_NameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (nolock)  WHERE AN.account_id = @w_account_id AND AN.name_link = @w_customer_name_link;
			SELECT @CUST_OwnerNameID = AN.AccountNameID FROM lp_account.dbo.account_name AN (nolock)  WHERE AN.account_id = @w_account_id AND AN.name_link = @w_owner_name_link;
			SELECT @CUST_AddressID = A.AccountAddressID FROM lp_account.dbo.account_address A (nolock)  WHERE A.account_id = @w_account_id AND A.address_link = @w_customer_address_link;
			SELECT @CUST_ContactID = AC.AccountContactID FROM lp_account.dbo.account_contact AC (nolock)  WHERE AC.account_id = @w_account_id AND AC.contact_link = @w_customer_contact_link;
			
			-- Set the values to empty so the view can work
			SET @CUST_Duns = '';
			SET @CUST_EmployerId = '';
			SET @CUST_TaxId = '';
			SET @CUST_SsnEncrypted = NULL;
			SET @CUST_SsnClear = @w_SSNClear;
			
			
			IF UPPER(LTRIM(RTRIM(@w_additional_id_nbr_type))) = 'DUNSNBR'
				SET @CUST_Duns = UPPER(@w_additional_id_nbr);
			IF UPPER(LTRIM(RTRIM(@w_additional_id_nbr_type))) = 'EMPLID'
				SET @CUST_EmployerId = UPPER(@w_additional_id_nbr);	
			IF UPPER(LTRIM(RTRIM(@w_additional_id_nbr_type))) = 'TAX ID'
				SET @CUST_TaxId = UPPER(@w_additional_id_nbr);
			IF UPPER(LTRIM(RTRIM(@w_additional_id_nbr_type))) = 'SSN'
				SET @CUST_SsnEncrypted = @w_SSNEncrypted;
				
			SELECT @CUST_CreditAgencyID = CA.CreditAgencyID FROM LibertyPower.dbo.CreditAgency CA (nolock)  WHERE LOWER(CA.Name) = LOWER(LTRIM(RTRIM(@w_credit_agency)));
			SELECT @CUST_BusinessTypeID = BT.BusinessTypeID FROM LibertyPower.dbo.BusinessType BT (nolock)  WHERE LOWER(BT.[Type]) = LOWER(LTRIM(RTRIM(@w_business_type)));
			SELECT @CUST_BusinessActivityID = BA.BusinessActivityID FROM LibertyPower.dbo.BusinessActivity BA (nolock)  WHERE LOWER(BA.Activity) = LOWER(LTRIM(RTRIM(@w_business_activity)));

			SET @CUST_CreditScoreEncrypted = @w_CreditScoreEncrypted;
			
			SET @CUST_ModifiedBy = Libertypower.dbo.ufn_GetUserId(@w_username, 0);
			SET @CUST_CreatedBy = Libertypower.dbo.ufn_GetUserId(@w_username, 0);
				
			/*
			Removed to lax the requirements of address and so forth , by Eric 12/13/2011			
			
			IF @CUST_ContactID IS NULL OR @CUST_ContactID = 0 OR @CUST_ContactID = -1
				RAISERROR('@CUST_ContactID IS NULL, cannot continue AccountInsteadOfTrigger',11,1)
			
			IF @CUST_AddressID IS NULL OR @CUST_AddressID = 0 OR @CUST_AddressID = -1
				RAISERROR('@CUST_AddressID IS NULL, cannot continue AccountInsteadOfTrigger',11,1)
			
			IF @CUST_OwnerNameID IS NULL OR @CUST_OwnerNameID = 0 OR @CUST_OwnerNameID = -1
				RAISERROR('@CUST_OwnerNameID IS NULL, cannot continue AccountInsteadOfTrigger',11,1)
			
			IF @CUST_NameID IS NULL OR @CUST_NameID = 0 OR @CUST_NameID = -1
				RAISERROR('@CUST_NameID IS NULL, cannot continue AccountInsteadOfTrigger',11,1)
			
			IF @CUST_CustomerID IS NULL OR @CUST_CustomerID = 0 OR @CUST_CustomerID = -1
				RAISERROR('@CUST_CustomerID IS NULL, cannot continue AccountInsteadOfTrigger',11,1)
			*/
			EXECUTE [Libertypower].[dbo].[usp_CustomerUpdate] 
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
				  ,@CUST_ModifiedBy,1
			;
			
		END -- END Customer
		
		-- ===============================================================================================================================================================
		--  WHILE LOOP FOOTER
		-- ===============================================================================================================================================================
		-- Try to get the next record
		FETCH NEXT FROM inserted_cursor 
		INTO @w_account_id  
		  , @w_account_number
		  , @w_account_type 
		  , @w_status 
		  , @w_sub_status 
		  , @w_customer_id 
		  , @w_entity_id 
		  , @w_contract_nbr  
		  , @w_contract_type 
		  , @w_retail_mkt_id 
		  , @w_utility_id 
		  , @w_product_id 
		  , @w_rate_id 
		  , @w_rate 
		  , @w_account_name_link 
		  , @w_customer_name_link 
		  , @w_customer_address_link 
		  , @w_customer_contact_link 
		  , @w_billing_address_link 
		  , @w_billing_contact_link 
		  , @w_owner_name_link 
		  , @w_service_address_link 
		  , @w_business_type 
		  , @w_business_activity 
		  , @w_additional_id_nbr_type 
		  , @w_additional_id_nbr 
		  , @w_contract_eff_start_date 
		  , @w_term_months 
		  , @w_date_end  
		  , @w_date_deal 
		  , @w_date_created 
		  , @w_date_submit 
		  , @w_sales_channel_role 
		  , @w_username  
		  , @w_sales_rep 
		  , @w_origin 
		  , @w_annual_usage 
		  , @w_date_flow_start 
		  , @w_date_por_enrollment 
		  , @w_date_deenrollment 
		  , @w_date_reenrollment 
		  , @w_tax_status 
		  , @w_tax_rate 
		  , @w_credit_score 
		  , @w_credit_agency 
		  , @w_por_option 
		  , @w_billing_type 
		  , @w_chgstamp 
		  , @w_usage_req_status 
		  , @w_Created 
		  , @w_CreatedBy 
		  , @w_Modified 
		  , @w_ModifiedBy 
		  , @w_rate_code 
		  , @w_zone 
		  , @w_service_rate_class 
		  , @w_stratum_variable 
		  , @w_billing_group 
		  , @w_icap 
		  , @w_tcap 
		  , @w_load_profile
		  , @w_loss_code 
		  , @w_meter_type 
		  , @w_requested_flow_start_date 
		  , @w_deal_type 
		  , @w_enrollment_type 
		  , @w_customer_code 
		  , @w_customer_group 
		  , @w_AccountID 
		  , @w_SSNClear 
		  , @w_SSNEncrypted 
		  , @w_CreditScoreEncrypted 
		  , @w_HeatIndexSourceID 
		  , @w_HeatRate 
		  , @w_evergreen_option_id 
		  , @w_evergreen_commission_end 
		  , @w_residual_option_id 
		  , @w_residual_commission_end 
		  , @w_initial_pymt_option_id 
		  , @w_sales_manager 
		  , @w_evergreen_commission_rate 
		  , @w_original_tax_designation
		;
	END -- THIS IS THE WHILE FOR THE CURSOR
	
	CLOSE inserted_cursor;
	DEALLOCATE inserted_cursor;

	PRINT 'End of update record for account';

END





GO


