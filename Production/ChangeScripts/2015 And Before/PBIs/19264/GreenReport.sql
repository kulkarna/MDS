/*

This script provides visibility to Green products per account

Set from and to dates for report date range

*/

DECLARE	@FromDate	datetime,
		@ToDate		datetime
		
SET		@FromDate	= '20130921'
SET		@ToDate		= '20130922'

DECLARE	@PriceTable TABLE (PriceID bigint, ProductCrossPriceID int)
DECLARE	@PriceGreenAttributesTable TABLE (ProductCrossPriceID int, ProdConfigGreenAttributesID int)

INSERT	INTO @PriceTable
SELECT	ID, ProductCrossPriceID
FROM	Libertypower..Price WITH (NOLOCK)
WHERE	ProductTypeID = 8
AND		CostRateEffectiveDate BETWEEN @FromDate AND @ToDate

INSERT	INTO @PriceGreenAttributesTable
SELECT	DISTINCT ProductCrossPriceID , ProdConfigGreenAttributesID
FROM	Libertypower..PriceGreenAttributes WITH (NOLOCK)

--SELECT	*
--FROM	@PriceTable

SELECT	distinct pr.*, '-------------------', loc.Location, rec.RecType, per.[Percent], '-------------------', pr.*, '-------------------', pa.*, '-------------------', ca.*
FROM	@PriceGreenAttributesTable pa
		INNER JOIN Libertypower..ProdConfigGreenAttributes ca WITH (NOLOCK) ON pa.ProdConfigGreenAttributesID = ca.ID
		INNER JOIN Libertypower..GreenLocation loc WITH (NOLOCK) ON ca.LocationID = loc.ID
		INNER JOIN Libertypower..GreenRecType rec WITH (NOLOCK) ON ca.RecTypeID = rec.ID
		INNER JOIN Libertypower..GreenPercentage per WITH (NOLOCK) ON ca.PercentageID = per.ID	
		INNER JOIN @PriceTable pr ON pa.ProductCrossPriceID = pr.ProductCrossPriceID
		INNER JOIN Libertypower..AccountContractRate acr WITH (NOLOCK) ON pr.PriceID = acr.PriceID		