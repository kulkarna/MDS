/*******************************************************************************
 * usp_ProductGreenRuleSetDelete
 * Delete green rule records and set by set ID
 *
 * History
 *******************************************************************************
 * 3/14/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductGreenRuleSetDelete]
	@ProductGreenRuleSetID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	DELETE
	FROM	LibertyPower..ProductGreenRule
	WHERE	ProductGreenRuleSetID = @ProductGreenRuleSetID
	
	DELETE
	FROM	LibertyPower..ProductGreenRuleSet
	WHERE	ProductGreenRuleSetID = @ProductGreenRuleSetID	

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
