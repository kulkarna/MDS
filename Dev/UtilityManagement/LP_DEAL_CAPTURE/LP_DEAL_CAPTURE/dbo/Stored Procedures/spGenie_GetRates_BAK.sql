





CREATE proc [dbo].[spGenie_GetRates_BAK](@ExpirationFlag int=0) as
begin

-- Version 2.0 SG  Added ExpirationDate IS NULL for c.
-- Version 2.1 SG  Added Flex Products
-- Version 2.2 SG  Added IL/AFF
-- Version 2.3 SG Added new query for Rate Expiration 
/*
EXEC [spGenie_GetRates] -- 57639
*/
set nocount on
if 1 = 0 begin 
	SET FMTONLY OFF 
END

-- Located in LP_Deal_Capture
declare @Channel table(Channelname varchar(10))
--insert into @Channel Values ('ABC')
--insert into @Channel Values ('GOENERGY')
insert into @Channel Values ('IRE3')
insert into @Channel Values ('IRE2')
insert into @Channel Values ('IRE')
insert into @Channel Values ('DTD')
insert into @Channel Values ('AFF')
insert into @Channel Values ('EG1')
insert into @Channel Values ('ENE2') 
--insert into @Channel Values ('GEG')

declare @Market table(MarketID int)
insert into @Market Values(8) --PA
insert into @Market Values(7)  --NY
insert into @Market Values(9)  --NJ
insert into @Market Values(13)  --IL
insert into @Market Values(10)  --MD


--select * from [Libertypower].[dbo].[Market]
if(@ExpirationFlag=0)
BEGIN

DECLARE @PriceIDs TABLE (PriceID bigint)

