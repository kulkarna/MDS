-- =============================================

-- Author:		Isabelle Tamanini

-- Create date: 2010-01-25

-- Description:	Gets enrolled accounts that have 

-- contract ended in the last 7 days

-- =============================================

-- Author:		Al Tafur

-- Create date: 2011-08-01

-- Description:	The 7 day limit has been removed 

--              It now includes ALL the elligible accounts  SR 1-689171

-- =============================================

-- Author:		  Isabelle Tamanini

-- Modified date: 2012-12-04

-- Description:	  Refactored to use the new account tables

-- =============================================


-- Author:		  0scar Garcia

-- Modified date: 2013-05-01

-- Description:	  Include the 11000 Pending de-enrollment status SR 1-85649821

-- =============================================


ALTER PROCEDURE [dbo].[usp_AccountExpiredProductsSelect]

(

 @p_account_number_filter                           varchar(30) = 'ALL',

 @p_contract_nbr_filter                             char(12)= 'ALL',

 @p_utility_id_filter                               varchar(15)= 'ALL',                                      

 @p_entity_id_filter                                varchar(15)= 'ALL',

 @p_retail_mkt_id_filter                            varchar(04)= 'ALL'

)

AS

BEGIN

	SET NOCOUNT ON

	

	-- Get the most recent AccountContractRate record for the account.

	SELECT ACR.*

	INTO #ACR

	FROM LibertyPower.dbo.AccountContractRate ACR (NOLOCK)

	JOIN (  

			SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 

	        FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)

			GROUP BY ACRR.AccountContractID

		 ) m ON ACR.AccountContractRateID = m.AccountContractRateID

	WHERE RateEnd < getdate()

	

	SELECT AC.*, ACS.[Status], ACS.SubStatus   --1-85649821 ADD account status

	INTO #AccountContract

	FROM LibertyPower.dbo.AccountContract AC WITH (NOLOCK)

	JOIN LibertyPower.dbo.AccountStatus ACS	WITH (NOLOCK) ON AC.AccountContractID = ACS.AccountContractID

	JOIN #ACR ON AC.AccountContractID = #ACR.AccountContractID

	WHERE ACS.status IN ('11000','905000', '906000') --1-85649821 ADD 11000

	

	SELECT	DISTINCT

			A.AccountNumber			AS account_number,

			CASE WHEN AT.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE AT.AccountType	END AS account_type,

			AC.[Status] AS [Status],			

			AC.SubStatus AS sub_status,

			ACR.RateStart AS contract_eff_start_date,

			A.EntityID				AS entity_id,

			C.Number				AS contract_nbr,

			[Libertypower].[dbo].[ufn_GetLegacyContractType] ( CT.[Type] , CTT.ContractTemplateTypeID, CDT.DealType) AS contract_type,

			M.MarketCode			AS retail_mkt_id,

			U.UtilityCode			AS utility_id,

			ACR.LegacyProductID     AS product_id,

			ACR.RateID			    AS rate_id,

			ACR.Rate			    AS rate,

			--ISNULL(USAGE.AnnualUsage,0)	AS annual_usage,

			0 AS annual_usage,

			ACR.Term AS term_months,

			USER1.UserName			AS username,

			'SALES CHANNEL/' + SC.ChannelName AS sales_channel_role,

			C.SalesRep				AS sales_rep,

			LibertyPower.dbo.ufn_GetLegacyFlowStartDate('906000', '10', ASERVICE.StartDate ) date_flow_start, 

			AC.SendEnrollmentDate	AS date_por_enrollment,

			LibertyPower.dbo.ufn_GetLegacyDateDeenrollment ('906000', '10', ASERVICE.EndDate ) date_deenrollment, 

			C.SignedDate			AS date_deal,

			A.DateCreated			AS date_created,

			ACR.RateEnd AS date_end,

			C.SubmitDate			AS date_submit,

			UPPER(TAX.[Status])		AS tax_status,

			CAST(0 AS INT)			AS tax_rate,

			n.name as full_name,

			A.AccountIdLegacy as account_id

	FROM LibertyPower.dbo.Account A WITH (NOLOCK)

	JOIN LibertyPower.dbo.[Contract] C	WITH (NOLOCK)				ON A.CurrentContractID = C.ContractID

	JOIN #AccountContract AC	WITH (NOLOCK)		ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID

	JOIN LibertyPower.dbo.ContractType CT			WITH (NOLOCK)	ON C.ContractTypeID = CT.ContractTypeID

	JOIN LibertyPower.dbo.Customer CUST				WITH (NOLOCK)	ON A.CustomerID = CUST.CustomerID

	JOIN LibertyPower.dbo.ContractTemplateType CTT	WITH (NOLOCK)	ON C.ContractTemplateID= CTT.ContractTemplateTypeID

	JOIN LibertyPower.dbo.AccountType AT			WITH (NOLOCK)	ON A.AccountTypeID = AT.ID		  								  

	JOIN LibertyPower.dbo.Utility U			WITH (NOLOCK)			ON A.UtilityID = U.ID

	JOIN LibertyPower.dbo.Market M			WITH (NOLOCK)			ON A.RetailMktID = M.ID

	LEFT JOIN LibertyPower.dbo.SalesChannel SC		WITH (NOLOCK)		ON C.SalesChannelID = SC.ChannelID

	LEFT JOIN LibertyPower.dbo.TaxStatus TAX		WITH (NOLOCK)		ON A.TaxStatusID = TAX.TaxStatusID

	LEFT JOIN LibertyPower.dbo.CreditAgency CA		WITH (NOLOCK)		ON CUST.CreditAgencyID = CA.CreditAgencyID	

	LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE	WITH (NOLOCK)		ON A.BillingTypeID = BILLTYPE.BillingTypeID

	LEFT JOIN LibertyPower.dbo.ContractDealType CDT		WITH (NOLOCK)	ON C.ContractDealTypeID = CDT.ContractDealTypeID

	--JOIN LibertyPower.dbo.AccountUsage USAGE	WITH (NOLOCK)		ON A.AccountID = USAGE.AccountID AND  C.StartDate = USAGE.EffectiveDate

	LEFT JOIN LibertyPower.dbo.[User] USER1		WITH (NOLOCK)		ON C.CreatedBy = USER1.UserID

	LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK) ON A.AccountID = ASERVICE.AccountID

	LEFT JOIN #ACR ACR ON ACR.AccountContractID = AC.AccountContractID

	--LEFT JOIN lp_account.dbo.[vw_AccountAddressNameContactIds] AddConNam ON A.AccountID = AddConNam.AccountID -- this way boosts 100ms less

	INNER JOIN LibertyPower..Name n WITH (NOLOCK) ON CUST.NameID = n.NameID

	WHERE	1=1

		AND (@p_account_number_filter = 'ALL' OR a.AccountNumber = @p_account_number_filter) 

		AND (@p_contract_nbr_filter = 'ALL' OR c.Number = @p_contract_nbr_filter)

		AND (@p_utility_id_filter = 'ALL' OR u.UtilityCode = @p_utility_id_filter) 

		AND (@p_entity_id_filter = 'ALL' OR a.EntityID = @p_entity_id_filter) 

		AND (@p_retail_mkt_id_filter = 'ALL' OR m.MarketCode = @p_retail_mkt_id_filter) 

 

SET NOCOUNT OFF;

END   
