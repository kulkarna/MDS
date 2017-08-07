

CREATE PROCEDURE [dbo].usp_SubTermsSelect
	@PriceID	int
AS
BEGIN
    SET NOCOUNT ON;

	Declare @ProductCrossPriceID int
	Set @ProductCrossPriceID = (Select ProductCrossPriceID From Price Where ID = @PriceID)
	
	Select
		ProductCrossPriceMultiID,
        ProductCrossPriceID,
        StartDate,
        Term,
        MarkupRate,
        Price
	From
		LibertyPower.dbo.ProductCrossPriceMulti
	Where
		ProductCrossPriceID = @ProductCrossPriceID
	Order By
		ProductCrossPriceMultiID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

