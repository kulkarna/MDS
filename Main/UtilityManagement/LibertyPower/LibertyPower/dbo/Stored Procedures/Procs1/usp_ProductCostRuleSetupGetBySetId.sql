
/*******************************************************************************
 * usp_ProductCostRuleSetupGetBySetId
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCostRuleSetupGetBySetId]  
	@ProductCostRuleSetupSetID					int
AS
	SELECT [ID]
      ,[Segment]
      ,[ProductType]
      ,[Market]
      ,[Utility]
      ,[Zone]
      ,[ServiceClass]
      ,[MaxRelativeStartMonth]
      ,[MaxTerm]
      ,[LowCostRate]
      ,[HighCostRate]
      ,[DateInserted]
      ,[InsertedBy]
      ,[PorRate]
      ,[GrtRate]
      ,[SutRate]
      ,[ProductCostRuleSetupSetID]
      ,[ServiceClassDisplayName]
      ,[PriceTier]
      ,[ProductBrandID]
	FROM [LibertyPower].[dbo].[ProductCostRuleSetup] WITH (NOLOCK)
	WHERE ProductCostRuleSetupSetID = @ProductCostRuleSetupSetID                                                                                                                                 
	
-- Copyright 2010 Liberty Power

