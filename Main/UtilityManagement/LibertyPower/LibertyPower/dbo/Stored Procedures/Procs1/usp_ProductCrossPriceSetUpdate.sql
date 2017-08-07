
/*******************************************************************************
 * usp_ProductCrossPriceSetUpdate
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceSetUpdate]  
	@ProductCrossPriceSetID					int,
	@EffectiveDate							datetime,  
	@ExpirationDate							datetime, 
	@CreatedBy								int = null,
	@DateCreated							DateTime = null
AS


	Update [LibertyPower].[dbo].[ProductCrossPriceSet]
	Set 
		EffectiveDate = @EffectiveDate
		,ExpirationDate = @ExpirationDate
		,CreatedBy = Coalesce(@CreatedBy, CreatedBy)
		,DateCreated = Coalesce(@DateCreated, DateCreated)
	WHERE ProductCrossPriceSetID = @ProductCrossPriceSetID   

	SELECT [ProductCrossPriceSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[CreatedBy]
      ,[DateCreated]
	FROM [LibertyPower].[dbo].[ProductCrossPriceSet]  WITH (NOLOCK)
	WHERE [ProductCrossPriceSetID] = @ProductCrossPriceSetID                                                                                                                                
	
-- Copyright 2010 Liberty Power

