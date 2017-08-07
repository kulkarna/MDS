
USE [lp_commissions]
GO


-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 7/8/2008
-- Description:	Get account detail
-- =============================================
-- Modified: 6/2/2010 Gail Mangaroo 
-- Added account override fields
-- =============================================
-- Modified: 12/6/2011 Gail Mangaroo
-- Modified 
-- Added ufn_account_detail_historical_sel to get account_name
-- ============================================
-- Modified: 12/13/2011 Gail Mangaroo -- prod 1/28/2012
-- Switch from lp_account.dbo.account to LibertyPower.dbo.Account
-- ============================================
-- Modified: 2/8/2012 Gail Mangaroo 
-- Fixed FlowStart and DeEnrollment sub queries
-- ============================================
-- Modified 2/21/2012 Gail Mangaroo 
-- Removed @p_account_number param and modified for effeciency
-- Added rate_desc 
-- ============================================
-- Modified 3/1/2012 Gail Mangaroo 
-- Added Account Type ID
-- ============================================
-- Modiifed 3/8/2012 Gail Mangaroo
-- Added MarketID 
-- ============================================
-- Modified 8/14/2012 Gail Mangaroo 
-- Changed join with Account status and added Price
-- ============================================
-- exec usp_account_detail_sel '2009-0023409' , '90008363A'
-- ============================================
-- Modified 9/14/2012 Gail Mangaroo 
-- Use LIbertyPower..Name
-- Added ContractStatusID 
-- ============================================
-- 11/28/2012 Gail Mangaroo 
-- Added additional fields and multi_rate price
-- ============================================
 -- ============================================
-- Modified 01/14/2013  Lehem Felican
-- Use LIbertyPower..Name
-- Add subStatus_descp to query 
-- ============================================

ALTER PROC  [dbo].[usp_account_detail_sel] 
( 
@p_account_id varchar(30)
, @p_contract_nbr varchar(30) = ''
) 

