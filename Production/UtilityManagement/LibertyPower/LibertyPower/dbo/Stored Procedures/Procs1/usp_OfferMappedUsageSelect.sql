/*******************************************************************************
 * usp_OfferMappedUsageSelect
 * Select mapped usage records for offer
 *
 * History
 *			07/30/2011 (EP) - adding usage type + changing source of usage table - IT022
 *			08/15/2011 (EP) - compensating for new usage type column added to EstimatedUsage
 *******************************************************************************
 * 2/20/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferMappedUsageSelect]
	@OfferId		varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	declare	@estimate	smallint, @user	smallint
	select	@estimate = value from usagetype where description = 'Estimated'
	select	@user = value from usageSource where description = 'User'

	SELECT		u.[ID], u.UtilityCode, u.AccountNumber, u.UsageType, u.UsageSource,
				CAST(CAST(DATEPART(mm, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.FromDate) AS varchar(4)) AS datetime) AS FromDate,
				CAST(CAST(DATEPART(mm, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.ToDate) AS varchar(4)) AS datetime) AS ToDate,	 	 
				u.TotalKwh, u.DaysUsed, u.Created, u.CreatedBy, u.Modified, u.MeterNumber,
				u.OnPeakKWh, u.OffPeakKWh, u.BillingDemandKW, u.MonthlyPeakDemandKW
	FROM		UsageConsolidated u WITH (NOLOCK)
				INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE		o.OFFER_ID = @OfferId
	UNION
	SELECT		u.[ID], u.UtilityCode, u.AccountNumber, u.UsageType, @user UsageSource,
				CAST(CAST(DATEPART(mm, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.FromDate) AS varchar(4)) AS datetime) AS FromDate,
				CAST(CAST(DATEPART(mm, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.ToDate) AS varchar(4)) AS datetime) AS ToDate,	 	 
				u.TotalKwh, u.DaysUsed, u.Created, u.CreatedBy, getdate() Modified, u.MeterNumber,
				-1 OnPeakKWh, -1 OffPeakKWh, -1 BillingDemandKW, -1 MonthlyPeakDemandKW
	FROM		EstimatedUsage u WITH (NOLOCK)
				INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE		o.OFFER_ID	= @OfferId
--			AND	m.UsageType	= @estimate
	ORDER BY	AccountNumber, FromDate

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
