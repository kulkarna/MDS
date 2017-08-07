


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_markets_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

INSERT INTO	OE_OFFER_MARKETS
SELECT		@p_offer_id_clone, MARKET
FROM		OE_OFFER_MARKETS
WHERE		OFFER_ID = @p_offer_id
