-- ====================================
-- Created By: Gail Mangaroo 
-- Created Date: 
-- ====================================

--======================================
-- Modified By: Gail Mangaroo
-- Modified 8/20/2008
-- Added RateID and Product Descp 
-- =====================================
-- Modified By: Jose Munoz
-- Modified 01/28/2010
-- Added HeatIndexSourceID and HeatRate columns in the select 
-- Project IT037
-- =====================================


CREATE PROC [dbo].[usp_deal_pricing_detail_sel_list]
( @p_deal_pricing_id int 
) 
AS 
BEGIN 

	SELECT 
		d.[deal_pricing_detail_id]
		,d.[deal_pricing_id]
		,d.[product_id]
		,d.[rate_id]
		,d.[date_created]
		,d.[username]
		,d.[date_modified]
		,d.[modified_by]
		,d.[Cost]
		,d.[MTM]
		,r.rate
		,r.term_months
		,r.rate_descp 
		,r.rate_id 
		,p.product_descp
		,r.GrossMargin
		,d.ContractRate
		,d.Commission
		,CASE WHEN d.HasPassThrough = '1' THEN '1' ELSE '0' END AS HasPassThrough
		,CASE WHEN d.BackToBack = '1' THEN '1' ELSE '0' END AS BackToBack
		,d.HeatIndexSourceID -- Project IT037
		,d.HeatRate -- Project IT037
	FROM [lp_deal_capture].[dbo].[deal_pricing_detail] d
		LEFT JOIN lp_common.dbo.common_product_rate r ON d.product_id = r.product_id AND d.rate_id = r.rate_id 
		LEFT JOIN lp_common.dbo.common_product p ON d.product_id = p.product_id 

	WHERE [deal_pricing_id] =  @p_deal_pricing_id  

END 



