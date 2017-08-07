/*******************************************************************************
 * usp_PriceTermsCurrentSelect
 * Gets current terms for parameters
 *
 * History
 *******************************************************************************
 * 11/2/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceTermsCurrentSelect]
	@ChannelID		int,
	@MarketID		int = NULL,	
	@UtilityID		int = NULL,
	@ProductBrandID	int = NULL,
	@AccountTypeID	int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ProductCrossPriceSetID	int
				
	SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
    FROM	LibertyPower..ProductCrossPriceSet WITH (NOLOCK)
	WHERE	GETDATE() BETWEEN EffectiveDate AND  ExpirationDate 
	
	IF @AccountTypeID IS NOT NULL
		BEGIN
			SELECT @AccountTypeID = ID FROM Libertypower..AccountType WHERE @AccountTypeID = ProductAccountTypeID       
		END  	     
    
	SELECT	DISTINCT Term
	FROM	LibertyPower..Price WITH (NOLOCK)
	WHERE	ProductCrossPriceSetID	= @ProductCrossPriceSetID
	AND		ChannelID				= @ChannelID  
	AND		MarketID				= CASE WHEN @MarketID IS NULL THEN MarketID ELSE @MarketID END
	AND		UtilityID				= CASE WHEN @UtilityID IS NULL THEN UtilityID ELSE @UtilityID END
	AND		ProductBrandID			= CASE WHEN @ProductBrandID IS NULL THEN ProductBrandID ELSE @ProductBrandID END
	AND		SegmentID				= CASE WHEN @AccountTypeID IS NULL THEN SegmentID ELSE @AccountTypeID END
	ORDER BY Term

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
