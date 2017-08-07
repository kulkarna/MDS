/*******************************************************************************
 * usp_ProductBrandSelect
 * Gets product brand by product brand id
 *
 * History
 *******************************************************************************
 * 6/1/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductBrandSelect]
	@ProductBrandId int
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ProductBrandID, ProductTypeID, [Name], IsCustom, IsDefaultRollover, RolloverBrandID, Active, Username, DateCreated, IsMultiTerm
	FROM	ProductBrand WITH (NOLOCK)
	WHERE	ProductBrandID	= @ProductBrandId
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
