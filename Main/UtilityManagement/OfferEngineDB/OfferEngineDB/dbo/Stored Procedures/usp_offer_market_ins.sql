
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_market_ins]

@p_offer_id			varchar(50),
@p_retail_mkt_id	varchar(25)

AS

IF NOT EXISTS (	SELECT	NULL
				FROM	OE_OFFER_MARKETS WITH (NOLOCK)
				WHERE	OFFER_ID = @p_offer_id AND MARKET = @p_retail_mkt_id)
	BEGIN
		INSERT INTO OE_OFFER_MARKETS (OFFER_ID, MARKET)
		VALUES		(@p_offer_id, @p_retail_mkt_id)

		IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			SELECT 1
		ELSE
			SELECT 0
	END
ELSE
	SELECT 0

