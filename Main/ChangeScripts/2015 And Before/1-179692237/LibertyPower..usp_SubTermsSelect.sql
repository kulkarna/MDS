USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SubTermsSelect]    Script Date: 07/25/2013 13:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modify : Thiago Nogueira
-- Date : 7/25/2013 
-- Ticket: 1-179692237
-- Changed PriceID to BIGINT
-- =============================================

ALTER PROCEDURE [dbo].[usp_SubTermsSelect]
	@PriceID	bigint
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
		LibertyPower.dbo.ProductCrossPriceMulti WITH (NOLOCK)
	Where
		ProductCrossPriceID = @ProductCrossPriceID
	Order By
		ProductCrossPriceMultiID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

