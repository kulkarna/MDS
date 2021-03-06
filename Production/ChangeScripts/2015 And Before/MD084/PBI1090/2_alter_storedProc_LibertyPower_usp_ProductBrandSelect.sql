USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductBrandSelect]    Script Date: 10/24/2012 11:12:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
ALTER PROCEDURE [dbo].[usp_ProductBrandSelect]
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
