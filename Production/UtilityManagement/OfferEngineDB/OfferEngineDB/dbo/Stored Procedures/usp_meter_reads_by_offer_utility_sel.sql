

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/1/2008
-- Description:	Get meter reads by offer per utility
-- =============================================
CREATE PROCEDURE [dbo].[usp_meter_reads_by_offer_utility_sel]

@p_offer_id		varchar(50),
@p_utility_id	varchar(50),
@p_zone			varchar(50)

AS

SET			@p_utility_id = REPLACE(@p_utility_id, '&amp;', '&')

SELECT		ISNULL(b.AccountNumber, '') AS AccountNumber, 
			ISNULL(b.Utility, '') AS Utility, 
			ISNULL(a.Zone, '') AS Zone, 
			ISNULL(b.FromDate, '') AS FromDate, 
			ISNULL(b.ToDate, '') AS ToDate, 
			ISNULL(b.Total_kWh, 0) AS Total_kWh, 
			ISNULL(b.DaysUsed, 0) AS DaysUsed,
			ISNULL(b.MeterNumber, '') AS MeterNumber, 
			ISNULL(b.OnPeakKWH, '0') AS OnPeakKWH, 
			ISNULL(b.OffPeakKWH, '0') AS OffPeakKWH,
			ISNULL(b.BillingDemandKW, 0) AS BillingDemandKW, 
			ISNULL(b.MonthlyPeakDemandKW, 0) AS MonthlyPeakDemandKW, 
			ISNULL(b.CurrentCharges, 0) AS CurrentCharges, 
			ISNULL(b.Comments, '') AS Comments
FROM		lp_historical_info..ProspectAccounts a WITH (NOLOCK) 
			INNER JOIN lp_historical_info..ProspectAccountBillingInfo b WITH (NOLOCK) ON a.AccountNumber = b.AccountNumber
WHERE		a.[Deal ID]	= @p_offer_id
AND			a.Utility	= @p_utility_id
AND			a.Zone		= @p_zone
--AND			b.CreatedBy	IN ('Offer Engine', 'USAGE ACQUIRE SCRPR')
ORDER BY	b.AccountNumber, b.FromDate



