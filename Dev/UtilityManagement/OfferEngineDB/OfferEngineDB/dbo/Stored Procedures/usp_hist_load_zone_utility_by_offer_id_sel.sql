-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/25/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_hist_load_zone_utility_by_offer_id_sel]

@p_offer_id		varchar(50)

AS

SELECT	DISTINCT zone, utility
FROM	lp_historical_info..HistLoadByZone WITH (NOLOCK)
WHERE	deal_id = @p_offer_id
