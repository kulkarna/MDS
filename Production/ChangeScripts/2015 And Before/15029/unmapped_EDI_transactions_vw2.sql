USE [integration]
GO

/****** Object:  View [dbo].[unmapped_EDI_transaction_vw2]    Script Date: 11/06/2013 08:15:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/************************************************
11/06/2013- Sal Tenorio
PBI 15029
Added wholesale_market_id condition
*************************************************/


/*
 * 03/23/2010 - José Munoz

 * Put index and alter on clause and where clause.

 *******************************************************************************
*/
ALTER VIEW [dbo].[unmapped_EDI_transaction_vw2]
AS

SELECT distinct t.EDI_814_transaction_id
	,t.date_created
	,m.market
	,u.utility
	,u.wholesale_market_id
	,t.market_id
	,t.utility_id
	,t.transaction_type
	,t.action_code
	,t.request_or_response
	,t.reject_or_accept
	,t.reasoncode
	,t.reasontext
FROM dbo.EDI_814_transaction AS t with(nolock)
JOIN dbo.market AS m  with(nolock) 
ON t.market_id = m.market_id 
JOIN dbo.utility AS u with(nolock) 
ON t.utility_id = u.utility_id 
WHERE t.direction					= 1
and t.action_code					<> 'C'
and not exists (select 1 from dbo.lp_transaction_mapping AS tm with(nolock)
				where tm.wholesale_market_id = u.wholesale_market_id OR tm.wholesale_market_id is NULL
				AND tm.market_id IN (t.market_id, 0) 
				AND tm.utility_id IN (t.utility_id, 0) 
				AND tm.external_transaction_type IN (t.transaction_type, '*ALL*') 
				AND tm.external_action_code IN (t.action_code, '*ALL*') 
				AND tm.external_service_type2 IN (t.service_type2, '*ALL*') 
				AND tm.external_request_or_response IN (t.request_or_response, '*ALL*') 
				AND tm.external_reject_or_accept IN (t.reject_or_accept, '*ALL*') 
				AND tm.external_reasoncode IN (t.reasoncode, '*ALL*') 
				AND tm.external_reasontext IN (t.reasontext, '*ALL*'))

/*
SELECT distinct t.EDI_814_transaction_id
	,t.date_created,m.market
	,u.utility,t.market_id
	,t.utility_id
	,t.transaction_type
	,t.action_code
	,t.request_or_response
	,t.reject_or_accept
	,t.reasoncode
	,t.reasontext
FROM dbo.EDI_814_transaction AS t with(nolock index = NDX_EDI_814_transaction_01)
JOIN dbo.market AS m  with(nolock index = market_market_id) 
ON t.market_id = m.market_id 
JOIN dbo.utility AS u with(nolock index = utility_utility_id) 
ON t.utility_id = u.utility_id 
LEFT JOIN dbo.lp_transaction_mapping AS tm with(nolock index = NDX_MarketIdUtility_id)
ON tm.market_id IN (t.market_id, 0) 
AND tm.utility_id IN (t.utility_id, 0) 
AND tm.external_transaction_type IN (t.transaction_type, '*ALL*') 
AND tm.external_action_code IN (t.action_code, '*ALL*') 
AND tm.external_service_type2 IN (t.service_type2, '*ALL*') 
AND tm.external_request_or_response IN (t.request_or_response, '*ALL*') 
AND tm.external_reject_or_accept IN (t.reject_or_accept, '*ALL*') 
AND tm.external_reasoncode IN (t.reasoncode, '*ALL*') 
AND tm.external_reasontext IN (t.reasontext, '*ALL*')
WHERE t.direction					= 1
and t.action_code					<> 'C'
--and tm.lp_transaction_mapping_id	IS NULL
and isnumeric(tm.lp_transaction_mapping_id) <> 1
*/


--SELECT distinct t.EDI_814_transaction_id,t.date_created,m.market, u.utility,t.market_id,t.utility_id, t.transaction_type, t.action_code, t.request_or_response, t.reject_or_accept, t.reasoncode, t.reasontext
--FROM dbo.EDI_814_transaction AS t 
--JOIN dbo.market AS m ON t.market_id = m.market_id 
--JOIN dbo.utility AS u ON t.utility_id = u.utility_id 
--LEFT OUTER JOIN dbo.lp_transaction_mapping AS tm ON 1 = 1 
--					  AND tm.market_id IN (t.market_id, 0) 
--					  AND tm.utility_id IN (t.utility_id, 0) 
--					  AND tm.external_transaction_type IN (t.transaction_type, '*ALL*') 
--					  AND tm.external_action_code IN (t.action_code, '*ALL*') 
--					  AND tm.external_service_type2 IN (t.service_type2, '*ALL*') 
--                      AND tm.external_request_or_response IN (t.request_or_response, '*ALL*') 
--                      AND tm.external_reject_or_accept IN (t.reject_or_accept, '*ALL*') 
--                      AND tm.external_reasoncode IN (t.reasoncode, '*ALL*') 
--                      AND tm.external_reasontext IN (t.reasontext, '*ALL*')
--WHERE     (tm.lp_transaction_mapping_id IS NULL) AND (t.action_code <> 'C') AND (t.direction = 1)



--SELECT     m.market, u.utility,t.market_id,t.utility_id, t.transaction_type, t.action_code, t.request_or_response, t.reject_or_accept, t.reasoncode, t.reasontext, COUNT(*) 
--                      AS [amount of transactions]
--FROM dbo.EDI_814_transaction AS t 
--JOIN dbo.market AS m ON t.market_id = m.market_id 
--JOIN dbo.utility AS u ON t.utility_id = u.utility_id 
--LEFT OUTER JOIN dbo.lp_transaction_mapping AS tm ON 1 = 1 
--						AND tm.market_id = t.market_id 
--						AND tm.utility_id IN (t.utility_id, 0) 
--						AND tm.external_transaction_type IN (t.transaction_type, '*ALL*') 
--						AND tm.external_action_code IN (t.action_code, '*ALL*') 
--						AND tm.external_service_type2 IN (t.service_type2, '*ALL*') 
--                      AND tm.external_request_or_response IN (t.request_or_response, '*ALL*') 
--                      AND tm.external_reject_or_accept IN (t.reject_or_accept, '*ALL*') 
--                      AND tm.external_reasoncode IN (t.reasoncode, '*ALL*') 
--                      AND tm.external_reasontext IN (t.reasontext, '*ALL*')
--WHERE     (tm.lp_transaction_mapping_id IS NULL) AND (t.action_code <> 'C') AND (t.direction = 1) AND (t.date_created > DateAdd(Year,-1,getdate()) )
--GROUP BY m.market,t.market_id,t.utility_id, u.utility, t.transaction_type, t.action_code, t.request_or_response, t.reject_or_accept, t.reasoncode, t.reasontext








GO


