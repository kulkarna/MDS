
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/19/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_aggregated_total_hourly_load_by_offer_sel]

@p_offer_id		varchar(50)

AS

SELECT		utility, zone, 
			CAST((SUM(H1) + SUM(H2) + SUM(H3) + SUM(H4) + SUM(H5) + SUM(H6) + SUM(H7) + SUM(H8) + 
			SUM(H9) + SUM(H10) + SUM(H11) + SUM(H12) + SUM(H13) + SUM(H14) + SUM(H15) + SUM(H16) + 
			SUM(H17) + SUM(H18) + SUM(H19) + SUM(H20) + SUM(H21) + SUM(H22) + SUM(H23) + SUM(H24)) AS int) AS TotalKWH
FROM		lp_historical_info..HistLoadByZone WITH (NOLOCK)
WHERE		deal_id = @p_offer_id
GROUP BY	utility, zone



