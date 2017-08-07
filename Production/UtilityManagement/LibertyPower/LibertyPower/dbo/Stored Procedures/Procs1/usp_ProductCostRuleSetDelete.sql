

/*******************************************************************************
* usp_ProductCostRuleSetDelete
*
*******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductCostRuleSetDelete]  
(	@ProductCostRuleSetID int	)
AS
-- Delete CostRuleRaw associated to the Cost Set
	Delete
	FROM ProductCostRuleRaw
	WHERE ProductCostRuleSetID = @ProductCostRuleSetID  

-- Delete CostRule associated to the Cost Set
	Delete
	FROM ProductCostRule
	WHERE ProductCostRuleSetID = @ProductCostRuleSetID  

-- Delete Cost Set
	Delete
	FROM ProductCostRuleSet 
	WHERE ProductCostRuleSetID = @ProductCostRuleSetID                                                                                                                              
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductCostRuleSetDelete';

