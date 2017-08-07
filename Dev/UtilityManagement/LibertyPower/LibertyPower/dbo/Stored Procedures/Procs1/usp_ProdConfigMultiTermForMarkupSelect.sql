/*******************************************************************************
 * usp_ProductCrossPriceMultiSelect
 * Gets product configuration data for multi-term in markup file format
 *
 * History
 *******************************************************************************
 * 9/21/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigMultiTermForMarkupSelect]

AS
BEGIN
    SET NOCOUNT ON;
                                                                                                                               
	SELECT	UPPER(LEFT(ct.Name, 3)) AS [Channel Type], at.AccountType AS Segment, pt.Name AS [Product Type],
			m.MarketCode AS Market, u.UtilityCode AS Utility, '' AS [Channel Group], z.zone AS Zone, 
			ISNULL(s.service_rate_class, 'All Others') AS [Utility Service Class], o.LowerTerm AS [Min Term], 
			o.UpperTerm AS [Max Term], '' AS [Mark-up Value], ISNULL(t.PriceTierID, '') AS [Price Tier], o.Term AS [Product Term]
	FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK) ON p.ProductConfigurationID = o.ProductConfigurationID
			INNER JOIN Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			INNER JOIN Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID
			INNER JOIN Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
			LEFT JOIN Libertypower..ProductConfigurationPriceTiers t WITH (NOLOCK) ON p.ProductConfigurationID = t.ProductConfigurationID
	WHERE	p.ProductTypeID = 7
	GROUP BY	ct.Name, at.AccountType, pt.Name, m.MarketCode, u.UtilityCode, z.zone, s.service_rate_class, t.PriceTierID, o.LowerTerm, 
				o.UpperTerm, o.Term
	ORDER BY	ct.Name, at.AccountType, pt.Name, m.MarketCode, u.UtilityCode, z.zone, s.service_rate_class, t.PriceTierID, o.Term, o.LowerTerm

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
