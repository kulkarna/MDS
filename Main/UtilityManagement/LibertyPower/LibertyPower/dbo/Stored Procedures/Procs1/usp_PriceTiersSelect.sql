/*******************************************************************************
 * usp_PriceTiersSelect
 * Gets price tiers
 *
 * History
 *******************************************************************************
 * 3/27/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceTiersSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, Name, [Description], MinMwh, MaxMwh, SortOrder, IsActive
    FROM	Libertypower..DailyPricingPriceTier WITH (NOLOCK)
    ORDER BY ID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
