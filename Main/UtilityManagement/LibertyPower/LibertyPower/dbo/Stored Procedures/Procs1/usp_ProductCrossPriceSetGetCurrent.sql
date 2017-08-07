
/*******************************************************************************
 * usp_ProductCrossPriceSetGetCurrent
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetGetCurrent]  
	
AS
	SELECT	s1.ProductCrossPriceSetID, s1.EffectiveDate, s1.ExpirationDate, s1.CreatedBy, s1.DateCreated
	FROM	ProductCrossPriceSet s1 WITH (NOLOCK)
			INNER JOIN 
	(	SELECT	MAX(ProductCrossPriceSetID) AS ProductCrossPriceSetID
		FROM [ProductCrossPriceSet] WITH (NOLOCK)
		WHERE EffectiveDate < '9999-12-31' 
	) s2 ON s1.ProductCrossPriceSetID = s2.ProductCrossPriceSetID
	
-- Copyright 2010 Liberty Power

