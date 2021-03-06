USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PricesBySetIdChannelGroupUtilitySelect]    Script Date: 07/12/2013 15:14:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PricesBySetIdChannelGroupUtilitySelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PricesBySetIdChannelGroupUtilitySelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PricesBySetIdChannelGroupUtilitySelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_PricesBySetIdChannelGroupUtilitySelect
 * Gets prices for specified set, channel group and utility IDs
 *
 * History
 *******************************************************************************
 * 7/10/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PricesBySetIdChannelGroupUtilitySelect]
	@ProductCrossPriceSetID	int,
	@ChannelGroupID			int,
	@UtilityID				int
AS
BEGIN
    SET NOCOUNT ON;			
			    
	SELECT	ID, ChannelID, ChannelGroupID, ChannelTypeID, ProductCrossPriceSetID, ProductTypeID, 
			MarketID, UtilityID, SegmentID, ZoneID, ServiceClassID, StartDate, Term, Price, CostRateEffectiveDate, 
			CostRateExpirationDate, IsTermRange, DateCreated, PriceTier, ProductBrandID, GrossMargin, ProductCrossPriceID
	INTO	#tmpPrice
	FROM	LibertyPower..Price WITH (NOLOCK)	
	WHERE	ProductCrossPriceSetID	= @ProductCrossPriceSetID
	AND		ChannelGroupID			= @ChannelGroupID
	AND		UtilityID				= @UtilityID
		
	CREATE CLUSTERED INDEX Idx_Price ON #tmpPrice(ChannelTypeID, ProductTypeID, MarketID, UtilityID, SegmentID, ProductBrandID, ZoneID, ServiceClassID, PriceTier)
	                                                                                                                               
	SELECT	DISTINCT p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, 
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode, 
			s.service_rate_class AS ServiceClassCode, '''' AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, 
			p.GrossMargin, p.ProductCrossPriceID, ISNULL(CAST(d.rate_submit_ind AS INT),2) AS LegacyStatus, d.ContractRate, dp.account_name AS RateDescription, 
			pb.IsMultiTerm, pb.IsCustom 
	FROM	#tmpPrice p WITH (NOLOCK)
			INNER JOIN	Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN	Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN	Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN	Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID
			INNER JOIN	Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
			INNER JOIN	Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			LEFT JOIN	lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN	lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
			LEFT JOIN   lp_deal_capture..deal_pricing_detail d WITH (NOLOCK) ON p.ID = d.PriceID
			LEFT JOIN	lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON d.deal_pricing_id = dp.deal_pricing_id				

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
' 
END
GO
