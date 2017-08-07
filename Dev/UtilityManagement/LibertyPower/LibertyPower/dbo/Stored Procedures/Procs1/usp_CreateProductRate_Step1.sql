
---- This is part of a 3 step process to transfer rates from DailyPricing to our legacy tables.
---- Step 1 sets up some temporary tables that will be used in later steps.  One of these tables has the SuperSaver calculations in it.
---- Step 2 takes the DailyPricing data and transforms it into legacy format using a mapping table.
---- Step 3 updates the production legacy tables.  There is an option to update the main table or just the history table.  
----        For the history table, there is an option to replace the history that is already there, or only fill in missing records.
----
---- All steps are safely re-runnable, but avoid skipping steps.

-- 2012-03-20 Eric Hernandez
-- Fixed the way we look up values in DailyPricing.  Have to add 1 day to the effective date, DATEADD(dd,1,CostRateEffectiveDate).

-- usp_CreateProductRate_Step1 '2011-12-02'
CREATE PROCEDURE [dbo].[usp_CreateProductRate_Step1]  (@EffDate datetime)
AS
BEGIN
	IF EXISTS (SELECT * FROM sys.tables WHERE [name] = 'temp_pcp')
		DROP TABLE LibertyPower..temp_pcp
	IF EXISTS (SELECT * FROM sys.tables WHERE [name] = 'temp_pcp_ss')
		DROP TABLE LibertyPower..temp_pcp_ss
	IF EXISTS (SELECT * FROM sys.tables WHERE [name] = 'temp_pcp_all')
		DROP TABLE LibertyPower..temp_pcp_all

	-- The date we are looking for might be the current dailing pricing.
	-- Otherwise, look in the history table.
	IF EXISTS (SELECT * FROM ProductCrossPrice (NOLOCK) WHERE @EffDate BETWEEN DATEADD(dd,1,CostRateEffectiveDate) AND CostRateExpirationDate)
	BEGIN
		SELECT *
		INTO temp_pcp_all
		FROM ProductCrossPrice (NOLOCK)
		WHERE @EffDate BETWEEN DATEADD(dd,1,CostRateEffectiveDate) AND CostRateExpirationDate
	END
	ELSE
	BEGIN
		SELECT *
		INTO temp_pcp_all
		FROM ProductCrossPrice_History (NOLOCK)
		WHERE @EffDate BETWEEN DATEADD(dd,1,CostRateEffectiveDate) AND CostRateExpirationDate
	END

--select * from temp_pcp_all
--select * from ChannelType
	-- Add tax for NJ.
	UPDATE temp_pcp_all
	SET Price = Price * 1.07
	WHERE MarketID = 9
	AND ChannelTypeID = 1

	-- This will reduce the table to only the records deemed Active by Marketting.
	SELECT pcp.*
	INTO temp_pcp
	FROM ProductConfiguration pc (NOLOCK)
	JOIN OfferActivation oa (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
	JOIN temp_pcp_all pcp WITH (NOLOCK)
		ON	pcp.MarketID		= pc.MarketID 
		AND	pcp.UtilityID		= pc.UtilityID
		AND	pcp.ProductTypeID	= pc.ProductTypeID
		AND	pcp.SegmentID		= pc.SegmentID	
		AND	pcp.ZoneID			= pc.ZoneID
		AND	pcp.ServiceClassID	= pc.ServiceClassID	
		AND	pcp.ChannelTypeID	= pc.ChannelTypeID
		AND pcp.term			= oa.term					
	WHERE 1=1
	AND oa.IsActive = 1	
	AND pc.IsTermRange = 0 -- not super saver


	-- SuperSaver
	IF EXISTS (SELECT * FROM sys.tables WHERE [name] = 'temp_pcp_ss')
		DROP TABLE LibertyPower..temp_pcp_ss

	SELECT ChannelGroupID
	       , MarketID
	       , UtilityID
	       , SegmentID
	       , ZoneID
	       , ServiceClassID
	       , StartDate
		   , termlevel = CASE WHEN term between 3  and 12 THEN 'lowterm'
							  WHEN term between 13 and 24 THEN 'midterm'
							  WHEN term between 25 and 36 THEN 'highterm' END
		  , MinPrice = min(price)
	INTO #pcp_ss
	FROM temp_pcp_all a
	WHERE term >= 3
	GROUP BY ChannelGroupID, MarketID, UtilityID, SegmentID, ZoneID, ServiceClassID, StartDate
	,  CASE WHEN term between 3  and 12 THEN 'lowterm'
			WHEN term between 13 and 24 THEN 'midterm'
			WHEN term between 25 and 36 THEN 'highterm' END


	SELECT a.producttypeid
	     , a.price
	     , a.marketid
	     , a.utilityid
	     , a.segmentid
	     , a.zoneid
	     , a.serviceclassid
	     , a.startdate
	     , a.term
	     , a.ChannelTypeID
	     , a.ChannelGroupID
	     , a.costrateeffectivedate
	     , a.markuprate
	INTO temp_pcp_ss
	FROM #pcp_ss ss
	JOIN temp_pcp_all a 
	  ON ss.minprice = a.price
	 AND ss.ChannelGroupID = a.ChannelGroupID
	 AND ss.MarketID = a.MarketID
	 AND ss.UtilityID = a.UtilityID
	 AND ss.SegmentID = a.SegmentID
	 AND ss.ZoneID = a.ZoneID
	 AND ss.ServiceClassID = a.ServiceClassID
	 AND ss.StartDate = a.StartDate

/*
 select ss.*
 from temp_pcp_ss ss
 join libertypower..utility u
 on ss.utilityid = u.id
 where  term = 8
 and utilitycode like 'pennpr%'
 */

END




