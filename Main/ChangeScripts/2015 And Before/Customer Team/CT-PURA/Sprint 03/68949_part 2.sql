USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountExpireProdUpdByAccountId]    Script Date: 06/04/2015 18:20:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 [usp_AccountExpireProdUpdByAccountId]
 *******************************************************************************
* 7/10/2015  Sara lakshmanan
* Modified Stored procedure to use ordersAPIconfiguration Table to include CTPURA changes or not
* if CTPURA- donot insert variable rate to ACR Table
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_AccountExpireProdUpdByAccountId]  
(  
 @p_AccountId      char(12),  
 @p_DefaultExpiredProductId   char (20),  
 @p_DefaultExpiredRateId   int,  
 @p_DefaultExpiredRate    float,  
 @p_DefaultExpiredTermMonths     int,  
 @p_CalculatedEffectiveStartDate datetime,  
 @p_CalculatedEndDate    datetime  
)  
  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE @w_ista_account_number    varchar(100),  
   @w_account_number     varchar(50),  
   @w_utility_id      varchar(50),  
   @w_product_id      char(20),  
   @w_product_category     varchar(20),  
   @w_product_sub_category    varchar(50),  
   @w_default_product_category   varchar(20),  
   @w_default_product_sub_category  varchar(50),  
   @w_full_name      varchar(100),  
   @w_error       varchar(5),  
   @w_deutsche_bank_group_name   varchar(100),  
   @w_rate        float,  
   @w_rate_code      varchar(50),  
   @w_rate_id int,
   @w_contract_eff_start_date_previous datetime,  
   @w_date_end_previous    datetime,  
   @p_timestamp      datetime,
   @w_account_type varchar(50),
   @w_status varchar(15),
   @w_sub_status varchar(15), 
   @w_customer_id varchar(10),
   @w_entity_id char(15),
   @w_contract_type varchar(25),
   @w_retail_mkt_id varchar(2),
   @w_account_name_link int, 
   @w_customer_name_link int,
   @w_customer_address_link int, 
   @w_customer_contact_link int,   
   @w_billing_address_link int, 
   @w_billing_contact_link int, 
   @w_owner_name_link int, 
   @w_service_address_link int,
   @w_business_type varchar(50),
   @w_business_activity varchar(50),
   @w_additional_id_nbr_type varchar(50),
   @w_additional_id_nbr varchar(50),
   @w_term_months int,
   @w_date_deal datetime,
   @w_date_created datetime,
   @w_date_submit datetime,
   @w_sales_channel_role varchar(100),
   @w_username varchar(100),
   @w_sales_rep varchar(64),
   @w_origin varchar(50),
   @w_annual_usage int,
   @w_date_flow_start datetime,
   @w_date_por_enrollment datetime, 
   @w_date_deenrollment datetime,
   @w_date_reenrollment datetime,
   @w_tax_status varchar(50),
   @w_tax_rate float,
   @w_credit_score real,
   @w_credit_agency varchar(30),
   @w_por_option varchar(50),
   @w_billing_type varchar(15),
   @w_chgstamp smallint
   
 -- ====================================================================================================================================================   
 -- ACCOUNT CONTRACT RATE TABLE VARIABLES IT79  
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
 DECLARE @w_ModifiedBy VARCHAR(100);  
 DECLARE @w_contract_nbr VARCHAR(100);  
 -- END ACCOUNT CONTRACT RATE TABLE VARIABLES  
  
 SET  @w_error       = 'FALSE'  
 SET  @p_timestamp      = GETDATE()  
  
 -- find account by the given account id 
