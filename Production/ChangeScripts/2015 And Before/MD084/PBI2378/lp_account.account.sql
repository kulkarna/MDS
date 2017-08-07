USE Lp_Account
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[account]
AS
--SELECT *
--FROM lp_account.dbo.account_bak;
SELECT DISTINCT
A.AccountID AS AccountID_key,
C.ContractID AS ContractID_key,
AC.AccountContractID AS AccountContractID_key,
A.AccountIdLegacy AS account_id,
A.AccountNumber AS account_number,
CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END AS account_type,
[Libertypower].[dbo].ufn_GetLegacyAccountStatus(ACS.[Status], ACS.SubStatus) AS [Status] ,
[Libertypower].[dbo].ufn_GetLegacyAccountSubStatus(ACS.[Status], ACS.SubStatus) AS sub_status ,
A.CustomerIdLegacy AS customer_id,
A.EntityID AS entity_id,
C.Number AS contract_nbr,
[Libertypower].[dbo].[ufn_GetLegacyContractType] ( CT.[Type] , CTT.ContractTemplateTypeID, CDT.DealType) AS contract_type,
M.MarketCode AS retail_mkt_id,
U.UtilityCode AS utility_id,
CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id,
CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID ELSE AC_DefaultRate.RateID END AS rate_id,
CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate ELSE AC_DefaultRate.Rate END AS rate,
isnull(AddConNam.account_name_link,0) AS account_name_link,
isnull(AddConNam.customer_name_link,0) AS customer_name_link,
isnull(AddConNam.customer_address_link,0) AS customer_address_link,
isnull(AddConNam.customer_contact_link,0) AS customer_contact_link,
isnull(AddConNam.billing_address_link,0) AS billing_address_link,
isnull(AddConNam.billing_contact_link,0) AS billing_contact_link,
isnull(AddConNam.owner_name_link,0) AS owner_name_link,
isnull(AddConNam.service_address_link,0) AS service_address_link,
left(UPPER(isnull(BT.[Type],'NONE')),35) AS business_type,
left(UPPER(isnull(BA.Activity,'NONE')),35) AS business_activity,
LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbrType(CUST.Duns, CUST.EmployerId, CUST.TaxId, CUST.SsnEncrypted ) additional_id_nbr_type,
LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbr(CUST.Duns, CUST.EmployerId, CUST.TaxId, CUST.SsnEncrypted ) additional_id_nbr,
CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart ELSE AC_DefaultRate.RateStart END AS contract_eff_start_date,
CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term ELSE AC_DefaultRate.Term END AS term_months,
CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd ELSE AC_DefaultRate.RateEnd END AS date_end,
C.SignedDate AS date_deal,
A.DateCreated AS date_created,
C.SubmitDate AS date_submit,
'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role,
USER1.UserName AS username,
C.SalesRep AS sales_rep,
A.Origin AS origin,
ISNULL(USAGE.AnnualUsage,0) AS annual_usage,
LibertyPower.dbo.ufn_GetLegacyFlowStartDate(ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate ) date_flow_start,
-- ASERVICE.StartDate,
AC.SendEnrollmentDate AS date_por_enrollment,
LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (ACS.[Status], ACS.[SubStatus], ASERVICE.EndDate ) date_deenrollment,
CAST('1900-01-01 00:00:00' AS DATETIME) AS date_reenrollment,
UPPER(TAX.[Status]) AS tax_status,
CAST(0 AS INT) AS tax_rate, --TODO
CAST(0 AS INT) AS credit_score, -- TODO
CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END AS credit_agency,
CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END AS por_option,
BILLTYPE.[Type] AS billing_type,
CAST(0 AS INT) AS chgstamp, -- TODO this column
CASE WHEN UPPER(URS.[Status]) = 'NONE' THEN NULL ELSE UPPER(URS.[Status]) END AS usage_req_status,
A.DateCreated AS Created,
USER3.UserName AS CreatedBy,
A.Modified AS Modified,
ISNULL(USER2.UserName,'') AS ModifiedBy,
ACR2.RateCode AS rate_code,
A.Zone AS zone,
A.ServiceRateClass AS service_rate_class,
A.StratumVariable AS stratum_variable,
A.BillingGroup AS billing_group,
A.Icap AS icap,
A.Tcap AS tcap,
A.LoadProfile AS load_profile,
A.LossCode AS loss_code,
MT.MeterTypeCode AS meter_type,
AC.RequestedStartDate AS requested_flow_start_date,
CDT.DealType AS deal_type,
DETAIL.EnrollmentTypeID AS enrollment_type,
CAST('' AS VARCHAR(10)) AS customer_code,
CAST('' AS VARCHAR(10)) AS customer_group,
A.AccountID AS AccountID,
CUST.SsnClear AS SSNClear,
CUST.SsnEncrypted AS SSNEncrypted,
CUST.CreditScoreEncrypted AS CreditScoreEncrypted,
ACR2.HeatIndexSourceID AS HeatIndexSourceID,
ACR2.HeatRate AS HeatRate,
ACC.EvergreenOptionID AS evergreen_option_id,
ACC.EvergreenCommissionEnd AS evergreen_commission_end,
ACC.ResidualOptionID AS residual_option_id,
ACC.ResidualCommissionEnd AS residual_commission_end,
ACC.InitialPymtOptionID AS initial_pymt_option_id,
ManagerUser.Firstname + ' ' + ManagerUser.Lastname AS sales_manager,
ACC.EvergreenCommissionRate AS evergreen_commission_rate,
DETAIL.OriginalTaxDesignation AS original_tax_designation,
ACR2.PriceID
FROM LibertyPower.dbo.Account A WITH (NOLOCK)
JOIN LibertyPower.dbo.AccountDetail DETAIL WITH (NOLOCK) ON DETAIL.AccountID = A.AccountID
JOIN LibertyPower.dbo.[Contract] C WITH (NOLOCK) ON A.CurrentContractID = C.ContractID
JOIN LibertyPower.dbo.AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID
JOIN LibertyPower.dbo.AccountContractCommission ACC WITH (NOLOCK) ON AC.AccountContractID = ACC.AccountContractID
JOIN LibertyPower.dbo.AccountStatus ACS WITH (NOLOCK) ON AC.AccountContractID = ACS.AccountContractID
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
--LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate
--WITH (NOLOCK) ON AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0
-- NEW DEFAULT RATE JOIN:
LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID
FROM LibertyPower.dbo.AccountContractRate ACRR WITH (NOLOCK)
WHERE ACRR.IsContractedRate = 0
GROUP BY ACRR.AccountContractID
) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK)
ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID
-- END NEW DEFAULT RATE JOIN:
JOIN LibertyPower.dbo.ContractType CT WITH (NOLOCK) ON C.ContractTypeID = CT.ContractTypeID
JOIN LibertyPower.dbo.Customer CUST WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID
JOIN LibertyPower.dbo.ContractTemplateType CTT WITH (NOLOCK) ON C.ContractTemplateID= CTT.ContractTemplateTypeID
JOIN LibertyPower.dbo.AccountType AT WITH (NOLOCK) ON A.AccountTypeID = AT.ID
JOIN LibertyPower.dbo.Utility U WITH (NOLOCK) ON A.UtilityID = U.ID
JOIN LibertyPower.dbo.Market M WITH (NOLOCK) ON A.RetailMktID = M.ID
LEFT JOIN lp_account.dbo.[vw_AccountAddressNameContactIds] AddConNam ON A.AccountID = AddConNam.AccountID -- this way boosts 100ms less
LEFT JOIN LibertyPower.dbo.BusinessType BT WITH (NOLOCK) ON CUST.BusinessTypeID = BT.BusinessTypeID
LEFT JOIN LibertyPower.dbo.BusinessActivity BA WITH (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID
LEFT JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK) ON C.SalesChannelID = SC.ChannelID
LEFT JOIN LibertyPower.dbo.TaxStatus TAX WITH (NOLOCK) ON A.TaxStatusID = TAX.TaxStatusID
LEFT JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK) ON CUST.CreditAgencyID = CA.CreditAgencyID
LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE WITH (NOLOCK) ON A.BillingTypeID = BILLTYPE.BillingTypeID
LEFT JOIN LibertyPower.dbo.MeterType MT WITH (NOLOCK) ON A.MeterTypeID = MT.ID
LEFT JOIN LibertyPower.dbo.ContractDealType CDT WITH (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID
JOIN LibertyPower.dbo.AccountUsage USAGE WITH (NOLOCK) ON A.AccountID = USAGE.AccountID AND C.StartDate = USAGE.EffectiveDate
JOIN LibertyPower.dbo.UsageReqStatus URS WITH (NOLOCK) ON USAGE.UsageReqStatusID = URS.UsageReqStatusID
LEFT JOIN LibertyPower.dbo.[User] ManagerUser WITH (NOLOCK) ON C.SalesManagerID = ManagerUser.UserID
LEFT JOIN LibertyPower.dbo.[User] USER1 WITH (NOLOCK) ON C.CreatedBy = USER1.UserID
LEFT JOIN LibertyPower.dbo.[User] USER2 WITH (NOLOCK) ON A.ModifiedBy = USER2.UserID
LEFT JOIN LibertyPower.dbo.[User] USER3 WITH (NOLOCK) ON A.CreatedBy = USER3.UserID
LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
--LEFT JOIN (
--select account_id, StartDate, EndDate, ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY StartDate DESC, EndDate DESC) AS rownum
-- from Libertypower.dbo.AccountService (NOLOCK)
--) ASERVICE ON A.AccountIdLegacy = ASERVICE.account_id and ASERVICE.rownum = 1
GO
