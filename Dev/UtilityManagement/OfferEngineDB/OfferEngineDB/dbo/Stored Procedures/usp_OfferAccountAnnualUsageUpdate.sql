
/*******************************************************************************
 * usp_OfferAccountAnnualUsageUpdate
 * To update annual usage and usage end date for account
 *
 * History
 * Modified 9/30/2009 - Eduardo Patino (Ticket 9481)
 *******************************************************************************
 * 6/11/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountAnnualUsageUpdate]
	@OfferId		varchar(50),
	@UtilityCode	varchar(50),
	@AccountNumber	varchar(50)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@AnnualUsage	bigint,
			@TotalUsage		float,
			@TotalDays		float,
			@w_364_range	datetime,
			@MaxEndDate		datetime
			
			select	top 1 @w_364_range = dateadd (day, -363, todate)
			FROM
			(
				SELECT	ToDate
				FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
						INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				WHERE	o.OFFER_ID			= @OfferId
				AND		o.ACCOUNT_NUMBER	= @AccountNumber
				UNION
				SELECT	ToDate
				FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
						INNER JOIN LibertyPower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				WHERE	o.OFFER_ID			= @OfferId
				AND		o.ACCOUNT_NUMBER	= @AccountNumber				
			)z
			ORDER BY todate DESC

			SELECT	@MaxEndDate = MAX(z.ToDate), @TotalUsage = SUM(z.TotalKwh), @TotalDays = SUM(z.DaysUsed)
			FROM
			(
				SELECT	ToDate, TotalKwh, DaysUsed
				FROM	LibertyPower..UsageConsolidated u WITH (NOLOCK)
						INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				WHERE	o.OFFER_ID			= @OfferId 
					AND	o.ACCOUNT_NUMBER	= @AccountNumber
					AND	ToDate >= @w_364_range
				GROUP BY ToDate, TotalKwh, DaysUsed
				UNION
				SELECT	ToDate, TotalKwh, DaysUsed
				FROM	LibertyPower..EstimatedUsage u WITH (NOLOCK)
						INNER JOIN Libertypower..OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
						INNER JOIN dbo.OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
				WHERE	o.OFFER_ID			= @OfferId 
					AND	o.ACCOUNT_NUMBER	= @AccountNumber
					AND	ToDate >= @w_364_range
				GROUP BY ToDate, TotalKwh, DaysUsed				
			)z

			IF @TotalDays > 0 AND @TotalUsage > 0
				SET	@AnnualUsage = CAST((CAST(@TotalUsage AS decimal(18,5)) * (CAST(365 AS decimal(18,5)) / CAST(@TotalDays AS decimal(18,5)))) AS int)
			ELSE
				SET	@AnnualUsage = 0

			UPDATE	dbo.OE_ACCOUNT
			SET		ANNUAL_USAGE	= CASE WHEN LEN(@AnnualUsage) > 0	THEN @AnnualUsage	ELSE ANNUAL_USAGE	END,
					USAGE_DATE		= CASE WHEN @MaxEndDate IS NOT NULL	THEN @MaxEndDate	ELSE USAGE_DATE		END
			WHERE	ACCOUNT_NUMBER	= @AccountNumber AND UTILITY = @UtilityCode

	SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power


