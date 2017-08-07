/*******************************************************************************
 * usp_ProductCrossPriceMultiSelect
 * Gets sub-terms for specified product cross price ID
 *
 * History
 *******************************************************************************
 * 9/18/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceMultiSelect]
	@ProductCrossPriceID	int
AS
BEGIN
    SET NOCOUNT ON;
                                                                                                                               
	SELECT	ProductCrossPriceMultiID, ProductCrossPriceID, StartDate, Term, MarkupRate, Price
	FROM	Libertypower..ProductCrossPriceMulti WITH (NOLOCK)
	WHERE	ProductCrossPriceID = @ProductCrossPriceID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
