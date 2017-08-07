
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/2/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_mat_price_zone_by_utility_sel]

@p_utility_id		varchar(50)

AS

SELECT	zone_mat_price
FROM	lp_historical_info..UtilityZoneXRef WITH (NOLOCK)
WHERE	utility_id = @p_utility_id


