/*******************************************************************************
 * [usp_PriceInsertSameMonth]
 * Inserts price record for same month pricing ONLY ONE TIME
 *
 * History
 *******************************************************************************
 * 12/7/2011 - AT  - one time run
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceInsertSameMonth]
AS
BEGIN

SET NOCOUNT ON;

DECLARE @StartDate	datetime 

Declare @p_MarketId		as int
	,@DateCreated		as datetime
	
Declare MarketCursor CURSOR
FOR 
select marketid 
from utility WITH (NOLOCK)
where marketid <>1
FOR READ ONLY

SELECT @StartDate	= '20120801'
	   ,@DateCreated			= GetDate()
		
OPEN MarketCursor

--Get the first Market name from the cursor
FETCH NEXT FROM MarketCursor INTO @p_MarketId

--Loop until the cursor was not able to fetch
WHILE (@@Fetch_Status <> 0)
BEGIN

	INSERT INTO	LibertyPower..Price (ChannelID, ChannelGroupID, ChannelTypeID, ProductCrossPriceSetID, 
				ProductTypeID, MarketID, UtilityID, SegmentID, ZoneID, ServiceClassID, StartDate, Term, Price, CostRateEffectiveDate, 
				CostRateExpirationDate, IsTermRange, DateCreated, PriceTier, ProductBrandID, GrossMargin)
	SELECT      ChannelID, ChannelGroupID, ChannelTypeID, ProductCrossPriceSetID, ProductTypeID, MarketID, UtilityID, SegmentID, ZoneID, 
				ServiceClassID, @StartDate, Term, Price, CostRateEffectiveDate, CostRateExpirationDate, IsTermRange, @DateCreated, PriceTier, 
				ProductBrandID, GrossMargin
	  FROM		libertypower..price with (nolock)
	 WHERE		marketid = @p_MarketId
	   and		costrateeffectivedate between '20120801' and '20120830'
	   and		startdate = '20120901'

			

END

CLOSE MarketCursor
DEALLOCATE MarketCursor

					
SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power














