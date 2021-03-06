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
-- Added reason_code, usage and amount of assoc transaction  
-- ====================================================
-- Modified 2/9/2010 Gail Mangaroo
-- Added deEnrollment date and vendor row number 
-- ===================================================
-- Modified 5/20/2010 Gail Mangaroo 
-- Exclude transactions assoc with meter reads 
-- ===================================================
-- Modified 8/10/2010 Gail Mangaroo 
-- Use payment type to filter report ( ATMS / Prepaid ) 
-- Altered to use LibertPower..SalesChannel
-- ===================================================
-- Modified 9/7/2010 Gail Mangaroo 
-- Added NOLOCK optimizer hints. Resolved issue with duplicates as a result of payment plan updates. 
-- ===================================================
-- Modified 1/12/2010 Gail Mangaroo 
-- Added plan_id and usage date fields to accomodate the ATMS reports
-- ===================================================
-- Modified 2/3/2012 Gail Mangaroo 
-- Added NOlock and removed lp_account..account ref
-- ===================================================
-- Modified 2/29/2012 Gail Mangaroo 
-- Modified to be more efficient
-- ===================================================
-- Modified 6/3/2013 Gail Mangaroo
-- Added payment_type_id , calculation_freq_id
-- ===================================================
-- Modified 6/25/2013 Gail Mangaroo
-- Added payment_type_id and report_freq_id fields
-- ===================================================
-- Modified 9/19/2013 Gail Mangaroo
-- Added total field
-- ===================================================
-- Modified 9/23/2013 Gail Mangaroo 
-- Corrrected join on total field 
-- ===================================================
ALTER PROC [dbo].[usp_report_detail_final_sel]
 @p_report_id int 
	, @p_vendor_id int = 0
	, @p_retail_mkt_id varchar(5) = ''
	, @p_payable_only bit = 1
	, @p_report_date_start datetime = null 
	, @p_report_date_end datetime  = null 
	, @p_payment_type_id int = 0 
	
