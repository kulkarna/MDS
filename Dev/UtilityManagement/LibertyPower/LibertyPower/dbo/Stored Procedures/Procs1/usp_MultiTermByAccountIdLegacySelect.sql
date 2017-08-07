/*******************************************************************************
 * usp_MultiTermByAccountIdLegacySelect
 * Gets sub-terms for specified legacy account id
 *
 * History
 *******************************************************************************
 * 10/9/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MultiTermByAccountIdLegacySelect]
	@AccountIdLegacy	char(12)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@PriceID				bigint,
			@ProductCrossPriceID	int
                                                                                                               
	SELECT	TOP 1 @PriceID = r.PriceID
	FROM	Libertypower..Account a WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract c WITH (NOLOCK)
			ON a.AccountID = c.AccountID
			INNER JOIN Libertypower..AccountContractRate r WITH (NOLOCK)
			ON c.AccountContractID = r.AccountContractID			
	WHERE	a.AccountIdLegacy	= @AccountIdLegacy
	AND		r.IsContractedRate	= 1
	ORDER BY r.AccountContractRateID DESC
	
	SELECT	m.ProductCrossPriceMultiID, m.ProductCrossPriceID, m.StartDate, m.Term, m.MarkupRate, m.Price
	FROM	Libertypower..Price p WITH (NOLOCK)
			INNER JOIN Libertypower..ProductCrossPriceMulti m WITH (NOLOCK)
			ON p.ProductCrossPriceID = m.ProductCrossPriceID
	WHERE	p.ID = @PriceID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
