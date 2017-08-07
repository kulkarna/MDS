/*******************************************************************************
 * usp_OfferZoneUtilitySelect
 * Get zones and utilities for specified offer
 *
 * History
 *******************************************************************************
 * 2/18/2009
 * Created.
 * 4/13/2012 - removed code to strip hyphen from utility name
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferZoneUtilitySelect]                                                                                     

@OfferId	varchar(50)

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	DISTINCT ZONE, UTILITY
	FROM	OE_ACCOUNT a WITH (NOLOCK)
			INNER JOIN OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON a.ID = o.OE_ACCOUNT_ID
	WHERE	o.OFFER_ID = @OfferId
	AND		a.ACCOUNT_NUMBER NOT IN -- Do not price zero usage accounts
	(
		SELECT	DISTINCT z.AccountNumber
		FROM
		(
			SELECT	u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate,
					CAST(DATEPART(yyyy, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(4)) + '-' + RIGHT('0' + CAST(DATEPART(mm, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(2)), 2) + '-01' AS MinDate,
					MAX(u.ToDate) AS MaxDate
			FROM	LibertyPower..Usage u WITH (NOLOCK)
					INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
					INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			WHERE	o.OFFER_ID = @OfferId
			GROUP BY u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate
		)z	
		WHERE z.FromDate BETWEEN z.MinDate AND z.MaxDate
		GROUP BY z.AccountNumber, z.ToDate, z.FromDate
		HAVING SUM(z.TotalKwh) = 0	
	)

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

