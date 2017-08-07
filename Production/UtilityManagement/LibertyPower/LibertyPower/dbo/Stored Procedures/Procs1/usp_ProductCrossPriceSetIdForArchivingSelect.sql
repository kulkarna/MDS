
/*******************************************************************************
 * usp_ProductCrossPriceSetIdForArchivingSelect
 *
 * Gets product cross price set ids that are ready for archiving
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetIdForArchivingSelect]  
	
AS

SELECT	DISTINCT ProductCrossPriceSetID
FROM	Libertypower..ProductCrossPrice WITH (NOLOCK)
WHERE	CostRateExpirationDate < GETDATE()

	
-- Copyright 2010 Liberty Power
