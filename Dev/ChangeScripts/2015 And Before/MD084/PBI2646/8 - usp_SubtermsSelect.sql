USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_SubtermsSelect]    Script Date: 10/10/2012 14:46:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_SubtermsSelect]
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

GO