AS 
BEGIN 
	SET NOCOUNT ON

	SELECT distinct a.AccountID
		, c.ContractID
		, acc.AccountContractID
		, a.AccountIDLegacy
		, c.SignedDate 
		, startDate = (SELECT min(acs_start.startDate) 
								FROM LibertyPower.dbo.AccountService acs_start (NOLOCK) 
								WHERE  acs_start.account_id = a.AccountIDLegacy
									AND (acs_start.EndDate is null OR acs_start.EndDate = '1/1/1900' OR acs_start.EndDate >= c.SignedDate)
									AND acs_start.StartDate > '1/1/1900'
							 )
		, endDate = isnull(( SELECT TOP 1 EndDate 
								from LibertyPower.dbo.AccountService (NOLOCK)
								WHERE account_id = a.AccountIDLegacy 
									AND (EndDate >= c.SignedDate OR EndDate is null OR EndDate = '1/1/1900')
								ORDER BY StartDate desc
							), '1/1/1900')
							
	INTO #acct
	FROM LibertyPower.dbo.Account a (NOLOCK) 
		JOIN LibertyPower.dbo.AccountContract acc (NOLOCK) ON a.AccountID = acc.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = acc.ContractID
	WHERE a.accountIDLegacy = @p_account_id 
		AND c.Number = @p_contract_nbr 
		
		
	SELECT  
		account_id			= a.AccountIDLegacy
		, account_number	= a.AccountNumber
		, full_name			= n.name
		, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,c.SignedDate)) 
		, requested_flow_start_date = c.SignedDate   --a.requested_flow_start_date
		, date_end			= c.EndDate
		, date_start		= c.StartDate
		, sales_rep			= c.salesRep
		, annual_usage		= isnull(au.annualUsage, 0)
		, [status]			= LTRIM(RTRIM(s.Status))
		, sub_status		= LTRIM(RTRIM(s.SubStatus))
		, contract_nbr		= c.Number
		, retail_mkt_id		= m.MarketCode
		, utility_id		= u.UtilityCode
		, term_months		= acr.Term
		, product_id		= acr.LegacyProductID
		, sales_channel_role	= v.vendor_system_name
		, vendor_id			= v.vendor_id
		, rate				= acr.Rate
		, rate_id			= acr.RateId 
		, date_flow_start	= temp.StartDate
		, date_deenrolled	= temp.EndDate
		, contract_type		= ct.type + ' ' + cdt.DealType 
		, ContractDealTypeID = c.ContractDealTypeID
		, contract_eff_start_date = acr.RateStart 
		, p.product_descp
		, renewal			=  case when c.ContractDealTypeID = 2 then 1 else 0 end
		, review_ind		= r.review_ind 
		, review_id			= r.commission_review_id 
		, account_type		= at.AccountType
		, status_descp		= es.status_descp 
		, subStatus_descp   = ess.sub_status_descp
		
		, evergreen_option_id			= accom.EvergreenOptionID
		, evergreen_commission_end		= accom.evergreenCommissionEnd
		, evergreen_commission_rate		= accom.evergreenCommissionRate   
		, residual_option_id			= accom.ResidualOptionID
		, residual_commission_end		= accom.ResidualCommissionEnd
		, initial_pymt_option_id		= accom.InitialPymtOptionID
		
		, sales_manager		= isnull(mu.Firstname, '') + ' ' + isnull(mu.Lastname, '')
		, rate_descp

		, PriceID = acr.PriceID 
		, Price = case when pr.ProductTypeid = 7 then pcpm.Price else pr.price end
		, c.ContractStatusID 
		, acr.ProductCrossPriceMultiId
		
		, a.AccountTypeID 
		, a.CustomerID
		, MarketID = a.RetailMktID
		, a.UtilityID
		, a.AccountNameID
				
	FROM #acct temp 
		JOIN LibertyPower.dbo.Account a (NOLOCK) ON a.AccountID = temp.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = temp.ContractID
		JOIN LibertyPower.dbo.ContractType ct (NOLOCK) ON c.ContractTypeID = ct.ContractTypeID
		JOIN LibertyPower.dbo.ContractDealType cdt (NOLOCK) ON c.ContractDealTypeID = cdt.ContractDealTypeID
		JOIN LibertyPower.dbo.AccountType at (NOLOCK) ON at.ID = a.AccountTypeID 
		JOIN LibertyPower.dbo.vw_AccountContractRate acr (NOLOCK) ON acr.AccountContractID = temp.AccountContractID --AND acr.IsContractedRate = 1
		LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON temp.AccountContractID = s.AccountContractID
		LEFT JOIN LibertyPower.dbo.AccountUsage au (NOLOCK) ON a.AccountID = au.AccountID AND  c.StartDate = au.EffectiveDate
		LEFT JOIN LibertyPower.dbo.AccountContractCommission accom (NOLOCK) ON accom.AccountContractID = temp.AccountContractID
		--LEFT JOIN lp_account.dbo.account_name n (NOLOCK) ON a.accountNameId = n.accountNameId
		LEFT JOIN LibertyPower.dbo.Name n (NOLOCK) on a.accountNameid = n.nameid
		LEFT JOIN lp_commissions.dbo.vendor v (NOLOCK) on c.SalesChannelID = v.ChannelID
		LEFT JOIN LibertyPower.dbo.Market m (NOLOCK) ON m.ID = a.RetailMktID 
		LEFT JOIN LibertyPower.dbo.Utility u (NOLOCK) ON u.ID = a.UtilityID 
		LEFT JOIN lp_common.dbo.common_product p (NOLOCK) ON acr.LegacyProductID = p.product_id 
		LEFT JOIN lp_commissions.dbo.commission_review_request r (NOLOCK) ON r.Contract_nbr = c.Number
			and ( r.account_id = a.AccountIDLegacy or isnull(r.account_id, '') = '' )
			and (r.product_id = p.product_id  or isnull(r.product_id, '') = '' )
			and (r.rate_id = acr.rateid  or isnull(r.rate_id, 0) = 0 )
			and r.review_ind = 1 
		LEFT JOIN lp_account.dbo.enrollment_status es (NOLOCK) ON s.status = es.status
		LEFT JOIN lp_account.dbo.enrollment_sub_status ess (NOLOCK) ON es.status = ess.status and ess.sub_status = s.SubStatus 
		LEFT JOIN LibertyPower.dbo.[User] mu (NOLOCK) ON c.SalesManagerID = mu.UserID
		LEFT JOIN lp_Common.dbo.common_product_rate cpr (NOLOCK) on cpr.product_id = acr.LegacyProductID AND  cpr.rate_id = acr.RateID
		LEFT JOIN LibertyPower.dbo.Price pr (NOLOCK) ON pr.id = acr.priceid
		LEFT JOIN LibertyPower.dbo.ProductCrossPriceMulti pcpm (NOLOCK) ON acr.ProductCrossPriceMultiId = pcpm.ProductCrossPriceMultiId

END
GO
