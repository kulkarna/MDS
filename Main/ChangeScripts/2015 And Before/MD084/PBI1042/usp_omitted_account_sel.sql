USE [lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 7/12/2008
-- Description:	Retrieves all accounts that should have a commission request but do not.
-- =============================================
-- Modified 12/02/2009
-- Modified to allow the omission of accounts with 0 usage to reduce the load on the bach processor 
-- ============================================
-- Modified 2/10/2010 Gail Mangaroo 
-- Excluded voided transactions from the transaction_detail table and exclude internal vendors
-- ============================================
-- Modified 2/11/2010 Gail Mangaroo 
-- Added vendor_descp field 
-- ============================================
-- Modified 5/6/2010 Gail Mangaroo 
-- Get vendor names from LibertyPower..salesChannel 
-- ============================================
-- Modified 9/1/2010 Gail Mangaroo 
-- Added NOLOCK optimizer hints to aleviate deadlocks
-- ============================================
-- Modified 8/5/2011 Gail Mangaroo 
-- Removed transaction_request table 
-- ============================================
-- Modified 8/25/2011 Gail Mangaroo 
-- Replaced join with transaction_request table to avoid duplicate requests being submitted
-- ============================================
-- Modified 9/8/2011 Gail Mangaroo 
-- Modified to be more efficient and include 'SOHO'
-- ============================================
-- Modified 9/13/2011 Gail Mangaroo 
-- Ignore omitted accounts less than 5 days old
-- ============================================
-- Modified 12/16/2011 Gail Mangaroo 
-- Modify/Correct 5 day old logic 
-- ============================================
-- Modified 10/3/2012 Gail Mangaroo 
-- use LibertyPower..Name
-- =============================================
-- exec usp_omitted_account_sel '6/1/2008' , '6/10/2008' , 0 , 0 

ALTER PROCEDURE [dbo].[usp_omitted_account_sel] 
	@p_start_date datetime
	, @p_end_date datetime
	, @p_exclude_pending bit = 1
	, @p_vendor_id int = 0 
	, @p_retail_mkt_id varchar(5) = ''
	, @p_account_type varchar(35) = ''
	, @p_start_row int = 0 
	, @p_page_size int = 0 
	, @p_exclude_holds bit = 1 
	, @p_commission_ready_only bit = 0 
	, @p_exclude_no_usage bit = 0 
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

				----drop table #comm_request
				--drop table #comm_status  -- :05
				--drop table #tmp_acct_dtl 
				--drop table #comment --0:25 		
				--drop table #tmp_acct_dtl_1 
				--drop table #tmp_acct
				
				--declare @p_start_date datetime
				--declare @p_end_date datetime
				--declare @p_exclude_pending bit 
				--declare @p_vendor_id int 
				--declare @p_retail_mkt_id varchar(5) 
				--declare @p_account_type varchar(35) 
				--declare @p_start_row int
				--declare @p_page_size int
				--declare @p_exclude_holds bit 
				--declare @p_commission_ready_only bit 
				--declare @p_exclude_no_usage bit 

				--set @p_start_date = '9/1/2012'
				--set @p_end_date = '10/5/2012'
				--set @p_exclude_pending= 0 ---- 
				--set @p_vendor_id = 906 -- 418 
				--set @p_retail_mkt_id = 'IL' ---'IL'
				--set @p_account_type = ''
				--set @p_start_row  =0 
				--set @p_page_size = 0 
				--set @p_exclude_holds = 1 ---  
				--set @p_commission_ready_only = 1 -- c
				--set @p_exclude_no_usage = 0

 	
 	DECLARE @strSQL nvarchar(MAX)
	DECLARE @ParmDefinition nvarchar(MAX) 
								
	SET @ParmDefinition = ' @p_start_date datetime
							, @p_end_date datetime
							, @p_exclude_pending bit 
							, @p_vendor_id int 
							, @p_retail_mkt_id varchar(5) 
							, @p_account_type varchar(35) 
							, @p_start_row int
							, @p_page_size int
							, @p_exclude_holds bit 
							, @p_commission_ready_only bit 
							, @p_exclude_no_usage bit '
							
	
	-- Get account statuses where commission is payable by utility and contract_type
	-- ===============================================================
	SELECT  combined_status = ltrim(rtrim(isnull(t.approved_status, ''))) + ltrim(rtrim(isnull(t.approved_sub_status, ''))), t.utility_id , t.contract_type , utilityID = u.id  
		INTO #comm_status
	FROM lp_common.dbo.common_utility_check_type  t (NOLOCK)
		JOIN LibertyPower.dbo.utility u (NOLOCK) ON t.utility_id = u.utilityCode 
		JOIN ( SELECT utility_id, contract_type , min([order]) as [order] 
				FROM lp_common.dbo.common_utility_check_type
				WHERE commission_on_approval = 1
				GROUP BY utility_id, contract_type
			 ) m ON m.utility_id = t.utility_id 
						AND m.contract_type = t.contract_type 
	WHERE t.[order] >= m.[order]
		AND  ltrim(rtrim(isnull(t.approved_status, ''))) <> ''
	Order by t.utility_id, contract_type  , t.[order]

	CREATE INDEX idx_comm_status on #comm_status ( utilityID , contract_type , combined_status ) 

		
	CREATE TABLE #tmp_acct (AccountID int, accountIDLegacy varchar(50), accountNumber varchar(50), accountNameId int , UtilityID int, AccountTypeID int
			, AccountContractID int , SignedDate datetime, EndDate datetime , salesRep varchar(50), StartDate datetime, Number varchar(50)
			, ContractDealTypeID int, ContractTypeID int, salesChannelID int 
			, MarketCode varchar(50) 
			, vendor_id int, vendor_system_name varchar(150))

	SET @strSQL = '
		SELECT a.AccountID , a.accountIDLegacy, a.accountNumber, a.accountNameId, a.UtilityID, a.AccountTypeID
			, acc.AccountContractID
			, c.SignedDate, c.EndDate, c.salesRep, c.StartDate, c.Number, c.ContractDealTypeID, c.ContractTypeID, c.salesChannelID
			, m.MarketCode
			, v.vendor_id, v.vendor_system_name
			
		FROM LibertyPower.dbo.Account a (NOLOCK) 
			JOIN LibertyPower.dbo.AccountContract acc (NOLOCK) ON a.AccountID = acc.AccountID
			JOIN LibertyPower.dbo.Contract c (NOLOCK) ON c.ContractID = acc.ContractID 
			JOIN LibertyPower.dbo.Market m (NOLOCK) ON m.ID = a.RetailMktID
		    JOIN LibertyPower.dbo.AccountType at (NOLOCK) ON at.ID = a.AccountTypeID 				
			LEFT JOIN lp_commissions.dbo.Vendor v (NOLOCK) ON c.SalesChannelID = v.channelID
			LEFT JOIN lp_commissions.dbo.transaction_detail d (NOLOCK) ON a.AccountIDLegacy = d.account_id 
				AND c.Number = d.contract_nbr 
				AND d.transaction_type_id in ( 1, 5 )  
				AND d.void = 0 
									
		WHERE c.SignedDate between @p_start_date and @p_end_date 
			AND d.account_id is null 
			AND v.inactive_ind = 0 
			AND v.vendor_category_id not in ( 0, 3) -- not internal / undefined
		'
		
	If isnull(@p_vendor_id, 0) <> 0 
		SET @strsql = @strsql + ' AND (v.vendor_id = @p_vendor_id OR v.parent_vendor_id = @p_vendor_id) '
	
	if len(rtrim(isnull(@p_account_type, '') )) <> 0 
		SET @strsql = @strsql + ' AND at.accountType = @p_account_type '
	else
		SET @strsql = @strsql + ' AND at.id in ( 2,3,4 ) ' -- ( 'SOHO', 'SMB', 'RESIDENTIAL', 'RES' )
		
	If len(rtrim(isnull(@p_retail_mkt_id, '') )) <> 0 
		SET @strsql = @strsql + ' AND m.MarketCode = @p_retail_mkt_id '
	
	If @p_commission_ready_only = 1  
		SET @strsql = @strsql + ' AND c.contractStatusID <> 2 '
				
											
	INSERT INTO #tmp_acct 
	EXECUTE sp_executesql  @strsql 
		, @ParmDefinition 
		, @p_start_date = @p_start_date
		, @p_end_date = @p_end_date
		, @p_exclude_pending = @p_exclude_pending
		, @p_vendor_id = @p_vendor_id 
		, @p_retail_mkt_id = @p_retail_mkt_id
		, @p_account_type = @p_account_type 
		, @p_start_row  = @p_start_row  
		, @p_page_size = @p_page_size 
		, @p_exclude_holds = @p_exclude_holds 
		, @p_commission_ready_only = @p_commission_ready_only 
		, @p_exclude_no_usage = @p_commission_ready_only 


	CREATE TABLE #tmp_acct_dtl_1 ( account_id varchar(30) , account_number varchar(30) , full_name varchar(150) 
								, date_deal datetime , requested_flow_start_date datetime, date_end	datetime
								, sales_rep	varchar(150) , annual_usage float , [status]	varchar(30), sub_status varchar(30)
								, contract_nbr	varchar(30) , retail_mkt_id	varchar(30), utility_id varchar(30)
								, term_months int , product_id varchar(30) , sales_channel_role varchar(150)
								, vendor_id	 int , rate	float, rate_id	 int , date_flow_start datetime , date_deenrolled datetime
								, contract_type varchar(150), contract_eff_start_date datetime, product_descp varchar(150)
								, renewal bit , review_ind bit , review_id int ,account_type varchar(150), status_descp varchar(150) 
								, vendor_name varchar(150) , hold_id int , hold_type_descp varchar(150), vendor_descp varchar(350)  )
								

								
	SET @strSQL = '
		SELECT DISTINCT
			account_id			= a.accountIDLegacy
			, account_number	= a.accountNumber
			, full_name		= n.name
			, date_deal			= DATEADD(dd,0, DATEDIFF(dd,0,a.SignedDate))  
			, requested_flow_start_date = DATEADD(dd,0, DATEDIFF(dd,0,a.SignedDate))   -- use date deal for renewals
			, date_end			= a.EndDate  
			, sales_rep			= a.salesRep 
			, annual_usage		= isnull(au.annualusage, 0)
			, [status]			= LTRIM(RTRIM(s.status))
			, sub_status		= LTRIM(RTRIM(s.subStatus))
			, contract_nbr		= a.Number 
			, retail_mkt_id		= a.MarketCode  
			, utility_id		= u.utilityCode 
			, term_months		= accr.Term
			, product_id		= accr.LegacyProductID
			, sales_channel_role = a.vendor_system_name 
			, vendor_id			= a.vendor_id  
			, rate				= accr.rate
			, rate_id			= accr.rateId 
			, date_flow_start	= accr.RateStart 
			, date_deenrolled	= accr.RateEnd 
			, contract_type		= ct.type + '' '' + cdt.DealType 
			, contract_eff_start_date = accr.RateStart 
			, p.product_descp
			, renewal			=  case when a.ContractDealTypeID = 2 then 1 else 0 end  
			, review_ind		= rr.review_ind 
			, review_id			= 0 
			, account_type		= at.AccountType
			, status_descp		= status_descp
			
			, vendor_name = SC.ChannelName 
			, h.hold_id 
			, ht.hold_type_descp
			, vendor_descp = SC.ChannelDescription 

		FROM #tmp_acct a (NOLOCK) 
			
			LEFT JOIN LibertyPower.dbo.vw_AccountContractRate accr (NOLOCK) ON accr.AccountContractID = a.AccountContractID 
				AND accr.IsContractedRate = 1
		    JOIN LibertyPower.dbo.AccountType at (NOLOCK) ON at.ID = a.AccountTypeID 				
			JOIN LibertyPower.dbo.ContractDealType cdt (NOLOCK) ON a.ContractDealTypeID = cdt.ContractDealTypeID
			JOIN LibertyPower.dbo.ContractType ct (NOLOCK) ON a.ContractTypeID = ct.ContractTypeID
			
			LEFT JOIN LibertyPower.dbo.SalesChannel SC (NOLOCK) ON a.salesChannelID = SC.ChannelID 
			LEFT JOIN LibertyPower.dbo.AccountUsage au (NOLOCK) ON a.AccountID = au.AccountID AND  a.StartDate = au.EffectiveDate
			LEFT JOIN LibertyPower.dbo.Utility u (NOLOCK) ON u.ID = a.UtilityID 
			
			LEFT JOIN lp_commissions.dbo.transaction_request r (NOLOCK) ON a.AccountIDLegacy = r.account_id 
				AND a.Number = r.contract_nbr 
				AND a.vendor_system_name = r.vendor_system_name 
				AND (r.process_status = ''0000003'' or r.date_processed is null )
				AND r.transaction_type_Code in ( ''COMM'', ''RENEWCOMM'') 
						
			
			LEFT JOIN lp_common.dbo.common_product p (NOLOCK) ON accr.LegacyProductID = p.product_id 
							
			LEFT JOIN LibertyPower.dbo.AccountStatus s (NOLOCK) ON a.AccountContractID = s.AccountContractID 
			
			LEFT JOIN lp_account.dbo.enrollment_status_substatus_vw st (NOLOCK) ON s.status = st.status 
				AND s.subStatus = st.sub_status
		
			LEFT JOIN LibertyPower.dbo.Name n (NOLOCK) ON a.accountNameId = n.NameId
			
			LEFT JOIN lp_commissions.dbo.commission_review_request rr (NOLOCK) ON rr.contract_nbr = a.Number 
				AND rr.product_id = accr.LegacyProductID 
				AND rr.rate_id = accr.rateID 

			LEFT JOIN lp_commissions.dbo.transaction_hold h (NOLOCK) ON a.accountIDLegacy = h.account_id 
				AND h.transaction_type_id = case when a.ContractDealTypeID = 2 then 5 else 1 end 
				AND h.vendor_id = a.vendor_id 	
				AND h.active = 1 
			
			LEFT JOIN lp_commissions.dbo.hold_type ht (NOLOCK) ON h.hold_type_id = ht.hold_type_id 
			
			LEFT JOIN #comm_status cs (NOLOCK)  ON cs.utilityID = a.utilityID 
				AND cs.contract_type =  ct.type + '' '' + cdt.DealType  
				AND cs.combined_status =  ltrim(rtrim(s.status)) + ltrim(rtrim(s.substatus))
								
		WHERE 1 = 1 	
		'
		
	If  @p_exclude_holds = 1
		SET @strsql = @strsql + ' AND h.hold_id is null '
			
	If 	@p_exclude_pending = 1
		SET @strsql = @strsql + ' AND r.account_id is null '

	If @p_commission_ready_only = 1  --- accounts must be at least five days old to allow for corrections and contract merges etc... 
		SET @strsql = @strsql + '  AND
										 ( ( s.status in (''905000'', ''906000'', ''06000'' , ''05000'')  AND datediff(day, a.SignedDate, getdate()) > 5  ) 
											OR 
										  (s.status in (''07000'' ) AND s.substatus in (''20'') )
											OR
										   cs.combined_status is not null 
										 ) 
								'

	If @p_exclude_no_usage <> 0 
		SET @strsql = @strsql + ' AND au.annualUsage > 0 '
		
	INSERT INTO #tmp_acct_dtl_1
	EXECUTE sp_executesql  @strsql 
		, @ParmDefinition 
		, @p_start_date = @p_start_date
		, @p_end_date = @p_end_date
		, @p_exclude_pending = @p_exclude_pending
		, @p_vendor_id = @p_vendor_id 
		, @p_retail_mkt_id = @p_retail_mkt_id
		, @p_account_type = @p_account_type 
		, @p_start_row  = @p_start_row  
		, @p_page_size = @p_page_size 
		, @p_exclude_holds = @p_exclude_holds 
		, @p_commission_ready_only = @p_commission_ready_only 
		, @p_exclude_no_usage = @p_commission_ready_only 
								
	-- Get account list 
	-- ==============================
	SELECT * , ROW_NUMBER() OVER ( Order by full_name ) as RowNum
	INTO #tmp_acct_dtl
	FROM #tmp_acct_dtl_1
		
			
	-- Get last comment
	-- =====================
	SELECT v.account_id , max(v.date_comment) as date_comment
		INTO #comment 
	FROM #tmp_acct_dtl d
		JOIN lp_account.dbo.comments_vw v (nolock)
			ON d.account_id = v.account_id
	WHERE v.process_id in ( 'CHECK ACCOUNT', 'CREDIT CHECK', 
										'DEENROLLMENT REQUEST', 'ENROLLMENT', 'ENROLLMENT REJECTION', 
										'POST-USAGE CREDIT CHECK', 'POST-USAGE MIN USAGE CHECK', 'PROFITABILITY',
										'USAGE ACQUIRE' , 'TPV' , 'DOCUMENTS')
	GROUP BY v.account_id 
	
	CREATE INDEX idx_comment ON #comment ( account_id , date_comment ) 
	
	-- final select 
	-- =========================
	SELECT d.* , c.comments
	FROM #tmp_acct_dtl d
		LEFT JOIN ( select v.account_id, max(v.comment)  as comments 
					from #comment c 
						JOIN lp_account.dbo.comments_vw v with (nolock) ON c.account_id = v.account_id
							AND c.date_comment = v.date_comment
					group by v.account_id 
				  )  as c ON d.account_id = c.account_id 
	WHERE RowNum >= isnull(@p_start_row , 0)
			AND ( RowNum < isnull(@p_start_row , 0) + isnull(@p_page_size, 0) OR @p_page_size = 0 ) 
	
	
	SELECT Count(*) as MaxRows 
	FROM #tmp_acct_dtl	

END
