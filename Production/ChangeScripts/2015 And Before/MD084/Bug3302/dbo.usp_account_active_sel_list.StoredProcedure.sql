USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_active_sel_list]    Script Date: 10/31/2012 17:11:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_active_sel_list]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_account_active_sel_list]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_active_sel_list]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/27/2007
-- Description:	Select active accounts
-- =============================================
-- Author:		Hugo Ramos / Isabelle Tamanini
-- Modified date: 10/29/2010
-- Description:	Add fields required on ticket 17205
-- =============================================
-- Modified 10/31/2012 - Rick Deigsler
-- Removed join on account view
-- and joined to the world directly
-- =============================================
--exec usp_account_active_sel_list_test @p_contract_nbr=N''2009-0326651''
CREATE PROCEDURE  [dbo].[usp_account_active_sel_list]

@p_contract_nbr		char(12)

AS

SELECT	DISTINCT 
		a.AccountIdLegacy		AS account_id,
		a.AccountNumber			AS account_number,
		CASE WHEN at.AccountType = ''RES'' THEN ''RESIDENTIAL'' ELSE at.AccountType	END AS account_type,
	status                                 = b.status_descp,
	sub_status                             = c.sub_status_descp,
	a.CustomerIdLegacy AS customer_id,
	entity_id                              = d.entity_descp,
	ct.Number AS contract_nbr,
	Libertypower.dbo.ufn_GetLegacyContractType ( cty.[Type] , ctt.ContractTemplateTypeID, cdt.DealType) AS contract_type,
	retail_mkt_id                          = e.retail_mkt_descp,
	utility_id                             = f.utility_descp,
	product_id                             = g.product_id,
	product_descp                          = g.product_descp,
	zone								   = a.zone,
	a.ServiceRateClass AS service_rate_class,
	a.BillingGroup			AS billing_group,
	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.RateID			 ELSE AC_DefaultRate.RateID			 END AS rate_id,
	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.Rate			 ELSE AC_DefaultRate.Rate			 END AS rate,
	names                                  = ''Names'',
	address                                = ''Address'',
	contact                                = ''Contacs'',
	left(UPPER(isnull(bt.[Type],''NONE'')),35)		AS business_type,
	left(UPPER(isnull(ba.Activity,''NONE'')),35)		AS business_activity,		
	LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbrType(cust.Duns, cust.EmployerId, cust.TaxId, cust.SsnEncrypted ) additional_id_nbr_type, 		
	LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbr(cust.Duns, cust.EmployerId, cust.TaxId, cust.SsnEncrypted ) additional_id_nbr, 
	ISNULL(usg.AnnualUsage,0)	AS annual_usage,      
	CAST(0 AS INT) AS credit_score, -- TODO,
	CASE WHEN ca.Name IS NULL THEN ''NONE'' ELSE UPPER(ca.Name) END AS credit_agency,
	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.Term ELSE AC_DefaultRate.Term END AS term_months,
	user1.UserName AS username,
	''SALES CHANNEL/'' + sc.ChannelName AS sales_channel_role,
	ct.SalesRep AS sales_rep,
	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.RateStart  ELSE AC_DefaultRate.RateStart END AS contract_eff_start_date,
	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.RateEnd	ELSE AC_DefaultRate.RateEnd   END AS date_end,
	ct.SignedDate			AS date_deal,
	a.DateCreated			AS date_created,
	ct.SubmitDate			AS date_submit,
	LibertyPower.dbo.ufn_GetLegacyFlowStartDate(acs.[Status], acs.[SubStatus], asvc.StartDate ) AS date_flow_start,
	ac.SendEnrollmentDate	AS date_por_enrollment,
	LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (acs.[Status], acs.[SubStatus], asvc.EndDate ) date_deenrollment,
	CAST(''1900-01-01 00:00:00'' AS DATETIME) AS date_reenrollment,
	UPPER(tax.[Status])		AS tax_status,
	CAST(0 AS INT)			AS tax_rate, --TODO
	a.origin,
	h.full_name,
	CASE WHEN a.PorOption = 1 THEN ''YES'' ELSE ''NO'' END	AS por_option,
	billtype.[Type]			AS billing_type,
	CAST(0 AS INT)			AS chgstamp -- TODO this column
