


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_price_request_offer_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

INSERT INTO	OE_PRICING_REQUEST_OFFER
SELECT		REQUEST_ID, @p_offer_id_clone
FROM		OE_PRICING_REQUEST_OFFER
WHERE		OFFER_ID = @p_offer_id




