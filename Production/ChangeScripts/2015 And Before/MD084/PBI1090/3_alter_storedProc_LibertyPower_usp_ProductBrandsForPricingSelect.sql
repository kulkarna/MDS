USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductBrandsForPricingSelect]    Script Date: 10/24/2012 11:31:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_ProductBrandsForPricingSelect
 * Gets product brands for daily pricing
 *
 * History
 *******************************************************************************
 * 4/3/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 * Modified By Lev Rosenblum at 10/24/2012
 * b.IsMultiTerm has been added to output.
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_ProductBrandsForPricingSelect]
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	b.ProductBrandID, b.ProductTypeID, b.[Name], b.IsCustom, b.IsDefaultRollover, b.IsMultiTerm
			, b.RolloverBrandID, b.Active, b.Username, b.DateCreated
	FROM	Libertypower..ProductBrand b WITH (NOLOCK)
			INNER JOIN Libertypower..ProductType t WITH (NOLOCK) ON b.ProductTypeID = t.ProductTypeID
	WHERE	b.ProductTypeID IN (1,3,4,6,7)
	AND		b.Active = 1
	AND		t.Active = 1
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
