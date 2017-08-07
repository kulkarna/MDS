/*******************************************************************************
 * usp_ProductOffersActiveByMarketSelect
 * Gets active product offers by market
 *
 * History
 *******************************************************************************
 * 11/2/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductOffersActiveByMarketSelect]
	@MarketID	int
AS
BEGIN
    SET NOCOUNT ON;
	
	SELECT	o.OfferActivationID, p.ProductConfigurationID, p.SegmentID, p.ChannelTypeID, 
			p.ProductTypeID, p.ProductName, p.MarketID, p.UtilityID, p.ZoneID, 
			p.ServiceClassID, o.Term, o.IsActive, o.LowerTerm, o.UpperTerm, p.IsTermRange, 
			p.CreatedBy, p.DateCreated, p.RelativeStartMonth, p.ProductBrandID
	FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK) 
			ON p.ProductConfigurationID = o.ProductConfigurationID
	WHERE	o.IsActive	= 1
	AND		p.MarketID	= @MarketID
	ORDER BY o.OfferActivationID DESC

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