SELECT DISTINCT  
   @w_account_number = A.AccountNumber    
  ,@w_account_type = CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END      
  ,@w_status = [Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus)
  ,@w_sub_status = [Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(ACS.[Status], ACS.SubStatus)   
  ,@w_customer_id = A.CustomerIdLegacy
  ,@w_entity_id = A.EntityID  
  ,@w_contract_nbr = C.Number
  ,@w_contract_type = [Libertypower].[dbo].[ufn_GetLegacyContractType] (CT.[Type] , CTT.ContractTemplateTypeID, CDT.DealType)
  ,@w_retail_mkt_id = M.MarketCode
  ,@w_utility_id = U.UtilityCode    
  ,@w_product_id = CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END 
  ,@w_rate_id = CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID    ELSE AC_DefaultRate.RateID END
  ,@w_rate = CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate    ELSE AC_DefaultRate.Rate END  
  ,@w_full_name = n.full_name
   
  ,@w_account_name_link = isnull(AddConNam.account_name_link,0)
  ,@w_customer_name_link = isnull(AddConNam.customer_name_link,0)
  ,@w_customer_address_link = isnull(AddConNam.customer_address_link,0)
  ,@w_customer_contact_link = isnull(AddConNam.customer_contact_link,0)
  ,@w_billing_address_link = isnull(AddConNam.billing_address_link,0)
  ,@w_billing_contact_link = isnull(AddConNam.billing_contact_link,0)
  ,@w_owner_name_link = isnull(AddConNam.owner_name_link,0)
  ,@w_service_address_link = isnull(AddConNam.service_address_link,0)
    
  ,@w_business_type = left(UPPER(isnull(BT.[Type],'NONE')),35)
  ,@w_business_activity = left(UPPER(isnull(BA.Activity,'NONE')),35)
    
  ,@w_additional_id_nbr_type = LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbrType(CUST.Duns, CUST.EmployerId, CUST.TaxId, CUST.SsnEncrypted)   
  ,@w_additional_id_nbr = LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbr(CUST.Duns, CUST.EmployerId, CUST.TaxId, CUST.SsnEncrypted)
    
  ,@w_contract_eff_start_date_previous = CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart  ELSE AC_DefaultRate.RateStart END  
  ,@w_term_months = CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term  ELSE AC_DefaultRate.Term END  
  ,@w_date_end_previous = CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd ELSE AC_DefaultRate.RateEnd END
  ,@w_date_deal = C.SignedDate
  ,@w_date_created = A.DateCreated
  ,@w_date_submit = C.SubmitDate 
  ,@w_sales_channel_role = 'SALES CHANNEL/' + SC.ChannelName  
  ,@w_username = USER1.UserName 
  ,@w_sales_rep = C.SalesRep 
  ,@w_origin = A.Origin   
  ,@w_annual_usage = ISNULL(USAGE.AnnualUsage, (SELECT TOP 1 ISNULL(AnnualUsage, 0) FROM LibertyPower..AccountUsage WITH (NOLOCK) WHERE AccountID = A.AccountID ORDER BY EffectiveDate DESC))
  ,@w_date_flow_start = LibertyPower.dbo.ufn_GetLegacyFlowStartDate(ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate)
  ,@w_date_por_enrollment = AC.SendEnrollmentDate      
  ,@w_date_deenrollment = LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (ACS.[Status], ACS.[SubStatus], ASERVICE.EndDate)   
  ,@w_date_reenrollment = CAST('1900-01-01 00:00:00' AS DATETIME)
    
  ,@w_tax_status = UPPER(TAX.[Status]) 
  ,@w_tax_rate = CAST(0 AS INT)  
  ,@w_credit_score = CAST(0 AS INT)
  ,@w_credit_agency = CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END  
  ,@w_por_option = CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END
  ,@w_billing_type = BILLTYPE.[Type]
  ,@w_chgstamp = CAST(0 AS INT)

  ,@w_ModifiedBy = CASE WHEN ISNULL(USER2.UserName, '') <> '' THEN USER2.UserName  
					WHEN ISNULL(USER3.UserName, '') <> '' THEN USER3.UserName  
					ELSE 'admin' END 
  ,@w_rate_code = ACR2.RateCode
  ,@w_ista_account_number = p.CustNo 
  ,@ACR_HeatIndexSourceID = ACR2.HeatIndexSourceID
  ,@ACR_HeatRate = ACR2.HeatRate
FROM LibertyPower.dbo.Account A WITH (NOLOCK)  
JOIN LibertyPower.dbo.[Contract] C WITH (NOLOCK)    ON A.CurrentContractID = C.ContractID  
JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK)  ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID  
JOIN LibertyPower.dbo.AccountStatus ACS WITH (NOLOCK)   ON AC.AccountContractID = ACS.AccountContractID  
  
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID   
LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID   
     FROM LibertyPower.dbo.AccountContractRate ACRR WITH (NOLOCK)  
        WHERE ACRR.IsContractedRate = 0   
        GROUP BY ACRR.AccountContractID  
          ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID  
LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK)    
 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID   
JOIN LibertyPower.dbo.ContractType CT   WITH (NOLOCK) ON C.ContractTypeID = CT.ContractTypeID  
JOIN LibertyPower.dbo.Customer CUST    WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID  
JOIN LibertyPower.dbo.ContractTemplateType CTT WITH (NOLOCK) ON C.ContractTemplateID= CTT.ContractTemplateTypeID  
JOIN LibertyPower.dbo.AccountType AT   WITH (NOLOCK) ON A.AccountTypeID = AT.ID  
                            
JOIN LibertyPower.dbo.Utility U   WITH (NOLOCK)   ON A.UtilityID = U.ID  
JOIN LibertyPower.dbo.Market M   WITH (NOLOCK)   ON A.RetailMktID = M.ID  
  
LEFT JOIN lp_account.dbo.[vw_AccountAddressNameContactIds] AddConNam ON A.AccountID = AddConNam.AccountID
INNER JOIN lp_account..account_name N WITH (NOLOCK) ON A.AccountIdLegacy = N.account_id AND AddConNam.customer_name_link = n.name_link  
  
LEFT JOIN LibertyPower.dbo.BusinessType BT  WITH (NOLOCK)  ON CUST.BusinessTypeID = BT.BusinessTypeID  
LEFT JOIN LibertyPower.dbo.BusinessActivity BA WITH (NOLOCK)  ON CUST.BusinessActivityID = BA.BusinessActivityID  
LEFT JOIN LibertyPower.dbo.SalesChannel SC  WITH (NOLOCK)  ON C.SalesChannelID = SC.ChannelID  
                  
