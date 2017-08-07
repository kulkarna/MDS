

/*******************************************************************************
* usp_ProductMarkupRuleSetDelete
*
*******************************************************************************/
Create PROCEDURE [dbo].[usp_ProductMarkupRuleSetDelete]  
(	@ProductMarkupRuleSetID int	)
AS
-- Delete MarkupRuleRaw associated to the Cost Set
	Delete
	FROM ProductMarkupRuleRaw
	WHERE ProductMarkupRuleSetID = @ProductMarkupRuleSetID  

-- Delete MarkupRule associated to the Cost Set
	Delete
	FROM ProductMarkupRule
	WHERE ProductMarkupRuleSetID = @ProductMarkupRuleSetID  

-- Delete MarkupRuleSet
	Delete
	FROM ProductMarkupRuleSet 
	WHERE ProductMarkupRuleSetID = @ProductMarkupRuleSetID                                                                                                                              
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductMarkupRuleSetDelete';

