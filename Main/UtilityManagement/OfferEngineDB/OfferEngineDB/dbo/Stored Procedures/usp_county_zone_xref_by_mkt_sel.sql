
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/12/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_county_zone_xref_by_mkt_sel]

@p_retail_mkt_id		varchar(50)

AS

SELECT		LTRIM(RTRIM(county_name)) AS county_name, zone
FROM		lp_historical_info..CountyZoneXRef WITH (NOLOCK)
WHERE		retail_mkt_id = @p_retail_mkt_id
ORDER BY	county_name


