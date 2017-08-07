
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/2/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_utility_zone_xref_sel]

AS

SELECT		utility_id, zone_mat_price
FROM		lp_historical_info..UtilityZoneXRef WITH (NOLOCK)
ORDER BY	utility_id ASC


