USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PriceDetailSelect]    Script Date: 07/29/2013 15:09:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_PriceDetailSelect]
@PriceID BIGINT
AS
BEGIN

SET NOCOUNT ON

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
DECLARE @ProductBrandID int
SELECT @ChannelID = ChannelID, @ChannelGroupID = ChannelGroupID, @ChannelTypeID = ChannelTypeID, @MarketID = MarketID,
@UtilityID = UtilityID, @SegmentID = SegmentID, @ProductTypeID = ProductTypeID, @StartDate = StartDate, @EffDate = CostRateEffectiveDate,
@Term = Term, @PriceTier = PriceTier, @ServiceClassID = ServiceClassID, @ZoneID = ZoneID, @ProductBrandID = ProductBrandID
FROM Libertypower.dbo.Price WITH (NOLOCK)
WHERE ID = @PriceID
------------------------------------------------------------------------------
---- Create a small Markup table with just the data we need.
------------------------------------------------------------------------------
DECLARE @MarkupRuleSetID INT
SELECT @MarkupRuleSetID = max(ProductMarkupRuleSetID)
FROM LibertyPower.dbo.ProductMarkupRuleSet m with (nolock)
WHERE EffectiveDate < @EffDate
SELECT *
INTO #Markup
FROM LibertyPower.dbo.ProductMarkupRule with (nolock)
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
FROM LibertyPower.dbo.ProductCostRuleSet with (nolock)
WHERE EffectiveDate < @EffDate
SELECT *
INTO #Cost
FROM LibertyPower.dbo.ProductCostRule with (nolock)
WHERE ProductCostRuleSetID = @CostRuleSetID
AND MarketID = @MarketID
AND UtilityID = @UtilityID
AND Term = @Term
AND StartDate = @StartDate
AND ProductTypeID = CASE WHEN @ProductTypeID = 8 THEN 1 ELSE @ProductTypeID END
AND PriceTier = @PriceTier
AND ServiceClassID = @ServiceClassID
AND ZoneID = @ZoneID
AND CustomerTypeID = @SegmentID
------------------------------------------------------------------------------
---- Create a small Setup table with just the data we need.
------------------------------------------------------------------------------
DECLARE @SetupSetID INT
SELECT @SetupSetID = max(ProductCostRuleSetupSetID)
FROM LibertyPower.dbo.ProductCostRuleSetupSet with (nolock)
WHERE UploadedDate < @EffDate
SELECT *
INTO #Setup
FROM LibertyPower.dbo.ProductCostRuleSetup with (nolock)
WHERE ProductCostRuleSetupSetID = @SetupSetID
AND Market = @MarketID
AND Utility = @UtilityID
AND Segment = @SegmentID
AND ProductType = @ProductTypeID
AND PriceTier = @PriceTier
AND ServiceClass = @ServiceClassID
AND Zone = @ZoneID

------------------------------------------------------------------------------
---- Create a small Green table with just the data we need.
------------------------------------------------------------------------------
DECLARE @GreenSetID INT
SELECT @GreenSetID = max(ProductGreenRuleSetID)
FROM LibertyPower.dbo.ProductGreenRuleSet with (nolock)
WHERE UploadedDate < @EffDate
SELECT *
INTO #Green
FROM LibertyPower.dbo.ProductGreenRule with (nolock)
WHERE ProductGreenRuleSetID = @GreenSetID
AND MarketID = @MarketID
AND UtilityID = @UtilityID
AND SegmentID = @SegmentID
AND Term = @Term
AND StartDate = @StartDate
AND ProductTypeID = @ProductTypeID
AND PriceTier = @PriceTier
AND ServiceClassID = @ServiceClassID
AND ZoneID = @ZoneID
AND ProductBrandID = @ProductBrandID

------------------------------------------------------------------------------
---- This query will contain a recreation of the Price values.
------------------------------------------------------------------------------
SELECT ProductCostRuleID, ProductMarkupRuleID, c.Rate as CostRate, m.Rate as MarkupRate , s.PorRate, s.GrtRate, s.SutRate, ISNULL(g.Rate,0) AS GreenAdder
FROM #Markup m 
JOIN #Cost c  ON m.ServiceClassID = c.ServiceClassID
AND m.ZoneID = c.ZoneID
AND m.PriceTier = c.PriceTier
AND c.Term BETWEEN m.MinTerm AND m.MaxTerm
JOIN #Setup s ON m.ServiceClassID = s.ServiceClass
AND m.ZoneID = s.Zone
AND m.PriceTier = s.PriceTier
AND s.ProductBrandID = CASE WHEN s.ProductBrandID = -1 THEN s.ProductBrandID ELSE @ProductBrandID END
LEFT JOIN #Green g ON g.ZoneID = c.ZoneID
AND m.ZoneID = g.ZoneID
AND m.PriceTier = g.PriceTier
AND g.Term BETWEEN m.MinTerm AND m.MaxTerm


SET NOCOUNT OFF

END
