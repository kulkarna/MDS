use lp_account
go
 /*******************************************************************************
 * <9/19/2013> - <Rafael Vasques>
 * Changing the view to use the new case looking for the new table, and also adding the new table join.
 * It 121 Release 2
 *******************************************************************************
 */
 alter VIEW [dbo].[account_renewal]      
AS      
      
SELECT  DISTINCT         
  A.AccountID AS AccountID_key,       
  C.ContractID AS ContractID_key,       
  AC.AccountContractID AS AccountContractID_key,       
  A.AccountIdLegacy AS account_id,       
        A.AccountNumber AS account_number,
		--#Rafael Vasques it 121 Change #Begin       
  -- AT.AccountType AS account_type,      
    CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END AS account_type,       
    ------## CASE WHEN ACS.[Status] in ('05000', '999998') THEN '07000'      
    ------## WHEN C.ContractStatusID = 2 THEN '07000'       
    ------## ELSE ACS.[Status] END AS [status],       
    ------##    CASE WHEN ACS.[Status] = '05000' THEN '20'       
    ------## WHEN ACS.[Status] = '999998' THEN '80'      
    ------## WHEN C.ContractStatusID = 2 THEN '80'       
    ------## ELSE ACS.SubStatus END AS sub_status,       
  -- ACS.[Status] AS [status],      
  --ACS.SubStatus AS sub_status,    
  CASE WHEN C.ContractStatusID = 2 THEN '07000'    
  when ac.AccountContractStatusID in (2,3) then '07000'    
  when AC.AccountContractStatusID = 1 then '01000'  
   end as [status],      
    Case when ((ac.AccountContractStatusID =2 and asq.EdiStatus = 1) or ac.AccountContractStatusID =1 ) then '10'    
    --when (ac.AccountContractStatusID =2 and asq.EdiStatus = 2) then '20'    
    when (ac.AccountContractStatusID =2 and (asq.EdiStatus = 2 OR asq.EDIStatus is null)) then '20'  
    when (ac.AccountContractStatusID =3 and ac.AccountContractStatusReasonID = 2) then '80'    
    when (ac.AccountContractStatusID =3 and ac.AccountContractStatusReasonID = 1) then '90'    
    end as sub_status,        
	--#Rafael Vasques it 121 Change #End
        A.CustomerIdLegacy AS customer_id,      
        A.EntityID AS entity_id,       
        C.Number AS contract_nbr,       
        CASE WHEN UPPER(CT.[Type]) = 'VOICE' THEN UPPER(CT.[Type]) + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END       
    WHEN CTT.ContractTemplateTypeID = 2 THEN 'CORPORATE' + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END -- id 2: custom template      
    WHEN UPPER(CT.[Type]) = 'PAPER' THEN UPPER(CT.[Type]) + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END       
    WHEN UPPER(CT.[Type]) = 'EDI' THEN 'POWER MOVE'       
    ELSE UPPER(CT.[Type]) END AS contract_type,       
  M.MarketCode AS retail_mkt_id,       
  U.UtilityCode AS utility_id,       
  -- CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id,      
  ACR2.LegacyProductID AS product_id,      
  --CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID ELSE AC_DefaultRate.RateID END AS rate_id,      
  ACR2.RateID AS rate_id,        
  -- CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate ELSE AC_DefaultRate.Rate END AS rate,      
  ACR2.Rate AS rate,       
        ISNULL(AddConNam.account_name_link, 0) AS account_name_link,       
        ISNULL(AddConNam.customer_name_link, 0) AS customer_name_link,       
        ISNULL(AddConNam.customer_address_link, 0) AS customer_address_link,       
        ISNULL(AddConNam.customer_contact_link, 0) AS customer_contact_link,       
        ISNULL(AddConNam.billing_address_link, 0) AS billing_address_link,       
        ISNULL(AddConNam.billing_contact_link, 0) AS billing_contact_link,       
        ISNULL(AddConNam.owner_name_link, 0) AS owner_name_link,       
        ISNULL(AddConNam.service_address_link, 0) AS service_address_link,       
        LEFT(UPPER(ISNULL(BT.[Type], 'NONE')), 35) AS business_type,       
        LEFT(UPPER(ISNULL(BA.Activity, 'NONE')), 35) AS business_activity,       
        CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN 'DUNSNBR'       
    WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN 'EMPLID'       
    WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN 'TAX ID'       
    ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN 'SSN'       
    ELSE 'NONE' END END AS additional_id_nbr_type,      
  CASE WHEN LTRIM(RTRIM(CUST.Duns)) <> '' THEN CUST.Duns       
    WHEN LTRIM(RTRIM(CUST.EmployerId)) <> '' THEN CUST.EmployerId       
    WHEN LTRIM(RTRIM(CUST.TaxId)) <> '' THEN CUST.TaxId       
    ELSE CASE WHEN CUST.SsnEncrypted IS NOT NULL AND CUST.SsnEncrypted != '' THEN '***-**-****'  ELSE 'NONE' END END AS additional_id_nbr,      
        ACR2.RateStart AS contract_eff_start_date,      
  --CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term ELSE AC_DefaultRate.Term END AS term_months,      
        ACR2.Term AS term_months,      
  --CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd ELSE AC_DefaultRate.RateEnd END AS date_end,      
        ACR2.RateEnd AS date_end,      
        ---------------------------------------------------------------------------      
        --MD084 PBI0999      
  ACR2.CurrentTerm,      
  ACR2.CurrentRateStart,      
  ACR2.CurrentRateEnd,      
  PB.ProductBrandID,      
  PB.Name as ProductBrandName,      
  PB.IsMultiTerm,      
  ---------------------------------------------------------------------------      
        C.SignedDate AS date_deal,       
        A.DateCreated AS date_created,       
        C.SubmitDate AS date_submit,       
        'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role,       
        USER1.UserName AS username,       
        C.SalesRep AS sales_rep,       
        A.Origin AS origin,       
        USAGE.AnnualUsage AS annual_usage,       
  ISNULL(ASERVICE.StartDate, CAST('1900-01-01 00:00:00' AS DATETIME)) AS date_flow_start,       
  AC.SendEnrollmentDate AS date_por_enrollment,       
        ISNULL(ASERVICE.EndDate, CAST('1900-01-01 00:00:00' AS DATETIME)) AS date_deenrollment,       
        CAST('1900-01-01 00:00:00' AS DATETIME) AS date_reenrollment,       
        UPPER(TAX.[Status]) AS tax_status,       
        CAST(0 AS INT) AS tax_rate, --TODO      
        CAST(0 AS INT) AS credit_score, --TODO      
        CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END AS credit_agency,       
  CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END AS por_option,       
  BILLTYPE.[Type] AS billing_type,       
  CAST(0 AS INT) AS chgstamp, -- TODO this column      
  ACR2.RateCode AS rate_code,      
        CUST.SsnClear AS SSNClear,      
        CUST.SsnEncrypted AS SSNEncrypted,       
        CUST.CreditScoreEncrypted AS CreditScoreEncrypted,       
        ACC.EvergreenOptionID AS evergreen_option_id,       
  ACC.EvergreenCommissionEnd AS evergreen_commission_end,       
  ACC.ResidualOptionID AS residual_option_id,       
        ACC.ResidualCommissionEnd AS residual_commission_end,       
        ACC.InitialPymtOptionID AS initial_pymt_option_id,       
        ManagerUser.Firstname + ' ' + ManagerUser.Lastname AS sales_manager,       
        ACC.EvergreenCommissionRate AS evergreen_commission_rate,       
        ACR2.PriceID      
