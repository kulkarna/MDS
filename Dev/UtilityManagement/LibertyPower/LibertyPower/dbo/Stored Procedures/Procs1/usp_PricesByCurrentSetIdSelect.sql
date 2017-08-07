/*******************************************************************************
 * usp_DailyPricingSalesChannelPricesSelect
 * Gets prices for specified sales channel and date
 *
 * History
 *******************************************************************************
 * 12/7/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PricesByCurrentSetIdSelect]

AS
BEGIN
    SET NOCOUNT ON;
                                                                                                                               
	SELECT	DISTINCT p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, 
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode, 
			s.service_rate_class AS ServiceClassCode, ISNULL(cr.ServiceClassDisplayName, '') AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, 
			p.GrossMargin, p.ProductCrossPriceID, ISNULL(CAST(d.rate_submit_ind AS INT),2) AS LegacyStatus, d.ContractRate, dp.account_name AS RateDescription
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
			ON	p.SegmentID				= cr.Segment
			AND	p.ProductTypeID			= cr.ProductType
			AND	p.UtilityID				= cr.Utility
			AND (p.ZoneID = cr.Zone OR cr.Zone = -1)  
			AND (p.ServiceClassID = cr.ServiceClass OR cr.ServiceClass = -1) 
			AND p.PriceTier				= cr.PriceTier		
	WHERE	p.ProductCrossPriceSetID	= (SELECT MAX(ProductCrossPriceSetID) FROM LibertyPower..Price p WITH (NOLOCK))

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
