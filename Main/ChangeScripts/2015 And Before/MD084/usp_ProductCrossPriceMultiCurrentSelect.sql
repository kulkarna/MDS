USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceMultiCurrentSelect]    Script Date: 09/27/2012 16:59:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceMultiCurrentSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceMultiCurrentSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceMultiCurrentSelect]    Script Date: 09/27/2012 16:59:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceMultiCurrentSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductCrossPriceMultiCurrentSelect
 *
 * Gets the multi-term prices for current product cross price set
 *
 * Created
 * 9/28/2012 - Rick Deigsler
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceMultiCurrentSelect]  
	
AS
	SELECT	m.ProductCrossPriceMultiID, m.ProductCrossPriceID, m.StartDate, m.Term, m.MarkupRate, m.Price
	FROM	Libertypower..ProductCrossPriceMulti m WITH (NOLOCK)
			INNER JOIN Libertypower..ProductCrossPrice p WITH (NOLOCK)
			ON m.ProductCrossPriceID = p.ProductCrossPriceID
			INNER JOIN
	(
	SELECT	s1.ProductCrossPriceSetID
	FROM	ProductCrossPriceSet s1 WITH (NOLOCK)
			INNER JOIN 
	(	SELECT	MAX(ProductCrossPriceSetID) AS ProductCrossPriceSetID
		FROM	Libertypower..ProductCrossPriceSet WITH (NOLOCK)
		WHERE	EffectiveDate < ''9999-12-31'' 
	) s2 ON s1.ProductCrossPriceSetID = s2.ProductCrossPriceSetID
	) s ON s.ProductCrossPriceSetID = p.ProductCrossPriceSetID
	
-- Copyright 2010 Liberty Power

' 
END
GO
