
/*******************************************************************************
 * usp_ProductMarkupRuleSetGetById
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductMarkupRuleSetGetById]  
	@ProductMarkupRuleSetID					int
AS
	SELECT [ProductMarkupRuleSetID]
      ,[EffectiveDate]
      ,[FileGuid]
      ,[UploadedBy]
      ,[UploadedDate]
      ,[UploadStatus]
  FROM [LibertyPower].[dbo].[ProductMarkupRuleSet] 
	WHERE ProductMarkupRuleSetID = @ProductMarkupRuleSetID                                                                                                                                 
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductMarkupRuleSetGetById';

