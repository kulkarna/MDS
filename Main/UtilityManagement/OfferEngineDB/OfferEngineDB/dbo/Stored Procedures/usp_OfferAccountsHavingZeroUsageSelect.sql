
/*******************************************************************************
 * usp_OfferAccountsHavingZeroUsageSelect
 * Gets accounts that have zero usage for the latest 364 days of meter reads
 * for specified offer
 *
 * History
 *******************************************************************************
 * 9/30/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountsHavingZeroUsageSelect]
	@OfferId		varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	DISTINCT z.AccountNumber
	FROM
	(
		SELECT	u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate,
				CAST(DATEPART(yyyy, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(4)) + '-' + RIGHT('0' + CAST(DATEPART(mm, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(2)), 2) + '-01' AS MinDate,
				MAX(u.ToDate) AS MaxDate
		FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
				INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
		WHERE	o.OFFER_ID = @OfferId
		GROUP BY u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate
		UNION
		SELECT	u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate,
				CAST(DATEPART(yyyy, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(4)) + '-' + RIGHT('0' + CAST(DATEPART(mm, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(2)), 2) + '-01' AS MinDate,
				MAX(u.ToDate) AS MaxDate
		FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
				INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]	
		WHERE	o.OFFER_ID = @OfferId	
		GROUP BY u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate		
	)z	
	WHERE z.FromDate BETWEEN z.MinDate AND z.MaxDate
	GROUP BY z.AccountNumber, z.ToDate, z.FromDate
	HAVING SUM(z.TotalKwh) = 0
		
    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power


