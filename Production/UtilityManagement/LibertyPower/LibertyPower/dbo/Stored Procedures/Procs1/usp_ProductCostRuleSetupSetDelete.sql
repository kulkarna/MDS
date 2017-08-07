

/*******************************************************************************
* usp_ProductCostRuleSetupSetDelete
*
*******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetupSetDelete]  
(	@ProductCostRuleSetupSetID int	)
AS

-- Delete CostRuleSetup associated to the CostRuleSetupSet
	Delete
	FROM ProductCostRuleSetup
	WHERE ProductCostRuleSetupSetID = @ProductCostRuleSetupSetID  

-- Delete CostRuleSetupSet
	Delete
	FROM ProductCostRuleSetupSet 
	WHERE ProductCostRuleSetupSetID = @ProductCostRuleSetupSetID                                                                                                                              
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetupSetDelete';