DECLARE	@ProductCrossPriceSetID	int,
		@PriceID				bigint,
		@RateID					int
						
    
	SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
    FROM	LibertyPower..ProductCrossPriceSet
	WHERE	EffectiveDate < '9999-12-31'   	
	
	-- get current prices  ----------------------------------------------------------------------------------------------------------------------
	SELECT	pr.ID															AS PriceID,
			pr.PriceTier													AS PriceTierID,
			--pr.ProductBrandID,
			--pr.ChannelTypeID,
			CAST(0 AS INT)													AS RateID, -- will update rate id later in proc
			
			-- build rate description
			CAST((d.ChannelName + ' ' + 
			CAST(pr.Term AS varchar(3)) + ' Mth ' + 
			ISNULL(z.zone, 'Default') + ' ' + 
			ISNULL(s.service_rate_class, 'Default') + ': ' + 
			CASE WHEN pt.ID = 0 THEN '' ELSE pt.[Description] END + ' ' + 
			CAST(DATEPART(mm, pr.StartDate) AS varchar(2))  + '/' + 
			CAST(DATEPART(yyyy, pr.StartDate) AS varchar(4))) AS varchar(250))		AS RateSelection,
						
			CAST(ISNULL(p.product_id, '')AS CHAR(20))						AS ProductSelection,
			d.ChannelName													AS PartnerName,
			at.ProductAccountTypeID											AS AccountTypeID,
			t.Account_Type													AS AccountType,
			m.MarketCode													AS MarketCode,
			u.UtilityCode													AS UtilityCode,
			CAST(ISNULL(p.product_descp, '')AS VARCHAR(50))					AS Brand,
			CAST(ISNULL(z.zone, 'Default') AS varchar(50))					AS ZoneCode,
			-- CAST(ISNULL(s.service_rate_class, 'Default') AS varchar(50))	AS ServiceClassCode,
			CAST(ISNULL(s.service_rate_class, 'Default') + ': '  + pt.[Description]	AS varchar(50))	AS ServiceClassCode,
			pr.StartDate													AS FlowStartMonth,
			pr.Term															AS ContractTerm,
			CAST(pr.Price AS decimal(12,5))									AS TransferRate,
			pr.CostRateExpirationDate										AS RateExpirationDate
	INTO	#tmp
	FROM	Libertypower..Price (NOLOCK) pr
			INNER JOIN  [Libertypower].[dbo].ProductBrand  (NOLOCK)  PB on pr.ProductBRandID = pb.ProductBrandID AND pb.IsMultiTerm = 0
			INNER JOIN	[Libertypower].[dbo].[DailyPricingPriceTier] pt			ON pr.PriceTier = pt.ID 
			INNER JOIN	[Libertypower].[dbo].[Utility] (NOLOCK) u				ON pr.UtilityID = u.ID 
			INNER JOIN	[Libertypower].[dbo].[Market] (NOLOCK) m				ON m.[ID] = u.[MarketID]
			INNER JOIN	@Market mm												ON m.ID = mm.MarketID
			INNER JOIN	[Libertypower].[dbo].[AccountType] (NOLOCK) at			ON pr.SegmentID = at.ID
			INNER JOIN	[lp_common].[dbo].[product_account_type] (NOLOCK) t		ON at.ProductAccountTypeID = t.account_type_id
			LEFT JOIN	[lp_common].[dbo].[zone] (NOLOCK) z						ON pr.ZoneID = z.zone_id
			LEFT JOIN	[lp_common].[dbo].[service_rate_class] s				ON pr.ServiceClassID = s.service_rate_class_id
			INNER JOIN	[Libertypower]..[SalesChannelChannelGroup] (NOLOCK) c	ON pr.ChannelGroupID = c.ChannelGroupID 
						AND c.EffectiveDate <= GETDATE() 
						AND (c.ExpirationDate > GETDATE() OR c.ExpirationDate IS NULL)
			INNER JOIN
			(
				SELECT	ChannelID, x.ChannelName 
				FROM	[Libertypower].[dbo].[SalesChannel] x (NOLOCK) 
						INNER JOIN @Channel y ON x.ChannelName = y.ChannelName
			)d																	ON c.ChannelID = d.ChannelID AND pr.ChannelID = d.ChannelID
			-- determine product id
			INNER JOIN	[lp_common].[dbo].[common_product] (NOLOCK) p			ON p.ProductBrandID = pr.ProductBrandID
																				AND p.utility_id = u.UtilityCode
																				AND p.account_type_id = at.ProductAccountTypeID
																				AND p.is_flexible = CASE WHEN pr.ChannelTypeID = 2 THEN 1 ELSE 0 END
																				AND p.inactive_ind = 0		
	WHERE	pr.ProductCrossPriceSetID = @ProductCrossPriceSetID		
	ORDER BY d.ChannelName, at.ProductAccountTypeID, m.MarketCode, u.UtilityCode, z.zone, s.service_rate_class, pr.StartDate, pr.Term
			
	-- create index to improve performance
	CREATE CLUSTERED INDEX idx_PriceID ON #tmp(PriceID)
	
	-- update #tmp table with new rate ids  ----------------------------------------------------------------------------------------------------------	
	CREATE TABLE #PriceIDs (PriceID [bigint] NOT NULL)
	CREATE TABLE #PriceIDsRateIds (PriceID [bigint] NOT NULL, NewRateId [bigint] not null)
	
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
	WHERE Brand <> 'POWER MOVE'
	ORDER BY PriceID
	
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
	FROM #tmp WHERE Brand <> 'POWER MOVE'

	DROP TABLE #tmp	





