/*******************************************************************************
 * usp_DailyPricingMaxTermsSelect
 * Gets max term for specified parameters
 *
 * History
 *******************************************************************************
 * 7/7/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingMaxTermsSelect]
	@MarketID		int,
	@UtilityID		int,
	@ZoneID			int,
	@ServiceClassID	int,
	@SegmentID		int,
	@ProductTypeID	int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE	@ProductCostRuleSetupSetID	int
    
	SELECT	TOP 1 @ProductCostRuleSetupSetID = ProductCostRuleSetupSetID
    FROM	ProductCostRuleSetupSet
	WHERE	UploadStatus = 2        --> 2 = Complete                                                                                                                      
	ORDER BY UploadedDate DESC      

	SELECT	MaxTerm
	FROM	ProductCostRuleSetup WITH (NOLOCK)
	WHERE	Market						= @MarketID
	AND		Utility						= @UtilityID
	AND		Zone						= @ZoneID
	AND		ServiceClass				= @ServiceClassID
	AND		Segment						= @SegmentID
	AND		ProductType					= @ProductTypeID
	AND		ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingMaxTermsSelect';

