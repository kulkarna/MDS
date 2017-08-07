USE [lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[spGenie_GetRates]    Script Date: 05/20/2014 04:30:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modified: Isabelle Tamanini
-- Date:     05/13/2013
-- Description:	Get the rates for the tablet
-- Channels: IRE, AFF, DTD, EG1, IRE2, ENE2, IRE3
-- =============================================
-- Modified: Isabelle Tamanini
-- Date:     06/07/2013
-- Description:	Green products included on the query
-- =============================================
-- Modified: Jaime Forero/ Isabelle Tamanini
-- Date:     08/01/2013
-- Description:	Add Flex product pricing
-- =============================================
-- Modified: Jaime Forero
-- Date:     08/09/2013
-- Description:	Add New channels: SOL, C4S, EG1, AGRD
--				and new market OH
-- =============================================
-- Modified: Jaime Forero
-- Date:     11/21/2013
-- Description:	Add New channels: NYMIL, PME, USD, NYMCT, NYM 
--				and new market CT
-- =============================================
-- Modified: Sara lakshmanan
-- Date:     2/26/2014
-- Description:	Removed the join for the SalesChannelGroup 
-- =============================================
-- Modified: Jaime Forero
-- Date:     3/7/2014
-- Description:	Add New channels: CMG, UTY, TRM
-- =============================================
-- Modified: Jaime Forero
-- Date:     04/09/2014
-- Description:	Added New channels, NFG and BAE, removed NYMIL (by Dane)
-- =============================================
-- Modified: Jaime Forero
-- Date:     04/30/2014
-- Description:	Added New channels TDM
-- =============================================
-- Modified: Vishal Raju
-- Date:     05/19/2014
-- Description:	Added New channels-FIN,EAG and AGRD
-- =============================================
ALTER proc [dbo].[spGenie_GetRates](@ExpirationFlag int=0) as
begin

-- Version 2.0 SG  Added ExpirationDate IS NULL for c.
-- Version 2.1 SG  Added Flex Products
-- Version 2.2 SG  Added IL/AFF
-- Version 2.3 SG  Added new query for Rate Expiration 
-- Version 2.4 IT  Performance optimization
/*

EXEC [spGenie_GetRates] 0 -- 134133

EXEC [spGenie_GetRates_JFORERO] 0 -- 166141


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
WHERE ChannelName IN (
					  'EG1',
					  'IMC',
					  'NYM',
					  --'NYMIL', 
					  'USD', 
					  'NYMCT',
					  'TMM',
					  'CMG',
					  'UTY',
					  'TRM',
					  'BAE',
					  'NFG',
					  'TDM',
					  'FIN',
					  'EAG',
					  'AGRD'
						)
AND SCCG.EffectiveDate <= GETDATE()
AND (SCCG.ExpirationDate > GETDATE() OR SCCG.ExpirationDate IS NULL)


--------------------------------------------------------------------------------------------------
--Added to fix the issue with the Channel Groups being changed
--Feb 26 2014
--If exists ( Select ChannelID from #Channel where ChannelId in (1194,1218,1219 ))
--BEGIN
--Update #Channel Set ChannelGroupID=142 where ChannelId in (1194,1218,1219 )
--END
-----------------------------------------------------------------------------------------



		
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
			 13, --IL
			 16, -- OH
			 3 -- CT
			) 
			 
if(@ExpirationFlag=0)
BEGIN

CREATE TABLE #PriceIDs (PriceID [bigint] NOT NULL)
CREATE TABLE #PriceIDsRateIds (PriceID [bigint] NOT NULL, NewRateId [bigint] not null)

DECLARE	@ProductCrossPriceSetID	int,
		@PriceID				bigint,
		@RateID					int,
		@PCPSetExpirationDate   datetime
						
    
	SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
    FROM	LibertyPower..ProductCrossPriceSet (NOLOCK)
	WHERE	EffectiveDate < '9999-12-31' 
	  AND   ProductCrossPriceSetID <> 873
	
	SELECT	@PCPSetExpirationDate = ExpirationDate
    FROM	LibertyPower..ProductCrossPriceSet (NOLOCK)
	WHERE	ProductCrossPriceSetID = @ProductCrossPriceSetID 
	
	-- get current prices  ----------------------------------------------------------------------------------------------------------------------
	SELECT	
			PriceID = pr.ID,
			PriceTierID = pr.PriceTier,
			RateID = CAST(0 AS INT), -- will update rate id later in proc
			-- build rate description
			RateSelection = CAST((c.ChannelName + ' ' + 
							CAST(pr.Term AS varchar(3)) + ' Mth ' + 
							ISNULL(z.zone, 'Default') + ' ' + 
							ISNULL(s.service_rate_class, 'Default') + ': ' + 
							CASE WHEN pt.ID = 0 THEN '' ELSE pt.[Description] END + ' ' + 
							CAST(DATEPART(mm, pr.StartDate) AS varchar(2))  + '/' + 
							CAST(DATEPART(yyyy, pr.StartDate) AS varchar(4))) AS varchar(250)),
			PartnerName = c.ChannelName,
			AccountTypeID = at.ProductAccountTypeID,
			AccountType = t.Account_Type,
			MarketCode = m.MarketCode,
			UtilityCode = u.UtilityCode,
			ZoneCode = CAST(ISNULL(z.zone, 'Default') AS varchar(50)),
			ServiceClassCode = CAST(ISNULL(s.service_rate_class, 'Default') + ': '  + pt.[Description]	AS varchar(50)),
			FlowStartMonth = pr.StartDate,
			ContractTerm = pr.Term,
			TransferRate = CAST(pr.Price AS decimal(12,5)),
			RateExpirationDate = CASE WHEN (pr.ProductBrandID = 4 AND pr.ProductCrossPriceSetID = -1) THEN @PCPSetExpirationDate
								 ELSE pr.CostRateExpirationDate
								 END,
			--RateExpirationDate = CAST('2013-09-24 23:59:59' AS DATETIME),
			pr.ProductBrandID,
			at.ProductAccountTypeID,
			pr.ChannelTypeID
	INTO	#tmp_prev
	FROM	#Channel	(NOLOCK) c
			INNER JOIN  Libertypower..Price (NOLOCK) pr							ON
			--Commented on Feb 26 2014 -- pr.ChannelGroupID = c.ChannelGroupID AND 
			 pr.ChannelID = c.ChannelID
			INNER JOIN  [Libertypower].[dbo].ProductBrand  (NOLOCK)  PB         ON pr.ProductBRandID = pb.ProductBrandID
																				AND pb.IsMultiTerm = 0
																				--AND pb.ProductBrandID not in (18,19)
			INNER JOIN	[Libertypower].[dbo].DailyPricingPriceTier (NOLOCK) pt  ON pr.PriceTier = pt.ID 
			INNER JOIN	[Libertypower].[dbo].[Utility] (NOLOCK) u				ON pr.UtilityID = u.ID 
			INNER JOIN	#Market M												ON m.MarketID = u.MarketID
			INNER JOIN	[Libertypower].[dbo].[AccountType] (NOLOCK) at			ON pr.SegmentID = at.ID
			INNER JOIN	[lp_common].[dbo].[product_account_type] (NOLOCK) t		ON at.ProductAccountTypeID = t.account_type_id
			LEFT JOIN	[lp_common].[dbo].[zone] (NOLOCK) z						ON pr.ZoneID = z.zone_id
			LEFT JOIN	[lp_common].[dbo].[service_rate_class] (NOLOCK) s		ON pr.ServiceClassID = s.service_rate_class_id
			
	WHERE	pr.ProductCrossPriceSetID = @ProductCrossPriceSetID	
			 OR (pr.ProductBrandID = 4 AND pr.ProductCrossPriceSetID = -1)
	;
 
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
			TransferRate,
			RateExpirationDate
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
    FROM	lp_common..RateIDKey WITH (NOLOCK)
		
	INSERT INTO #PriceIDsRateIds
	SELECT DISTINCT PriceID, @RateID + ROW_NUMBER() OVER (ORDER BY PriceId) As NewRateId
	FROM	#PriceIDs	
    
    UPDATE #tmp
    SET RateId = pr.NewRateId
    FROM #tmp tmp
    join #PriceIDsRateIds pr ON tmp.PriceID = pr.PriceID
    
    SELECT @RateID = MAX(RateId)
    FROM #tmp
    
	-- store price mapping data for later use  -------------------------------------------------------------------------------------------------------

	UPDATE	lp_common..RateIDKey
	SET		RateID = (@RateID + 1)	
		
	INSERT INTO [Libertypower].[dbo].[GeniePriceMapping]
	SELECT	PriceID, ProductSelection, RateID, RateSelection, PriceTierID
	FROM	#tmp
	
	-- return prices  --------------------------------------------------------------------------------------------------------------------------------	
	SELECT	RateID,
			RateSelection,			
			ProductSelection,
			PartnerName,
			AccountTypeID,
			AccountType,
			MarketCode,
			UtilityCode,
			Brand,
			ZoneCode,
			ServiceClassCode,
			FlowStartMonth,
			ContractTerm,
			TransferRate,
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

SET NOCOUNT OFF;
end
