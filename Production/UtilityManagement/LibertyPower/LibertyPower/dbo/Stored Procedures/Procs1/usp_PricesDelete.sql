/*******************************************************************************
 * usp_PricesDelete
 * Deletes current sales channel prices
 *
 * History
 *******************************************************************************
 * 12/15/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PricesDelete]

AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@Date					datetime,
			@ProductCrossPriceSetID	int
			
    SET		@Date	= DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) -- just date, no time, just right...
    
    SELECT	TOP 1 @ProductCrossPriceSetID = ProductCrossPriceSetID
    FROM	Libertypower..Price WITH (NOLOCK)
	WHERE	CostRateEffectiveDate = @Date
	
	DELETE	FROM Libertypower..Price
	WHERE	ProductCrossPriceSetID = @ProductCrossPriceSetID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