/*
	SELECT  
	e.rate_id as RateID,
	e.rate_descp as RateSelection,
	a.product_id as ProductSelection,
	d.ChannelName as PartnerName,
	a.account_type_id as AccountTypeID,
	t.Account_Type as AccountType,
	m.MarketCode as MarketCode,
	u.UtilityCode as UtilityCode,
	a.product_descp as Brand,
	isnull(z.zone, 'Default') as ZoneCode,
	isnull(s.service_rate_class, 'Default') as ServiceClassCode,
	e.contract_eff_start_date as FlowStartMonth,
	e.term_months as ContractTerm,
	e.rate as TransferRate,
	e.due_date as RateExpirationDate
	--Convert(datetime,'2/10/2012 2:50 PM',101) as RateExpirationDate
	into #tmp
	FROM 
	[lp_common].[dbo].[common_product] (nolock) a 
	inner join
	[Libertypower].[dbo].[Utility] (nolock) u on a.utility_id=u.UtilityCode 
	inner join
	[Libertypower].[dbo].[Market] (nolock) m on m.[ID]=u.[MarketID]
	inner join
	@Market mm
	on m.ID=mm.MarketID
	inner join
	[lp_common].[dbo].[common_product_rate] (nolock) e on a.product_id=e.product_id 
	inner join
	[lp_common].[dbo].[product_account_type] (nolock) t on a.account_type_id=t.account_type_id
	left join
	[lp_common].[dbo].[zone] (nolock) z on e.zone_id=z.zone_id
	left join
	[lp_common].[dbo].[service_rate_class] s on e.service_rate_class_id=s.service_rate_class_id
	inner join
	[Libertypower]..[SalesChannelChannelGroup] (nolock) c on right(left(e.rate_id,3),2)= c.ChannelGroupID 
    and c.EffectiveDate<=getdate()
and (c.ExpirationDate >getdate() or c.ExpirationDate is null)
	inner join
	(
		Select ChannelID, x.ChannelName 
		from Libertypower.dbo.SalesChannel x (nolock) inner join 
		@Channel y on x.ChannelName=y.ChannelName
	)d 
	on c.ChannelID=d.ChannelID 
	and e.inactive_ind=0
	and a.iscustom=0
	inner join [LibertyPower].[dbo].[AccountType] at on left(t.account_type,3) = left(at.AccountType,3)
	inner join 
	[LibertyPower].[dbo].[SalesChannelAccountType] sat 
		on c.ChannelID = sat.ChannelID
		and m.id=sat.marketid
		and at.ID=sat.accounttypeid

	insert into #tmp
	SELECT  
	e.rate_id as RateID,
	e.rate_descp as RateSelection,
	a.product_id as ProductSelection,
	d.PartnerName as PartnerName,
	a.account_type_id as AccountTypeID,
	t.Account_Type as AccountType,
	m.MarketCode as MarketCode,
	u.UtilityCode as UtilityCode,
	a.product_descp as Brand,
	isnull(z.zone, 'Default') as ZoneCode,
	isnull(s.service_rate_class, 'Default') as ServiceClassCode,
	e.contract_eff_start_date as FlowStartMonth,
	e.term_months as ContractTerm,
	e.rate as TransferRate,
	e.due_date as RateExpirationDate
	--Convert(datetime,'2/10/2012 2:50 PM',101) as RateExpirationDate
	FROM 
	[lp_common].[dbo].[common_product] (nolock) a 
	inner join
	[Libertypower].[dbo].[Utility] (nolock) u on a.utility_id=u.UtilityCode and right(rtrim(a.product_id),3)='ABC'
	and a.product_category='fixed' and a.isdefault=0 and a.[product_sub_category]='portfolio' and a.inactive_ind=0
	inner join
	[Libertypower].[dbo].[Market] (nolock) m on m.[ID]=u.[MarketID]
	inner join
	[lp_common].[dbo].[common_product_rate] (nolock) e on a.product_id=e.product_id 
	inner join
	[lp_common].[dbo].[product_account_type] (nolock) t on a.account_type_id=t.account_type_id
	left join
	[lp_common].[dbo].[zone] (nolock) z on e.zone_id=z.zone_id
	left join
	[lp_common].[dbo].[service_rate_class] s on e.service_rate_class_id=s.service_rate_class_id
	inner join [LibertyPower].[dbo].[AccountType] at on left(t.account_type,3) = left(at.AccountType,3)
	inner join
	(Select distinct PartnerName, MarketCode from #tmp) d
	on m.MarketCode=d.MarketCode


	Select * from #tmp where Brand <>'POWER MOVE'
*/
END



else

BEGIN
	select ExpirationDate as RateExpirationDate
	from libertypower.dbo.ProductCrossPriceSet (nolock)
	where ProductCrossPriceSetID = (select max(ProductCrossPriceSetID) from libertypower.dbo.ProductCrossPriceSet (nolock))

END

end
