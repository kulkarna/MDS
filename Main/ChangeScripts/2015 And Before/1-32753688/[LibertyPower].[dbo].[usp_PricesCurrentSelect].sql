USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PricesCurrentSelect]    Script Date: 10/16/2012 18:13:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_DailyPricingSalesChannelPricesCurrentSelect
 * Gets current prices for specified sales channel
 *
 * History
 *******************************************************************************
 * 12/7/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_PricesCurrentSelect]
	@ChannelID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ProductCostRuleSetupSetID	int,
			@ProductCrossPriceSetID	int
			
	SELECT	@ProductCostRuleSetupSetID = MAX(ProductCostRuleSetupSetID)
    FROM	LibertyPower..ProductCostRuleSetupSet WITH (NOLOCK)
	WHERE	UploadStatus = 2 --> 2 = Complete 			
    
	SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
    FROM	LibertyPower..ProductCrossPriceSet
	WHERE	GETDATE() BETWEEN EffectiveDate AND  ExpirationDate      
    
	SELECT	p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, 
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode, 
			s.service_rate_class AS ServiceClassCode, ISNULL(cr.ServiceClassDisplayName, '') AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, p.GrossMargin
			, ISNULL(CAST(d.rate_submit_ind AS INT),2) AS LegacyStatus, d.ContractRate, dp.account_name AS RateDescription
	FROM	LibertyPower..Price p WITH (NOLOCK)
			INNER JOIN	Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN	Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN	Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN	Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID
			INNER JOIN	Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			LEFT JOIN	lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN	lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
			LEFT JOIN   lp_deal_capture..deal_pricing_detail d WITH (NOLOCK) ON p.ID = d.PriceID
			LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON d.deal_pricing_id = dp.deal_pricing_id
			LEFT JOIN	Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)
			ON	p.SegmentID			= cr.Segment
			AND	p.ProductTypeID		= cr.ProductType
			AND	p.UtilityID			= cr.Utility
			AND p.ZoneID = cr.Zone
			AND p.ServiceClassID = cr.ServiceClass
			AND p.PriceTier			= cr.PriceTier		
	WHERE	p.ChannelID						= @ChannelID
	AND		(p.ProductCrossPriceSetID  = @ProductCrossPriceSetID OR (p.ProductCrossPriceSetID = 0 AND p.CostRateExpirationDate > GETDATE()))
	AND		(cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID OR cr.ProductCostRuleSetupSetID IS NULL)

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
