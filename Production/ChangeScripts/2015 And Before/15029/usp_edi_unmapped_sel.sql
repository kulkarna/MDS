USE [integration]
GO
/****** Object:  StoredProcedure [dbo].[usp_edi_unmapped_sel]    Script Date: 11/06/2013 08:18:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 03/23/2010 - José Munoz
 Alter where clause.
 *******************************************************************************
 Modify 02/11/2013 SWCS - José Munoz
 Ticket 1-55248967
 Change query to fix performance problem
 *******************************************************************************
 11/06/2013 - Sal Tenorio
 Added wholesale_market_id to the select statement
 PBI 15029
 *******************************************************************************

 [usp_edi_unmapped_sel] '20100412', '20100415'


*/

ALTER PROCEDURE [dbo].[usp_edi_unmapped_sel] (@DateCreatedFirst DATETIME, @DateCreatedLast DATETIME)
AS

begin
	set nocount on ;
	
	declare @BeginDate			datetime
		, @EndDate				datetime

	select @BeginDate		= convert(varchar(8), @DateCreatedFirst, 112)
		,@EndDate			= convert(varchar(8), @DateCreatedLast, 112)

	SELECT 
		m.market
		,u.wholesale_market_id
		,t.market_id
		,t.utility_id
		,u.utility
		,t.transaction_type
		,t.action_code
		,t.request_or_response
		,t.reject_or_accept
		,t.reasoncode
		,t.reasontext
		,t.service_type2 
		,COUNT(*) AS [amount of transactions]
	INTO #TEMPEDI
	FROM dbo.EDI_814_transaction AS t with(nolock)
	JOIN dbo.market AS m  with(nolock) 
	ON t.market_id = m.market_id 
	JOIN dbo.utility AS u with(nolock) 
	ON t.utility_id = u.utility_id 
	WHERE t.direction					= 1
	and t.action_code					<> 'C'
	and convert(varchar(8), t.date_created, 112) between @BeginDate and @EndDate				
	GROUP BY
	     u.wholesale_market_id 
		,m.market
		,t.market_id
		,t.utility_id
		,u.utility
		,t.transaction_type
		,t.action_code
		,t.request_or_response
		,t.reject_or_accept
		,t.reasoncode
		,t.reasontext
		,t.service_type2 
	ORDER BY [amount of transactions] DESC, t.market_id, u.utility, t.action_code DESC	
	
	
	SELECT
		wholesale_market_id 
		,market
		,market_id
		,utility_id
		,utility
		,transaction_type
		,action_code
		,request_or_response
		,reject_or_accept
		,reasoncode
		,reasontext
		,[amount of transactions]
	FROM #TEMPEDI t WITH (NOLOCK)
	WHERE not exists (
	select 1 from dbo.lp_transaction_mapping AS tm with(nolock)
	where
	    tm.wholesale_market_id = wholesale_market_id OR tm.wholesale_market_id is NULL
	AND tm.market_id IN (t.market_id, 0) 
	AND tm.utility_id IN (t.utility_id, 0) 
	AND tm.external_transaction_type IN (t.transaction_type, '*ALL*') 
	AND tm.external_action_code IN (t.action_code, '*ALL*') 
	AND tm.external_service_type2 IN (t.service_type2, '*ALL*') 
	AND tm.external_request_or_response IN (t.request_or_response, '*ALL*') 
	AND tm.external_reject_or_accept IN (t.reject_or_accept, '*ALL*') 
	AND tm.external_reasoncode IN (t.reasoncode, '*ALL*') 
	AND tm.external_reasontext IN (t.reasontext, '*ALL*'))
	
	DROP TABLE #TEMPEDI

	SET NOCOUNT OFF
	
END

/*	Ticket 1-55248967 Begin
	Original code Commented by ticket SR 1-55248967

	SELECT 
		m.market
		,t.market_id
		,t.utility_id
		,u.utility
		,t.transaction_type
		,t.action_code
		,t.request_or_response
		,t.reject_or_accept
		,t.reasoncode
		,t.reasontext
		,COUNT(*) AS [amount of transactions]
	FROM dbo.EDI_814_transaction AS t with(nolock index = NDX_EDI_814_transaction_01)
	JOIN dbo.market AS m  with(nolock index = market_market_id) 
	ON t.market_id = m.market_id 
	JOIN dbo.utility AS u with(nolock index = utility_utility_id) 
	ON t.utility_id = u.utility_id 
	WHERE t.direction					= 1
	and t.action_code					<> 'C'
	and not exists (select 1 from dbo.lp_transaction_mapping AS tm with(nolock index = NDX_lp_transaction_mapping_01)
					where tm.market_id IN (t.market_id, 0) 
					AND tm.utility_id IN (t.utility_id, 0) 
					AND tm.external_transaction_type IN (t.transaction_type, '*ALL*') 
					AND tm.external_action_code IN (t.action_code, '*ALL*') 
					AND tm.external_service_type2 IN (t.service_type2, '*ALL*') 
					AND tm.external_request_or_response IN (t.request_or_response, '*ALL*') 
					AND tm.external_reject_or_accept IN (t.reject_or_accept, '*ALL*') 
					AND tm.external_reasoncode IN (t.reasoncode, '*ALL*') 
					AND tm.external_reasontext IN (t.reasontext, '*ALL*'))
	and convert(varchar(8), t.date_created, 112) between @BeginDate and @EndDate				
	GROUP BY m.market
		,t.market_id
		,t.utility_id
		,u.utility
		,t.transaction_type
		,t.action_code
		,t.request_or_response
		,t.reject_or_accept
		,t.reasoncode
		,t.reasontext
	ORDER BY [amount of transactions] DESC, t.market_id, u.utility, t.action_code DESC	

END	

Ticket 1-55248967 End
*/

/*	
	SELECT market
		,market_id
		,utility_id
		,utility
		,transaction_type
		,action_code
		,request_or_response
		,reject_or_accept
		,reasoncode, reasontext
		,COUNT(*) AS [amount of transactions]
	FROM unmapped_EDI_transaction_vw2 with (nolock)
	WHERE convert(varchar(8), date_created, 112) between @BeginDate and @EndDate
	GROUP BY market,market_id,utility_id, utility, transaction_type, action_code, request_or_response, reject_or_accept, reasoncode, reasontext
	ORDER BY [amount of transactions] DESC, market_id, utility, action_code DESC
	
	set nocount off
end


--SELECT market,market_id,utility_id, utility, transaction_type, action_code, request_or_response, reject_or_accept, reasoncode, reasontext
--	, COUNT(*) AS [amount of transactions]
--FROM unmapped_EDI_transaction_vw2
--WHERE date_created < @DateCreatedLast 
--AND date_created > @DateCreatedFirst
--GROUP BY market,market_id,utility_id, utility, transaction_type, action_code, request_or_response, reject_or_accept, reasoncode, reasontext
--ORDER BY [amount of transactions] DESC, market_id, utility, action_code DESC

*/

