USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProspectAccountsSelect]    Script Date: 07/13/2013 14:04:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_ProspectAccountsSelect
 * Select prospect account data for offer id
 *
 *******************************************************************************
 * 5/11/2009 - Rick Deigsler
 * Created.
 *
 * Modified 5/20/2010 - Rick Deigsler
 * Added offer id parameter to usp_NstarUtilityCodeUpdate call
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_ProspectAccountsSelect]
	@OfferId		varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- SD Ticket 13295
	-- Updates utility code in offer engine with utility code in usage.
	-- Pricing uploads all NSTAR accounts as NSTAR-BOS.    
    EXEC	usp_NstarUtilityCodeUpdate @OfferId

	SELECT	a.UTILITY, p.CUSTOMER_NAME AS CustomerName, a.ACCOUNT_NUMBER AS AccountNumber, 
			ad.ADDRESS AS ServiceAddress, ad.Zip AS ZipCode, a.RATE_CODE AS RateCode, 
			a.LOAD_PROFILE AS LoadProfile, a.SUPPLY_GROUP AS SupplyGroup, m.METER_NUMBER AS MeterNumber, 
			ISNULL(i.Icap,ISNULL(a.ICAP,0)) AS ICAP, ISNULL(t.Tcap,ISNULL(a.TCAP,0)) AS TCAP, a.BILL_GROUP AS BillGroup, a.STRATUM_VARIABLE AS StratumVariable, 
			a.VOLTAGE, a.ZONE, a.RATE_CLASS AS RateClass, o.OFFER_ID AS OfferId, 
			CASE WHEN a.UTILITY = 'O&R' OR a.UTILITY = 'ROCKLAND' THEN 
				CASE WHEN a.STRATUM_VARIABLE IS NULL OR LEN(a.STRATUM_VARIABLE) = 0 THEN
					a.LOAD_SHAPE_ID
				ELSE
					a.LOAD_SHAPE_ID + '-' + a.STRATUM_VARIABLE
				END
			ELSE 
				a.LOAD_SHAPE_ID 
			END AS LoadShapeID, 
			a.METER_TYPE AS MeterType, a.MARKET AS RetailMarketCode, a.IsIcapEsimated, a.ID AS OE_ACCOUNT_ID
	FROM	OE_OFFER_ACCOUNTS o WITH (NOLOCK)
			INNER JOIN OE_ACCOUNT a WITH (NOLOCK) ON o.oe_account_id = a.id
			LEFT JOIN OE_ACCOUNT_ADDRESS ad WITH (NOLOCK) ON a.ACCOUNT_NUMBER = ad.ACCOUNT_NUMBER
			INNER JOIN OE_PRICING_REQUEST_OFFER po WITH (NOLOCK) ON po.OFFER_ID = o.OFFER_ID
			INNER JOIN OE_PRICING_REQUEST p WITH (NOLOCK) ON p.REQUEST_ID = po.REQUEST_ID
			LEFT JOIN (SELECT TOP 1 ACCOUNT_NUMBER, METER_NUMBER FROM OE_ACCOUNT_METERS WITH (NOLOCK)) m ON a.ACCOUNT_NUMBER = m.ACCOUNT_NUMBER
			LEFT JOIN OeIcaps i WITH (NOLOCK) ON a.ID = i.OeAccountID AND GETDATE() BETWEEN i.StartDate AND i.EndDate
			LEFT JOIN OeTcaps t WITH (NOLOCK) ON a.ID = t.OeAccountID AND GETDATE() BETWEEN t.StartDate AND t.EndDate				
	WHERE	o.OFFER_ID = @OfferId

	SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

GO

