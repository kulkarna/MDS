USE [integration]
GO

/****** Object:  View [dbo].[unmapped_EDI_transactions_vw]    Script Date: 11/06/2013 08:08:50 ******/

/************************************************
11/06/2013- Sal Tenorio
PBI 15029
Added wholesale_market_id condition
*************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[unmapped_EDI_transactions_vw]
AS

SELECT m.marketcode as market, t.market_id, u.utilitycode as utility, t.utility_id, t.transaction_type, t.action_code, t.request_or_response, t.reject_or_accept, t.reasoncode, t.reasontext, count(*) as [amount of transactions]
FROM EDI_814_transaction t (nolock)
JOIN libertypower..market m (nolock) on t.market_id = m.id
JOIN libertypower..utility u (nolock) on t.utility_id = u.id
LEFT JOIN lp_transaction_mapping tm (nolock) 
	ON 1=1
	AND (tm.wholesale_market_id = u.WholeSaleMktID OR tm.wholesale_market_id is NULL)
	AND (tm.market_id IN (t.market_id,0))
	AND (tm.utility_id IN (t.utility_id,0)) -- The choice *ALL* gets stored as a zero for utility.
	AND (tm.external_transaction_type IN (t.transaction_type,'*ALL*'))
	AND (tm.external_action_code IN (t.action_code,'*ALL*'))
	AND (tm.external_service_type2 IN (t.service_type2,'*ALL*'))
	AND (tm.external_request_or_response IN (t.request_or_response,'*ALL*'))
	AND (tm.external_reject_or_accept in (t.reject_or_accept,'*ALL*'))
	AND (tm.external_reasoncode IN (t.reasoncode,'*ALL*'))
	AND (tm.external_reasontext IN (t.reasontext,'*ALL*'))
WHERE tm.lp_transaction_mapping_id IS NULL
AND action_code <> 'C' AND direction = 1
AND (t.date_created > DateAdd(Year,-1,getdate()) )
GROUP BY m.marketcode, t.market_id, u.utilitycode, t.utility_id, t.transaction_type, t.action_code, t.request_or_response, t.reject_or_accept, t.reasoncode, t.reasontext




GO


