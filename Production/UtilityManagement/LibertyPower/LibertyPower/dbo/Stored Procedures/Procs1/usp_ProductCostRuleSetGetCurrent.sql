

/*******************************************************************************
* usp_ProductCostRuleSetGetCurrent
*
*******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetGetCurrent]  

AS
	SELECT  TOP 1 [ProductCostRuleSetID]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
	FROM [LibertyPower].[dbo].[ProductCostRuleSet]
	WHERE EffectiveDate = (Select max(EffectiveDate)
							From ProductCostRuleSet 
							Where EffectiveDate <= getdate()
							AND [ExpirationDate] > getdate())
	AND [ExpirationDate] > getdate()	
	ORDER BY UploadedDate Desc    	                                                                                                                              
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetGetCurrent';

