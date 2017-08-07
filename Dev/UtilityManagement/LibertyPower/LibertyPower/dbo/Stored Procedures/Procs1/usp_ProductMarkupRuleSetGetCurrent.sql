
/*******************************************************************************
* usp_ProductMarkupRuleSetGetCurrent
*
*******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductMarkupRuleSetGetCurrent]  

AS
	SELECT TOP 1 [ProductMarkupRuleSetID]
      ,[EffectiveDate]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
	FROM [LibertyPower].[dbo].[ProductMarkupRuleSet]
	WHERE EffectiveDate = (Select max(EffectiveDate)
							From ProductMarkupRuleSet 
							Where EffectiveDate <= getdate())     
	
	ORDER BY [UploadedDate] Desc                                                                                                                            
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductMarkupRuleSetGetCurrent';

