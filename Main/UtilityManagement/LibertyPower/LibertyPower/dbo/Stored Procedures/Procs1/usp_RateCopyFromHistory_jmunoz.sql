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

 EXEC [libertypower].[dbo].[usp_RateCopyFromHistory] 
		@ChannelName=N'PE1'
		,@UtilityCode=N'AMEREN'
		,@StartDate=N'2011-11-17'
		,@EndDate=N'2011-11-18'
		,@Product_id=N'AMEREN_IP_ABC' 
		,@Rate_id=N'104011203'

		
*/

CREATE PROCEDURE [dbo].[usp_RateCopyFromHistory_jmunoz]
	@UtilityCode			VARCHAR(15)	
	,@ChannelName			VARCHAR(30)	
	,@StartDate				DATETIME		= NULL
	,@EndDate				DATETIME		= NULL
	,@Product_id			VARCHAR(20)		= ''
	,@Rate_id				VARCHAR(12)		= ''
AS
BEGIN
    SET NOCOUNT ON;
	
	DECLARE @ChannelGroupID			SMALLINT
		,@ChannelID					INT
		,@UtilityID					INT
		,@MarketID					INT
		,@ChannelTypeID				INT
		,@Count						INTEGER
		,@Message					VARCHAR(MAX)		
		,@ProcessDate				DATETIME
		
	SELECT @ProcessDate				= GETDATE()
			,@Product_id			= LTRIM(RTRIM(@Product_id))

	
	/* Temp table to history rate */
	DECLARE @HistoryProduct TABLE 
								(product_id					CHAR(20)
								,rate_id					INT
								,rate						FLOAT
								,eff_date					DATETIME
								,contract_eff_start_date	DATETIME
								,GrossMargin				FLOAT
								,term_months				INT
								,date_created				DATETIME
								,username					NVARCHAR(200))


	DECLARE @TEMPCOPY TABLE (ID					INTEGER)
	
	IF @StartDate IS NULL
		SET @StartDate = CONVERT(CHAR(10), GETDATE(), 112)
	
	IF @EndDate IS NULL
		SET @EndDate = CONVERT(CHAR(10), GETDATE(), 112)

	IF @EndDate < @StartDate
	BEGIN
		PRINT 'Problem with the start date and the end date.'
	END
	
	SELECT @UtilityID		= ID
		,@MarketID			= MarketID
	FROM Libertypower..Utility WITH (NOLOCK)
	WHERE UtilityCode	= @UtilityCode
	
	IF @UtilityID IS NULL
	BEGIN
		PRINT 'The Utility Code is invalid'
		GOTO FIN
	END

	SELECT @ChannelGroupID	= CG.ChannelGroupID
		,@ChannelID			= CG.ChannelID
		,@ChannelTypeID		= C.ChannelTypeID
	FROM libertypower..saleschannelchannelgroup CG WITH (NOLOCK)
	INNER JOIN libertypower..saleschannel SC WITH (NOLOCK) 
	ON sc.channelid = cg.channelid
	INNER JOIN libertypower..ChannelGroup C WITH (NOLOCK) 
	ON C.ChannelGroupID	= CG.ChannelGroupID
	WHERE SC.channelname	= @ChannelName
	
	IF @ChannelGroupID IS NULL
	BEGIN
		PRINT 'The Channel name is invalid'
		GOTO FIN
	END

	IF @ChannelTypeID = 4
	BEGIN
		
		INSERT INTO @HistoryProduct
		SELECT P.product_id, P.rate_id, P.rate, P.eff_date, P.contract_eff_start_date
				,P.GrossMargin, P.term_months, P.date_created, P.username
		FROM lp_common..Product_rate_history P WITH (NOLOCK)
		WHERE P.product_id				= @Product_id
		AND P.rate_id					= @Rate_id
		--AND SUBSTRING(LTRIM(RTRIM(STR(P.rate_id))), 2,2)	= RIGHT(RTRIM(STR(100 + @ChannelGroupID)),2)
		AND P.eff_date					>= CONVERT(CHAR(10),@StartDate,112)
		AND P.eff_date					<= CONVERT(CHAR(10),@EndDate,112)
		ORDER BY P.Product_id, P.rate_id, P.Eff_date

		IF RIGHT(@Product_id,3) = 'ABC'
			SET @Product_id = SUBSTRING(@Product_id, 1, LEN(@Product_id)-4)
		ELSE
			SET @Product_id = @Product_id + '_ABC'
			
		INSERT INTO @HistoryProduct
		SELECT P.product_id, P.rate_id, P.rate, P.eff_date, P.contract_eff_start_date
				,P.GrossMargin, P.term_months, P.date_created, P.username
		FROM lp_common..Product_rate_history P WITH (NOLOCK)
		WHERE P.product_id		= @Product_id
		AND P.rate_id			= @Rate_id
		--AND SUBSTRING(LTRIM(RTRIM(STR(P.rate_id))), 2,2)	= RIGHT(RTRIM(STR(100 + @ChannelGroupID)),2)
		AND P.eff_date		>= CONVERT(CHAR(10),@StartDate,112)
		AND P.eff_date		<= CONVERT(CHAR(10),@EndDate,112)
		ORDER BY P.Product_id, P.rate_id, P.Eff_date				
	END
	ELSE
	BEGIN
		INSERT INTO @HistoryProduct
		SELECT P.product_id, P.rate_id, P.rate, P.eff_date, P.contract_eff_start_date
				,P.GrossMargin, P.term_months, P.date_created, P.username
		FROM lp_common..Product_rate_history P WITH (NOLOCK)
		WHERE P.product_id = @Product_id
		AND P.rate_id = @Rate_id
		--AND SUBSTRING(LTRIM(RTRIM(STR(P.rate_id))), 4,2) <>	'00'
		--AND SUBSTRING(LTRIM(RTRIM(STR(P.rate_id))), 2,2)	= RIGHT(RTRIM(STR(100 + @ChannelGroupID)),2)
		AND P.eff_date		>= CONVERT(CHAR(10),@StartDate,112)
		AND P.eff_date		<= CONVERT(CHAR(10),@EndDate,112)		
		ORDER BY P.Product_id, P.rate_id, P.Eff_date
	END
	
	SELECT @Count = COUNT(1) from @HistoryProduct
	SET @Message	= LTRIM(RTRIM(STR(@Count))) + ' Rows were copied to @HistoryProduct Table'
	PRINT @Message
	
	INSERT INTO [WORKSPACE].[dbo].[PriceTest]
	SELECT 
		ChannelID					= @ChannelID
		,ChannelGroupId				= @ChannelGroupID
		,ChannelTypeID				= CASE	WHEN @ChannelTypeID = 4 AND P.Product_id LIKE '%ABC%' THEN 2
											WHEN @ChannelTypeID = 4 AND P.Product_id NOT LIKE '%ABC%' THEN 1
											ELSE @ChannelTypeID END
		,ProductCrossPriceSetID		= ISNULL(PCP.ProductCrossPriceSetID, -1)
		,ProductTypeId				= PT.ProductTypeId
		,MarketId					= @MarketID
		,UtilityId					= @UtilityID
		,SegmentId					= AT.ID
		,ZoneId						= PTT.ZoneID
		,ServiceClassID				= PTT.ServiceClassID
		,StartDate					= P.Contract_Eff_start_date
		,Term						= P.term_months
		,Price						= P.rate
		,CostRateEffectiveDate		= P.Eff_Date
		,CostRateExpirationDate		= DATEADD(dd, 1, P.Eff_Date)
		,IsTermRange				= CASE WHEN CHARINDEX(P.Product_id, 'SS') > 0 THEN 1 ELSE 0 END
		,DateCreated				= @ProcessDate
		,PriceTier					= ISNULL(DPT.ID,0)
		,ProductBrandId				= CP.ProductBrandId
		,GrossMargin				= P.GrossMargin
	FROM @HistoryProduct P 
	INNER JOIN lp_common..Common_product CP WITH (NOLOCK)
	ON CP.Product_id			= P.Product_id
	LEFT JOIN libertypower..ProductCrossPriceSet PCP WITH (NOLOCK)
	ON PCP.EffectiveDate			= CASE WHEN P.Eff_Date = '20120712' THEN '20120710'
										WHEN P.Eff_Date <= '20120803' THEN DATEADD(DD, -1, P.Eff_Date) 
									ELSE P.Eff_Date END
	INNER JOIN libertypower..ProductType PT WITH (NOLOCK)
	ON PT.Name					= CP.product_category
	LEFT JOIN libertypower..product_transition PTT WITH (NOLOCK)
	ON PTT.Product_id			= P.Product_id
	AND PTT.rate_id				= P.rate_id
	INNER JOIN Libertypower..AccountType AT WITH (NOLOCK)
	ON AT.ProductAccountTypeID		= CP.account_type_id
	LEFT JOIN lp_common..Common_product_rate CPR WITH (NOLOCK)
	ON CPR.Product_id			= P.Product_id
	AND CPR.Rate_Id				= P.Rate_Id
	AND CPR.eff_date			= (	SELECT MAX(X.eff_date)
									FROM lp_common..Common_product_rate X WITH (NOLOCK)
									WHERE X.Product_id		= CPR.Product_id
									AND X.Rate_Id			= CPR.Rate_Id)
	LEFT JOIN [Libertypower].[dbo].[DailyPricingPriceTier] DPT with (nolock)
	ON CHARINDEX(DPT.[Description], CPR.rate_descp) > 0
	ORDER BY P.Product_id, P.Rate_id, P.Eff_Date

	SET @Count		= @@ROWCOUNT
	SET @Message	= LTRIM(RTRIM(STR(@Count))) + ' Rows were copied to PriceTest Table'
	PRINT @Message
	
	INSERT INTO @TEMPCOPY
	SELECT TOP (@Count) ID
	FROM [WORKSPACE].[dbo].[PriceTest] ORDER BY 1 DESC

	UPDATE [WORKSPACE].[dbo].[PriceTest]
	SET ProductCrossPriceSetID = (SELECT TOP 1 ProductCrossPriceSetID 
				FROM libertypower..ProductCrossPriceSet PP WITH (NOLOCK)
				WHERE PP.EffectiveDate <= P.CostRateEffectiveDate 
				ORDER BY ProductCrossPriceSetID DESC) 
	FROM [WORKSPACE].[dbo].[PriceTest] P
	WHERE P.ID	IN (SELECT ID FROM @TEMPCOPY)
	AND P.ProductCrossPriceSetID = -1
	
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
	WHERE A.ID						IN (SELECT ID FROM @TEMPCOPY)
	AND A.ProductCrossPriceSetID	<> -1
	AND NOT EXISTS (SELECT 1 
					FROM [Libertypower].[dbo].[Price] B WITH (NOLOCK)
					WHERE B.ChannelID				= A.ChannelID
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
	SET @Message	= LTRIM(RTRIM(STR(@Count))) + ' Rows were copied to Price Table.'

	PRINT @Message
	
	FIN:	
	SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2012 Liberty Power