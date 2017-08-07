/*******************************************************************************
 * usp_PriceTierSortOrderUpdate
 * Updates price tier sort order
 *
 * History
 *******************************************************************************
 * 4/13/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceTierSortOrderUpdate]
	@PriceTierID	int, 
	@SortOrder		int
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	Libertypower..DailyPricingPriceTier 
    SET		SortOrder	= @SortOrder
    WHERE	ID			= @PriceTierID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
