USE [lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =====================================================
-- Author:			Gail Mangaroo 
-- Created Date:	8/22/2008
-- Description:		Get report detail for final report 
-- =====================================================
-- Modified 10/2/2009 Gail Mangaroo 
-- Added Vendor_Descp field
-- =====================================================
-- Modified 12/18/2009 Gail Mangaroo 
-- Get single sales rep per contract 
-- =====================================================
-- Modified 12/27/2009 Gail Mangaroo	
-- Get comments from transaction detail instead of invoice_detail/account_summary
-- =====================================================
-- Modified 1/14/2010 Gail Mangaroo
-- Added usage and amount of assoc transaction  
-- ====================================================
-- Modified 2/9/2010 Gail Mangaroo
-- Added deEnrollment date and vendor row numbers
-- ===================================================
-- Modified 4/30/2010 Gail Mangaroo 
-- Altered to include payment schedules in payoff status 
-- ===================================================
-- Modified 5/6/2010 Gail Mangaroo 
-- Get vendor names from LibertyPower..salesChannel
-- ===================================================
-- Modified 5/20/2010 Gail Mangaroo 
-- Exclude transactions assoc with meter reads 
-- ===================================================
-- Modified 8/11/2010 Gail Mangaroo 
-- Included payment plan table
-- ===================================================
-- Modified 8/24/2010 Gail Mangaroo
-- Included additional fields from payment plan table -- payment_num , ect.
-- ===================================================
-- Modified 1/12/2010 Gail Mangaroo 
-- Added plan_id and usage date fields to accomodate the ATMS reports
-- ===================================================
-- Modified 6/6/2011 Gail Mangaroo 
-- added report_type param to payment_plan sub query 
-- ===================================================
-- Modified 2/3/2012 Gail Mangaroo 
-- altered to use LibertyPower..account structure
-- ===================================================
-- Modified 8/1/2012 Gail Mangaroo
-- optimized
-- ===================================================
-- Modified 8/21/2012 Gail Mangaroo 
-- fixed issue with un-approved transactions not showing and status of deleted accounts 
-- ===================================================
-- Modified 9/19/2012 Gail Mangaroo 
-- fixed issue with duplicate entries in lp_account..account_name
-- Use LibertyPower..Name structure
-- ===================================================
-- Modified 6/25/2013 Gail Mangaroo
-- Added payment_type_id and report_freq_id fields
-- ===================================================
-- Modified 9/19/2013 Gail Mangaroo
-- Corrected values assigned to the payment_type_id field 
-- and added total field.
-- ===================================================
-- Modified 9/23/2013 Gail Mangaroo 
-- Corrrected join on total field 
-- ===================================================
ALTER PROC [dbo].[usp_report_detail_prelim_sel]
	@p_calculation_freq_id int 
	, @p_due_date datetime 
	, @p_vendor_id int 
	, @p_retail_mkt_id varchar(5) = ''
	, @p_report_type_id int = 1
	, @p_payable_only bit = 1 
	, @p_payment_type_id int  = 0


AS
BEGIN 
	 --drop table #report_detail
	 --drop table #trans_list 		
	 --drop table #pymt_trans_list
	 --drop table #vendor_list
	 --drop table #unique_list
	 
	CREATE TABLE #report_detail 
		( line_item_type_code varchar(50) 
			, line_item_type_descp varchar(150) 
			, line_item_type_id int
			, transaction_detail_id  int 
			, amount money 
			, rate float
			, term float 
			, contract_term float
			, product_id varchar(50) 
			, date_deal datetime 
			, date_due datetime 
			, base_amount money 
			, transaction_status_id int 
			, transaction_status_code varchar(50)
			, transaction_status_descp varchar(50) 
			, transaction_type_descp varchar(150) 
			, transaction_type_id int 
			, account_name varchar(150) 
			, account_number varchar(50) 
			, sales_rep varchar(50) 
			, account_summary_id int 
			, comments varchar(250)
			, contract_nbr varchar(50) 
			, status_id int 
			, status_code varchar(100)
			, status_descp varchar(100)
			, summary_id int 
			, next_payment_amt money 
			, next_payment_descp varchar(200)
			, pymt_num int
			, num_payments int 
			, payment_freq_id int 
			, payment_freq_code varchar(50)
			, item_descp varchar(150) 
			, retail_mkt_id varchar(25)
			, utility_id varchar(100)
			, vendor_id int 
			, vendor_name varchar(100) 
			, target_date datetime
			, product_descp varchar(150)
			, unique_id varchar(100)
			, reason varchar(200) 
			, reason_code varchar(50)
			, account_status varchar(30)
			, account_sub_status varchar(30) 
			, account_status_descp varchar(150)
			, account_sub_status_descp varchar(150) 
			, account_id varchar(50)
			, vendor_descp varchar(150)
			
			, assoc_base_amount float 
			, assoc_amount money
			, date_deenrollment datetime
			
			, plan_id int
			
			, usage_start_date datetime
			, usage_end_date datetime
			, read_date datetime 
			
			, report_freq_id int 
			, payment_type_id int 
		) 
	
	
	DECLARE @report_freq_code varchar(50) 
	SELECT @report_freq_code = calculation_freq_code 
		FROM lp_commissions..calculation_freq (NOLOCK)
		WHERE calculation_freq_id = @p_calculation_freq_id 

	DECLARE @strsql nvarchar(max)
	DECLARE @strparam nvarchar(1000)
	
	-- initiate temp tables 
	CREATE TABLE #trans_list_temp ( transaction_detail_id int )
	create CLUSTERED index idx_tlt_1 on #trans_list_temp (transaction_detail_id ) 
	
	CREATE TABLE #trans_list_temp_2  ( transaction_detail_id int, payment_type_id int )
	create CLUSTERED index idx_tlt_2 on #trans_list_temp_2 (transaction_detail_id ) 
	
	-- get transaction detail set 
	set @strparam = N' @p_due_date datetime 
						, @p_calculation_freq_id int
						, @p_vendor_id int
						, @p_retail_mkt_id varchar(5)
					'
					
	set @strsql = 
		'SELECT d.transaction_detail_id 
			FROM lp_commissions..transaction_detail d (NOLOCK) 
			WHERE d.invoice_id = 0 
				and d.void = 0 
				and d.date_due <= @p_due_date '

	if isnull(@p_calculation_freq_id, 0) <> 0 
		set @strsql = @strsql + ' and d.calculation_freq_id = @p_calculation_freq_id '
	
	if isnull(@p_vendor_id, 0) <> 0 
		set @strsql = @strsql + ' and d.vendor_id = @p_vendor_id '
	
	if isnull(@p_retail_mkt_id, '') <> ''
		set @strsql = @strsql + ' and d.retail_mkt_id = @p_retail_mkt_id '
		
	if isnull(@p_report_type_id, 0) = 2 
		set @strsql = @strsql + ' and d.exception_ind = 1 '
	
	if isnull(@p_payable_only, 0) = 1 
		set @strsql = @strsql + ' and d.approval_status_id = 1 '
	
	set @strsql = @strsql + ' ORDER BY d.transaction_detail_id '
	
	INSERT INTO #trans_list_temp
	EXECUTE sp_executesql   @strsql , @strparam
			, @p_due_date = @p_due_date
			, @p_vendor_id = @p_vendor_id
			, @p_calculation_freq_id = @p_calculation_freq_id 
			, @p_retail_mkt_id = @p_retail_mkt_id 
			
	
	--IF isnull(@p_payment_type_id,0) <> 0
	--BEGIN 
		-- Filter by payment type 
		-- ===========================
		INSERT INTO #trans_list_temp_2
		SELECT t.* 
			, payment_type_id = case when isnull(pod.payment_type_id, 0) > 0 then pod.payment_type_id 
									 when isnull(pod_assoc.payment_type_id, 0) > 0 then pod_assoc.payment_type_id 
									 when isnull(pod_assoc2.payment_type_id, 0) > 0 then pod_assoc2.payment_type_id 
								else 0 end 
			-- isnull(isnull(pod.payment_type_id, isnull(pod_assoc.payment_type_id , pod_assoc2.payment_type_id )) , 0)  
			--, assoc.base_amount as assoc_base_amount , assoc.amount  = assoc_amount 
		FROM  #trans_list_temp t (NOLOCK)
			JOIN lp_commissions..transaction_detail d (NOLOCK) on d.transaction_detail_id = t.transaction_detail_id 
			LEFT JOIN lp_commissions..payment_option_def pod (NOLOCK) ON d.payment_option_def_id = pod.payment_option_def_id 

			LEFT JOIN lp_commissions..transaction_detail assoc (NOLOCK) ON d.assoc_transaction_id = assoc.transaction_detail_id 
			LEFT JOIN lp_commissions..payment_option_def pod_assoc (NOLOCK) ON assoc.payment_option_def_id = pod_assoc.payment_option_def_id 

			LEFT JOIN lp_commissions..transaction_detail assoc2 (NOLOCK) ON assoc.assoc_transaction_id = assoc2.transaction_detail_id 
			LEFT JOIN lp_commissions..payment_option_def pod_assoc2 (NOLOCK) ON assoc2.payment_option_def_id = pod_assoc2.payment_option_def_id 
		
		WHERE ( pod.payment_type_id = @p_payment_type_id 
					OR pod_assoc.payment_type_id = @p_payment_type_id 
					OR pod_assoc2.payment_type_id = @p_payment_type_id 
					OR isnull(@p_payment_type_id,0) = 0 
					OR (isnull(d.payment_option_def_id, 0) = 0 AND d.transaction_detail_id is not null AND isnull(pod_assoc.payment_type_id , 0) = 0 AND isnull(pod_assoc2.payment_type_id , 0) = 0) 
					OR (isnull(assoc.payment_option_def_id, 0) = 0 AND assoc.transaction_detail_id is not null AND isnull(d.payment_option_def_id, 0) = 0 AND isnull(pod_assoc2.payment_type_id , 0) = 0) 
					OR (isnull(assoc2.payment_option_def_id, 0) = 0 AND assoc2.transaction_detail_id is not null AND isnull(assoc.payment_option_def_id, 0) = 0 AND assoc.transaction_detail_id is not null AND isnull(d.payment_option_def_id, 0) = 0) 
				)
		ORDER BY t.transaction_detail_id
		--DELETE t1 
		--FROM #trans_list_temp t1 (NOLOCK)
		--	LEFT JOIN #trans_list_temp_2 t2 (NOLOCK) 
		--		ON t1.transaction_detail_id = t2.transaction_detail_id 
		--WHERE t2.transaction_detail_id is null 
		
	--END -- filter by payment type 


	-- Get Transaction Detail with New Payment Plans
	-- =============================================
		 	-- tl.payment_type_id
	-- get payment data 	
	CREATE TABLE #trans_list (transaction_detail_id int, payment_amount money, plan_id int, payment_freq_id int, num_payments int, payment_type_id int) 
	create CLUSTERED index idx_tl on #trans_list (transaction_detail_id ) 
	
	SET @strsql =  ' 
		SELECT tl.transaction_detail_id, ppp.payment_amount, pp.plan_id, pp.payment_freq_id , pp.num_payments , tl.payment_type_id
		FROM #trans_list_temp_2 tl (NOLOCK)
			LEFT JOIN lp_commissions..payment_plan_transaction_detail ppd (NOLOCK) 
				ON tl.transaction_detail_id = ppd.transaction_detail_id
			LEFT JOIN lp_commissions..payment_plan pp  (NOLOCK)
				ON ppd.plan_id = pp.plan_id
			LEFT JOIN lp_commissions..payment_plan_pymt ppp (NOLOCK) 
				ON pp.plan_id = ppp.plan_id 
		WHERE isnull(ppp.payment_number, 1) = 1 
			AND isnull(ppd.active, 1)  = 1
		'
		
	if isnull(@p_report_type_id, 0) = 2 
		set @strsql = @strsql + ' and isnull(pp.report_type_id, 1) = ' + cast (@p_report_type_id as char)
	else
		-- then only want standard report records. Can be duplicates if all records included
		set @strsql = @strsql + ' and isnull(pp.report_type_id, 1) = 1 ' 
		
	set @strsql = @strsql + ' ORDER BY ppd.transaction_detail_id '

	INSERT	INTO #trans_list
	EXECUTE sp_executesql @strsql 

	drop table #trans_list_temp
	drop table #trans_list_temp_2
				
	-- get transaction detail 	
	INSERT INTO #report_detail
	SELECT DISTINCT l.line_item_type_code
		, l.line_item_type_descp 
		, l.line_item_type_id 
		, d.transaction_detail_id 
		, d.amount
		, d.rate
		, d.term 
		, d.contract_term 
		, d.product_id 
		, d.date_deal 
		, d.date_due 
		, d.base_amount 
		, transaction_status_id = d.approval_status_id 
		, transaction_status_code = ds.status_code
		, transaction_status_descp = ds.status_descp
		, tt.transaction_type_descp , tt.transaction_type_id 
		, account_name = n.name 
		, account_number  = ac.AccountNumber 
		, sales_rep = c2.salesrep 
		, a.account_summary_id 
		, comments = isnull(d.comments, '') 
		, a.contract_nbr 
		, a.status_id 
		, status_code = isnull(sl.status_code, '') 
		, status_descp = isnull(sl.status_descp , '')
		, summary_id = c.contract_summary_id 

		, next_payment_amt = isnull(isnull(tl.payment_amount, c.next_payment_amt),0)
		, next_payment_descp = isnull(c.next_payment_descp , '')
		, pymt_num = 1 
		, num_payments = isnull(isnull(tl.num_payments, c.num_payments),1)  
		, payment_freq_id = isnull(isnull(tl.payment_freq_id, c.payment_freq_id),0) 
		, payment_freq_code = isnull(isnull(f2.payment_freq_code, f.payment_freq_code), '')
		, item_descp = 'Contract'

		-- common  detail
		, retail_mkt_id = isnull(u.retail_mkt_id, '') 
		, utility_id = isnull(u.utility_id, '') 
		, v.vendor_id 
		, vendor_name = isnull(SC.ChannelName, '') 
		, target_date =  @p_due_date
		, product_descp = isnull(p.product_descp, '' ) 
		
		, unique_id = 'C' + ltrim(rtrim(cast(c.contract_summary_id as char)))
		, reason = isnull(replace (d.reason_code , r.reason_code , r.reason_code_descp) , '')
		, reason_code = d.reason_code 
		, account_status = s.Status
		, account_sub_status = s.SubStatus 
		, account_status_descp = case when acc.AccountContractID is null then 'Deleted' else vs.status_descp end
		, account_sub_status_descp = vs.sub_status_descp
		, account_id = a.account_id 
		
		, vendor_descp = SC.ChannelDescription
		, assoc_base_amount = assoc.base_amount 
		, assoc_amount = assoc.amount 
		, date_deenrollment  = '1/1/1900' 
		, tl.plan_id
		, usage_start_date = d.date_term_start
		, usage_end_date = d.date_term_end 
		, read_date = null 
		
		, report_freq_id = d.calculation_freq_id
		, payment_type_id = tl.payment_type_id
			
	FROM 	
		-- transaction detail 
		#trans_list tl  (NOLOCK) 
		JOIN lp_commissions..transaction_detail d (NOLOCK) ON d.transaction_detail_id = tl.transaction_detail_id 
		JOIN lp_commissions..account_summary a (NOLOCK) ON d.transaction_summary_id = a.account_summary_id 
		JOIN lp_commissions..contract_summary c (NOLOCK) ON c.contract_summary_id = a.contract_summary_id
						
		JOIN lp_commissions..vendor v (NOLOCK) on v.vendor_id = c.vendor_id
		JOIN lp_common.dbo.common_utility u (NOLOCK) ON d.utility_id = u.utility_id
		JOIN lp_common..common_product p (NOLOCK) on d.product_id = p.product_id 
		
		JOIN lp_commissions..status_list sl (NOLOCK) ON a.status_id = sl.status_id
		JOIN lp_commissions..transaction_type tt (NOLOCK) ON d.transaction_type_id = tt.transaction_type_id
			
		LEFT JOIN libertypower..account ac (NOLOCK) ON ac.accountidLegacy = d.account_id 
		LEFT JOIN LibertyPower..Contract c2 (NOLOCK) ON c2.Number = d.contract_nbr 
		--LEFT JOIN lp_account..account_name acc_name (NOLOCK) ON ac.accountNameId = acc_name.accountNameId
		LEFT JOIN LibertyPower.dbo.Name n (NOLOCK) on ac.accountNameid = n.nameid
		LEFT JOIN LibertyPower..AccountContract acc (NOLOCK) ON ac.AccountID = acc.AccountID
			AND c2.ContractID = acc.ContractID 
		LEFT JOIN  LibertyPower..AccountStatus s (NOLOCK) ON s.AccountContractID = acc.AccountContractID 
		LEFT JOIN lp_account.dbo.enrollment_status_substatus_vw vs (NOLOCK) ON s.status = vs.status AND s.substatus = vs.sub_status
		
		LEFT JOIN lp_commissions..payment_freq f (NOLOCK) ON c.payment_freq_id = f.payment_freq_id
		LEFT JOIN lp_commissions..payment_freq f2 (NOLOCK) ON tl.payment_freq_id = f2.payment_freq_id

		LEFT JOIN lp_commissions..status_list ds (NOLOCK) ON d.approval_status_id = ds.status_id
		LEFT JOIN lp_commissions..reason_code r (NOLOCK) ON r.reason_code = case when charindex('-', d.reason_code) > 0 then substring(d.reason_code, 1, charindex('-', d.reason_code ) - 1 ) 
														else d.reason_code 
													end 
		LEFT JOIN lp_commissions..transaction_detail assoc (NOLOCK) ON d.assoc_transaction_id = assoc.transaction_detail_id 
		LEFT JOIN LibertyPower.dbo.SalesChannel AS SC (NOLOCK) ON v.ChannelID = SC.ChannelID 
		LEFT JOIN lp_commissions..line_item_type l (NOLOCK) ON l.line_item_type_id = 1

	-- END Get Transaction Detail with New Payment Plans
	-- =============================================
	
	-- Get Transaction Detail for Continuing payments from previous reports ; scheduled for payment on next report  
	-- =============================================================================================================
	
	-- get pending payments from open schedules 
	set @strparam = N' @p_due_date datetime 
						, @p_calculation_freq_id int
						, @p_vendor_id int
						, @p_retail_mkt_id varchar(5)
					'
	SET @strsql = ' SELECT d.transaction_detail_id , p.payment_schedule_id , c.contract_summary_id , a.account_summary_id 
					FROM lp_commissions..payment_schedule p (NOLOCK) 
						JOIN lp_commissions..contract_summary c (NOLOCK) ON c.contract_summary_id = p.line_item_id and p.line_item_type_id = 1
						JOIN lp_commissions..account_summary a (NOLOCK) on a.contract_summary_id = c.contract_summary_id 
						JOIN lp_commissions..transaction_detail d (NOLOCK) on d.transaction_summary_id = a.account_summary_id and p.invoice_id = d.invoice_id
					WHERE 1 = 1 
						AND p.status_id in (9 , 16) 
						AND payment_due_date <= @p_due_date '
				
	if isnull(@p_calculation_freq_id, 0) <> 0 
		set @strsql = @strsql + ' and d.calculation_freq_id = @p_calculation_freq_id ' 
	
	if isnull(@p_vendor_id, 0) <> 0 
		set @strsql = @strsql + ' and d.vendor_id = @p_vendor_id ' 
	
	if isnull(@p_retail_mkt_id, '') <> ''
		set @strsql = @strsql + ' and d.retail_mkt_id = @p_retail_mkt_id '

	SET @strsql = @strsql + ' ORDER BY contract_summary_id, account_summary_id, payment_schedule_id, transaction_detail_id ' 
	
	SELECT 0 transaction_detail_id , 0 payment_schedule_id ,  0 contract_summary_id , 0 account_summary_id 
	INTO #pymt_trans_list
	create CLUSTERED index idx_ptl on #pymt_trans_list (contract_summary_id, account_summary_id, payment_schedule_id, transaction_detail_id ) 	
							
	INSERT INTO #pymt_trans_list 
	--select * from #pymt_trans_list
	EXECUTE sp_executesql @strsql, @strparam
			, @p_due_date = @p_due_date
			, @p_vendor_id = @p_vendor_id
			, @p_calculation_freq_id = @p_calculation_freq_id 
			, @p_retail_mkt_id = @p_retail_mkt_id 
	
	-- get transaction detail 
	INSERT INTO #report_detail
	SELECT DISTINCT l.line_item_type_code
		, l.line_item_type_descp 
		, l.line_item_type_id 
		, d.transaction_detail_id 
		, d.amount
		, d.rate
		, d.term 
		, d.contract_term 
		, d.product_id 
		, d.date_deal 
		, d.date_due 
		, d.base_amount 
		, transaction_status_id = d.approval_status_id 
		, transaction_status_code = ds.status_code
		, transaction_status_descp = ds.status_descp
		, tt.transaction_type_descp , tt.transaction_type_id 
			
		-- account _detail 
		, account_name = i.account_name
		, account_number  = i.account_number
		, sales_rep = i.sales_rep

		-- acct summary detail 
		, a.account_summary_id 
		, comments = isnull(d.comments, '') 
		, i.contract_nbr 
		, i.status_id 
		, status_code = isnull(sl.status_code, '') 
		, status_descp = isnull(sl.status_descp , '')

		-- contract summary detail 
		, summary_id = p.line_item_id 
		, next_payment_amt = case when p.status_id = 9 then p.payment_amt when p.status_id = 16 then total_amt - isnull((select sum(payment_amount) from lp_commissions..payment (NOLOCK)where payment_schedule_id = p.payment_schedule_id), 0) else 0 end --p.payment_amt  
		, next_payment_descp = isnull(p.payment_descp , '') + case when p.status_id = 16 then ' - Balance' else '' end  
		, pymt_num = isnull((select count(*) from lp_commissions..payment (NOLOCK) where payment_schedule_id = p.payment_schedule_id), 0) + 1  
		, p.num_payments 
		, p.payment_freq_id
		, payment_freq_code = isnull(f.payment_freq_code, '')
		, item_descp = 'Contract'

		-- common  detail
		, retail_mkt_id = isnull(u.retail_mkt_id, '') 
		, utility_id = isnull(u.utility_id, '') 
		, v.vendor_id 
		, vendor_name = isnull(SC.ChannelName, '') 
		, target_date =  @p_due_date
		, product_descp = isnull(pr.product_descp, '' ) 
	
		, unique_id = 'P' + ltrim(rtrim(cast(p.payment_schedule_id as char)))
		, reason = isnull(replace (d.reason_code , r.reason_code , r.reason_code_descp) , '')
		, reason_code = d.reason_code 
		, account_status = i.account_status
		, account_sub_status = i.account_sub_status
		, account_status_descp = vs.status_descp
		, account_sub_status_descp = vs.sub_status_descp
		, account_id = a.account_id 
		
		,vendor_descp = SC.ChannelDescription
		
		, assoc_base_amount = assoc.base_amount 
		, assoc_amount = assoc.amount 
		, date_deenrollment = '1/1/1900' -- = case when acr.date_deenrollment is null then acc.date_deenrollment else acr.date_deenrollment end
			
		, p.plan_id 

		, usage_start_date = d.date_term_start -- x.start_date
		, usage_end_date = d.date_term_end  -- x.end_date 
		, read_date = null -- x.read_date 
							
		, report_freq_id = d.calculation_freq_id
		, payment_type_id =  case when isnull(pod.payment_type_id, 0) > 0 then pod.payment_type_id 
									 when isnull(pod_assoc.payment_type_id, 0) > 0 then pod_assoc.payment_type_id 
									 when isnull(pod_assoc2.payment_type_id, 0) > 0 then pod_assoc2.payment_type_id 
								else 0 end 
							-- isnull(isnull(pod.payment_type_id, isnull(pod_assoc.payment_type_id , pod_assoc2.payment_type_id )) , 0) 
										
	FROM 	#pymt_trans_list ptl (NOLOCK)
			JOIN lp_commissions..payment_schedule p (NOLOCK) ON p.payment_schedule_id = ptl.payment_schedule_id 
			JOIN lp_commissions..contract_summary c (NOLOCK) ON c.contract_summary_id = ptl.contract_summary_id -- line_item_id and p.line_item_type_id = 1
			JOIN lp_commissions..account_summary a (NOLOCK) on a.account_summary_id = ptl.account_summary_id -- a.contract_summary_id = c.contract_summary_id 
			JOIN lp_commissions..transaction_detail d (NOLOCK) on d.transaction_detail_id = ptl.transaction_detail_id -- d.transaction_summary_id = a.account_summary_id and p.invoice_id = d.invoice_id
			LEFT JOIN lp_commissions..payment_option_def pod (NOLOCK) ON d.payment_option_def_id = pod.payment_option_def_id 
			
			JOIN lp_commissions..invoice_detail i (NOLOCK) ON i.payment_schedule_id = p.payment_schedule_id and a.account_id = i.account_id 
			JOIN lp_commissions..vendor v (NOLOCK) on v.vendor_id = d.vendor_id

			LEFT JOIN lp_common.dbo.common_utility u (NOLOCK) ON d.utility_id = u.utility_id
			LEFT JOIN lp_common..common_product pr (NOLOCK) on d.product_id = pr.product_id 

			LEFT JOIN lp_commissions..line_item_type l (NOLOCK) ON l.line_item_type_id = 1
			LEFT JOIN lp_commissions..status_list sl (NOLOCK) ON i.status_id = sl.status_id
			LEFT JOIN lp_commissions..transaction_type tt (NOLOCK) ON d.transaction_type_id = tt.transaction_type_id
			
			LEFT JOIN lp_commissions..payment_freq f (NOLOCK) ON c.payment_freq_id = f.payment_freq_id
			LEFT JOIN lp_commissions..status_list ds (NOLOCK) ON d.approval_status_id = ds.status_id

			LEFT JOIN lp_commissions..reason_code r (NOLOCK) ON r.reason_code = case when charindex('-', d.reason_code) > 0 then substring(d.reason_code, 1, charindex('-', d.reason_code ) - 1 ) 
															else d.reason_code 
														end 
			
			LEFT JOIN lp_account.dbo.enrollment_status_substatus_vw vs (NOLOCK) ON i.account_status = vs.status 
				AND i.account_sub_status = vs.sub_status
			
			LEFT JOIN lp_commissions..transaction_detail assoc (NOLOCK) ON d.assoc_transaction_id = assoc.transaction_detail_id 
			LEFT JOIN lp_commissions..payment_option_def pod_assoc (NOLOCK) ON assoc.payment_option_def_id = pod_assoc.payment_option_def_id 

			LEFT JOIN lp_commissions..transaction_detail assoc2 (NOLOCK) ON assoc.assoc_transaction_id = assoc2.transaction_detail_id 
			LEFT JOIN lp_commissions..payment_option_def pod_assoc2 (NOLOCK) ON assoc2.payment_option_def_id = pod_assoc2.payment_option_def_id 

			LEFT JOIN libertypower..account ac (NOLOCK) ON ac.accountidLegacy = d.account_id 
			LEFT JOIN LibertyPower..Contract c2 (NOLOCK) ON c2.Number = d.contract_nbr 
			-- LEFT JOIN lp_account..account_name acc_name (NOLOCK) ON ac.accountNameId = acc_name.accountNameId
			LEFT JOIN LibertyPower..AccountContract acc (NOLOCK) ON ac.AccountID = acc.AccountID
				AND c2.ContractID = acc.ContractID 
			LEFT OUTER JOIN LibertyPower.dbo.SalesChannel AS SC (NOLOCK) ON v.ChannelID = SC.ChannelID 

	WHERE 1= 1 


			AND ( pod.payment_type_id = @p_payment_type_id 
				OR pod_assoc.payment_type_id = @p_payment_type_id 
				OR pod_assoc2.payment_type_id = @p_payment_type_id 
				OR isnull(@p_payment_type_id,0) = 0 
				OR (isnull(d.payment_option_def_id, 0) = 0 AND d.transaction_detail_id is not null AND isnull(pod_assoc.payment_type_id , 0) = 0 AND isnull(pod_assoc2.payment_type_id , 0) = 0) 
				OR (isnull(assoc.payment_option_def_id, 0) = 0 AND assoc.transaction_detail_id is not null AND isnull(d.payment_option_def_id, 0) = 0 AND isnull(pod_assoc2.payment_type_id , 0) = 0) 
			    OR (isnull(assoc2.payment_option_def_id, 0) = 0 AND assoc2.transaction_detail_id is not null AND isnull(assoc.payment_option_def_id, 0) = 0 AND assoc.transaction_detail_id is not null AND isnull(d.payment_option_def_id, 0) = 0) 
			)

	-- END Get Transaction Detail for Continuing payments from previous reports ; scheduled for payment on next report  
	-- =============================================================================================================
					

/*			
	-- fix missing names
	-- =====================================
	DECLARE name_csr CURSOR FOR 
		SELECT Distinct account_id, contract_nbr 
		FROM @report_detail
		WHERE ltrim(rtrim(isnull(account_number, '' ))) = ''
		
	OPEN name_csr
	FETCH NEXT FROM name_csr INTO  @msg_acct_id, @msg_contr_nbr
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		UPDATE @report_detail SET sales_rep = h.sales_rep, account_number = h.account_number, account_name = h.full_name, account_status = h.status, account_sub_status = h.sub_status, date_deenrollment = h.date_deenrollment  
		FROM @report_detail d
			JOIN ( SELECT * FROM  lp_commissions.dbo.ufn_account_detail_historical (@msg_acct_id, @msg_contr_nbr)) as h
				ON d.account_id = h.account_id AND d.contract_nbr = h.contract_nbr 
		WHERE d.account_id = @msg_acct_id AND d.contract_nbr = @msg_contr_nbr AND  ltrim(rtrim(isnull(d.account_number, '' ))) = ''
		
		FETCH NEXT FROM name_csr INTO  @msg_acct_id, @msg_contr_nbr
	END 
	CLOSE name_csr
	DEALLOCATE name_csr 

		
	-- Update acct_status where necessary 
	-- ======================================
	UPDATE @report_detail SET account_status_descp = vs.status_descp, account_sub_status_descp = vs.sub_status_descp
	FROM @report_detail d
		JOIN lp_account.dbo.enrollment_status_substatus_vw vs (NOLOCK) ON d.account_status = vs.status AND d.account_sub_status = vs.sub_status
	WHERE account_status_descp = '' and account_sub_status_descp = ''
*/

	-- get unique vendors  
	-- =====================================
	SELECT distinct vendor_id , vendor_name 
	INTO #vendor_list
	FROM #report_detail (NOLOCK)
	create CLUSTERED index udx_vl on #vendor_list (vendor_id , vendor_name ) 

	-- get unique values 
	-- =====================================
	SELECT distinct vendor_id , report_freq_id , retail_mkt_id , sales_rep, unique_id , next_payment_amt 
	INTO #unique_list	
	FROM #report_detail (NOLOCK)
	create CLUSTERED index idx_ul on #unique_list (vendor_id , retail_mkt_id , sales_rep ) 
				
	SELECT a.* 
		, b.vendor_mkt_total 
		, c.vendor_mkt_rep_total 
		, report_freq_code = @report_freq_code 
		, d.vendor_total 
		, grand_total = (SELECT sum(next_payment_amt) FROM #unique_list (NOLOCK))  
		, e.vendor_order_by_name
		, g.report_freq_vendor_total
		, h.report_freq_grand_total
	FROM #report_detail a (NOLOCK)
		LEFT JOIN ( 	
				SELECT vendor_id , retail_mkt_id  ,  sum(next_payment_amt) as vendor_mkt_total  
				FROM #unique_list (NOLOCK)
				GROUP BY  vendor_id , retail_mkt_id 
			) b ON	a.vendor_id = b.vendor_id AND a.retail_mkt_id = b.retail_mkt_id  
		LEFT JOIN ( 	
				SELECT vendor_id , retail_mkt_id  , sales_rep, sum(next_payment_amt) as vendor_mkt_rep_total  
				FROM #unique_list (NOLOCK)
				GROUP BY  vendor_id , retail_mkt_id , sales_rep
			) c ON	a.vendor_id = c.vendor_id AND a.retail_mkt_id = c.retail_mkt_id  AND a.sales_rep = c.sales_rep
 
		LEFT JOIN ( 	
				SELECT vendor_id , sum(next_payment_amt) as vendor_total  
				FROM #unique_list (NOLOCK)
				GROUP BY  vendor_id 
			) d ON	a.vendor_id = d.vendor_id  
			
		LEFT JOIN ( 
				SELECT vendor_id, row_number() over (order by vendor_name) as vendor_order_by_name
				FROM #vendor_list (NOLOCK)
			) e ON a.vendor_id = e.vendor_id

		LEFT JOIN ( 	
				SELECT vendor_id , report_freq_id , sum(next_payment_amt) as report_freq_vendor_total  
				FROM #unique_list (NOLOCK)
				GROUP BY vendor_id , report_freq_id 
			) g ON	a.vendor_id = g.vendor_id AND a.report_freq_id = g.report_freq_id
					
		LEFT JOIN ( 	
				SELECT report_freq_id , sum(next_payment_amt) as report_freq_grand_total  
				FROM #unique_list (NOLOCK)
				GROUP BY report_freq_id 
			) h ON	a.report_freq_id = h.report_freq_id
					
	ORDER BY vendor_name, retail_mkt_id, sales_rep	

END
GO