


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/22/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_meter_read_dates_by_offer_sel]

@p_offer_id		varchar(50)

AS

SELECT		b.FromDate, 
			b.ToDate
FROM		lp_historical_info..ProspectAccounts a WITH (NOLOCK) 
			INNER JOIN lp_historical_info..ProspectAccountBillingInfo b WITH (NOLOCK) ON a.AccountNumber = b.AccountNumber
WHERE		a.[Deal ID]	= @p_offer_id
AND			b.FromDate IS NOT NULL
AND			b.ToDate IS NOT NULL
ORDER BY	b.FromDate, b.ToDate








