USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountByAccountIdSelect]    Script Date: 11/02/2012 09:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
* usp_AccountByAccountIdSelect
* Get account data by account id
*
* History
*******************************************************************************
* 5/27/2009 - Rick Deigsler
* Created.
*******************************************************************************
* 1/22/2010 - Eric Hernandez
* Modified code so that it can find an account by the new or legacy account ID.
*******************************************************************************
* 5/17/2011 - Sofia Melo
* Added field usage_req_status to select clause
*******************************************************************************
* 1/24/2012 - Jaime Forero
* Refactored for IT79 new db schema
*******************************************************************************
TEST CASES:
First we need to find some dummy Acount ids:
SELECT TOP(100) * FROM LibertyPower..Account WHERE CurrentContractId IS NOT NULL
EXEC LibertyPOwer..[usp_AccountByAccountIdSelect] '2007-0017633'
EXEC LibertyPOwer..[usp_AccountByAccountIdSelect] 077852004
*/

ALTER PROCEDURE [dbo].[usp_AccountByAccountIdSelect]                                                                                     
	@AccountId	char(12)
AS
BEGIN
    SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	/*
	Removed as part of the IT79 refactor, left here as reference -- Jaime    
    -- This next line was added so that the stored proc can accept both the legacy and newere Account IDs.
    -- Note that the legacy account_id is not numeric.
    IF ISNUMERIC(@AccountId) = 0
		SELECT @AccountId = AccountID FROM lp_account.dbo.account WHERE account_id = @AccountId

	SELECT	DISTINCT 
			a.AccountID
			, a.account_id AS LegacyAccountId
			, account_number AS AccountNumber
			, a.por_option --added for INF82
			, AccountType = CASE WHEN account_type = 'SOHO' THEN 'SOHO' ELSE UPPER(LEFT(account_type, 3)) END
			, annual_usage AS AnnualUsage
			, contract_nbr AS ContractNumber
			, contract_type AS ContractType
			, contract_eff_start_date AS ContractStartDate
			, date_end AS ContractEndDate
			, date_flow_start AS FlowStartDate, term_months AS Term, date_deenrollment AS DeenrollmentDate
			, utility_id AS UtilityCode, product_id AS ProductId, rate, rate_id AS RateId
			, a.icap AS Icap
			, a.tcap AS Tcap
			, billing_group AS BillCycleID			
			, retail_mkt_id AS RetailMarketCode
			, a.zone As ZoneCode
			, service_rate_class AS RateClass
			, a.rate_code as RateCode
			, a.load_profile as LoadProfile
			, ISNULL(AW.WaiveEtf,0) AS WaiveEtf
			, AW.WaivedEtfReasonCodeID
			, ISNULL(AW.IsOutgoingDeenrollmentRequest,0) AS IsOutgoingDeenrollmentRequest
			, [status] AS EnrollmentStatus, [sub_status] AS EnrollmentSubStatus
			, account_name.full_name As BusinessName, date_submit AS DateSubmit, date_deal AS DateDeal,
			 sales_channel_role AS SalesChannelId, sales_rep AS SalesRep 
			 ,AW.CurrentEtfID
			 ,(SELECT dbo.ufn_EtfGetZoneAndClassFromProduct (a.AccountID)) AS PricingZoneAndClass	 
			 ,a.credit_agency, a.credit_score		 
			 ,a.usage_req_status--added for ticket 21650	 
			 ,a.billing_Type as BillingType -- CKE added for Ticket 1-3507461			 
	FROM	lp_account..account a WITH (NOLOCK)
		LEFT JOIN lp_account..account_additional_info i WITH (NOLOCK) ON a.account_id = i.account_id
		LEFT OUTER JOIN LibertyPower..AccountEtfWaive AW ON a.AccountID = AW.AccountID 
		LEFT OUTER JOIN lp_account..account_name WITH (NOLOCK) 
			ON account_name.account_id = a.account_id AND account_name.name_link = a.customer_name_link	
	WHERE a.AccountID = @AccountID
	*/
	-- ***********************************************************************************
	-- IT79 Refactored Code Start
	DECLARE @INT_AccountID INT; -- this is to avoid casting delays
	
	-- This next line was added so that the stored proc can accept both the legacy and newere Account IDs.
	-- Note that the legacy account_id is not numeric.
	IF ISNUMERIC(@AccountId) = 0
		SELECT @INT_AccountID = AccountID FROM LibertyPower.dbo.Account WHERE AccountIdLegacy = @AccountId;
	ELSE
		SET @INT_AccountID = CAST(@AccountId AS INT);
		
	SELECT DISTINCT
			A.AccountID
			, A.AccountIdLegacy AS LegacyAccountId
			, A.AccountNumber AS AccountNumber
			, CASE WHEN A.PorOption = 1 THEN 'YES' WHEN A.PorOption = 0 THEN 'NO' ELSE NULL END AS por_option --added for INF82
			, AT.AccountType -- AccountType = CASE WHEN account_type = 'SOHO' THEN 'SOHO' ELSE UPPER(LEFT(account_type, 3)) END
			, USAGE.AnnualUsage AS AnnualUsage
			, C.Number AS ContractNumber
			, [LibertyPower].[dbo].[ufn_GetLegacyContractType] (CT.[Type], CTT.ContractTemplateTypeID, CDT.DealType ) AS ContractType
			, CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart ELSE AC_DefaultRate.RateStart END AS ContractStartDate
			, CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd ELSE AC_DefaultRate.RateEnd END AS ContractEndDate
			, LibertyPower.dbo.[ufn_GetLegacyFlowStartDate](ACS.[Status], ACS.[SubStatus], ASERVICE.StartDate) as FlowStartDate
			, CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term ELSE AC_DefaultRate.Term END AS Term
			, LibertyPower.dbo.[ufn_GetLegacyDateDeenrollment](ACS.[Status], ACS.[SubStatus], ASERVICE.EndDate) AS DeenrollmentDate
			, U.UtilityCode AS UtilityCode
			, CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END AS ProductId
			, CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate ELSE AC_DefaultRate.Rate END AS rate
			, CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID ELSE AC_DefaultRate.RateID END AS RateID
			, A.icap AS Icap
			, A.tcap AS Tcap
			, A.BillingGroup AS BillCycleID
			, M.MarketCode AS RetailMarketCode
			, A.Zone As ZoneCode
			, A.ServiceRateClass AS RateClass
			, ACR2.RateCode
			, A.LoadProfile
			, ISNULL(AW.WaiveEtf,0) AS WaiveEtf
			, AW.WaivedEtfReasonCodeID
			, ISNULL(AW.IsOutgoingDeenrollmentRequest,0) AS IsOutgoingDeenrollmentRequest
			, [LibertyPower].[dbo].[ufn_GetLegacyAccountStatus](ACS.[Status], ACS.[SubStatus]) AS EnrollmentStatus
			, [LibertyPower].[dbo].[ufn_GetLegacyAccountSubStatus](ACS.[Status], ACS.[SubStatus]) AS EnrollmentSubStatus
			, CUST_NAME.Name As BusinessName
			, C.SubmitDate AS DateSubmit
			, C.SignedDate AS DateDeal
			, 'SALES CHANNEL/' + SC.ChannelName AS SalesChannelId
			, C.SalesRep AS SalesRep
			, AW.CurrentEtfID
			, '' AS PricingZoneAndClass --LibertyPower.dbo.ufn_EtfGetZoneAndClassFromProduct (A.AccountID) AS PricingZoneAndClass
			, CASE WHEN CA.Name IS NULL THEN 'NONE' ELSE UPPER(CA.Name) END AS credit_agency
			, CAST(0 AS INT) AS credit_score
			, CASE WHEN UPPER(URS.[Status]) = 'NONE' THEN NULL ELSE UPPER(URS.[Status]) END AS usage_req_status --added for ticket 21650
			, BILLTYPE.[Type] as BillingType -- CKE added for Ticket 1-3507461
	FROM	LibertyPower..Account A WITH (NOLOCK)
	JOIN	LibertyPower..Customer CUST WITH (NOLOCK) 
	ON		A.CustomerID = CUST.CustomerID
	
	JOIN	LibertyPower..AccountType AT WITH (NOLOCK) 
	ON		A.AccountTypeID = AT.ID
	
	JOIN	LibertyPower..AccountContract AC WITH (NOLOCK) 
	ON		A.CurrentContractID = AC.ContractID AND A.AccountId = AC.AccountID -- current/lasdt contract
	
	JOIN	LibertyPower..[Contract] C WITH (NOLOCK) 
	ON		A.CurrentContractID = C.ContractID
	
	JOIN	LibertyPower.dbo.AccountStatus ACS WITH (NOLOCK) 
	ON		AC.AccountContractID = ACS.AccountContractID
	
	JOIN	LibertyPower.dbo.ContractType CT WITH (NOLOCK) 
	ON		C.ContractTypeID = CT.ContractTypeID
	
	JOIN	LibertyPower.dbo.ContractTemplateType CTT WITH (NOLOCK) 
	ON		C.ContractTemplateID= CTT.ContractTemplateTypeID
	
	JOIN	LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) 
	ON		AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
	
	JOIN	LibertyPower.dbo.Utility U WITH (NOLOCK) 
	ON		A.UtilityID = U.ID
	
	JOIN	LibertyPower.dbo.Market M WITH (NOLOCK) 
	ON		A.RetailMktID = M.ID
	
	JOIN	LibertyPower..AccountUsage USAGE WITH (NOLOCK) 
	ON		A.AccountID = USAGE.ACcountID AND USAGE.EffectiveDate = C.StartDate
	
	JOIN	LibertyPower.dbo.UsageReqStatus URS WITH (NOLOCK) 
	ON		USAGE.UsageReqStatusID = URS.UsageReqStatusID
	
	LEFT	JOIN LibertyPower..Name CUST_NAME WITH (NOLOCK) 
	ON		CUST_NAME.NameID = CUST.NameID
	
	LEFT	JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK) 
	ON		C.SalesChannelID = SC.ChannelID
	
	--LEFT	JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK) 
	--ON		AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later
	
	-- NEW DEFAULT RATE JOIN:
	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
			   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
			   WHERE ACRR.IsContractedRate = 0 
			   GROUP BY ACRR.AccountContractID
			  ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
	LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
	 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
	-- END NEW DEFAULT RATE JOIN:
	
	LEFT	JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK) 
	ON		CUST.CreditAgencyID = CA.CreditAgencyID
	
	LEFT	JOIN LibertyPower.dbo.ContractDealType CDT WITH (NOLOCK) 
	ON		C.ContractDealTypeID = CDT.ContractDealTypeID
	
	LEFT	JOIN LibertyPower.dbo.BillingType BILLTYPE WITH (NOLOCK) 
	ON		A.BillingTypeID = BILLTYPE.BillingTypeID
	
	LEFT	JOIN LibertyPower..AccountEtfWaive AW WITH (NOLOCK) 
	ON		A.AccountId = AW.AccountID
	
	LEFT	JOIN lp_account..account_additional_info i WITH (NOLOCK) 
	ON		A.AccountIdLegacy = i.account_id
	
	LEFT	JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) 
	ON		A.AccountID = ASERVICE.AccountID
	/*LEFT	JOIN (
			select	account_id, StartDate, EndDate, ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY StartDate DESC, EndDate DESC) AS rownum
			from		Libertypower.dbo.AccountService (NOLOCK)
				) ASERVICE 
	ON		A.AccountIdLegacy = ASERVICE.account_id 
	AND		ASERVICE.rownum = 1
	*/
	WHERE	A.AccountID = @INT_AccountID
	-- IT79 Refactored Code End
	-- ***********************************************************************************

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power



