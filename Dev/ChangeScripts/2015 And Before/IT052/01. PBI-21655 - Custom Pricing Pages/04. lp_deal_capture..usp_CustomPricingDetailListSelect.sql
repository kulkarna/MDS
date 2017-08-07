USE [Lp_deal_capture]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CustomPricingDetailListSelect]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_CustomPricingDetailListSelect]
GO

-- =================================================
-- Created By: Gail Mangaroo 
-- Date Created: 12/4/2013
-- =================================================
CREATE procedure [dbo].[usp_CustomPricingDetailListSelect]
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
		,HasPassThrough = isnull(d.HasPassThrough , 0) 
		,BackToBack = isnull(d.BackToBack , 0 ) 
		,d.HeatIndexSourceID -- Project IT037
		,d.HeatRate -- Project IT037
		,d.ExpectedTermUsage
		,d.ExpectedAccountsAmount
		,rate_submit_ind = isnull(d.rate_submit_ind, 0) 
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
		
		,dp.account_name
		,dp.date_expired
		,dp.commission_rate
		,r.contract_eff_start_date as date_start
		,r.BillingTypeID as BillingType
		,dp.pricing_request_id
		,d.PriceID
		,d.SelfGenerationID
		,d.PriceTypeID --- Project IT052 
		,dp.CustomDealID  --- Project IT052 
		
		,AccountType = at.accountType
		,AccountTypeID = at.ID
		,ProductAccountTypeID = at.ProductAccountTypeID
		,UtilityID = u.ID

	FROM [lp_deal_capture].[dbo].[deal_pricing_detail] d (NOLOCK)
		JOIN lp_deal_capture..deal_pricing dp (NOLOCK) 
			ON dp.deal_pricing_id = d.deal_pricing_id
		JOIN lp_common.dbo.common_product_rate r (NOLOCK)
			ON d.product_id = r.product_id 
			AND d.rate_id = r.rate_id 
		JOIN lp_common.dbo.common_product p (NOLOCK)
			ON d.product_id = p.product_id 
		JOIN LibertyPower..Utility u (NOLOCK)
			ON p.utility_id = u.utilityCode
		JOIN LibertyPower..Market m (NOLOCK)
			ON u.MarketID = m.ID  
		JOIN LibertyPower..AccountType at (NOLOCK)
			ON p.account_type_id = at.ProductAccountTypeID                

	SET NOCOUNT OFF;

END 
GO 