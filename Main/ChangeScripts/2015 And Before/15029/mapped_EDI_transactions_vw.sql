USE [Integration]
GO

/****** Object:  View [dbo].[mapped_EDI_transactions_vw]    Script Date: 11/06/2013 08:03:04 ******/
/************************************************
11/06/2013- Sal Tenorio
PBI 15029
Added wholesale_market_id condition
*************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[mapped_EDI_transactions_vw]
AS

-- We take only the top mapping (in where clause) to show which one will be selected by the system.
SELECT a.Market, a.Utility, a.Transaction_Type + '_' + a.action_code as 'Transaction_Type', a.Request_or_Response, a.Reject_or_Accept, a.ReasonCode, a.ReasonText,
	tc.cnt as 'Count',
	External_ReasonCode, External_ReasonText, t.lp_transaction_id, t.description as LibertyTransDesc, LP_ReasonCode, r.option_id as 'LP Reason Text', rp.Chargeback, rp.Retention, rp.Requires_Fix, rp.enrollment_submission_requeue

FROM 
(
	-- We then create a row number so we can number each mapping per each transaction combination
	SELECT row_number() over (
		partition by market, utility, transaction_type, action_code, request_or_response, reject_or_accept, reasoncode, reasontext
		order by     market_id desc, utility_id , external_transaction_type desc, external_action_code desc, external_request_or_response desc, external_reject_or_accept desc, external_reasoncode desc, external_reasontext desc 
		) as rownum, * 
	FROM (
		-- This query returns a distinct list of all transaction combinations, along with all mappings that apply to them.
		SELECT distinct u.WholeSaleMktID, m.marketcode as market, u.utilitycode as utility, t.transaction_type, t.action_code, t.request_or_response, t.reject_or_accept, t.reasoncode, t.reasontext, tm.*
		FROM EDI_814_transaction t (nolock)
		JOIN libertypower..market m (nolock) on t.market_id = m.id
		JOIN libertypower..utility u (nolock) on t.utility_id = u.id
		JOIN lp_transaction_mapping tm (nolock)
			ON 1=1
			AND (tm.wholesale_market_id = u.WholeSaleMktID OR tm.wholesale_market_id is NULL)
			AND (tm.market_id IN (t.market_id,0))
			AND (tm.utility_id IN (t.utility_id,0)) -- The choice *ALL* gets stored as a zero for utility.
			AND (tm.external_transaction_type in (t.transaction_type,'*ALL*'))
			AND (tm.external_action_code in (t.action_code,'*ALL*'))
			AND (tm.external_service_type2 in (t.service_type2,'*ALL*'))
			AND (tm.external_request_or_response in (t.request_or_response,'*ALL*'))
			AND (tm.external_reject_or_accept in (t.reject_or_accept,'*ALL*'))
			AND (tm.external_reasoncode in (t.reasoncode,'*ALL*'))
			AND (replace(tm.external_reasontext,' ','') in (replace(t.reasontext,' ',''),'*ALL*'))
		WHERE action_code <> 'C' and direction = 1
		AND (t.date_created > DateAdd(Year,-1,getdate()) )
	) b
) a
JOIN lp_transaction t (nolock) on a.lp_transaction_id = t.lp_transaction_id
JOIN (select * from lp_common.dbo.common_views	where process_id = 'reason code') r on a.lp_reasoncode = r.return_value
LEFT JOIN lp_enrollment.dbo.reason_code_properties rp (nolock) on a.lp_reasoncode = rp.reason_code
LEFT JOIN
	(
		SELECT marketcode as market, utilitycode as utility, Transaction_Type, action_code, request_or_response, reject_or_accept, reasoncode, reasontext, count(*) as cnt
		FROM EDI_814_transaction t (nolock)
		JOIN libertypower..market m (nolock) on t.market_id = m.id
		JOIN libertypower..utility u (nolock) on t.utility_id = u.id
		WHERE action_code <> 'C' and direction = 1
		AND (t.date_created > DateAdd(Year,-1,getdate()) )
		GROUP BY marketcode, utilitycode, transaction_type, action_code, request_or_response, reject_or_accept, reasoncode, reasontext
	) tc ON a.market = tc.market and a.utility = tc.utility and a.Transaction_Type = tc.Transaction_Type and a.action_code = tc.action_code 
			and isnull(a.request_or_response,'null') = isnull(tc.request_or_response,'null') and  isnull(a.reject_or_accept,'null') = isnull(tc.reject_or_accept,'null') and isnull(a.reasoncode,'null') = isnull(tc.reasoncode,'null') and isnull(a.reasontext,'null') = isnull(tc.reasontext,'null')
WHERE rownum = 1



GO


