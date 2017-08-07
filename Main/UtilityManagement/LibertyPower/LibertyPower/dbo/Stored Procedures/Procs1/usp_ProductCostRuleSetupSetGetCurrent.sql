

/*******************************************************************************
* usp_ProductCostRuleSetupSetGetCurrent
*
*******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetupSetGetCurrent]  

AS
	SELECT top 1 [ProductCostRuleSetupSetID]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
    FROM [LibertyPower].[dbo].[ProductCostRuleSetupSet]
	WHERE [UploadStatus] = 2        --> 2 = Complete                                                                                                                      
	ORDER BY [UploadedDate] Desc
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetupSetGetCurrent';