FROM 
	enrollment_status b WITH (NOLOCK),
	enrollment_sub_status c WITH (NOLOCK),
	lp_common..common_entity d WITH (NOLOCK),
	lp_common..common_retail_market e WITH (NOLOCK),
	lp_common..common_utility f WITH (NOLOCK),
	lp_common..common_product g WITH (NOLOCK),
	account_name h WITH (NOLOCK),
	lp_contract_renewal..deal_contract_account i WITH (NOLOCK),
	
	LibertyPower..Account a WITH (NOLOCK)
	JOIN LibertyPower..AccountType at WITH (NOLOCK) ON a.AccountTypeID = at.ID
	JOIN LibertyPower.dbo.[Contract] ct WITH (NOLOCK) ON a.CurrentContractID = ct.ContractID	
	JOIN LibertyPower.dbo.ContractType cty			WITH (NOLOCK)	ON ct.ContractTypeID = cty.ContractTypeID
	JOIN LibertyPower.dbo.ContractTemplateType ctt	WITH (NOLOCK)	ON ct.ContractTemplateID= ctt.ContractTemplateTypeID
	LEFT JOIN LibertyPower..ContractDealType cdt WITH (NOLOCK) ON ct.ContractDealTypeID = cdt.ContractDealTypeID
	JOIN LibertyPower.dbo.AccountContract ac WITH (NOLOCK) ON a.AccountID = ac.AccountID AND a.CurrentContractID = ac.ContractID
	JOIN LibertyPower.dbo.vw_AccountContractRate acr2 WITH (NOLOCK)	ON AC.AccountContractID = acr2.AccountContractID
	JOIN LibertyPower.dbo.Customer cust WITH (NOLOCK) ON a.CustomerID = cust.CustomerID	
	JOIN LibertyPower.dbo.Utility u			WITH (NOLOCK)			ON a.UtilityID = u.ID
	JOIN LibertyPower.dbo.Market m			WITH (NOLOCK)			ON a.RetailMktID = m.ID	
	
	LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
			   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
			   WHERE ACRR.IsContractedRate = 0 
			   GROUP BY ACRR.AccountContractID
			  ) ACRR2 ON ACRR2.AccountContractID = ac.AccountContractID
	LEFT JOIN LibertyPower..AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
	 ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 	
	LEFT JOIN LibertyPower..BusinessType bt		WITH (NOLOCK)		ON cust.BusinessTypeID = bt.BusinessTypeID
	LEFT JOIN LibertyPower..BusinessActivity ba	WITH (NOLOCK)		ON cust.BusinessActivityID = ba.BusinessActivityID
	JOIN LibertyPower..AccountUsage usg WITH (NOLOCK) ON a.AccountID = usg.AccountID AND ct.StartDate = usg.EffectiveDate
	LEFT JOIN LibertyPower..CreditAgency ca		WITH (NOLOCK)		ON cust.CreditAgencyID = ca.CreditAgencyID	
	LEFT JOIN LibertyPower..[User] user1		WITH (NOLOCK)		ON ct.CreatedBy = user1.UserID
	LEFT JOIN LibertyPower..SalesChannel sc		WITH (NOLOCK)		ON ct.SalesChannelID = sc.ChannelID
	JOIN LibertyPower..AccountStatus acs	WITH (NOLOCK)			ON ac.AccountContractID = acs.AccountContractID
	LEFT JOIN LibertyPower..AccountLatestService asvc WITH (NOLOCK) ON a.AccountID = asvc.AccountID
	LEFT JOIN LibertyPower..TaxStatus tax		WITH (NOLOCK)		ON a.TaxStatusID = tax.TaxStatusID
	LEFT JOIN LibertyPower..BillingType billtype	WITH (NOLOCK)		ON a.BillingTypeID = billtype.BillingTypeID
	LEFT JOIN lp_account..vw_AccountAddressNameContactIds AddConNam ON a.AccountID = AddConNam.AccountID

WHERE	i.account_number in (select account_number from lp_account..account WITH (NOLOCK) where contract_nbr = @p_contract_nbr)
AND		Libertypower.dbo.ufn_GetLegacyAccountStatus(acs.[Status], acs.SubStatus)                               = b.status
AND		Libertypower.dbo.ufn_GetLegacyAccountStatus(acs.[Status], acs.SubStatus)                                = c.status
AND		Libertypower.dbo.ufn_GetLegacyAccountSubStatus(acs.[Status], acs.SubStatus)                            = c.sub_status
AND		a.EntityID                             = d.entity_id
AND		m.MarketCode                         = e.retail_mkt_id
AND		u.UtilityCode                            = f.utility_id
AND		CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END = g.product_id
AND		a.AccountIdLegacy                            = h.account_id
AND		isnull(AddConNam.account_name_link,0)        = h.name_link
--AND		a.status IN (''905000'',''906000'',''07000'')
AND		a.AccountIdLegacy							= i.account_id
AND		i.renew									= 1
order by a.AccountNumber asc


' 
END
GO