LEFT JOIN LibertyPower.dbo.TaxStatus TAX  WITH (NOLOCK)  ON A.TaxStatusID = TAX.TaxStatusID  
LEFT JOIN LibertyPower.dbo.CreditAgency CA  WITH (NOLOCK)  ON CUST.CreditAgencyID = CA.CreditAgencyID   
LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE WITH (NOLOCK)  ON A.BillingTypeID = BILLTYPE.BillingTypeID  
LEFT JOIN LibertyPower.dbo.MeterType MT   WITH (NOLOCK)  ON A.MeterTypeID = MT.ID   
LEFT JOIN LibertyPower.dbo.ContractDealType CDT  WITH (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID  
  
  
LEFT JOIN LibertyPower.dbo.AccountUsage USAGE WITH (NOLOCK)  ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate  
LEFT JOIN LibertyPower.dbo.UsageReqStatus URS WITH (NOLOCK)  ON USAGE.UsageReqStatusID = URS.UsageReqStatusID  
  
LEFT JOIN LibertyPower.dbo.[User] USER1  WITH (NOLOCK)  ON C.CreatedBy = USER1.UserID  
LEFT JOIN LibertyPower.dbo.[User] USER2  WITH (NOLOCK)  ON A.ModifiedBy = USER2.UserID  
LEFT JOIN LibertyPower.dbo.[User] USER3  WITH (NOLOCK)  ON A.CreatedBy = USER3.UserID  
LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID 

LEFT JOIN ( SELECT p.PremNo, c.CustNo FROM ISTA..Premise P WITH (NOLOCK)
			 INNER JOIN ISTA..Customer C WITH (NOLOCK) ON p.CustID = c.CustID ) P ON A.AccountNumber = p.PremNo  
WHERE A.AccountIdLegacy = @p_AccountId  
   
 BEGIN TRAN TransExpire  
  
  INSERT INTO account_history (account_id, account_number, account_type, status, sub_status, customer_id, entity_id,   
     contract_nbr, contract_type, retail_mkt_id, utility_id, product_id, rate_id, rate,   
     account_name_link, customer_name_link, customer_address_link, customer_contact_link,   
     billing_address_link, billing_contact_link, owner_name_link, service_address_link,   
     business_type, business_activity, additional_id_nbr_type, additional_id_nbr,   
     contract_eff_start_date, term_months, date_end, date_deal, date_created, date_submit,   
     sales_channel_role, username, sales_rep, origin, annual_usage, date_flow_start,   
     date_por_enrollment, date_deenrollment, date_reenrollment, tax_status, tax_rate,   
     credit_score, credit_agency, por_option, billing_type, chgstamp, date_inserted) 
  VALUES (@p_AccountId, @w_account_number, @w_account_type, @w_status, @w_sub_status, ISNULL(@w_customer_id, ''), @w_entity_id,   
     @w_contract_nbr, @w_contract_type, @w_retail_mkt_id, @w_utility_id, @w_product_id, @w_rate_id, @w_rate,   
     @w_account_name_link, @w_customer_name_link, @w_customer_address_link, @w_customer_contact_link,   
     @w_billing_address_link, @w_billing_contact_link, @w_owner_name_link, @w_service_address_link,   
     @w_business_type, @w_business_activity, @w_additional_id_nbr_type, @w_additional_id_nbr,   
     @w_contract_eff_start_date_previous, @w_term_months, @w_date_end_previous, @w_date_deal, @w_date_created, @w_date_submit,   
     @w_sales_channel_role, @w_username, @w_sales_rep, @w_origin, @w_annual_usage, @w_date_flow_start,   
     @w_date_por_enrollment, @w_date_deenrollment, @w_date_reenrollment, @w_tax_status, @w_tax_rate,   
     @w_credit_score, @w_credit_agency, @w_por_option, @w_billing_type, @w_chgstamp, @p_timestamp) 
  
  IF @@ERROR <> 0  
  BEGIN  
   SET @w_error = 'TRUE'  
   GOTO PROCESS_END  
  END  
  
  INSERT INTO account_history_auto_renewal  
  VALUES (@p_AccountId, @w_account_number, @w_account_type, @w_status, @w_sub_status, ISNULL(@w_customer_id, ''), @w_entity_id,   
     @w_contract_nbr, @w_contract_type, @w_retail_mkt_id, @w_utility_id, @w_product_id, @w_rate_id, @w_rate,   
     @w_account_name_link, @w_customer_name_link, @w_customer_address_link, @w_customer_contact_link,   
     @w_billing_address_link, @w_billing_contact_link, @w_owner_name_link, @w_service_address_link,   
     @w_business_type, @w_business_activity, @w_additional_id_nbr_type, @w_additional_id_nbr,   
     @w_contract_eff_start_date_previous, @w_term_months, @w_date_end_previous, @w_date_deal, @w_date_created, @w_date_submit,   
     @w_sales_channel_role, @w_username, @w_sales_rep, @w_origin, @w_annual_usage, @w_date_flow_start,   
     @w_date_por_enrollment, @w_date_deenrollment, @w_date_reenrollment, @w_tax_status, @w_tax_rate,   
     @w_credit_score, @w_credit_agency, @w_por_option, @w_billing_type, @w_chgstamp, @p_timestamp)
  
  IF @@ERROR <> 0  
  BEGIN  
   SET @w_error = 'TRUE'  
   GOTO PROCESS_END  
  END  
  
  -- IT79 Enter rate into the new table structure, its possible that we dont need the account table update afterwords, but left there  
  -- in case there are triggers or other dependencies on the data updated in the account table  
  -- GET THE LATEST RATE RECORD to update:  
  SELECT TOP(1)  @ACR_AccountContractID = ACR.AccountContractID,  
      @ACR_TransferRate = TransferRate,  
      @ACR_GrossMargin = GrossMargin,  
      @ACR_CommissionRate = CommissionRate,  
      @ACR_AdditionalGrossMargin = AdditionalGrossMargin  
  FROM LibertyPower.dbo.AccountContractRate ACR WITH (NOLOCK)  
  JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK) ON ACR.AccountContractID = AC.AccountContractID   
  JOIN LibertyPower.dbo.Account A WITH (NOLOCK) ON A.AccountID = AC.AccountID   
  JOIN LibertyPower.dbo.[Contract] C WITH (NOLOCK) ON AC.ContractID = C.ContractID   
  WHERE C.Number = @w_contract_nbr  
  AND  A.AccountIDLegacy  = @p_AccountId  
  ORDER BY ACR.DateCreated DESC;  
   
  IF @w_date_end_previous > @p_timestamp --TFS#36171
  BEGIN  
   SET @w_error = 'TRUE'  
   GOTO PROCESS_END  
  END 
  ELSE
  
  BEGIN
    
  SET @ACR_LegacyProductID = @p_DefaultExpiredProductId;  
  SET @ACR_Term = @p_DefaultExpiredTermMonths;  
  SET @ACR_RateID = @p_DefaultExpiredRateId;  
  SET @ACR_Rate = @p_DefaultExpiredRate;  
  SET @ACR_RateCode = @w_rate_code; -- A NULL value will no update the table and leave whatever value is there  
  SET @ACR_RateStart = @p_CalculatedEffectiveStartDate;  
  SET @ACR_RateEnd = @p_CalculatedEndDate;  
  SET @ACR_IsContractedRate = 0; -- This is not a contracted rate  
  SET @ACR_ModifiedBy = LibertyPower.dbo.ufn_GetUserId(@w_ModifiedBy, 0);  
    
  ---
  --- PHH 5/21/2015 - The follow check is for PURA accounts.  If this is a residental or home office 
  ---                 we don't register the VAR into ACR.  This will have already been done by the VRE.
  ---                 IF MORE PURA STATES ARE ADDED, then this if statement will need to be extended.
  ---

  Declare  @IsCTPura bit=0 ;
  SET @IsCTPura= (SELECT ISCTPURA FROM LIbertypower..OrdersAPIConfiguration )

