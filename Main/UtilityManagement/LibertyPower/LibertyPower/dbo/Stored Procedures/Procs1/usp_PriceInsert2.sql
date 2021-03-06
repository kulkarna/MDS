﻿
/*******************************************************************************
 * usp_PriceInsert2
 * Inserts price record for specified sales channel
 *
 * History
 *******************************************************************************
 * 12/7/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceInsert2]
	@ChannelID				int, 
	@ChannelGroupID			int, 
	@ChannelTypeID			int, 
	@ProductCrossPriceSetID	int, 
	@ProductTypeID			int, 
	@MarketID				int, 
	@UtilityID				int, 
	@SegmentID				int, 
	@ZoneID					int, 
	@ServiceClassID			int, 
	@StartDate				datetime, 
	@Term					int, 
	@Price					decimal(18,10), 
	@CostRateEffectiveDate	datetime, 
	@CostRateExpirationDate	datetime, 
	@IsTermRange			tinyint, 
	@DateCreated			datetime,
	@PriceTier				tinyint,
	@ProductBrandID			int,
	@GrossMargin			decimal(18,10),
	@ProductCrossPriceID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	bigint
   
	INSERT INTO	LibertyPower..Price (ChannelID, ChannelGroupID, ChannelTypeID, ProductCrossPriceSetID, 
				ProductTypeID, MarketID, UtilityID, SegmentID, ZoneID, ServiceClassID, StartDate, Term, Price, CostRateEffectiveDate, 
				CostRateExpirationDate, IsTermRange, DateCreated, PriceTier, ProductBrandID, GrossMargin, ProductCrossPriceID)
	VALUES		(@ChannelID, @ChannelGroupID, @ChannelTypeID, @ProductCrossPriceSetID, @ProductTypeID, @MarketID, @UtilityID, @SegmentID, @ZoneID, 
				@ServiceClassID, @StartDate, @Term, @Price, @CostRateEffectiveDate, @CostRateExpirationDate, @IsTermRange, @DateCreated, @PriceTier, 
				@ProductBrandID, @GrossMargin, @ProductCrossPriceID) 

	SET  @ID = SCOPE_IDENTITY()

					
	SELECT	p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, 
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode, 
			s.service_rate_class AS ServiceClassCode, s.service_rate_class AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, p.GrossMargin, p.ProductCrossPriceID
	FROM	LibertyPower..Price p WITH (NOLOCK)
			INNER JOIN	Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN	Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN	Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN	Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID
			INNER JOIN	Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			LEFT JOIN	lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN	lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
	WHERE	p.ID = @ID 

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

