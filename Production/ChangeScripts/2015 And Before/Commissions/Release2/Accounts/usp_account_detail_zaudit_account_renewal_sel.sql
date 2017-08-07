
USE [lp_commissions]
GO


/*******************************************************************************
 * usp_account_detail_zaudit_account_renewal_sel
 * Get account detail from zAduit_account table.
 * History
 *******************************************************************************
 * 5/22/2009 Gail Mangaroo.
 * Created.
 *******************************************************************************
 * Modified: 6/2/2010 Gail Mangaroo 
 * Added account override fields
  
 * 12/6/2011 Gail Mangaroo
 * Modified 
 * Added ufn_account_detail_historical_sel to get account_name
 *******************************************************************************
  * 8/14/2012 Gail Mangaroo 
 * Add additional fields and optimize
 ******************************************************************************* 
 * 9/17/2012 Gail Mangaroo	
 * Add ContractStatusID
 *******************************************************************************
 * 9/26/2012 Gail Mangaroo
 * Modified 
 * Added check for all empty parameters
 *******************************************************************************
  -- ============================================
-- Modified 01/14/2013  Lehem Felican
-- Use LIbertyPower..Name
-- Add subStatus_descp to query 
-- ============================================
  exec usp_account_detail_zaudit_account_renewal_sel '2009-0023409' , '', '90008362A'
  
 */
ALTER Procedure [dbo].[usp_account_detail_zaudit_account_renewal_sel]
( 
@p_account_id varchar(30)
, @p_account_number varchar(30) = ''
, @p_contract_nbr varchar(30) = ''
, @p_vendor_system_name varchar(50) = ''
, @p_start_date datetime = null
, @p_end_date datetime = null
, @p_status varchar(50) = null 
, @p_sub_status varchar(50) = null 
) 

