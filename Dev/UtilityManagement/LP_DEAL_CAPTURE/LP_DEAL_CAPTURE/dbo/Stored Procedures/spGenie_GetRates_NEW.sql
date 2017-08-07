
-- 
/*

exec [spGenie_GetRates]
exec [spGenie_GetRates_NEW]

*/

CREATE proc [dbo].[spGenie_GetRates_NEW](@ExpirationFlag int=0) as
begin

-- Version 2.0 SG  Added ExpirationDate IS NULL for c.
-- Version 2.1 SG  Added Flex Products
-- Version 2.2 SG  Added IL/AFF
-- Version 2.3 SG  Added new query for Rate Expiration 
-- Version 2.4 IT  Performance optimization
/*
EXEC [spGenie_GetRates] 0 -- 57639
*/
set nocount on


CREATE TABLE #Channel (
	ChannelId [int] not null,
	ChannelName [varchar](10) not null,
	ChannelGroupId [int] not null
)

INSERT INTO #Channel
SELECT SC.ChannelID, SC.ChannelName, SCCG.ChannelGroupID
FROM [Libertypower]..[SalesChannel]             SC   (NOLOCK)
JOIN [Libertypower]..[SalesChannelChannelGroup] SCCG (NOLOCK) ON SCCG.ChannelID = SC.ChannelID
WHERE ChannelName IN ('IRE3',
					  'IRE2',
					  'IRE',
					  'DTD',
					  'AFF',
					  'EG1',
					  'ENE2')
AND SCCG.EffectiveDate <= GETDATE()
AND (SCCG.ExpirationDate > GETDATE() OR SCCG.ExpirationDate IS NULL)

		
CREATE TABLE #Market (
	MarketID [int] NOT NULL,
	MarketCode [varchar](50) NOT NULL
)
INSERT INTO #Market
SELECT ID, MarketCode
FROM LibertyPower..Market
WHERE ID IN (7,  --NY
			 8,  --PA
			 9,  --NJ
			 10, --MD
			 13) --IL
			 
			 
if(@ExpirationFlag=0)
BEGIN

CREATE TABLE #PriceIDs (PriceID [bigint] NOT NULL)
CREATE TABLE #PriceIDsRateIds (PriceID [bigint] NOT NULL, NewRateId [bigint] not null)

