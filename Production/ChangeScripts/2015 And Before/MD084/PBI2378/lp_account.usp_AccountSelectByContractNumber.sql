USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountSelectByContractNumber]    Script Date: 11/02/2012 10:41:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
* usp_AccountSelectByContractNumber
* Get account data
*
* History
*******************************************************************************
* 5/27/2009 - Rick Deigsler
* Created.
* 1/22/2010 - Antonio Jr
* Inserted select to bring renewal accounts
*******************************************************************************
* 2/2/2012 - Thiago Nogueira
* Refactoring to new tables
*******************************************************************************
* 5/27/2009 - Cathy Ghazal
* Modified 11/2/2012
* use vw_AccountContractRate instead of AccountContractRate and fix Left join to AccountContractRate for isContractedRate =0
*******************************************************************************
usp_AccountSelectByContractNumber 'Cathy160', '0'
*/
ALTER PROCEDURE [dbo].[usp_AccountSelectByContractNumber]
(@ContractNumber varchar(50),
@GetRenewal char(1) = 'N')
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Temp table for speed boost
	SELECT *
	INTO #Contract
	FROM LibertyPower..Contract (NOLOCK)
	WHERE Number = @ContractNumber
	
	SELECT A.*
	INTO #Account
	FROM LibertyPower..Account A WITH (NOLOCK)
	JOIN LibertyPower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND (A.CurrentContractID = AC.ContractID OR (A.CurrentRenewalContractID = AC.ContractID AND @GetRenewal = 'Y'))
	JOIN #Contract C WITH (NOLOCK) ON AC.ContractID = C.ContractID
	
	SELECT AC.*
	INTO #AccountContract
	FROM LibertyPower..Account A WITH (NOLOCK)
	JOIN LibertyPower..AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND (A.CurrentContractID = AC.ContractID OR (A.CurrentRenewalContractID = AC.ContractID AND @GetRenewal = 'Y'))
	JOIN #Contract C WITH (NOLOCK) ON AC.ContractID = C.ContractID
	
	SELECT	DISTINCT
			C.Number AS contract_nbr,
			A.AccountIdLegacy AS account_id,
			A.AccountNumber AS account_number,
			CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType END AS account_type,
			CASE WHEN (ACS.[Status] = '05000' AND A.CurrentRenewalContractID = AC.ContractID) THEN '07000'
			WHEN C.ContractStatusID = 2 THEN '07000'
			ELSE ACS.[Status] END AS [status] ,
			CASE WHEN ACS.[Status] = '05000' THEN '20'
			WHEN C.ContractStatusID = 2 THEN '80'
			ELSE ACS.SubStatus END AS sub_status ,
			A.CustomerIdLegacy AS customer_id,
			A.EntityID AS entity_id,
			CASE WHEN UPPER(CT.[Type]) = 'VOICE' THEN UPPER(CT.[Type]) + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END
			WHEN CTT.ContractTemplateTypeID = 2 THEN 'CORPORATE' + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END -- id 2: custom template
			WHEN UPPER(CT.[Type]) = 'PAPER' THEN UPPER(CT.[Type]) + CASE WHEN UPPER(CDT.DealType) = 'RENEWAL' THEN ' RENEWAL' ELSE '' END
			WHEN UPPER(CT.[Type]) = 'EDI' THEN 'POWER MOVE'
			ELSE UPPER(CT.[Type]) END AS contract_type,
			M.MarketCode AS retail_mkt_id,
			U.UtilityCode AS utility_id,
			CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS product_id,
			CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID ELSE AC_DefaultRate.RateID END AS rate_id,
			CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate ELSE AC_DefaultRate.Rate END AS rate,
			ISNULL(AddConNam.account_name_link,0) AS account_name_link,
			ISNULL(AddConNam.customer_name_link,0) AS customer_name_link,
			ISNULL(AddConNam.customer_address_link,0) AS customer_address_link,
			ISNULL(AddConNam.customer_contact_link,0) AS customer_contact_link,
			ISNULL(AddConNam.billing_address_link,0) AS billing_address_link,
			ISNULL(AddConNam.billing_contact_link,0) AS billing_contact_link,
			ISNULL(AddConNam.owner_name_link,0) AS owner_name_link,
			ISNULL(AddConNam.service_address_link,0) AS service_address_link,
			LEFT(UPPER(isnull(BT.[Type],'NONE')),35) AS business_type,
			LEFT(UPPER(isnull(BA.Activity,'NONE')),35) AS business_activity,
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
			ISNULL(USAGE.AnnualUsage, 0) AS annual_usage,
			LibertyPower.dbo.ufn_GetLegacyFlowStartDate(ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate ) date_flow_start,
			AC.SendEnrollmentDate,
			LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (ACS.[Status], ACS.[SubStatus], ASERVICE.EndDate ) date_deenrollment,
			CAST('1900-01-01 00:00:00' AS DATETIME) AS date_reenrollment,
			UPPER(TAX.[Status]) AS tax_status,
			CAST(0 AS INT) AS tax_rate,
			CAST(0 AS INT) AS credit_score,
			CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END AS credit_agency,
			CASE WHEN A.PorOption = 1 THEN 'YES' ELSE 'NO' END AS por_option,
			BILLTYPE.[Type] AS billing_type,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_01_value ELSE B1.field_01_value END AS field_01_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_02_value ELSE B1.field_02_value END AS field_02_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_03_value ELSE B1.field_03_value END AS field_03_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN ISNULL(B2.field_04_value,'') ELSE ISNULL(B1.field_04_value,'') END AS field_04_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_05_value ELSE B1.field_05_value END AS field_05_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_06_value ELSE B1.field_06_value END AS field_06_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_07_value ELSE B1.field_07_value END AS field_07_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_08_value ELSE B1.field_08_value END AS field_08_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_09_value ELSE B1.field_09_value END AS field_09_value,
			CASE WHEN A.CurrentRenewalContractID = AC.ContractID THEN B2.field_10_value ELSE B1.field_10_value END AS field_10_value,
			A.BillingGroup AS billing_group,
			A.zone, A.LoadProfile, AddConNam.account_name_link As BusinessName,
			A.ServiceRateClass AS RateClass, ACR2.RateCode, A.AccountID, C.ContractID, A.StratumVariable
	FROM	#Account A WITH (NOLOCK)
	JOIN	#AccountContract AC WITH (NOLOCK) ON A.AccountID = AC.AccountID AND (A.CurrentContractID = AC.ContractID OR (A.CurrentRenewalContractID = AC.ContractID AND @GetRenewal = 'Y'))
	JOIN	#Contract C WITH (NOLOCK) ON AC.ContractID = C.ContractID
	JOIN	LibertyPower.dbo.AccountType AT WITH (NOLOCK) ON A.AccountTypeID = AT.ID
	JOIN	LibertyPower.dbo.Utility U WITH (NOLOCK) ON A.UtilityID = U.ID
	JOIN	LibertyPower.dbo.Market M WITH (NOLOCK) ON A.RetailMktID = M.ID
	JOIN	LibertyPower.dbo.AccountStatus ACS WITH (NOLOCK) ON AC.AccountContractID = ACS.AccountContractID
	JOIN	LibertyPower.dbo.ContractType CT WITH (NOLOCK) ON C.ContractTypeID = CT.ContractTypeID
	JOIN	LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
		
	--LEFT	JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK) ON AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later
	-- NEW DEFAULT RATE JOIN:
	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
			   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
			   WHERE ACRR.IsContractedRate = 0 
			   GROUP BY ACRR.AccountContractID
			  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
	LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
	 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
	-- END NEW DEFAULT RATE JOIN:
	
	
	JOIN	LibertyPower.dbo.Customer CUST WITH (NOLOCK) ON A.CustomerID = CUST.CustomerID
	JOIN	LibertyPower.dbo.ContractTemplateType CTT WITH (NOLOCK) ON C.ContractTemplateID= CTT.ContractTemplateTypeID
	LEFT	JOIN LibertyPower.dbo.BusinessType BT WITH (NOLOCK) ON CUST.BusinessTypeID = BT.BusinessTypeID
	LEFT	JOIN LibertyPower.dbo.BusinessActivity BA WITH (NOLOCK) ON CUST.BusinessActivityID = BA.BusinessActivityID
	LEFT	JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK) ON C.SalesChannelID = SC.ChannelID
	LEFT	JOIN LibertyPower.dbo.TaxStatus TAX WITH (NOLOCK) ON A.TaxStatusID = TAX.TaxStatusID
	LEFT	JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK) ON CUST.CreditAgencyID = CA.CreditAgencyID
	LEFT	JOIN LibertyPower.dbo.BillingType BILLTYPE WITH (NOLOCK) ON A.BillingTypeID = BILLTYPE.BillingTypeID
	LEFT	JOIN LibertyPower.dbo.ContractDealType CDT WITH (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID
	JOIN	LibertyPower.dbo.AccountUsage USAGE WITH (NOLOCK) ON A.AccountID = USAGE.AccountID AND C.StartDate = USAGE.EffectiveDate
	LEFT	JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID
	LEFT	JOIN lp_account.dbo.[vw_AccountAddressNameContactIds] AddConNam ON A.AccountID = AddConNam.AccountID
	LEFT	JOIN LibertyPower.dbo.[User] USER1 WITH (NOLOCK) ON C.CreatedBy = USER1.UserID
	LEFT	JOIN account_additional_info B1 WITH (NOLOCK) ON A.AccountIdLegacy = B1.account_id
	LEFT	JOIN account_renewal_additional_info B2 WITH (NOLOCK) ON A.AccountIdLegacy = B2.account_id
	
	SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
