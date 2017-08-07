/*******************************************************************************
 * usp_ProductGreenRuleGetBySetID
 * Gets green rule records by set ID
 *
 * History
 *******************************************************************************
 * 3/13/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductGreenRuleGetBySetID]
	@ProductGreenRuleSetID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ProductGreenRuleID
			,ProductGreenRuleSetID
			,SegmentID
			,MarketID
			,UtilityID
			,ServiceClassID
			,ZoneID
			,ProductTypeID
			,ProductBrandID
			,StartDate
			,Term
			,Rate
			,CreatedBy
			,DateCreated
			,ISNULL(PriceTier, 0) AS PriceTier
	  FROM	LibertyPower.dbo.ProductGreenRule WITH (NOLOCK)
	  WHERE	ProductGreenRuleSetID = @ProductGreenRuleSetID
	  ORDER BY ProductGreenRuleID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
