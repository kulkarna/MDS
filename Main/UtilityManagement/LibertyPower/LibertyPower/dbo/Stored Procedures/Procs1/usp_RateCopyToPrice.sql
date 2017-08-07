/*******************************************************************************
* usp_RateCopyFromHistory
* Copy pricing rate from lp_common..product_rate_history 
* to libertypower..Price
*
* History
*******************************************************************************
* 8/10/2012 - Jose Munoz - SWCS
* Created.
*******************************************************************************
TEST CASES:

EXEC [libertypower].[dbo].[usp_RateCopyToPrice] 
		,@Product_id=N'PEPCO-DC_IP' 
		,@Rate_id=N'104011233'
		,@StartDate=N'20120801'
		,@EndDate=N'20120801'
		
*/

CREATE PROCEDURE [dbo].[usp_RateCopyToPrice]
	@ChannelName			VARCHAR(30)	
	,@StartDate				DATETIME		
	,@EndDate				DATETIME	
	,@PriceID				INT = 0
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @Count				INTEGER
		,@Message				VARCHAR(MAX)
		,@ChannelGroupID		INTEGER
		,@ChannelID				INTEGER
		,@ChannelTypeID			INTEGER
		
	SELECT @ChannelGroupID	= CG.ChannelGroupID
		,@ChannelID			= CG.ChannelID
		,@ChannelTypeID		= C.ChannelTypeID
	FROM libertypower..saleschannelchannelgroup CG WITH (NOLOCK)
	INNER JOIN libertypower..saleschannel SC WITH (NOLOCK) 
	ON sc.channelid = cg.channelid
	INNER JOIN libertypower..ChannelGroup C WITH (NOLOCK) 
	ON C.ChannelGroupID	= CG.ChannelGroupID
	WHERE SC.channelname	= @ChannelName


	IF @PriceID = 0
		INSERT INTO [Libertypower].[dbo].[Price]
			(ChannelID
			,ChannelGroupID
			,ChannelTypeID
			,ProductCrossPriceSetID
			,ProductTypeID
			,MarketID
			,UtilityID
			,SegmentID
			,ZoneID
			,ServiceClassID
			,StartDate
			,Term
			,Price
			,CostRateEffectiveDate
			,CostRateExpirationDate
			,IsTermRange
			,DateCreated
			,PriceTier
			,ProductBrandID
			,GrossMargin)
		SELECT 
			A.ChannelID
			,A.ChannelGroupID
			,A.ChannelTypeID
			,A.ProductCrossPriceSetID
			,A.ProductTypeID
			,A.MarketID
			,A.UtilityID
			,A.SegmentID
			,A.ZoneID
			,A.ServiceClassID
			,A.StartDate
			,A.Term
			,A.Price
			,A.CostRateEffectiveDate
			,A.CostRateExpirationDate
			,A.IsTermRange
			,A.DateCreated
			,A.PriceTier
			,A.ProductBrandID
			,A.GrossMargin
		FROM [Workspace].[dbo].[PriceTest] A WITH (NOLOCK)
		WHERE A.ChannelGroupID		= @ChannelGroupID
		AND A.ChannelID				= @ChannelID
		AND ((A.ChannelTypeID		= 1 AND  @ChannelTypeID = 4)
			OR (A.ChannelTypeID		= 2 AND  @ChannelTypeID = 4)
			OR (A.ChannelTypeID		= @ChannelTypeID AND  @ChannelTypeID <> 4))
		AND CONVERT(VARCHAR(10),A.CostRateEffectiveDate, 112) BETWEEN @StartDate AND @EndDate
		AND NOT EXISTS (SELECT 1 
						FROM [Libertypower].[dbo].[Price] B WITH (NOLOCK)
						WHERE B.ChannelID				=	A.ChannelID
						AND	B.ChannelGroupID			= A.ChannelGroupID
						AND	B.ChannelTypeID				= A.ChannelTypeID
						AND	B.ProductCrossPriceSetID	= A.ProductCrossPriceSetID
						AND	B.ProductTypeID				= A.ProductTypeID
						AND	B.MarketID					= A.MarketID
						AND	B.UtilityID					= A.UtilityID
						AND	B.SegmentID					= A.SegmentID
						AND	B.ZoneID					= A.ZoneID
						AND	B.ServiceClassID			= A.ServiceClassID
						AND	B.StartDate					= A.StartDate
						AND	B.Term						= A.Term
						AND	B.Price						= A.Price
						AND	B.CostRateEffectiveDate		= A.CostRateEffectiveDate
						AND	B.CostRateExpirationDate	= A.CostRateExpirationDate
						AND	B.IsTermRange				= A.IsTermRange
						AND	B.DateCreated				= A.DateCreated
						AND	B.PriceTier					= A.PriceTier
						AND	B.ProductBrandID			= A.ProductBrandID
						AND	B.GrossMargin				= A.GrossMargin)
	ELSE
		INSERT INTO [Libertypower].[dbo].[Price]
			(ChannelID
			,ChannelGroupID
			,ChannelTypeID
			,ProductCrossPriceSetID
			,ProductTypeID
			,MarketID
			,UtilityID
			,SegmentID
			,ZoneID
			,ServiceClassID
			,StartDate
			,Term
			,Price
			,CostRateEffectiveDate
			,CostRateExpirationDate
			,IsTermRange
			,DateCreated
			,PriceTier
			,ProductBrandID
			,GrossMargin)
		SELECT 
			A.ChannelID
			,A.ChannelGroupID
			,A.ChannelTypeID
			,A.ProductCrossPriceSetID
			,A.ProductTypeID
			,A.MarketID
			,A.UtilityID
			,A.SegmentID
			,A.ZoneID
			,A.ServiceClassID
			,A.StartDate
			,A.Term
			,A.Price
			,A.CostRateEffectiveDate
			,A.CostRateExpirationDate
			,A.IsTermRange
			,A.DateCreated
			,A.PriceTier
			,A.ProductBrandID
			,A.GrossMargin
		FROM [Workspace].[dbo].[PriceTest] A WITH (NOLOCK)
		WHERE A.ID					= @PriceID
		AND NOT EXISTS (SELECT 1 
						FROM [Libertypower].[dbo].[Price] B WITH (NOLOCK)
						WHERE B.ChannelID				=	A.ChannelID
						AND	B.ChannelGroupID			= A.ChannelGroupID
						AND	B.ChannelTypeID				= A.ChannelTypeID
						AND	B.ProductCrossPriceSetID	= A.ProductCrossPriceSetID
						AND	B.ProductTypeID				= A.ProductTypeID
						AND	B.MarketID					= A.MarketID
						AND	B.UtilityID					= A.UtilityID
						AND	B.SegmentID					= A.SegmentID
						AND	B.ZoneID					= A.ZoneID
						AND	B.ServiceClassID			= A.ServiceClassID
						AND	B.StartDate					= A.StartDate
						AND	B.Term						= A.Term
						AND	B.Price						= A.Price
						AND	B.CostRateEffectiveDate		= A.CostRateEffectiveDate
						AND	B.CostRateExpirationDate	= A.CostRateExpirationDate
						AND	B.IsTermRange				= A.IsTermRange
						AND	B.DateCreated				= A.DateCreated
						AND	B.PriceTier					= A.PriceTier
						AND	B.ProductBrandID			= A.ProductBrandID
						AND	B.GrossMargin				= A.GrossMargin)		
	
	SET @Count		= @@ROWCOUNT
	
	SET @Message	= LTRIM(RTRIM(STR(@Count))) + ' Rows were copied.'

	PRINT @Message
	
    SET NOCOUNT OFF;
END

		