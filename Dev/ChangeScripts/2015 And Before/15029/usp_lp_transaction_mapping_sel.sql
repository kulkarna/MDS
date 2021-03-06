USE [integration]
GO
/****** Object:  StoredProcedure [dbo].[usp_lp_transaction_mapping_sel]    Script Date: 11/04/2013 10:46:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  [usp_lp_transaction_mapping_sel_dev] @p_market_id = 3
--  [usp_lp_transaction_mapping_sel_dev] @p_market_id = 0
--  [usp_lp_transaction_mapping_sel_dev]  @p_market_id = NULL
--  [usp_lp_transaction_mapping_sel_dev]  @p_market_id = -1
--  [usp_lp_transaction_mapping_sel_dev]  @p_market_id = -1
--  [usp_lp_transaction_mapping_sel_dev]  @p_market_id = 0, @p_utility_id = 0
--  [usp_lp_transaction_mapping_sel_dev]  @p_market_id = -1, @p_utility_id = 26
/**
	Jaime Forero 7/13/2011
*/

/*****************************************************************
	Sal Tenorio 11/04/2013
	Added new column wholesale_market_id to support ISO selection	
	PBI 15029
*******************************************************************/

ALTER PROCEDURE [dbo].[usp_lp_transaction_mapping_sel]  
(	@lp_transaction_mapping_id int = null, 
	@p_show_active_only tinyint = null, 
	@p_market_id INT = null,
	@p_utility_id  INT = NULL
)
AS
BEGIN

SET NOCOUNT ON;

	-- Jaime ticket # 24274, if market id = 0 is a wildcard to show all markets
	 IF @p_market_id = 0
		SET @p_market_id = NULL;
	
	IF @p_utility_id = 0
		SET @p_utility_id = NULL;
		
	SELECT lp_transaction_mapping_id, tm.lp_transaction_id, t.description as LibertyTransDesc
		, lp_reasoncode
		, r.option_id as lp_reasontext
		, tm.wholesale_market_id as WholesaleMktId
		, tm.market_id
		, ISNULL(m.market, '*ALL*') as market
		, tm.utility_id
		, isnull(u.utility,'*ALL*') as utility
		, external_transaction_type 
		, external_action_code 
		, external_request_or_response
		, external_reject_or_accept
		, external_reasoncode
		, external_reasontext
		, tm.date_created, tm.date_last_mod, tm.active 
		, rp.chargeback, rp.retention, rp.requires_fix, rp.enrollment_submission_requeue
--		, isnull(rp.chargeback,'NA') as chargeback, isnull(rp.retention,'NA') as retention, isnull(rp.requires_fix,'NA') as requires_fix, isnull(rp.enrollment_submission_requeue,'NA') as enrollment_submission_requeue
	FROM lp_transaction_mapping tm (nolock)
	JOIN lp_transaction t  (nolock) on tm.lp_transaction_id = t.lp_transaction_id
	LEFT JOIN market m  (nolock) on tm.market_id = m.market_id
	LEFT JOIN (select * from lp_common.dbo.common_views	where process_id = 'reason code') r on tm.lp_reasoncode = r.return_value
	LEFT JOIN lp_enrollment.dbo.reason_code_properties rp  (nolock) on tm.lp_reasoncode = rp.reason_code
	LEFT JOIN utility u  (nolock) on tm.utility_id = u.utility_id
	WHERE lp_transaction_mapping_id = isnull(@lp_transaction_mapping_id,lp_transaction_mapping_id)
	and tm.active = isnull(@p_show_active_only,tm.active)
	AND ( tm.market_id = 0 OR tm.market_id = ISNULL(@p_market_id, tm.market_id ) )  -- ticket # 24274
	AND ( tm.utility_id = 0 OR u.utility_id = ISNULL(@p_utility_id, u.utility_id ) ) -- ticket # 24274
	AND ( tm.market_id = 0 OR tm.market_id  = CASE WHEN @p_utility_id IS NOT NULL THEN u.market_id ELSE tm.Market_id END) -- ticket # 24274
	ORDER BY lp_transaction_mapping_id
	
	SET NOCOUNT OFF;
END


 
