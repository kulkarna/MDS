
/*******************************************************************************
 * usp_ProductCostRuleSetGetById
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetGetById]  
	@ProductCostRuleSetID					int
AS
	SELECT [ProductCostRuleSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
  FROM [LibertyPower].[dbo].[ProductCostRuleSet] 
	WHERE ProductCostRuleSetID = @ProductCostRuleSetID                                                                                                                                 
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetGetById';

