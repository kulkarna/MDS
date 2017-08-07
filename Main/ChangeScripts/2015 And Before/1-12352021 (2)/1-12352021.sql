CREATE PROCEDURE [dbo].[usp_PriceDetailSelect]                                                                                   
	@PriceID INT
AS
BEGIN

DECLARE @ChannelID INT
DECLARE @ChannelGroupID INT
DECLARE @ChannelTypeID INT
DECLARE @MarketID INT
DECLARE @UtilityID INT
DECLARE @SegmentID INT
DECLARE @ProductTypeID INT
DECLARE @StartDate DATETIME
DECLARE @EffDate DATETIME
DECLARE @Term INT
DECLARE @PriceTier INT
DECLARE @ServiceClassID INT
DECLARE @ZoneID INT

SELECT @ChannelID = ChannelID, @ChannelGroupID = ChannelGroupID, @ChannelTypeID = ChannelTypeID, @MarketID = MarketID,
@UtilityID = UtilityID, @SegmentID = SegmentID, @ProductTypeID = ProductTypeID, @StartDate = StartDate, @EffDate = CostRateEffectiveDate,
@Term = Term, @PriceTier = PriceTier, @ServiceClassID = ServiceClassID, @ZoneID = ZoneID
FROM Libertypower.dbo.Price WITH (NOLOCK)
WHERE ID = @PriceID

------------------------------------------------------------------------------
---- Create a small Markup table with just the data we need.
------------------------------------------------------------------------------
      DECLARE @MarkupRuleSetID INT

      SELECT @MarkupRuleSetID = max(ProductMarkupRuleSetID)
      FROM LibertyPower.dbo.ProductMarkupRuleSet m
      WHERE EffectiveDate < @EffDate

      SELECT *
      INTO #Markup
      FROM LibertyPower.dbo.ProductMarkupRule (NOLOCK)
      WHERE ProductMarkupRuleSetID = @MarkupRuleSetID
      AND ChannelGroupID = @ChannelGroupID
      AND ChannelTypeID = @ChannelTypeID
      AND MarketID = @MarketID
      AND UtilityID = @UtilityID
      AND SegmentID = @SegmentID
	  AND ProductTypeID = @ProductTypeID
      AND PriceTier = @PriceTier
      AND ServiceClassID = @ServiceClassID
      AND ZoneID = @ZoneID


------------------------------------------------------------------------------
---- Create a small Cost table with just the data we need.
------------------------------------------------------------------------------
      DECLARE @CostRuleSetID INT

      SELECT @CostRuleSetID = max(ProductCostRuleSetID)
      FROM LibertyPower.dbo.ProductCostRuleSet
      WHERE EffectiveDate < @EffDate

      SELECT *
      INTO #Cost
      FROM LibertyPower.dbo.ProductCostRule (NOLOCK)
      WHERE ProductCostRuleSetID = @CostRuleSetID
      AND MarketID = @MarketID
      AND UtilityID = @UtilityID
      AND Term = @Term
      AND StartDate = @StartDate
      AND ProductTypeID = @ProductTypeID
      AND PriceTier = @PriceTier
      AND ServiceClassID = @ServiceClassID
      AND ZoneID = @ZoneID


------------------------------------------------------------------------------
---- Create a small Setup table with just the data we need.
------------------------------------------------------------------------------
      DECLARE @SetupSetID INT

      SELECT @SetupSetID = max(ProductCostRuleSetupSetID)
      FROM LibertyPower.dbo.ProductCostRuleSetupSet
      WHERE UploadedDate < @EffDate

      SELECT *
      INTO #Setup
      FROM LibertyPower.dbo.ProductCostRuleSetup (NOLOCK)
      WHERE ProductCostRuleSetupSetID = @SetupSetID
      AND Market = @MarketID
      AND Utility = @UtilityID
      AND Segment = @SegmentID
      AND ProductType = @ProductTypeID
      AND PriceTier = @PriceTier
      AND ServiceClass = @ServiceClassID
      AND Zone = @ZoneID
      
      
------------------------------------------------------------------------------
---- This query will contain a recreation of the Price values.
------------------------------------------------------------------------------
      SELECT ProductCostRuleID, ProductMarkupRuleID, c.Rate as CostRate, m.Rate as MarkupRate , s.PorRate, s.GrtRate, s.SutRate
      FROM #Markup m
      JOIN #Cost c ON m.ServiceClassID = c.ServiceClassID
                        AND m.ZoneID = c.ZoneID
                        AND m.PriceTier = c.PriceTier
                        AND c.Term BETWEEN m.MinTerm AND m.MaxTerm
      JOIN #Setup s ON m.ServiceClassID = s.ServiceClass
                        AND m.ZoneID = s.Zone
                        AND m.PriceTier = s.PriceTier
END