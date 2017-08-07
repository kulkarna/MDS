
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceMultiSelectByProductCrossPriceMultiID]
	@ProductCrossPriceMultiID	bigint
AS
BEGIN
    SET NOCOUNT ON;
                                                                                                                               
	SELECT	ProductCrossPriceMultiID, ProductCrossPriceID, StartDate, Term, MarkupRate, Price
	FROM	Libertypower..ProductCrossPriceMulti WITH (NOLOCK)
	WHERE	ProductCrossPriceMultiID = @ProductCrossPriceMultiID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
