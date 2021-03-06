USE [Lp_commissions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_rate_sel_by_parent]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_rate_sel_by_parent]
GO


-- ===================================
-- Created By: Gail Mangaroo 
-- Created Date: 11/19/2012
-- ===================================
CREATE PROC [dbo].[usp_vendor_rate_sel_by_parent] 
(
@p_parent_setting_id int 
) 
AS 

BEGIN 
	
	SELECT r.*
	
		,cr.[calculation_rule_id]
		,cr.[calculation_rule_code]
		,cr.[calculation_rule_descp]
		
	FROM [lp_commissions].[dbo].[vendor_rate] r (NOLOCK)
		LEFT JOIN [lp_commissions].[dbo].rate_type rt (NOLOCK) ON r.rate_type_id = rt.rate_type_id 
		LEFT JOIN [lp_commissions].[dbo].calculation_rule cr (NOLOCK) ON cr.calculation_rule_id = rt.calculation_rule_id 
		
	WHERE r.assoc_rate_setting_id = @p_parent_setting_id 
		AND r.inactive_ind = 0 
		
	ORDER BY r.[rate_vendor_type_id], r.[rate_type_id], r.[transaction_type_id]
END
GO
