
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/30/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_historical_load_by_offer_id_zone_utility_sel]

@p_offer_id		varchar(50),
@p_utility_id	varchar(50),
@p_zone			varchar(10)

AS

SELECT		utility, deal_id, usg_dte, zone, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12, 
			H13, H14, H15, H16, H17, H18, H19, H20, H21, H22, H23, H24, Created, CreatedBy
FROM		lp_historical_info..HistLoadByZone WITH (NOLOCK)
WHERE		deal_id = @p_offer_id
AND			utility	= @p_utility_id
AND			zone	= @p_zone
ORDER BY	usg_dte ASC

