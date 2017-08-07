
---- This is part of a 3 step process to transfer rates from DailyPricing to our legacy tables.
---- Step 1 sets up some temporary tables that will be used in later steps.  One of these tables has the SuperSaver calculations in it.
---- Step 2 takes the DailyPricing data and transforms it into legacy format using a mapping table.
---- Step 3 updates the production legacy tables.  There is an option to update the main table or just the history table.  
----        For the history table, there is an option to replace the history that is already there, or only fill in missing records.
----
---- All steps are safely re-runnable, but avoid skipping steps.


-- exec [USP_CreateProductRateHistory] '2011-11-01'
CREATE PROCEDURE usp_CreateProductRate_Step2 (@EffDate datetime)
AS

DECLARE @MarketID		int,
		@UtilityID		int,
		@CurrentMonth	datetime
		
SELECT @CurrentMonth = dateadd(m,-1,min(StartDate))
FROM temp_pcp

print 'processing for date starting ' + convert(varchar(12),@CurrentMonth)

IF EXISTS (SELECT * FROM sys.tables WHERE [name] = 'temp_product_rate')
	DROP TABLE LibertyPower..temp_product_rate
	
SELECT TOP 0 *
INTO temp_product_rate
FROM lp_common..product_rate_history


---- Loop starts here.
DECLARE CurrUtilityLoop CURSOR FOR
SELECT	DISTINCT m.ID, u.ID
FROM Utility u
JOIN Market m ON u.MarketID = m.ID
ORDER BY m.ID

OPEN CurrUtilityLoop
FETCH NEXT FROM CurrUtilityLoop INTO @MarketID, @UtilityID

WHILE (@@FETCH_STATUS <> -1)
BEGIN

	print 'processing market id ' + convert(varchar(6), @MarketId)
	print 'processing utility id ' + convert(varchar(6), @UtilityId)

	---- For processing speed, make a temp table of only the relevant records needed.
	SELECT *
	INTO #product_transition
	FROM LibertyPower.dbo.product_transition with (nolock)
	WHERE utilityid = @UtilityID

	---- For processing speed, make a temp table of only the relevant records needed.
	SELECT pr.*
	INTO #common_product_rate
	FROM lp_common.dbo.common_product_rate pr (nolock)
	JOIN lp_common.dbo.common_product p (nolock) on pr.product_id = p.product_id
	JOIN libertypower.dbo.utility u (nolock) on p.utility_id = u.utilitycode
	WHERE u.id = @UtilityID


	---- Create a not-so-temp table with all the records we intend to inject into the product history.
	INSERT INTO temp_product_rate
			   ([product_id]
			   ,[rate_id]
			   ,[rate]
			   ,[eff_date]
			   ,[date_created]
			   ,[username]
			   ,[contract_eff_start_date]
			   ,[GrossMargin]
			   ,[term_months]
			   ,[inactive_ind])
	SELECT 
		product_id	= r.product_id, 
		rate_id		= r.rate_id, 
		rate		= round(pcp.price,5), 
		eff_date	= @EffDate, --DATEADD(dd, 1, pcp.costrateeffectivedate), 
		date_created = getdate(), 
		username	= 'SYSTEM', 
		contract_eff_start_date = DateAdd(m, pt.RelativeStartMonth, @CurrentMonth), 
		GrossMargin = MarkupRate, 
		term_months = pt.term, 
		inactive_ind = 0
	FROM #common_product_rate r with (nolock)
	JOIN #product_transition pt with (nolock) ON pt.product_id = r.product_id AND pt.rate_id = r.rate_id
	JOIN temp_pcp pcp
		ON	pcp.MarketID			= pt.MarketID 
		AND	pcp.UtilityID			= pt.UtilityID
		AND	pcp.ProductTypeID		= pt.ProductTypeID
		AND	pcp.SegmentID			= pt.AccountTypeID	
		AND	pcp.ZoneID				= pt.ZoneID
		AND	pcp.ServiceClassID		= pt.ServiceClassID	
		AND	pcp.ChannelTypeID		= pt.ChannelTypeID
		AND pcp.term				= pt.term
		AND pcp.ChannelGroupID +100	= left(pt.rate_id,3)	
		AND pcp.StartDate			= DATEADD(m, pt.RelativeStartMonth, @CurrentMonth)
	WHERE r.product_id NOT LIKE '%SS%'
	AND pt.product_id NOT LIKE '%SS%'

	-- SuperSaver
	INSERT INTO temp_product_rate
			   ([product_id]
			   ,[rate_id]
			   ,[rate]
			   ,[eff_date]
			   ,[date_created]
			   ,[username]
			   ,[contract_eff_start_date]
			   ,[GrossMargin]
			   ,[term_months]
			   ,[inactive_ind])
	SELECT 
		product_id	= r.product_id, 
		rate_id		= r.rate_id, 
		rate		= round(pcp.price,5), 
		eff_date	= @EffDate, --DATEADD(dd, 1, pcp.costrateeffectivedate), 
		date_created = getdate(), 
		username	= 'SYSTEM', 
		contract_eff_start_date = DateAdd(m, pt.RelativeStartMonth, @CurrentMonth), 
		GrossMargin = MarkupRate, 
		term_months = pcp.term, 
		inactive_ind = 0
	FROM #common_product_rate r with (nolock)
	JOIN #product_transition pt with (nolock) ON pt.product_id = r.product_id AND pt.rate_id = r.rate_id
	JOIN temp_pcp_ss pcp
		ON	pcp.MarketID			= pt.MarketID 
		AND	pcp.UtilityID			= pt.UtilityID
		AND	pcp.ProductTypeID		= pt.ProductTypeID
		AND	pcp.SegmentID			= pt.AccountTypeID	
		AND	pcp.ZoneID				= pt.ZoneID
		AND	pcp.ServiceClassID		= pt.ServiceClassID	
		AND	pcp.ChannelTypeID		= pt.ChannelTypeID
		AND pcp.term / 12			= pt.term / 12 -- verifies the supersaver is of the right level, 3-12, 13-24, 25-36
		AND pcp.ChannelGroupID +100	= left(pt.rate_id,3)	
		AND pcp.StartDate			= DATEADD(m, pt.RelativeStartMonth, @CurrentMonth)
	WHERE r.product_id LIKE '%SS%'
	AND pt.product_id LIKE '%SS%'	


	FETCH NEXT FROM CurrUtilityLoop INTO @MarketID, @UtilityId
	
	drop table #product_transition
	drop table #common_product_rate

END
CLOSE CurrUtilityLoop
DEALLOCATE CurrUtilityLoop


print 'copying into the product_rate_history table -  may the lord bless us all ' 


