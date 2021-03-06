USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PricesByCurrentSetIdSelect]    Script Date: 09/20/2012 08:42:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PricesByCurrentSetIdSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PricesByCurrentSetIdSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PricesByCurrentSetIdSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
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
			s.service_rate_class AS ServiceClassCode, ISNULL(cr.ServiceClassDisplayName, '''') AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, 
			p.GrossMargin, p.ProductCrossPriceID
	FROM	LibertyPower..Price p WITH (NOLOCK)
			INNER JOIN	Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN	Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN	Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN	Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID
			INNER JOIN	Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			LEFT JOIN	lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN	lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
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
' 
END
GO
