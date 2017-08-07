

/*******************************************************************************
 * usp_OfferAccountMappedUsageSelect
 * Select mapped usage records for offer account
 *
 * History
 *			07/30/2011 (EP) - adding usage type + changing source of usage table - IT022
 *			08/15/2011 (EP) - compensating for new usage type column added to EstimatedUsage
 *******************************************************************************
 * 2/19/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferAccountMappedUsageSelect]
	@OfferId		varchar(50),
	@AccountNumber	varchar(50)
AS
BEGIN
	-- usp_OfferAccountMappedUsageSelect 'OF-035392', 'PE000011443686887454'
	-- select * from OfferUsageMapping where UsageId in (3142394, 3142395, 3142396, 3142397) order by 1, 2
	-- select * from OfferEngineDB..OE_OFFER_ACCOUNTS where [ID] in (627503, 627631)
    SET NOCOUNT ON;

	declare	@estimate	smallint, @user	smallint
	select	@estimate = value from usagetype where description = 'Estimated'
	select	@user = value from usageSource where description = 'User'
		
	SELECT		DISTINCT u.[ID], u.UtilityCode, u.AccountNumber, u.UsageType, u.UsageSource,
				CAST(CAST(DATEPART(mm, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.FromDate) AS varchar(4)) AS datetime) AS FromDate,
				CAST(CAST(DATEPART(mm, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.ToDate) AS varchar(4)) AS datetime) AS ToDate,	 
				u.TotalKwh, u.DaysUsed, u.Created, u.CreatedBy, u.Modified, '' as ModifiedBy, u.MeterNumber, 
				u.OnPeakKWh, u.OffPeakKWh, u.BillingDemandKW, u.MonthlyPeakDemandKW, cast('0' as float) as CurrentCharges, 
				'' as Comments, '' as TransactionNumber, u.FromDate AS From_Date
	FROM		UsageConsolidated u WITH (NOLOCK)
				INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE		o.OFFER_ID			= @OfferId 
		AND		o.ACCOUNT_NUMBER	= @AccountNumber
--		AND		u.FromDate			>= '2009-01-01' -- no 2008 usage
	UNION
	SELECT		DISTINCT u.[ID], u.UtilityCode, u.AccountNumber, u.UsageType, @user UsageSource,
				CAST(CAST(DATEPART(mm, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.FromDate) AS varchar(4)) AS datetime) AS FromDate,
				CAST(CAST(DATEPART(mm, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, u.ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, u.ToDate) AS varchar(4)) AS datetime) AS ToDate,	 
				u.TotalKwh, u.DaysUsed, u.Created, u.CreatedBy, getdate() Modified, '' as ModifiedBy, u.MeterNumber, 
				NULL OnPeakKWh, NULL OffPeakKWh, NULL BillingDemandKW, NULL MonthlyPeakDemandKW, cast('0' as float) as CurrentCharges, 
				'' as Comments, '' as TransactionNumber, u.FromDate AS From_Date
	FROM		EstimatedUsage u WITH (NOLOCK)
				INNER JOIN OfferUsageMapping m WITH (NOLOCK) ON u.[ID] = m.UsageId and m.UsageType = u.UsageType
				INNER JOIN OfferEngineDB..OE_OFFER_ACCOUNTS o WITH (NOLOCK) ON m.OfferAccountsId = o.[ID]
	WHERE		o.OFFER_ID			= @OfferId 
		AND		o.ACCOUNT_NUMBER	= @AccountNumber
--		AND		m.UsageType			= @estimate
--		AND		u.FromDate			>= '2009-01-01' -- no 2008 usage
	ORDER BY	u.FromDate

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

