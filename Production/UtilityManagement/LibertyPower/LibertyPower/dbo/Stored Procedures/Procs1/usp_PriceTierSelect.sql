/*******************************************************************************
 * usp_PriceTierSelect
 * Gets price tier for specified ID
 *
 * History
 *******************************************************************************
 * 3/27/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceTierSelect]
	@PriceTierID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, Name, [Description], MinMwh, MaxMwh, SortOrder, IsActive
    FROM	Libertypower..DailyPricingPriceTier WITH (NOLOCK)
    WHERE	ID = @PriceTierID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
