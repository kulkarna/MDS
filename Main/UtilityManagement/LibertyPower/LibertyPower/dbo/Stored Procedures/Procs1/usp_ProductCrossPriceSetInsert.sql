
/*******************************************************************************
 * usp_ProductCrossPriceSetInsert
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCrossPriceSetInsert]  
	@EffectiveDate							datetime,  
	@ExpirationDate							datetime, 
	@CreatedBy								int = 0,
	@DateCreated							DateTime = null
AS

	Declare @ProductCrossPriceSetID int

	Insert Into [LibertyPower].[dbo].[ProductCrossPriceSet]
		( EffectiveDate, ExpirationDate, CreatedBy, DateCreated )
	Values
		( @EffectiveDate, @ExpirationDate, @CreatedBy, Coalesce(@DateCreated, getDate()) )

	set @ProductCrossPriceSetID = @@Identity
	
	
	SELECT [ProductCrossPriceSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[CreatedBy]
      ,[DateCreated]
	FROM [LibertyPower].[dbo].[ProductCrossPriceSet] 
	WHERE [ProductCrossPriceSetID] = @ProductCrossPriceSetID                                                                                                                                   
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCrossPriceSetInsert';

