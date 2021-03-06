USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_active_sel_list]    Script Date: 06/16/2013 23:35:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jaime Forero
-- Create date: 6/17/2013
-- Description:	New SP for the account list in the renewal applications
--exec [usp_account_active_sel_list_renewal] @p_contract_nbr=N'2009-0326651'
-- =============================================
CREATE PROCEDURE  [dbo].[usp_account_active_sel_list_renewal]
@p_contract_nbr		char(12),
@p_account_id       char(12) = null
AS

select distinct 
-- r.contract_nbr,
a.AccountIdLegacy as account_id,
a.AccountNumber AS account_number,
CASE WHEN at.AccountType = 'RES' THEN 'RESIDENTIAL' ELSE at.AccountType	END AS account_type,
status                                 = es.status_descp,
	sub_status                             = ess.sub_status_descp,
	a.CustomerIdLegacy AS customer_id,
	entity_id                              = entity.entity_descp,
	c.Number AS contract_nbr,
	Libertypower.dbo.ufn_GetLegacyContractType ( cty.[Type] , ctt.ContractTemplateTypeID, cdt.DealType) AS contract_type,
	retail_mkt_id                          = m.RetailMktDescp, --e.retail_mkt_descp
	utility_id                             = u.LegacyName,
	product_id                             = 'Disabled',--g.product_id,
	product_descp                          = 'Disabled',--g.product_descp,
	zone								   = a.zone,
	a.ServiceRateClass AS service_rate_class,
	a.BillingGroup			AS billing_group,
	'Disabled' as rate_id,--CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.RateID			 ELSE AC_DefaultRate.RateID			 END AS rate_id,
	'Disabled' as rate,--CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.Rate			 ELSE AC_DefaultRate.Rate			 END AS rate,
	names                                  = 'Names',
	address                                = 'Address',
	contact                                = 'Contacs',
	left(UPPER(isnull(bt.[Type],'NONE')),35)		AS business_type,
	left(UPPER(isnull(ba.Activity,'NONE')),35)		AS business_activity,		

	LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbrType(cust.Duns, cust.EmployerId, cust.TaxId, cust.SsnEncrypted ) additional_id_nbr_type, 		
	LibertyPower.dbo.ufn_GetLegacyAdditionalIdNbr(cust.Duns, cust.EmployerId, cust.TaxId, cust.SsnEncrypted ) additional_id_nbr, 

	ISNULL(usg.AnnualUsage,0)	AS annual_usage	,     
	CAST(0 AS INT) AS credit_score, -- TODO,
	CASE WHEN ca.Name IS NULL THEN 'NONE' ELSE UPPER(ca.Name) END AS credit_agency,
	'disabled' as term_months, --	CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.Term ELSE AC_DefaultRate.Term END AS term_months,
	user1.UserName AS username,
	'SALES CHANNEL/' + sc.ChannelName AS sales_channel_role,
	c.SalesRep AS sales_rep,
	'disabled' as contract_eff_start_date, --CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.RateStart  ELSE AC_DefaultRate.RateStart END AS contract_eff_start_date,
	'disabled' as date_end, --CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.RateEnd	ELSE AC_DefaultRate.RateEnd   END AS date_end,
	c.SignedDate			AS date_deal,
	a.DateCreated			AS date_created,
	c.SubmitDate			AS date_submit,

	LibertyPower.dbo.ufn_GetLegacyFlowStartDate(acs.[Status], acs.[SubStatus], asvc.StartDate ) AS date_flow_start,
	ac.SendEnrollmentDate	AS date_por_enrollment,
	LibertyPower.dbo.ufn_GetLegacyDateDeenrollment (acs.[Status], acs.[SubStatus], asvc.EndDate ) date_deenrollment,

	CAST('1900-01-01 00:00:00' AS DATETIME) AS date_reenrollment,
	UPPER(tax.[Status])		AS tax_status,
	CAST(0 AS INT)			AS tax_rate, --TODO
	a.origin,
	full_name = Name.Name, --h.full_name,
	CASE WHEN a.PorOption = 1 THEN 'YES' ELSE 'NO' END	AS por_option,
	billtype.[Type]			AS billing_type,
	CAST(0 AS INT)			AS chgstamp

from
 --lp_common..common_product g WITH (NOLOCK),
 Lp_contract_renewal.dbo.deal_contract_account r with (nolock)
