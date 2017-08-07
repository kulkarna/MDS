USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetMultiTermsByProductCrossPriceID]    Script Date: 10/12/2012 14:18:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_GetMultiTermsByProductCrossPriceID
 * Gets sub-terms for specified ProductCrossPriceID
 *
 * History
 *******************************************************************************
 * 10/12/2012 - Lev Rosenblum
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GetMultiTermsByProductCrossPriceID]
	@ProductCrossPriceID	int
AS
BEGIN
    SET NOCOUNT ON;
                                                                                                                               
	SELECT	m.ProductCrossPriceMultiID, m.ProductCrossPriceID, m.StartDate, m.Term, m.MarkupRate, m.Price
	FROM	Libertypower..ProductCrossPriceMulti m with (nolock)
	WHERE	m.ProductCrossPriceID = @ProductCrossPriceID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
