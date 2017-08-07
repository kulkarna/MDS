/*******************************************************************************
 * usp_MultiTermByPriceIDSelect
 * Gets sub-terms for specified price ID
 *
 * History
 *******************************************************************************
 * 10/8/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MultiTermByPriceIDSelect]
	@PriceID	bigint
AS
BEGIN
    SET NOCOUNT ON;
                                                                                                                               
	SELECT	m.ProductCrossPriceMultiID, m.ProductCrossPriceID, m.StartDate, m.Term, m.MarkupRate, m.Price
	FROM	Libertypower..ProductCrossPriceMulti m WITH (NOLOCK)
			INNER JOIN Libertypower..Price p WITH (NOLOCK)
			ON m.ProductCrossPriceID = p.ProductCrossPriceID
	WHERE	p.ID = @PriceID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