join LibertyPower.dbo.Account a with (nolock) on r.account_number = a.AccountNumber	
join LibertyPower.dbo.[Contract] c with (nolock) on a.CurrentContractID = c.ContractID
join LibertyPower.dbo.AccountContract ac with (nolock) on a.AccountID = ac.AccountID and a.CurrentContractID = ac.ContractID
join LibertyPower.dbo.AccountType at with (nolock) on a.AccountTypeID = at.ID
join LibertyPower.dbo.AccountStatus ast with (nolock) on ac.AccountContractID = ast.AccountContractID  
join Lp_Account.dbo.[enrollment_status] es WITH (NOLOCK) on ast.Status = es.status --and ast.SubStatus = es.sub_status
join Lp_Account.dbo.[enrollment_sub_status] ess WITH (NOLOCK) on ast.Status = ess.status and ast.SubStatus = ess.sub_status
JOIN LibertyPower.dbo.ContractType cty			WITH (NOLOCK)	ON c.ContractTypeID = cty.ContractTypeID
JOIN LibertyPower.dbo.ContractTemplateType ctt	WITH (NOLOCK)	ON c.ContractTemplateID= ctt.ContractTemplateTypeID
LEFT JOIN LibertyPower..ContractDealType cdt WITH (NOLOCK) ON c.ContractDealTypeID = cdt.ContractDealTypeID
-- JOIN LibertyPower.dbo.vw_AccountContractRate acr2 WITH (NOLOCK)	ON AC.AccountContractID = acr2.AccountContractID
JOIN LibertyPower.dbo.Customer cust WITH (NOLOCK) ON a.CustomerID = cust.CustomerID	
JOIN LibertyPower.dbo.Utility u			WITH (NOLOCK)			ON a.UtilityID = u.ID
JOIN LibertyPower.dbo.Market m			WITH (NOLOCK)			ON a.RetailMktID = m.ID	
join lp_common..common_entity entity WITH (NOLOCK) on a.EntityID = entity.entity_id

---- NEW DEFAULT RATE JOIN:
--LEFT JOIN (SELECT MAX(ACRR.AccountContractRateID) AS AccountContractRateID, ACRR.AccountContractID 
--		   FROM LibertyPower.dbo.AccountContractRate ACRR	WITH (NOLOCK)
--	       WHERE ACRR.IsContractedRate = 0 
--	       GROUP BY ACRR.AccountContractID
--          ) ACRR2 ON ACRR2.AccountContractID = AC.AccountContractID
--LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate	WITH (NOLOCK)  
-- ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID 
---- END NEW DEFAULT RATE JOIN:

LEFT JOIN LibertyPower..BusinessType bt		WITH (NOLOCK)		ON cust.BusinessTypeID = bt.BusinessTypeID
LEFT JOIN LibertyPower..BusinessActivity ba	WITH (NOLOCK)		ON cust.BusinessActivityID = ba.BusinessActivityID
JOIN LibertyPower..AccountUsage usg WITH (NOLOCK) ON a.AccountID = usg.AccountID AND c.StartDate = usg.EffectiveDate
LEFT JOIN LibertyPower..CreditAgency ca		WITH (NOLOCK)		ON cust.CreditAgencyID = ca.CreditAgencyID	
LEFT JOIN LibertyPower..[User] user1		WITH (NOLOCK)		ON c.CreatedBy = user1.UserID
LEFT JOIN LibertyPower..SalesChannel sc		WITH (NOLOCK)		ON c.SalesChannelID = sc.ChannelID
JOIN LibertyPower..AccountStatus acs	WITH (NOLOCK)			ON ac.AccountContractID = acs.AccountContractID
LEFT JOIN LibertyPower..AccountLatestService asvc WITH (NOLOCK) ON a.AccountID = asvc.AccountID
LEFT JOIN LibertyPower..TaxStatus tax		WITH (NOLOCK)		ON a.TaxStatusID = tax.TaxStatusID
LEFT JOIN LibertyPower..BillingType billtype	WITH (NOLOCK)		ON a.BillingTypeID = billtype.BillingTypeID
-- LEFT JOIN lp_account..vw_AccountAddressNameContactIds AddConNam ON a.AccountID = AddConNam.AccountID
LEFT JOIN LibertyPower.dbo.Name Name WITH (NOLOCK) ON Cust.NameID = Name.NameID

where 1=1
-- AND		CASE WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN acr2.LegacyProductID ELSE AC_DefaultRate.LegacyProductID END = g.product_id
and c.Number = @p_contract_nbr
AND     (@p_account_id IS NULL OR a.AccountIdLegacy = @p_account_id)
order by a.AccountNumber







