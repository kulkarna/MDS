
USE [lp_commissions]
GO

/*******************************************************************************
 * usp_account_detail_account_sel
 * Get account detail from account table.
 * History
 *******************************************************************************
 * 1/22/2009 Gail Mangaroo.
 * Created.
 *******************************************************************************
 * 12/6/2011 Gail Mangaroo
 * Modified 
 * Added ufn_account_detail_historical_sel to get account_name
 *******************************************************************************
 * 12/13/2011 Gail Mangaroo -- prod 1/28/2012
 * Modified
 * Switch from lp_account..account to LibertyPower..Account
  *******************************************************************************
 * 2/7/2012 Gail Mangaroo 
 * Fixed FlowStart and DeEnrollment sub queries
 *******************************************************************************
 * 2/8/2012 Gail Mangaroo 
 * Fixed FlowStart and DeEnrollment sub queries
 *******************************************************************************
 * Modified 2/21/2012 Gail Mangaroo 
 * Removed @p_account_number param and modified for effeciency
 * Added rate_desc 
 *******************************************************************************
 * Modified 3/1/2012 Gail Mangaroo 
 * Added Account Type ID
 *******************************************************************************
 * Modiifed 3/8/2012 Gail Mangaroo
 * Added MarketID 
 *******************************************************************************
 * Modified 8/22/2012 Gail Mangaroo
 * Fixed join with commission_review re empty strings
 * Fixed Join with account status - only one row will exist now
 * When getting service end date, check if start date <== contract end date
 * Accept vendor_system_name or vendor_name 
 * and added Price
 *******************************************************************************
 * Modified 9/14/2012 Gail Mangaroo 
 * Use LIbertyPower..Name
 * Added ContractStatusID 
 *******************************************************************************
 * 9/26/2012 Gail Mangaroo
 * Modified 
 * Added check for all empty parameters
 *******************************************************************************
 * 11/28/2012 Gail Mangaroo 
 * Added additional fields and multi_rate price
 *******************************************************************************
-- ============================================
-- Modified 01/14/2013  Lehem Felican
-- Use LIbertyPower..Name
-- Add subStatus_descp to query 
-- ============================================
exec usp_account_detail_account_sel '2009-0023409' , '', '90008363A'

 */
 
ALTER Procedure [dbo].[usp_account_detail_account_sel]
( 
@p_account_id varchar(30)
, @p_account_number varchar(30) = ''
, @p_contract_nbr varchar(30) = ''
, @p_vendor_system_name varchar(50) = ''
, @p_start_date datetime = null
, @p_end_date datetime = null
) 

AS 
BEGIN 
			--drop table #acct
			
			--DECLARE @p_account_id varchar(30)
			--DECLARE  @p_account_number varchar(30) 
			--DECLARE  @p_contract_nbr varchar(30) 
			--DECLARE  @p_vendor_system_name varchar(50)
			--DECLARE  @p_start_date datetime 
			--DECLARE  @p_end_date datetime 

			--SET @p_account_id = '' -- '2009-0023409'
			--SET @p_account_number = ''
			--SET @p_contract_nbr = '' -- '90008362A'
			--SET @p_vendor_system_name = ''
			--SET @p_start_date = null 
			--SET @p_end_date = null 
			
	SET NOCOUNT ON

	CREATE TABLE #acct ( accountID int , contractID int , accountContractID int , startDate datetime , endDate datetime )

	DECLARE @strsQL NVARCHAR(max)
	DECLARE @ParmDefinition NVARCHAR(500)
	DECLARE @strWHERE nvarchar(max) 
	
	SET @strWHERE = ''
	SET @ParmDefinition = N'
	 @p_account_id varchar(30)
	, @p_account_number varchar(30) 
	, @p_contract_nbr varchar(30) 
	, @p_vendor_system_name varchar(50) 
	, @p_start_date datetime 
	, @p_end_date datetime  
	'

	SET @strsQL = 
	'SELECT a.AccountID
		, c.ContractID
		, acc.AccountContractID
		, startDate = (SELECT min(acs_start.startDate) 
								FROM LibertyPower.dbo.AccountService acs_start (NOLOCK) 
								WHERE  acs_start.account_id = a.AccountIDLegacy
									AND (acs_start.EndDate is null OR acs_start.EndDate = ''1/1/1900'' OR acs_start.EndDate >= c.SignedDate)
									AND acs_start.StartDate > ''1/1/1900''
							 )
		, endDate = isnull(( SELECT TOP 1 EndDate 
								from LibertyPower.dbo.AccountService (NOLOCK)
								WHERE account_id = a.AccountIDLegacy 
									AND (EndDate >= c.SignedDate OR EndDate is null OR EndDate = ''1/1/1900'')
								ORDER BY StartDate desc
							), ''1/1/1900'')
		
	FROM LibertyPower.dbo.Account a (NOLOCK) 
		JOIN LibertyPower.dbo.AccountContract acc (NOLOCK) ON a.AccountID = acc.AccountID
		JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = acc.ContractID
		JOIN lp_Commissions.dbo.vendor v (NOLOCK) ON v.ChannelID  = c.SalesChannelID
		JOIN LibertyPower.dbo.SalesChannel sc (NOLOCK) ON sc.ChannelID  = c.SalesChannelID
	
	WHERE  1 =1 '

	if ltrim(rtrim(isnull(@p_account_id, ''))) <> ''
		SET @strWHERE = @strWHERE + N' AND a.accountIDLegacy =  @p_account_id '

	if ltrim(rtrim(isnull(@p_contract_nbr, ''))) <> ''
		SET @strWHERE = @strWHERE + N' AND c.Number = @p_contract_nbr '
	
	if ltrim(rtrim(isnull(@p_account_number, ''))) <> ''
		SET @strWHERE = @strWHERE + N' AND a.accountNumber = @p_account_number '
		
	if ltrim(rtrim(isnull(@p_vendor_system_name, ''))) <> '' 
		SET @strWHERE = @strWHERE + N' AND ( v.vendor_system_name = @p_vendor_system_name  OR sc.channelname = @p_vendor_system_name) '
	
	if @p_start_date is not null
		SET @strWHERE = @strWHERE + N' AND c.SignedDate >= @p_start_date '
	
	if  @p_end_date is not null
		SET @strWHERE = @strWHERE + N' AND c.SignedDate <= @p_end_date '

	IF len(ltrim(@strWhere)) = 0 -- prevent returning dataset without setting parameters
		SET @strWhere = @strWhere + N' AND 1 = 0 '

	SET @strsql = @strsql + @strWhere	
		
	INSERT INTO #acct 
	EXECUTE sp_executesql  @strsql 
		, @ParmDefinition 
		, 	@p_account_id = @p_account_id
		, 	@p_contract_nbr = @p_contract_nbr
		, 	@p_account_number = @p_account_number
		, 	@p_vendor_system_name = @p_vendor_system_name
		, 	@p_start_date = @p_start_date
		, 	@p_end_date = @p_end_date 

	SELECT  
		account_id			= a.AccountIDLegacy
		, account_number	= a.AccountNumber
		, full_name			= n.name
		, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,c.SignedDate)) 
		, requested_flow_start_date = c.SignedDate   
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
		, sales_channel_role = v.vendor_system_name
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


