-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/27/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_a_clean_slate]

AS

-- remove the return to execute this...REMOVES EVERYTHING !!!
return 

-- historical info data  -------------------------------------------------------------------
DELETE FROM	lp_historical_info..ProspectDailyProfileByAcct
WHERE		AccountNumber IN (	SELECT	PA_EXT_ID AS AccountNumber
							FROM	lp_historical_info..RO_PA_PROSPECT
							WHERE	QUOTE_NUMBER LIKE 'OF-%' )

DELETE FROM	lp_historical_info..RO_PA_USAGE_HISTORY
WHERE		PA_EXT_ID IN (	SELECT	PA_EXT_ID
							FROM	lp_historical_info..RO_PA_PROSPECT
							WHERE	QUOTE_NUMBER LIKE 'OF-%' )

DELETE FROM	lp_historical_info..RO_PA_RESULTS
WHERE		QUOTE_NUMBER LIKE 'OF-%'

DELETE FROM	lp_historical_info..RO_PA_PROSPECT
WHERE		QUOTE_NUMBER LIKE 'OF-%'

DELETE FROM	lp_historical_info..HistLoadByZone
WHERE		deal_id IN (	SELECT	DealID
							FROM	lp_historical_info..ProspectDeals
							WHERE	DealID LIKE 'OF-%' )


DELETE FROM	lp_historical_info..ProspectAccountBillingInfo
WHERE		AccountNumber IN (	SELECT	AccountNumber	
								FROM	lp_historical_info..ProspectAccounts
								WHERE		[Deal ID] IN (	SELECT	DealID
															FROM	lp_historical_info..ProspectDeals
															WHERE	DealID LIKE 'OF-%' ) )

DELETE FROM	lp_historical_info..ProspectAccounts
WHERE		[Deal ID] IN (	SELECT	DealID
							FROM	lp_historical_info..ProspectDeals
							WHERE	DealID LIKE 'OF-%' )

DELETE FROM	lp_historical_info..ProspectDeals
WHERE		DealID LIKE 'OF-%'
--------------------------------------------------------------------------------------------

-- accounts
DELETE FROM	OE_ACCOUNT

-- account addresses
DELETE FROM	OE_ACCOUNT_ADDRESS

-- account meters
DELETE FROM	OE_ACCOUNT_METERS

-- contracted offers
DELETE FROM	OE_CONTRACTED_OFFERS

-- matprice files
DELETE FROM	OE_MATPRICE_FILE

-- offer
DELETE FROM	OE_OFFER

-- offer accounts
DELETE FROM	OE_OFFER_ACCOUNTS

-- offer aggregates
DELETE FROM	OE_OFFER_AGGREGATES

-- offer component details
DELETE FROM	OE_OFFER_COMPONENT_DETAILS

-- flow start dates
DELETE FROM	OE_OFFER_FLOW_DATES

-- offer market prices detail
DELETE FROM	OE_OFFER_MARKET_PRICES_DETAIL

-- market
DELETE FROM	OE_OFFER_MARKETS

-- offer price files
DELETE FROM	OE_OFFER_PRICE_FILES

-- offer status messages
DELETE FROM	OE_OFFER_STATUS_MESSAGE

-- utilities
DELETE FROM	OE_OFFER_UTILITIES

-- prices
DELETE FROM	OE_PRICES

-- pricing request accounts
DELETE FROM	OE_PRICING_REQUEST_ACCOUNTS

-- pricing request files
DELETE FROM	OE_PRICING_REQUEST_FILES

-- pricing request offer
DELETE FROM	OE_PRICING_REQUEST_OFFER

-- terms and prices
DELETE FROM	OE_TERMS_AND_PRICES

UPDATE	OE_PRICING_REQUEST
SET		TOTAL_NUMBER_OF_ACCOUNTS = 0

UPDATE	OE_PRICING_REQUEST
SET		STATUS = 'Assigned'
WHERE	STATUS = 'Open'

-- audit tables
DELETE FROM zOE_ACCOUNT_AUDIT

DELETE FROM zOE_OFFER_AUDIT

--error table
DELETE FROM zErrors






