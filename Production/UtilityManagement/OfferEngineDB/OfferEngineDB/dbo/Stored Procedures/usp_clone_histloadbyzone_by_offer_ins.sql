
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/16/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_histloadbyzone_by_offer_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

INSERT INTO	lp_historical_info..HistLoadByZone
SELECT		utility, @p_offer_id_clone, usg_dte, zone, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12, 
			H13, H14, H15, H16, H17, H18, H19, H20, H21, H22, H23, H24, GETDATE(), CreatedBy
FROM		lp_historical_info..HistLoadByZone
WHERE		deal_id = @p_offer_id

