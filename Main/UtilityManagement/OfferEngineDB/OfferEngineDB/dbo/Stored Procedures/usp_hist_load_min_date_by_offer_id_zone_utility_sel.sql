-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/25/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_hist_load_min_date_by_offer_id_zone_utility_sel]

@p_offer_id		varchar(50),
@p_utility_id	varchar(50),
@p_zone			varchar(10)

AS

SELECT	MIN(usg_dte) as usg_dte
FROM	lp_historical_info..HistLoadByZone WITH (NOLOCK)
WHERE	deal_id		= @p_offer_id
AND		utility		= @p_utility_id
AND		zone		= @p_zone
