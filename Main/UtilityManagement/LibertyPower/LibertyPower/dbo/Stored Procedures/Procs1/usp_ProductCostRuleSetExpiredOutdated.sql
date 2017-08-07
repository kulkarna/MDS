/*******************************************************************************
* usp_ProductCostRuleSetExpiredOutdated
*
*******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetExpiredOutdated]  
	@ProductCostRuleSetID Int
AS
	Update [LibertyPower].[dbo].[ProductCostRuleSet]
	Set [ExpirationDate] = getdate()
	Where [ExpirationDate] > getdate()
	AND [UploadStatus] = 2  
	AND ProductCostRuleSetID <> @ProductCostRuleSetID 
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetExpiredOutdated';

