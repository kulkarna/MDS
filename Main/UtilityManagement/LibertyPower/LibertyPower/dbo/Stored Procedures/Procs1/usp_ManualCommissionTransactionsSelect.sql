
/*******************************************************************************
 * usp_ManualCommissionTransactionsSelect
 * To get commission transactions that meet criteria
 * for calculating gross margins adjustments
 * and inserted through manual process
 *
 * History
 *******************************************************************************
 * 11/20/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ManualCommissionTransactionsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	t.transaction_detail_id	AS TransactionDetailId,
			t2.reason_code, 
			t2.amount,
			t.base_amount,
			t2.amount / t.base_amount AS AdjustmentRate,
			t.rate_requested		AS RateRequested, 
			t.rate					AS Rate, 
			t.vendor_pct			AS VendorPct, 
			t.house_pct				AS HousePct, 
			t.rate_split_point		AS RateSplitPoint,
			t.account_id			AS AccountId,
			t.contract_nbr			AS ContractNumber,
			a.utility_id			AS UtilityCode,
			a.account_number		AS AccountNumber,
			r.target_date	AS ReportDate
	FROM	lp_commissions..transaction_detail t WITH (NOLOCK)
			LEFT JOIN lp_commissions..transaction_detail t2 ON t.transaction_detail_id = t2.assoc_transaction_id
			AND t2.void = 0 AND t2.invoice_id > 0 AND t2.approval_status_id = 1 AND t2.transaction_type_id = 2
			INNER JOIN lp_commissions..invoice i ON i.invoice_id = t.invoice_id
			INNER JOIN lp_commissions..report r ON i.report_id = r.report_id
			INNER JOIN lp_account..account a WITH (NOLOCK) ON t.account_id = a.account_id
	WHERE	t.void = 0 
	AND		t.approval_status_id IN ( 1, 3) -- (1 is approved , 3 is pending review )
	AND		t.invoice_id > 0 -- 0 means not yet paid; > 0 means paid/report locked.
	AND		t.transaction_type_id IN ( 1 ,5 )  -- 1 is commission , 5 is renewal commission , 2 is chargeback – these values are stored in the transaction_type table
	AND		t.vendor_pct > 0 -- if vendor_pct = 0, then there is no split to be considered
	AND		t.vendor_pct < 1
	AND		t2.transaction_detail_id IS NULL
--	AND		t.transaction_detail_id > (SELECT TransactionDetailId FROM CommTransDetailIdProcessed)
--	AND		r.target_date >= (SELECT ReportDate FROM CommTransDetailIdProcessed)	
	AND		t.account_id IN (SELECT DISTINCT account_id FROM AEHCommissionUpdate112009)
	ORDER BY r.target_date, t.transaction_detail_id    
    
	--SELECT	t.transaction_detail_id	AS TransactionDetailId, 
	--		t.rate_requested		AS RateRequested, 
	--		t.rate					AS Rate, 
	--		t.vendor_pct			AS VendorPct, 
	--		t.house_pct				AS HousePct, 
	--		t.rate_split_point		AS RateSplitPoint,
	--		t.account_id			AS AccountId,
	--		t.contract_nbr			AS ContractNumber,
	--		a.utility_id			AS UtilityCode,
	--		a.account_number		AS AccountNumber,
	--		t.date_due				AS ReportDate
	--FROM	lp_commissions..transaction_detail t WITH (NOLOCK)
	--		INNER JOIN lp_account..account a WITH (NOLOCK) ON t.account_id = a.account_id
	--WHERE	t.void = 0 
	--AND		t.approval_status_id IN ( 1, 3) -- (1 is approved , 3 is pending review )
	--AND		t.invoice_id > 0 -- 0 means not yet paid; > 0 means paid/report locked.
	--AND		t.transaction_type_id IN ( 1 ,5 )  -- 1 is commission , 5 is renewal commission , 2 is chargeback – these values are stored in the transaction_type table
	--AND		t.vendor_pct > 0 -- if vendor_pct = 0, then there is no split to be considered
	--AND		t.transaction_detail_id > (SELECT TransactionDetailId FROM CommTransDetailIdProcessed)
	--AND		t.date_due >= (SELECT ReportDate FROM CommTransDetailIdProcessed)		
	--ORDER BY t.date_due, t.transaction_detail_id
    
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power

