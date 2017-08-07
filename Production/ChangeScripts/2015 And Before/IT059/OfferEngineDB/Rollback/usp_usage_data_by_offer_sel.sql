USE [OfferEngineDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_usage_data_by_offer_sel]    Script Date: 07/13/2013 14:04:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/29/2008
-- Description:	Get all usage data for offer
-- =============================================
ALTER PROCEDURE [dbo].[usp_usage_data_by_offer_sel]

@p_offer_id		varchar(50)

AS

SELECT		ISNULL(p.CUSTOMER_NAME, '') AS CustomerName, 
			ISNULL(u.AccountNumber, '') AS AccountNumber, 
			ISNULL(u.UtilityCode, '') AS Utility, 
			ISNULL(u.FromDate, '') AS FromDate, 
			ISNULL(u.ToDate, '') AS ToDate, 
			ISNULL(u.TotalKwh, 0) AS Total_kWh, 
			ISNULL(u.DaysUsed, 0) AS DaysUsed,
			ISNULL(mt.METER_NUMBER, '') AS MeterNumber, 
			ISNULL(u.OnPeakKWH, 0) AS OnPeakKWH, 
			ISNULL(u.OffPeakKWH, 0) AS OffPeakKWH,
			ISNULL(u.BillingDemandKW, 0) AS BillingDemandKW, 
			ISNULL(u.MonthlyPeakDemandKW, 0) AS MonthlyPeakDemandKW, 
			ISNULL(u.UsageType, 0) AS UsageType,

			ISNULL(a.LOAD_SHAPE_ID, '') AS LoadShapeID, 
			ISNULL(a.RATE_CLASS, '') AS RateClass, 
			ISNULL(a.RATE_CODE, '') AS RateCode, 
			'' AS Rider, 
			ISNULL(a.STRATUM_VARIABLE, '') AS StratumVariable, 
			ISNULL(a.ICAP, 0) AS ICAP, 
			ISNULL(a.TCAP, 0) AS TCAP, 
			'' AS POLRType, 
			ISNULL(a.BILL_GROUP, '') AS BillGroup, 
			ISNULL(a.VOLTAGE, '') AS Voltage, 
			ISNULL(a.ZONE, '') AS Zone, 
			ISNULL(a.MARKET, '') AS ISO, 
			ISNULL(a.LOAD_PROFILE, '') AS LoadProfile, 
			ISNULL(a.METER_TYPE, '') AS IDR, 
			ISNULL(o.OFFER_ID, '') AS DealID, 
			ISNULL(a.SUPPLY_GROUP, '') AS SupplyGroup,
			ISNULL(ad.ADDRESS, '') AS ServiceAddress, 
			ISNULL(ad.Zip, '') AS ZipCode
FROM		Libertypower..UsageConsolidated u WITH (NOLOCK)
			INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId AND u.UsageType = m.UsageType
			INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			INNER JOIN OfferEngineDB..OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
			LEFT JOIN OE_ACCOUNT_ADDRESS ad WITH (NOLOCK) ON a.ACCOUNT_NUMBER = ad.ACCOUNT_NUMBER
			INNER JOIN OE_PRICING_REQUEST_OFFER po WITH (NOLOCK) ON po.OFFER_ID = o.OFFER_ID
			INNER JOIN OE_PRICING_REQUEST p WITH (NOLOCK) ON p.REQUEST_ID = po.REQUEST_ID
			LEFT JOIN (SELECT TOP 1 ACCOUNT_NUMBER, METER_NUMBER FROM OE_ACCOUNT_METERS WITH (NOLOCK)) mt ON a.ACCOUNT_NUMBER = mt.ACCOUNT_NUMBER
WHERE		o.OFFER_ID = @p_offer_id 


UNION

SELECT		ISNULL(p.CUSTOMER_NAME, '') AS CustomerName, 
			ISNULL(u.AccountNumber, '') AS AccountNumber, 
			ISNULL(u.UtilityCode, '') AS Utility, 
			ISNULL(u.FromDate, '') AS FromDate, 
			ISNULL(u.ToDate, '') AS ToDate, 
			ISNULL(u.TotalKwh, 0) AS Total_kWh, 
			ISNULL(u.DaysUsed, 0) AS DaysUsed,
			ISNULL(mt.METER_NUMBER, '') AS MeterNumber, 
			'0' AS OnPeakKWH, 
			'0' AS OffPeakKWH,
			0 AS BillingDemandKW, 
			0 AS MonthlyPeakDemandKW, 
			ISNULL(u.UsageType, 0) AS UsageType,

			ISNULL(a.LOAD_SHAPE_ID, '') AS LoadShapeID, 
			ISNULL(a.RATE_CLASS, '') AS RateClass, 
			ISNULL(a.RATE_CODE, '') AS RateCode, 
			'' AS Rider, 
			ISNULL(a.STRATUM_VARIABLE, '') AS StratumVariable, 
			ISNULL(a.ICAP, 0) AS ICAP, 
			ISNULL(a.TCAP, 0) AS TCAP, 
			'' AS POLRType, 
			ISNULL(a.BILL_GROUP, '') AS BillGroup, 
			ISNULL(a.VOLTAGE, '') AS Voltage, 
			ISNULL(a.ZONE, '') AS Zone, 
			ISNULL(a.MARKET, '') AS ISO, 
			ISNULL(a.LOAD_PROFILE, '') AS LoadProfile, 
			ISNULL(a.METER_TYPE, '') AS IDR, 
			ISNULL(o.OFFER_ID, '') AS DealID, 
			ISNULL(a.SUPPLY_GROUP, '') AS SupplyGroup,
			ISNULL(ad.ADDRESS, '') AS ServiceAddress, 
			ISNULL(ad.Zip, '') AS ZipCode
FROM		Libertypower..EstimatedUsage u WITH (NOLOCK)
			INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId AND u.UsageType = m.UsageType
			INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			INNER JOIN OfferEngineDB..OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
			LEFT JOIN OE_ACCOUNT_ADDRESS ad WITH (NOLOCK) ON a.ACCOUNT_NUMBER = ad.ACCOUNT_NUMBER
			INNER JOIN OE_PRICING_REQUEST_OFFER po WITH (NOLOCK) ON po.OFFER_ID = o.OFFER_ID
			INNER JOIN OE_PRICING_REQUEST p WITH (NOLOCK) ON p.REQUEST_ID = po.REQUEST_ID
			LEFT JOIN (SELECT TOP 1 ACCOUNT_NUMBER, METER_NUMBER FROM OE_ACCOUNT_METERS WITH (NOLOCK)) mt ON a.ACCOUNT_NUMBER = mt.ACCOUNT_NUMBER
WHERE		o.OFFER_ID = @p_offer_id 


GO