DECLARE	@ProductCrossPriceSetID	int,
		@PriceID				bigint,
		@RateID					int
						
    
	SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
    FROM	LibertyPower..ProductCrossPriceSet
	WHERE	EffectiveDate < '9999-12-31'  
	
	-- get current prices  ----------------------------------------------------------------------------------------------------------------------
	SELECT	TOP(10)
			pr.ID															AS PriceID,
			pr.PriceTier													AS PriceTierID,
			CAST(0 AS INT)													AS RateID, -- will update rate id later in proc
			
			-- build rate description
			CAST((c.ChannelName + ' ' + 
			CAST(pr.Term AS varchar(3)) + ' Mth ' + 
			ISNULL(z.zone, 'Default') + ' ' + 
			ISNULL(s.service_rate_class, 'Default') + ': ' + 
			CASE WHEN pt.ID = 0 THEN '' ELSE pt.[Description] END + ' ' + 
			CAST(DATEPART(mm, pr.StartDate) AS varchar(2))  + '/' + 
			CAST(DATEPART(yyyy, pr.StartDate) AS varchar(4))) AS varchar(250))		AS RateSelection,
			c.ChannelName													AS PartnerName,
			at.ProductAccountTypeID											AS AccountTypeID,
			t.Account_Type													AS AccountType,
			m.MarketCode													AS MarketCode,
			u.UtilityCode													AS UtilityCode,
			CAST(ISNULL(z.zone, 'Default') AS varchar(50))					AS ZoneCode,
			CAST(ISNULL(s.service_rate_class, 'Default') + ': '  + pt.[Description]	AS varchar(50))	AS ServiceClassCode,
			pr.StartDate													AS FlowStartMonth,
			pr.Term															AS ContractTerm,
			CAST(pr.Price AS decimal(12,5))									AS TransferRate,
			pr.CostRateExpirationDate										AS RateExpirationDate,
			pr.ProductBrandID,
			at.ProductAccountTypeID,
			pr.ChannelTypeID
	INTO	#tmp_prev
	FROM	#Channel	(NOLOCK) c
			INNER JOIN  Libertypower..Price (NOLOCK) pr							ON pr.ChannelGroupID = c.ChannelGroupID 
																				AND pr.ChannelID = c.ChannelID
			INNER JOIN  [Libertypower].[dbo].ProductBrand  (NOLOCK)  PB         ON pr.ProductBRandID = pb.ProductBrandID
																				AND pb.IsMultiTerm = 0
			INNER JOIN	[Libertypower].[dbo].[DailyPricingPriceTier] pt			ON pr.PriceTier = pt.ID 
			INNER JOIN	[Libertypower].[dbo].[Utility] (NOLOCK) u				ON pr.UtilityID = u.ID 
			INNER JOIN	#Market M												ON m.MarketID = u.MarketID
			INNER JOIN	[Libertypower].[dbo].[AccountType] (NOLOCK) at			ON pr.SegmentID = at.ID
			INNER JOIN	[lp_common].[dbo].[product_account_type] (NOLOCK) t		ON at.ProductAccountTypeID = t.account_type_id
			LEFT JOIN	[lp_common].[dbo].[zone] (NOLOCK) z						ON pr.ZoneID = z.zone_id
			LEFT JOIN	[lp_common].[dbo].[service_rate_class] s				ON pr.ServiceClassID = s.service_rate_class_id
			
	WHERE	pr.ProductCrossPriceSetID = @ProductCrossPriceSetID	
			
	-- create index to improve performance
	CREATE CLUSTERED INDEX idx_PriceID ON #tmp_prev(PriceID)
			
	SELECT  PriceID,
			PriceTierID,
			RateId,
			RateSelection,
			CAST(ISNULL(p.product_id, '')AS CHAR(20))						AS ProductSelection,
			PartnerName,
			AccountTypeID,
			AccountType,
			MarketCode,
			UtilityCode,
			CAST(ISNULL(p.product_descp, '')AS VARCHAR(50))					AS Brand,
			ZoneCode,
			ServiceClassCode,
			FlowStartMonth,
			ContractTerm,
			CAST(TransferRate AS decimal(12,5)) AS TransferRate
	INTO #tmp
	FROM #tmp_prev                          tp
	JOIN [lp_common].[dbo].[common_product] p  (NOLOCK) ON p.ProductBrandID = tp.ProductBrandID
														AND p.utility_id = tp.UtilityCode
														AND p.account_type_id = tp.ProductAccountTypeID
														AND p.is_flexible = CASE WHEN tp.ChannelTypeID = 2 THEN 1 ELSE 0 END
														AND p.inactive_ind = 0		
														AND p.product_descp <> 'POWER MOVE'	
	
	CREATE CLUSTERED INDEX idx_PriceID ON #tmp(PriceID)
	
	-- update #tmp table with new rate ids  ----------------------------------------------------------------------------------------------------------	
	INSERT INTO #PriceIDs
	SELECT DISTINCT PriceID
	FROM	#tmp
	
	SELECT	@RateID = (RateID-1)
    FROM	lp_common..RateIDKey
		
	INSERT INTO #PriceIDsRateIds
	SELECT DISTINCT PriceID, @RateID + ROW_NUMBER() OVER (ORDER BY PriceId) As NewRateId
	FROM	#PriceIDs	
    
    UPDATE #tmp
    SET RateId = pr.NewRateId
    FROM #tmp tmp
    join #PriceIDsRateIds pr ON tmp.PriceID = pr.PriceID
    
    SELECT @RateID = MAX(RateId)
    FROM #tmp
    
    UPDATE	lp_common..RateIDKey
	SET		RateID = (@RateID + 1)	
		
	-- store price mapping data for later use  -------------------------------------------------------------------------------------------------------
	INSERT INTO [Libertypower].[dbo].[GeniePriceMapping]
	SELECT	PriceID, ProductSelection, RateID, RateSelection, PriceTierID
	FROM	#tmp
	
	-- return prices  --------------------------------------------------------------------------------------------------------------------------------	
	SELECT	CAST(RateID AS INT) AS RateID,
			CAST(RateSelection AS VARCHAR(250)) AS RateSelection ,			
			ProductSelection,
			PartnerName,
			AccountTypeID,
			AccountType,
			MarketCode,
			UtilityCode,
			Brand,
			CAST(ZoneCode AS varchar(50)) AS ZoneCode ,
			ServiceClassCode,
			CAST(FlowStartMonth AS DATETIME) AS FlowStartMonth ,
			ContractTerm,
			CAST(TransferRate AS  decimal(12,5)) AS TransferRate ,
			RateExpirationDate
	FROM #tmp
	order by RateId

	DROP TABLE #tmp	
END

else

BEGIN
	select ExpirationDate as RateExpirationDate
	from libertypower.dbo.ProductCrossPriceSet (nolock)
	where ProductCrossPriceSetID = (select max(ProductCrossPriceSetID) from libertypower.dbo.ProductCrossPriceSet (nolock))

END

end
