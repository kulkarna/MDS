/*******************************************************************************
 * usp_ProductBrandByProductTypeIdSelect
 * Gets product brands by product type id
 *
 * History
 *******************************************************************************
 * 6/15/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductBrandByProductTypeIdSelect]
	@ProductTypeId int
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ProductBrandID, ProductTypeID, [Name], IsCustom, IsDefaultRollover, RolloverBrandID, 
			Active, Username, DateCreated, IsMultiTerm
	FROM	ProductBrand WITH (NOLOCK)
	WHERE	ProductTypeId	= @ProductTypeId
	AND		Active			= 1
	ORDER BY ProductTypeId
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