AS
BEGIN 

	--drop table #tmp_rpt_transactions
	--drop table #unique_list	
	--drop table #vendor_list
	--drop table #tmp_rpt_dtl

	DECLARE @reportID table ( report_id int) 

	IF isnull(@p_report_id, 0) = 0 AND @p_report_date_start > '1/1/1900' AND @p_report_date_end > '1/1/1900'
	BEGIN
		print 'here 1'
		INSERT INTO @reportID 
		SELECT report_id 
			FROM lp_Commissions..report (NOLOCK)
			WHERE target_date between @p_report_date_start AND @p_report_date_end AND status_id = 8 
	END 
	ELSE
		IF isnull(@p_report_id, 0) > 0 
		BEGIN
		print 'here 3'
			INSERT INTO @reportID 
			SELECT report_id 
				FROM lp_Commissions..report  (NOLOCK)
			WHERE report_id = @p_report_id OR assoc_report_id = @p_report_id
		END 
	
	
	SELECT * 
	INTO #tmp_rpt_dtl
	FROM 
	(
	-- get transaction detail -- with payment plans  -- AFTER IT026 
	SELECT DISTINCT r.report_id 
			, d.transaction_detail_id 
			, p.payment_id
			, p.invoice_id 
			, ps.payment_schedule_id 
			, id.invoice_detail_id 
			, ps.plan_id 
	
	FROM @reportID r 
		JOIN lp_commissions..invoice i (NOLOCK) ON r.report_id = i.report_id 
		JOIN lp_commissions..payment p (NOLOCK) on i.invoice_id = p.invoice_id 
		JOIN lp_commissions..payment_schedule ps (NOLOCK) ON p.payment_schedule_id = ps.payment_schedule_id 
		JOIN lp_commissions..payment_plan pp (NOLOCK) ON pp.plan_id = ps.plan_id 
		JOIN lp_commissions..payment_plan_transaction_detail ppd (NOLOCK) ON ppd.plan_id = pp.plan_id --transaction_detail_id  
		JOIN lp_commissions..transaction_detail d (NOLOCK) ON ppd.transaction_detail_id = d.transaction_detail_id
		JOIN lp_commissions..invoice_detail id (NOLOCK) ON ps.payment_schedule_id = id.payment_schedule_id
	
	UNION 
	
	-- get transaction detail -- without payment plans  -- BEFORE IT026 
	SELECT DISTINCT r.report_id 
			, d.transaction_detail_id 
			, p.payment_id
			, p.invoice_id 
			, ps.payment_schedule_id 
			, id.invoice_detail_id 
			, ps.plan_id 
	
	FROM @reportID r 
		JOIN lp_commissions..invoice i (NOLOCK) ON r.report_id = i.report_id 
		JOIN lp_commissions..payment p (NOLOCK) on i.invoice_id = p.invoice_id 
		JOIN lp_commissions..payment_schedule ps (NOLOCK) ON p.payment_schedule_id = ps.payment_schedule_id 
		JOIN lp_commissions..contract_summary cs (NOLOCK) ON ps.line_item_id = cs.contract_summary_id 
		JOIN lp_commissions..account_summary acs (NOLOCK) ON acs.contract_summary_id = cs.contract_summary_id 
		JOIN lp_commissions..transaction_detail d (NOLOCK) ON acs.account_summary_id = d.transaction_summary_id 
			AND d.invoice_id = ps.invoice_id 
		JOIN lp_commissions..invoice_detail id (NOLOCK) ON ps.payment_schedule_id = id.payment_schedule_id
			AND id.account_id = acs.account_id 
	WHERE ps.plan_id = 0 
	) as t 
		

	-- get transaction detail
	SELECT DISTINCT r.report_id 
			, d.account_id 
			, d.transaction_detail_id 
			, d.rate 
			, d.term 
			, d.product_id 
			, d.date_deal
			, d.base_amount
			, d.amount
			, d.transaction_summary_id 
			, d.utility_id 
			, d.approval_status_id 
			, reason = space(100) 
			, account_summary_id = d.transaction_summary_id 
			, d.assoc_transaction_id 

			, tt.transaction_type_descp
			, tt.transaction_type_id 
			, transaction_status_descp = isnull(al.status_descp, '')
			, transaction_status_code = isnull(al.status_code, '')
			, transaction_status_id = al.status_id

			, p.payment_id
			, p.payment_amount
			, p.payment_number
			, payment_descp = isnull(p.payment_descp, '' ) 
			, p.invoice_id 

			, full_name = isnull(id.account_name, '')
			, id.account_number  
			, comments = isnull(d.comments, '') 
			, id.contract_nbr 
			, id.status_id 
			
			, sales_rep = id.sales_rep 
			, id.account_name 

			, sl.status_descp  

			, ps.payment_schedule_id 
			, ps.num_payments
			, contract_summary_id =  ps.line_item_id

			, l.line_item_type_code 
			, l.line_item_type_id
			
			, d.retail_mkt_id
			, v.vendor_id
			, vendor_name = SC.ChannelName 
			, r.target_date 
						
			, product_descp
			, item_descp =  'Contract' 
			, f.payment_freq_code
			, report_freq_code = rf.calculation_freq_code
			, matched = 0 

			, account_status = id.account_status
			, account_sub_status = id.account_sub_status
			, account_status_descp = vs.status_descp
			, account_sub_status_descp = vs.sub_status_descp
			
			, d.contract_term
			, vendor_descp = case when ltrim(rtrim(isnull(SC.ChannelDescription, ''))) = '' then SC.ChannelName else SC.ChannelDescription end 
			, d.reason_code
			
			, assoc_base_amount = assoc.base_amount 
			, assoc_amount = assoc.amount 
			
			, date_deenrollment  = '1/1/1900' -- case when acr.date_deenrollment is null then acc.date_deenrollment else acr.date_deenrollment end
			
			, ps_id = ps.payment_schedule_id
			, ps_inv_id = ps.invoice_id
			, ps.plan_id 
			
			, id.invoice_detail_id 

			, usage_start_date = d.date_term_start -- x.start_date -- replaced for performance
			, usage_end_date = d.date_term_end -- x.end_date  -- replaced for performance
			, read_date = null  -- x.read_date 
			
			, report_freq_id = r.calculation_freq_id
			, payment_type_id = isnull(isnull(pod.payment_type_id, isnull(pod_assoc.payment_type_id , pod_assoc2.payment_type_id )) , 0) 
			
	INTO #tmp_rpt_transactions
	
	FROM #tmp_rpt_dtl dt  (NOLOCK)
		
		JOIN lp_commissions..transaction_detail d (NOLOCK) ON d.transaction_detail_id = dt.transaction_detail_id 
		JOIN lp_commissions..payment_schedule ps (NOLOCK) ON dt.payment_schedule_id = ps.payment_schedule_id 
		JOIN lp_commissions..invoice_detail id (NOLOCK) ON id.invoice_detail_id = dt.invoice_detail_id 
		JOIN lp_commissions..report r (NOLOCK) ON r.report_id = dt.report_id
		JOIN lp_commissions..payment p (NOLOCK) ON p.payment_id = dt.payment_id 
		
		LEFT JOIN lp_commissions..payment_option_def pod (NOLOCK) ON d.payment_option_def_id = pod.payment_option_def_id 
		
		JOIN lp_commissions..line_item_type l (NOLOCK) ON l.line_item_type_id = ps.line_item_type_id
		JOIN lp_commissions..vendor v (NOLOCK) ON v.vendor_id = d.vendor_id
		JOIN lp_commissions..payment_freq f (NOLOCK) ON f.payment_freq_id = ps.payment_freq_ID
		JOIN lp_commissions..status_list al (NOLOCK) ON d.approval_status_id = al.status_id 
		
		LEFT JOIN lp_common..common_product pr (NOLOCK) ON d.product_id = pr.product_id 
		LEFT JOIN LibertyPower.dbo.SalesChannel AS SC (NOLOCK) ON v.ChannelID = SC.ChannelID 
		LEFT JOIN lp_commissions..status_list sl (NOLOCK) ON id.status_id = sl.status_id
		JOIN lp_commissions..transaction_type tt (NOLOCK) ON d.transaction_type_id = tt.transaction_type_id

		JOIN lp_commissions..calculation_freq rf (NOLOCK) ON r.calculation_freq_id = rf.calculation_freq_id 

		LEFT JOIN lp_account.dbo.enrollment_status_substatus_vw vs (NOLOCK) ON id.account_status = vs.status 
				AND id.account_sub_status = vs.sub_status
		
		LEFT JOIN lp_commissions..transaction_detail assoc (NOLOCK) ON d.assoc_transaction_id = assoc.transaction_detail_id 
		LEFT JOIN lp_commissions..payment_option_def pod_assoc (NOLOCK) ON assoc.payment_option_def_id = pod_assoc.payment_option_def_id 

		LEFT JOIN lp_commissions..transaction_detail assoc2 (NOLOCK) ON assoc.assoc_transaction_id = assoc2.transaction_detail_id 
		LEFT JOIN lp_commissions..payment_option_def pod_assoc2 (NOLOCK) ON assoc2.payment_option_def_id = pod_assoc2.payment_option_def_id 
				 																			
	WHERE 1 = 1 

		AND ( d.vendor_id = @p_vendor_id  OR isnull(@p_vendor_id, 0) = 0 ) 
		AND ( d.retail_mkt_id = @p_retail_mkt_id OR isnull(@p_retail_mkt_id, '') = '' )
		AND ( @p_payable_only = 0 OR ( @p_payable_only = 1 AND d.approval_status_id = 1 AND id.status_id = 13 ))

		AND ( pod.payment_type_id = @p_payment_type_id 
				OR pod_assoc.payment_type_id = @p_payment_type_id 
				OR pod_assoc2.payment_type_id = @p_payment_type_id 
				OR isnull(@p_payment_type_id,0) = 0 
				OR (isnull(d.payment_option_def_id, 0) = 0 AND d.transaction_detail_id is not null AND isnull(pod_assoc.payment_type_id , 0) = 0 AND isnull(pod_assoc2.payment_type_id , 0) = 0) 
				OR (isnull(assoc.payment_option_def_id, 0) = 0 AND assoc.transaction_detail_id is not null AND isnull(d.payment_option_def_id, 0) = 0 AND isnull(pod_assoc2.payment_type_id , 0) = 0) 
			    OR (isnull(assoc2.payment_option_def_id, 0) = 0 AND assoc2.transaction_detail_id is not null AND isnull(assoc.payment_option_def_id, 0) = 0 AND assoc.transaction_detail_id is not null AND isnull(d.payment_option_def_id, 0) = 0) 
			)

	drop table #tmp_rpt_dtl
					
    UPDATE t set reason = replace (t.reason_code , rc.reason_code , rc.reason_code_descp)
    FROM #tmp_rpt_transactions t (NOLOCK), lp_commissions..reason_code rc (NOLOCK)
	WHERE patindex ('%'+ rc.reason_code + '%'  , t.reason_code ) > 0 
	
				---- create index
				--CREATE NONCLUSTERED INDEX idx_tmp_rpt_transactions
				--	ON [dbo].[#tmp_rpt_transactions] ([transaction_type_id])
				--	INCLUDE ([assoc_transaction_id])
				--CREATE NONCLUSTERED INDEX idx_tmp_rpt_transactions2
				--	ON [dbo].[#tmp_rpt_transactions] ([approval_status_id])
				--	INCLUDE ([transaction_detail_id],[amount])
				--CREATE NONCLUSTERED INDEX idx_tmp_rpt_transactions3
				--	ON [dbo].[#tmp_rpt_transactions] ([matched])
				--	INCLUDE ([transaction_detail_id])
	

	-- get list of vendors etc
	SELECT distinct vendor_id , report_freq_id , retail_mkt_id , payment_schedule_id , sales_rep , payment_amount 
	INTO #unique_list	
	FROM #tmp_rpt_transactions (NOLOCK)

	CREATE CLUSTERED INDEX IDX_unique_list ON #unique_list (vendor_id , report_freq_id)
	
	-- get unique vendors  
	-- =====================================
	SELECT distinct vendor_id , vendor_name 
	INTO #vendor_list
	FROM #tmp_rpt_transactions (NOLOCK)
					
	-- final select list			
	SELECT a.* 
		, b.vendor_mkt_total 
		, c.vendor_mkt_rep_total 
		, d.vendor_grand_total
		, e.market_grand_total
		, g.report_freq_vendor_total
		, report_grand_total = (select sum(payment_amount) FROM #unique_list (NOLOCK))
		, f.vendor_order_by_name
		, h.report_freq_grand_total
	FROM #tmp_rpt_transactions a (NOLOCK)
		LEFT JOIN ( 	
				SELECT vendor_id , retail_mkt_id  ,  sum(payment_amount) as vendor_mkt_total  
				FROM #unique_list (NOLOCK)	 
				GROUP BY  vendor_id , retail_mkt_id 
			) b ON	a.vendor_id = b.vendor_id AND a.retail_mkt_id = b.retail_mkt_id  
		LEFT JOIN ( 	
				SELECT vendor_id , retail_mkt_id  , sales_rep, sum(payment_amount) as vendor_mkt_rep_total  
				FROM #unique_list (NOLOCK)	
				GROUP BY  vendor_id , retail_mkt_id , sales_rep
			) c ON	a.vendor_id = c.vendor_id AND a.retail_mkt_id = c.retail_mkt_id  AND a.sales_rep = c.sales_rep
 		LEFT JOIN ( 	
				SELECT vendor_id, sum(payment_amount) as vendor_grand_total  
				FROM #unique_list	(NOLOCK)
				GROUP BY  vendor_id 
			) d ON	a.vendor_id = d.vendor_id 
		LEFT JOIN ( 	
				SELECT retail_mkt_id, sum(payment_amount) as market_grand_total  
				FROM #unique_list	(NOLOCK)
				GROUP BY retail_mkt_id 
			) e ON	a.retail_mkt_id = e.retail_mkt_id 

		LEFT JOIN ( 	
				SELECT vendor_id , report_freq_id , sum(payment_amount) as report_freq_vendor_total  
				FROM #unique_list	(NOLOCK)
				GROUP BY vendor_id , report_freq_id 
			) g ON	a.vendor_id = g.vendor_id AND a.report_freq_id = g.report_freq_id
			
		LEFT JOIN ( 
				SELECT vendor_id, row_number() over (order by vendor_name) as vendor_order_by_name
				FROM #vendor_list (NOLOCK)
			) f ON a.vendor_id = f.vendor_id

		LEFT JOIN ( 	
				SELECT report_freq_id , sum(payment_amount) as report_freq_grand_total  
				FROM #unique_list	(NOLOCK)
				GROUP BY report_freq_id 
			) h ON a.report_freq_id = h.report_freq_id
												
	ORDER BY vendor_name, retail_mkt_id, sales_rep
		
END
GO 