-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/20/2008
-- Description:	
--
-- Modified 5/8/2009 - Rick Deigsler
-- Pull from OE
-- =============================================
CREATE PROCEDURE [dbo].[usp_aggregated_total_meter_reads_by_offer_sel]

@p_offer_id		varchar(50)

AS

SELECT z.UTILITY, z.ZONE, SUM(z.TotalKWH) AS TotalKWH
FROM
(
	SELECT		a.UTILITY, a.ZONE, TotalKwh= Convert(bigint, u.TotalKwh)
	FROM		Libertypower..UsageConsolidated u WITH (NOLOCK)
				INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				INNER JOIN dbo.OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE		o.OFFER_ID = @p_offer_id
	AND			a.ACCOUNT_NUMBER NOT IN -- Do not price zero usage accounts
	(
		SELECT	DISTINCT z.AccountNumber
		FROM
		(
			SELECT	u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate,
					CAST(DATEPART(yyyy, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(4)) + '-' + RIGHT('0' + CAST(DATEPART(mm, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(2)), 2) + '-01' AS MinDate,
					MAX(u.ToDate) AS MaxDate
			FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
					INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
					INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			WHERE	o.OFFER_ID = @p_offer_id
			GROUP BY u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate
		)z	
		WHERE z.FromDate BETWEEN z.MinDate AND z.MaxDate
		GROUP BY z.AccountNumber, z.ToDate, z.FromDate
		HAVING SUM(z.TotalKwh) = 0	
	)
	GROUP BY	a.UTILITY, a.ZONE, u.TotalKwh
	
	UNION
	
	SELECT		a.UTILITY, a.ZONE, TotalKwh= Convert(bigint, u.TotalKwh)
	FROM		Libertypower..EstimatedUsage u WITH (NOLOCK)
				INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				INNER JOIN dbo.OE_ACCOUNT a WITH (NOLOCK) ON o.ACCOUNT_NUMBER = a.ACCOUNT_NUMBER
	WHERE		o.OFFER_ID = @p_offer_id
	AND			a.ACCOUNT_NUMBER NOT IN -- Do not price zero usage accounts
	(
		SELECT	DISTINCT z.AccountNumber
		FROM
		(
			SELECT	u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate,
					CAST(DATEPART(yyyy, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(4)) + '-' + RIGHT('0' + CAST(DATEPART(mm, DATEADD(dd, -364, MAX(u.ToDate))) AS varchar(2)), 2) + '-01' AS MinDate,
					MAX(u.ToDate) AS MaxDate
			FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
					INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
					INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
			WHERE	o.OFFER_ID = @p_offer_id
			GROUP BY u.AccountNumber, u.ToDate, u.TotalKwh, u.FromDate
		)z	
		WHERE z.FromDate BETWEEN z.MinDate AND z.MaxDate
		GROUP BY z.AccountNumber, z.ToDate, z.FromDate
		HAVING SUM(z.TotalKwh) = 0	
	)
	GROUP BY	a.UTILITY, a.ZONE, u.TotalKwh	
) z
GROUP BY	z.UTILITY, z.ZONE

