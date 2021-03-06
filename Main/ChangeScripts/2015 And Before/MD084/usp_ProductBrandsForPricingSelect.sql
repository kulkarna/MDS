USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductBrandsForPricingSelect]    Script Date: 09/14/2012 16:17:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductBrandsForPricingSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductBrandsForPricingSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductBrandsForPricingSelect]    Script Date: 09/14/2012 16:17:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductBrandsForPricingSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductBrandsForPricingSelect
 * Gets product brands for daily pricing
 *
 * History
 *******************************************************************************
 * 4/3/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductBrandsForPricingSelect]
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	b.ProductBrandID, b.ProductTypeID, b.[Name], b.IsCustom, b.IsDefaultRollover, 
			b.RolloverBrandID, b.Active, b.Username, b.DateCreated
	FROM	Libertypower..ProductBrand b WITH (NOLOCK)
			INNER JOIN Libertypower..ProductType t WITH (NOLOCK) ON b.ProductTypeID = t.ProductTypeID
	WHERE	b.ProductTypeID IN (1,3,4,6,7)
	AND		b.Active = 1
	AND		t.Active = 1
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
