/*******************************************************************************
 * usp_OfferUtilityZoneMappedUsageSelect
 * Select mapped usage records for offer, utility, and zone
 *
 * History
 *******************************************************************************
 * 2/20/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferUtilityZoneMappedUsageSelect]                                                                                     
	@OfferId		varchar(50),
	@UtilityCode	varchar(50),
	@Zone			varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
	SET			@UtilityCode = REPLACE(@UtilityCode, '&amp;', '&')

	SELECT		DISTINCT ISNULL(u.AccountNumber, '') AS AccountNumber, 
				ISNULL(u.UtilityCode, '') AS Utility, 
				ISNULL(a.Zone, '') AS Zone, 
				ISNULL(CAST(CAST(DATEPART(mm, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.FromDate) AS varchar(4)) AS datetime), '') AS FromDate,
				ISNULL(CAST(CAST(DATEPART(mm, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.ToDate) AS varchar(4)) AS datetime), '') AS ToDate,	 
				ISNULL(u.TotalKwh, 0) AS Total_kWh, 
				ISNULL(u.DaysUsed, 0) AS DaysUsed,
				ISNULL(u.MeterNumber, '') AS MeterNumber, 
				ISNULL(u.OnPeakKWH, '0') AS OnPeakKWH, 
				ISNULL(u.OffPeakKWH, '0') AS OffPeakKWH,
				ISNULL(u.BillingDemandKW, 0) AS BillingDemandKW, 
				ISNULL(u.MonthlyPeakDemandKW, 0) AS MonthlyPeakDemandKW, 
				u.UsageType
	FROM		UsageConsolidated u WITH (NOLOCK)
				INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId AND u.UsageType = m.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				INNER JOIN OfferEngineDB..OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE		o.OFFER_ID		= @OfferId 
	AND			u.UtilityCode	= @UtilityCode
	AND			a.Zone			= @Zone
	GROUP BY	u.AccountNumber, u.UtilityCode, a.Zone, u.FromDate, u.ToDate, u.TotalKwh, u.DaysUsed, 
				u.MeterNumber, u.OnPeakKWH, u.OffPeakKWH, u.BillingDemandKW, u.MonthlyPeakDemandKW, u.UsageType
				
	UNION
				
	SELECT		DISTINCT ISNULL(u.AccountNumber, '') AS AccountNumber, 
				ISNULL(u.UtilityCode, '') AS Utility, 
				ISNULL(a.Zone, '') AS Zone, 
				ISNULL(CAST(CAST(DATEPART(mm, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.FromDate) AS varchar(4)) AS datetime), '') AS FromDate,
				ISNULL(CAST(CAST(DATEPART(mm, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.ToDate) AS varchar(4)) AS datetime), '') AS ToDate,	 
				ISNULL(u.TotalKwh, 0) AS Total_kWh, 
				ISNULL(u.DaysUsed, 0) AS DaysUsed,
				ISNULL(u.MeterNumber, '') AS MeterNumber, 
				'0' AS OnPeakKWH, 
				'0' AS OffPeakKWH,
				0 AS BillingDemandKW, 
				0 AS MonthlyPeakDemandKW, 
				u.UsageType
	FROM		EstimatedUsage u WITH (NOLOCK)
				INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId AND u.UsageType = m.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				INNER JOIN OfferEngineDB..OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE		o.OFFER_ID		= @OfferId 
	AND			u.UtilityCode	= @UtilityCode
	AND			a.Zone			= @Zone
	GROUP BY	u.AccountNumber, u.UtilityCode, a.Zone, u.FromDate, u.ToDate, u.TotalKwh, u.DaysUsed, 
				u.MeterNumber, u.UsageType				
	
	ORDER BY	AccountNumber, FromDate

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
