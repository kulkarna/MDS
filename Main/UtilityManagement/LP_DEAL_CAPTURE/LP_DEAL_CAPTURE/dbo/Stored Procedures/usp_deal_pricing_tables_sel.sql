
/************************************* usp_deal_pricing_tables_sel ***********************************************/

CREATE PROCEDURE [dbo].[usp_deal_pricing_tables_sel]
( 
  @p_deal_pricing_detail_id		 int = 0
) 
AS 
BEGIN 

	SET NOCOUNT ON;
	
	SELECT 
		 d.[deal_pricing_detail_id]
		,d.[deal_pricing_id]
		,d.[product_id]
		,d.[rate_id]
		,d.[date_created]
		,d.[username]
		,d.[date_modified]
		,d.[modified_by]
		,d.[MTM]
		,d.ContractRate
		,CASE WHEN d.HasPassThrough = '1' THEN '1' ELSE '0' END AS HasPassThrough
		,CASE WHEN d.BackToBack = '1' THEN '1' ELSE '0' END AS BackToBack
		,d.HeatIndexSourceID -- Project IT037
		,d.HeatRate -- Project IT037
		,d.ExpectedTermUsage
		,d.ExpectedAccountsAmount
		,CASE WHEN d.rate_submit_ind = '1' THEN '1' ELSE '0' END AS rate_submit_ind
		,d.Commission
		,d.Cost
		,d.ETP --added for project IT051: MtM
		,r.GrossMargin
		,r.IndexType
		,r.rate_descp
		,r.rate
		,r.term_months
		,p.account_type_id
		,p.utility_id
		,p.product_descp
		,u.UtilityCode
		,u.MarketID
		,m.MarketCode
		,dp.sales_channel_role
		,at.AccountType
		,dp.account_name
		,dp.date_expired
		,dp.commission_rate
		,r.contract_eff_start_date as date_start
		,r.BillingTypeID as BillingType
		,dp.pricing_request_id
		,d.PriceID
		,d.SelfGenerationID
	FROM [lp_deal_capture].[dbo].[deal_pricing_detail] d
		JOIN lp_deal_capture..deal_pricing dp ON dp.deal_pricing_id = d.deal_pricing_id
		JOIN lp_common.dbo.common_product_rate r ON d.product_id = r.product_id AND d.rate_id = r.rate_id 
		JOIN lp_common.dbo.common_product p ON d.product_id = p.product_id 
		JOIN LibertyPower..Utility u ON p.utility_id = u.utilityCode
		JOIN LibertyPower..Market m ON u.MarketID = m.ID  
		JOIN LibertyPower..AccountType at on p.account_type_id = at.ID                
	WHERE d.deal_pricing_detail_id = @p_deal_pricing_detail_id
   
END 
