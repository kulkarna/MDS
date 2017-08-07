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
 * Modified By Thiago Nogueira at 04/04/2013
 * Changing logic to do not show only Default Variable
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductBrandsForPricingSelect]
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	b.ProductBrandID, b.ProductTypeID, b.[Name], b.IsCustom, b.IsDefaultRollover, b.IsMultiTerm
			, b.RolloverBrandID, b.Active, b.Username, b.DateCreated
	FROM	Libertypower..ProductBrand b WITH (NOLOCK)
			INNER JOIN Libertypower..ProductType t WITH (NOLOCK) ON b.ProductTypeID = t.ProductTypeID
	WHERE	b.IsDefaultRollover = 0
	AND		b.Active = 1
	AND		t.Active = 1
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