FROM    LibertyPower.dbo.Account A WITH (NOLOCK)       
JOIN LibertyPower.dbo.AccountDetail DETAIL WITH (NOLOCK) ON DETAIL.AccountID = A.AccountID       
JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK)   ON A.AccountID = AC.AccountID  AND A.CurrentRenewalContractID = AC.ContractID       
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2  ON AC.AccountContractID = ACR2.AccountContractID --AND  ACR2.IsContractedRate=1       
left join libertypower..AccountSubmissionQueue asq with(nolock) on asq.AccountContractRateID = acr2.AccountContractRateID    
LEFT JOIN LibertyPower.dbo.Price P WITH (NOLOCK)    ON P.ID=ACR2.PriceID       
LEFT JOIN LibertyPower.dbo.ProductBrand PB WITH (NOLOCK)  ON PB.ProductBrandID=P.ProductBrandID       
JOIN LibertyPower.dbo.[Contract] C WITH (NOLOCK)   ON AC.ContractID = C.ContractID       
JOIN LibertyPower.dbo.AccountContractCommission ACC WITH (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID       
--JOIN LibertyPower.dbo.AccountStatus ACS WITH (NOLOCK) ON  AC.AccountContractID = ACS.AccountContractID       
JOIN LibertyPower.dbo.ContractType CT WITH (NOLOCK) ON  C.ContractTypeID = CT.ContractTypeID       
JOIN LibertyPower.dbo.Customer CUST WITH (NOLOCK) ON  A.CustomerID = CUST.CustomerID       
JOIN LibertyPower.dbo.ContractTemplateType CTT WITH (NOLOCK) ON  C.ContractTemplateID = CTT.ContractTemplateTypeID       
JOIN LibertyPower.dbo.AccountType AT WITH (NOLOCK) ON  A.AccountTypeID = AT.ID       
JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) ON  A.UtilityID = U.ID       
JOIN LibertyPower.dbo.Market M WITH (NOLOCK) ON  A.RetailMktID = M.ID       
LEFT JOIN dbo.vw_AccountAddressNameContactIds AddConNam ON  A.AccountID = AddConNam.AccountID       
LEFT JOIN LibertyPower.dbo.BusinessType BT WITH (NOLOCK) ON  CUST.BusinessTypeID = BT.BusinessTypeID       
LEFT JOIN LibertyPower.dbo.BusinessActivity BA WITH (NOLOCK) ON  CUST.BusinessActivityID = BA.BusinessActivityID       
LEFT JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK) ON  C.SalesChannelID = SC.ChannelID       
LEFT JOIN LibertyPower.dbo.TaxStatus TAX WITH (NOLOCK) ON  A.TaxStatusID = TAX.TaxStatusID       
LEFT JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK) ON  CUST.CreditAgencyID = CA.CreditAgencyID       
LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE WITH (NOLOCK) ON  A.BillingTypeID = BILLTYPE.BillingTypeID       
LEFT JOIN LibertyPower.dbo.MeterType MT WITH (NOLOCK) ON A.MeterTypeID = MT.ID       
LEFT JOIN LibertyPower.dbo.ContractDealType CDT WITH (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID       
JOIN LibertyPower.dbo.AccountUsage USAGE WITH (NOLOCK) ON A.AccountID = USAGE.AccountID AND USAGE.EffectiveDate = C.StartDate       
JOIN LibertyPower.dbo.UsageReqStatus URS WITH (NOLOCK) ON USAGE.UsageReqStatusID = URS.UsageReqStatusID       
LEFT JOIN LibertyPower.dbo.[User] ManagerUser WITH (NOLOCK) ON C.SalesManagerID = ManagerUser.UserID       
LEFT JOIN LibertyPower.dbo.[User] USER1 WITH (NOLOCK) ON C.CreatedBy = USER1.UserID       
LEFT JOIN LibertyPower.dbo.[User] USER2 WITH (NOLOCK) ON A.ModifiedBy = USER2.UserID       
LEFT JOIN LibertyPower.dbo.[User] USER3 WITH (NOLOCK) ON A.CreatedBy = USER3.UserID       
LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON  A.AccountID = ASERVICE.AccountID     