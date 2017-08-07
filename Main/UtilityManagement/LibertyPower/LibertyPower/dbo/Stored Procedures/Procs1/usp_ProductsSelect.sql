/*******************************************************************************
 * usp_ProductsSelect
 * Gets products
 *
 * History
 *******************************************************************************
 * 6/1/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductsSelect]

AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ProductTypeID, [Name], Active, Username, DateCreated
	FROM	ProductType WITH (NOLOCK)
	WHERE	Active = 1
	ORDER BY ProductTypeID
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
