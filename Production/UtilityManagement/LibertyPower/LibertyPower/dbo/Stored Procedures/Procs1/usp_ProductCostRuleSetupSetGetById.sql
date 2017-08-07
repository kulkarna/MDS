
/*******************************************************************************
 * usp_ProductCostRuleSetupSetGetById
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetupSetGetById]  
	@ProductCostRuleSetupSetID					int
AS
	SELECT [ProductCostRuleSetupSetID]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
  FROM [LibertyPower].[dbo].[ProductCostRuleSetupSet] 
	WHERE ProductCostRuleSetupSetID = @ProductCostRuleSetupSetID                                                                                                                                 
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetupSetGetById';

