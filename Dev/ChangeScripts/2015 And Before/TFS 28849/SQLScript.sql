USE LibertyPower
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************

 * PROCEDURE:	[usp_ProductBrandByProductBrandSelect]
 * PURPOSE:		Product Brand details based on Product Brand
 * HISTORY:		To get the details of Product Brand based on Product Brand
 *******************************************************************************
 * 12/12/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].usp_ProductBrandByProductBrandSelect
	@ProductBrand varchar(500)
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ProductBrandID, ProductTypeID, [Name], IsCustom, IsDefaultRollover, RolloverBrandID, Active, Username, DateCreated, IsMultiTerm
	FROM	ProductBrand WITH (NOLOCK)
	WHERE	Name	= @ProductBrand and Active=1 and IsDefaultRollover = 0
	
    SET NOCOUNT OFF;
END
-- Copyright 12/12/2013 Liberty Power

