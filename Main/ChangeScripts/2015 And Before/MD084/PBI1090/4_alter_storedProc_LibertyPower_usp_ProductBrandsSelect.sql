USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductBrandsSelect]    Script Date: 10/25/2012 10:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_ProductBrandsSelect
 * Gets product brands
 *
 * History
 *******************************************************************************
 * 2/15/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 10/27/2012 - Lev Rosenblum
 * Added IsMultiTerm to output.
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_ProductBrandsSelect]
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	b.ProductBrandID, b.ProductTypeID, b.[Name], b.IsCustom, b.IsDefaultRollover, 
			b.RolloverBrandID, b.Active, b.Username, b.DateCreated, b.IsMultiTerm
	FROM	Libertypower..ProductBrand b WITH (NOLOCK)
			INNER JOIN Libertypower..ProductType t WITH (NOLOCK) ON b.ProductTypeID = t.ProductTypeID
	WHERE	b.Active = 1
	AND		t.Active = 1
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