IF not (@IsCTPura=1) or   not ((RTRIM(@w_account_type) = 'RESIDENTIAL' OR RTRIM(@w_account_type) = 'SOHO') and (RTRIM(@w_utility_id) = 'CL&P' OR RTRIM(@w_utility_id) = 'UI'))  
   BEGIN
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
			 ,@ACR_ModifiedBy -- added new parameter CreatedBy  
			 ,@ACR_ModifiedBy ,1;  
   END
  
  
  -- END IT79 changes  
    
   --PRINT @w_ModifiedBy;  
  --UPDATE account  
  --SET  product_id    = @p_DefaultExpiredProductId,   
  --  rate_id     = @p_DefaultExpiredRateId,   
  --  rate     = @p_DefaultExpiredRate,  
  --  term_months    = @p_DefaultExpiredTermMonths,  
  --  date_end    = @p_CalculatedEndDate,  
  --  contract_eff_start_date = @p_CalculatedEffectiveStartDate,  
  --  ModifiedBy    = @w_ModifiedBy -- IT79 change  
  --WHERE account_id    = @p_AccountId  
  
  IF @@ERROR <> 0  
  BEGIN  
   SET @w_error = 'TRUE'  
   GOTO PROCESS_END  
  END  
  
  -- get product category for current product  
  SELECT @w_product_category = LTRIM(RTRIM(product_category)), @w_product_sub_category = ISNULL(product_sub_category, '')  
  FROM lp_common..common_product  
  WHERE product_id = @w_product_id  
  
  -- get product category for default product  
  SELECT @w_default_product_category = LTRIM(RTRIM(product_category)), @w_default_product_sub_category = ISNULL(product_sub_category, '')  
  FROM lp_common..common_product  
  WHERE product_id = @p_DefaultExpiredProductId  
    
  -- if going from fixed to variable, insert into queue for billing service  
  IF @w_product_category = 'FIXED' AND @w_default_product_category = 'VARIABLE'  
  BEGIN  
     
   INSERT INTO account_auto_renewal_queue  
   VALUES (@p_AccountId, @w_account_number, @w_account_type, @w_status, @w_sub_status, ISNULL(@w_customer_id, ''), @w_entity_id,   
     @w_contract_nbr, @w_contract_type, @w_retail_mkt_id, @w_utility_id, @w_product_id, @w_rate_id, @w_rate,   
     @w_account_name_link, @w_customer_name_link, @w_customer_address_link, @w_customer_contact_link,   
     @w_billing_address_link, @w_billing_contact_link, @w_owner_name_link, @w_service_address_link,   
     @w_business_type, @w_business_activity, @w_additional_id_nbr_type, @w_additional_id_nbr,   
     @w_contract_eff_start_date_previous, @w_term_months, @w_date_end_previous, @w_date_deal, @w_date_created, @w_date_submit,   
     @w_sales_channel_role, @w_username, @w_sales_rep, @w_origin, @w_annual_usage, @w_date_flow_start,   
     @w_date_por_enrollment, @w_date_deenrollment, @w_date_reenrollment, @w_tax_status, @w_tax_rate,   
     @w_credit_score, @w_credit_agency, @w_por_option, @w_billing_type, @w_chgstamp, @p_timestamp) 
     
   -- insert or update deutsche bank group  
   EXEC  usp_account_deutsche_link_ins_upd @p_AccountId  
     
   IF @@ERROR <> 0  
   BEGIN  
    SET @w_error = 'TRUE'  
    GOTO PROCESS_END  
   END  
  
   SET   @w_deutsche_bank_group_name = ISNULL(( SELECT code1   
                FROM lp_account..deutsche_bank_group WITH (NOLOCK) 
                WHERE deutsche_bank_group_id = ( SELECT MAX(deutsche_bank_group_id)  
                         FROM lp_account..account_deutsche_link WITH (NOLOCK)
                         WHERE account_id = @p_AccountId )  
              ), 'NONE')  
  
   -- SD Ticket # 5901  ------------------------------------------------------------  
   IF LEN(LTRIM(RTRIM(@w_product_sub_category))) > 0  
    SET @w_product_category = LTRIM(RTRIM(@w_product_sub_category)) + ' ' + LTRIM(RTRIM(@w_product_category))  
  
   IF LEN(LTRIM(RTRIM(@w_default_product_sub_category))) > 0  
    SET @w_default_product_category = LTRIM(RTRIM(@w_default_product_sub_category)) + ' ' + LTRIM(RTRIM(@w_default_product_category))  
  
   SET @w_full_name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@w_full_name, ',', ' '),'.', ' '), '''', ''), '&', ' and '), '/', ' '), '\', ' ')  
     
   INSERT INTO account_expired_product (ista_account_number, esiid, customer_name, rate_code, existing_plan_type,   
      new_plan_type, existing_rate, new_rate, contract_eff_start_date,   
      date_end, date_inserted)  
   VALUES  (@w_ista_account_number, @w_account_number, @w_full_name, @w_rate_code, @w_product_category,   
      @w_default_product_category, @w_rate, @p_DefaultExpiredRate,   
      @w_contract_eff_start_date_previous, @w_date_end_previous, @p_timestamp)  
  
   IF @@ERROR <> 0  
   BEGIN  
    SET @w_error = 'TRUE'  
   END  
  -- End SD Ticket # 5901  --------------------------------------------------------  
  END   
 END
   
 PROCESS_END:  
 IF @w_error = 'TRUE'  
 BEGIN  
  ROLLBACK TRAN TransExpire  
 END  
 ELSE  
 BEGIN  
  COMMIT TRAN TransExpire  
  
  EXEC usp_AccountExpiredProductLogInsert @AccountId = @p_AccountId,  
    @DateEndPrevious = @w_date_end_previous, @DateEndCurrent = @p_CalculatedEndDate,   
    @Status = 0  
 END  
   
 SET NOCOUNT OFF  
  
END  