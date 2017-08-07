
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/25/
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_market_by_offer_id_sel]

@p_offer_id		nvarchar(50)

AS

SELECT	DISTINCT a.MARKET AS return_value, b.retail_mkt_descp AS option_id
FROM	OE_OFFER_MARKETS a WITH (NOLOCK) 
		INNER JOIN lp_common..common_retail_market b WITH (NOLOCK) ON a.MARKET = b.retail_mkt_id
WHERE	OFFER_ID = @p_offer_id


