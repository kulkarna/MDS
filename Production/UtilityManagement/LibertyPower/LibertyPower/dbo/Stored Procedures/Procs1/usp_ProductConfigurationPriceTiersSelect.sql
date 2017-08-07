/*******************************************************************************
 * usp_ProductConfigurationPriceTiersSelect
 * Gets price tiers for product configuration
 *
 * History
 *******************************************************************************
 * 4/5/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationPriceTiersSelect]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	p.ID, p.ProductConfigurationID, p.PriceTierID, t.Name,
			t.[Description], t.MinMwh, t.MaxMwh, t.IsActive, t.SortOrder
    FROM	ProductConfigurationPriceTiers p WITH (NOLOCK)
			INNER JOIN  DailyPricingPriceTier t WITH (NOLOCK)
			ON p.PriceTierID = t.ID
    WHERE	p.ProductConfigurationID = CASE WHEN @ProductConfigurationID = -1 THEN p.ProductConfigurationID ELSE @ProductConfigurationID END

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
