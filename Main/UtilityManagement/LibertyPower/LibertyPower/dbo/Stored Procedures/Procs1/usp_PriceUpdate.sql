
/*******************************************************************************
 * usp_PriceInsert
 * Inserts price record for specified sales channel
 *
 * History
 *******************************************************************************
 * 8/21/2012 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceUpdate]
	@ID						int,
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
	@ProductCrossPriceID	int	= 0
AS
BEGIN
    SET NOCOUNT ON;

	SET	@CostRateEffectiveDate = DATEADD(dd, 0, DATEDIFF(dd, 0, @CostRateEffectiveDate))
    
	UPDATE	Libertypower..Price 
	SET		ChannelID				= @ChannelID, 
			ChannelGroupID			= @ChannelGroupID,
			ChannelTypeID			= @ChannelTypeID,
			ProductCrossPriceSetID	= @ProductCrossPriceSetID,
			ProductTypeID			= @ProductTypeID,
			MarketID				= @MarketID,
			UtilityID				= @UtilityID, 
			SegmentID				= @SegmentID,
			ZoneID					= @ZoneID,
			ServiceClassID			= @ServiceClassID,
			StartDate				= @StartDate, 
			Term					= @Term, 
			Price					= @Price,
			CostRateEffectiveDate	= @CostRateEffectiveDate,
			CostRateExpirationDate	= @CostRateExpirationDate,
			IsTermRange				= @IsTermRange, 
			PriceTier				= @PriceTier,
			ProductBrandID			= @ProductBrandID,
			GrossMargin				= @GrossMargin,
			ProductCrossPriceID		= @ProductCrossPriceID
	WHERE ID = @ID
    	
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

