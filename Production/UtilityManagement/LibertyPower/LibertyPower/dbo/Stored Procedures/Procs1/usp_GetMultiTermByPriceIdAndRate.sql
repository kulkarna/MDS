/*******************************************************************************
 * usp_GetMultiTermByPriceIdAndRate
 * Gets sub-terms for specified price ID and Rate
 *
 * History
 *******************************************************************************
 * 10/28/2012 - Lev Rosenblum
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GetMultiTermByPriceIdAndRate]
	@PriceID	bigint
	, @Rate float
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @Delta float;
	SELECT @Delta=@Rate-m.Price
	FROM	Libertypower..ProductCrossPriceMulti m WITH (NOLOCK)
		INNER JOIN Libertypower..Price p WITH (NOLOCK)
			ON m.ProductCrossPriceID = p.ProductCrossPriceID
	WHERE	p.ID = @PriceID and m.StartDate=
	(
		SELECT	 MIN(m.StartDate)
		FROM	Libertypower..ProductCrossPriceMulti m WITH (NOLOCK)
				INNER JOIN Libertypower..Price p WITH (NOLOCK)
				ON m.ProductCrossPriceID = p.ProductCrossPriceID
		WHERE	p.ID = @PriceID
	)
                                                                                                                               
	SELECT	m.ProductCrossPriceMultiID, m.ProductCrossPriceID, m.StartDate, m.Term, m.MarkupRate, (m.Price+@Delta) as Price, m.Price as TransferRate
	FROM	Libertypower..ProductCrossPriceMulti m WITH (NOLOCK)
			INNER JOIN Libertypower..Price p WITH (NOLOCK)
			ON m.ProductCrossPriceID = p.ProductCrossPriceID
	WHERE	p.ID = @PriceID

    SET NOCOUNT OFF;
END
