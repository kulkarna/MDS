/*******************************************************************************
 * usp_ProductCrossPriceMultiInsert
 * Inserts sub-terms for specified product cross price ID
 *
 * History
 *******************************************************************************
 * 9/18/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceMultiInsert]
	@ProductCrossPriceID	int,
	@StartDate				datetime, 
	@Term					int, 
	@MarkupRate				decimal(13,5), 
	@Price					decimal(13,5)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS(	SELECT	NULL 
					FROM	Libertypower..ProductCrossPriceMulti WITH (NOLOCK) 
					WHERE	ProductCrossPriceID	= @ProductCrossPriceID
					AND		StartDate			= @StartDate
					AND		Term				= @Term
				  )
		BEGIN                                                                                                                               
			INSERT INTO	Libertypower..ProductCrossPriceMulti (ProductCrossPriceID, StartDate, Term, MarkupRate, Price)
			VALUES		(@ProductCrossPriceID, @StartDate, @Term, @MarkupRate, @Price)
		END
	
    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