AS 
BEGIN 
	SET NOCOUNT ON

			--drop table #Audit_Account
			
			--DECLARE @p_account_id varchar(30)
			--DECLARE  @p_account_number varchar(30) 
			--DECLARE  @p_contract_nbr varchar(30) 
			--DECLARE  @p_vendor_system_name varchar(50)
			--DECLARE  @p_start_date datetime 
			--DECLARE  @p_end_date datetime 
			--DECLARE  @p_status varchar(50) 
			--DECLARE  @p_sub_status varchar(50) 

			--SET @p_account_id =  '' --'2009-0023409'
			--SET @p_account_number = ''
			--SET @p_contract_nbr = '' --  '90008362A' 
			--SET @p_vendor_system_name = ''
			--SET @p_start_date = null 
			--SET @p_end_date = null 
			--SET  @p_status  = null 
			--SET  @p_sub_status = null 
			
	DECLARE @strSQL nvarchar(max) 
	DECLARE @strSELECT varchar(max) 
	DECLARE @strWHERE varchar(max) 
	DECLARE @rowCount int 
	DECLARE @zAudit_account_id varchar(50) 

	CREATE TABLE #Audit_Account (zaudit_account_id int, account_id varchar(50)) 
		
	DECLARE @ParmDefinition NVARCHAR(500);
	SET @ParmDefinition = N'
	 @p_account_id varchar(30)
	, @p_account_number varchar(30) 
	, @p_contract_nbr varchar(30) 
	, @p_vendor_system_name varchar(50) 
	, @p_start_date datetime 
	, @p_end_date datetime 
	, @p_status varchar(50)
	, @p_sub_status varchar(50) '
	
	SET @strSELECT = 
	'SELECT max(zaudit_account_id), account_id 			
		FROM lp_account.dbo.zAudit_account_renewal a (NOLOCK)
		WHERE 1 = 1 '

	SET @strWHERE = ''
				
	IF ltrim(rtrim(isnull(@p_account_id, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere	+ N' AND a.account_id = @p_account_id'
	END 
	
	IF ltrim(rtrim(isnull(@p_contract_nbr, ''))) <> ''
	BEGIN
		SET @strWhere = @strWhere + N' AND a.contract_nbr = @p_contract_nbr '
	END
	
	IF ltrim(rtrim(isnull(@p_account_number, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.account_number = @p_account_number '
	END 
	
	IF ltrim(rtrim(isnull(@p_vendor_system_name, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.sales_channel_role = @p_vendor_system_name '
	END 
	
	IF @p_start_date is not null 
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.date_deal >=  @p_start_date '
	END 
	
	IF @p_end_date is not null 
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.date_deal <=  @p_end_date '
	END 
	
	IF ltrim(rtrim(isnull(@p_status, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.[Status] = @p_status '
	END 
	
	IF ltrim(rtrim(isnull(@p_sub_status, ''))) <> ''
	BEGIN 
		SET @strWhere = @strWhere + N' AND a.[sub_status] = @p_sub_status '
	END 

	IF len(ltrim(@strWhere)) = 0 -- prevent returning dataset without setting parameters
		SET @strWhere = @strWhere + N' AND 1 = 0 '
	
	-- Get zaudit account id 
	SET @strSQL = @strSELECT + @strWhere  + ' GROUP BY account_id '
	
	INSERT INTO #Audit_Account
	EXECUTE sp_executesql  @strSQL 
	, 	@ParmDefinition
	, 	@p_account_id = @p_account_id
	, 	@p_contract_nbr = @p_contract_nbr
	, 	@p_account_number = @p_account_number
	, 	@p_vendor_system_name = @p_vendor_system_name
	, 	@p_start_date = @p_start_date
	, 	@p_end_date = @p_end_date
	,   @p_status = @p_status
    ,   @p_sub_status = @p_sub_status
	
	SELECT 
		account_id			= a.account_id
		, account_number	= a.account_number
		, full_name			= (SELECT TOP 1 full_name FROM lp_commissions.dbo.[ufn_account_detail_historical] (a.account_id, a.contract_nbr) )
		, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,a.date_deal)) 
		, date_start		= a.contract_eff_start_date 
		, requested_flow_start_date = '1/1/1900'
		, date_end			= a.date_end
		, sales_rep			= a.sales_rep
		, annual_usage		= isnull(a.annual_usage, 0)
		, [status]			= LTRIM(RTRIM(a.status))
		, sub_status		= LTRIM(RTRIM(a.sub_status))
		, contract_nbr		= a.contract_nbr
		, retail_mkt_id		= a.retail_mkt_id
		, utility_id		= a.utility_id
		, term_months		= a.term_months
		, product_id		= a.product_id
		, sales_channel_role = a.sales_channel_role 
		, vendor_id			= v.vendor_id
		, rate				= a.rate
		, rate_id			= a.rate_id 
		, date_flow_start	= a.date_flow_start
		, date_deenrolled	= a.date_deenrollment
		, contract_type		= a.contract_type 
		, contractDealTypeID = case when account_type like '%RENEW%' then 2 else 1 end
		, contract_eff_start_date = a.contract_eff_start_date 
		, p.product_descp
		, renewal			=  case when account_type like '%RENEW%' then 1 else 0 end 	
		, review_ind		= r.review_ind 
		, review_id			= r.commission_review_id 
		, account_type		= a.account_type
		, status_descp		= es.status_descp 
		, subStatus_descp   = ess.sub_status_descp

		, a.[evergreen_option_id]
		, a.[evergreen_commission_end]
		, a.[residual_option_id]
		, a.[residual_commission_end]
		, a.[initial_pymt_option_id]
		, a.[evergreen_commission_rate] 
		
		, a.[sales_manager]
		, cpr.rate_descp
		
		, PriceID = 0 
		, Price = 0 
		, ContractStatusID = 0 
		, ProductCrossPriceMultiId = 0 
		
		, AccountTypeID  = 0
		, CustomerID = 0
		, MarketID = m.ID 
		, UtilityID = 0
		, AccountNameID = 0
		
	FROM lp_account.dbo.zAudit_account_renewal a (NOLOCK)
		JOIN #Audit_Account aa (NOLOCK) on aa.zaudit_account_id = a.zaudit_account_id 
		LEFT OUTER JOIN lp_commissions.dbo.vendor v (NOLOCK) on a.sales_channel_role = v.vendor_system_name
		JOIN lp_common.dbo.common_product p (NOLOCK) ON a.product_id = p.product_id 
		LEFT OUTER JOIN lp_commissions.dbo.commission_review_request r (NOLOCK) ON r.contract_nbr = a.contract_nbr and r.product_id = a.product_id and r.rate_id = a.rate_id 
		LEFT OUTER JOIN lp_account.dbo.enrollment_status es (NOLOCK) on a.status = es.status
		LEFT JOIN lp_account.dbo.enrollment_sub_status ess (NOLOCK) ON es.status = ess.status and ess.sub_status = a.sub_status
		LEFT OUTER JOIN lp_common.dbo.common_product_rate cpr (NOLOCK) on cpr.product_id = a.product_id and cpr.rate_id = a.rate_id 
		LEFT OUTER JOIN LibertyPower.dbo.accountType act (NOLOCK) on act.AccountType = a.account_type 
		JOIN LibertyPower.dbo.Market m (NOLOCK) on a.retail_mkt_id = m.marketcode and m.inactiveind = 0

END 
GO
