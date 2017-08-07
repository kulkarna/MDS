
/*******************************************************************************
 * usp_OfferAnnualUsageUpdate
 * Updates annual usage and usage end date for accounts in specified offer
 *
 * History
 * Modified 9/30/2009 - Eduardo Patino (Ticket 9481)
 *******************************************************************************
 * 6/11/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAnnualUsageUpdate]
	@OfferId		varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

		UPDATE	dbo.OE_ACCOUNT
		SET		ANNUAL_USAGE	= CASE WHEN b.TotalDays > 0 THEN CAST(((b.TotalUsage * 365.0) / b.TotalDays) AS bigint) ELSE 0 END, 
				USAGE_DATE		= CASE WHEN b.MaxEndDate IS NOT NULL THEN b.MaxEndDate ELSE USAGE_DATE END,
				NeedUsage		= CASE WHEN b.TotalDays > 0 THEN 0 ELSE 1 END
		-- select a.ACCOUNT_NUMBER, CASE WHEN b.TotalDays > 0 THEN CAST(((b.TotalUsage * 365.0) / b.TotalDays) AS bigint) ELSE 0 END ANNUAL_USAGE, CASE WHEN b.MaxEndDate IS NOT NULL THEN b.MaxEndDate ELSE USAGE_DATE END USAGE_DATE
		FROM	dbo.OE_ACCOUNT a
				INNER JOIN
		(
			SELECT	z.AccountNumber, MAX(z.ToDate) AS MaxEndDate, CAST(SUM(z.TotalKwh) AS decimal(18,5)) AS TotalUsage, CAST(SUM(z.DaysUsed) AS decimal(18,5)) AS TotalDays
			FROM
			(
				SELECT	u.AccountNumber, u.ToDate, u.TotalKwh, u.DaysUsed
				FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
						INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				WHERE	o.OFFER_ID			= @OfferId
					and	u.todate >= (	select	dateadd (day, -363, max(usg.todate))
										from	LibertyPower..UsageConsolidated usg WITH (NOLOCK)
												INNER JOIN LibertyPower..OfferUsageMapping um WITH (NOLOCK) ON usg.[ID] = um.UsageId
												INNER JOIN dbo.OE_OFFER_ACCOUNTS oa WITH (NOLOCK) ON um.OfferAccountsId = oa.[ID]
										WHERE	oa.OFFER_ID = @OfferId and u.AccountNumber = usg.AccountNumber)
				GROUP BY u.AccountNumber, u.ToDate, u.TotalKwh, u.DaysUsed
			)z	GROUP BY z.AccountNumber
		) b ON a.ACCOUNT_NUMBER = b.AccountNumber

	SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power


