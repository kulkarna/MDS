
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_markets_by_pricing_request_id_sel]

@p_pricing_request_id		varchar(50)

AS

SELECT		' Select Market...' AS option_id, '' AS return_value
UNION
SELECT		retail_mkt_descp AS option_id, retail_mkt_id AS return_value
FROM		lp_common..common_retail_market WITH (NOLOCK)
WHERE		retail_mkt_id IN
(
	SELECT	DISTINCT b.MARKET
	FROM	OE_PRICING_REQUEST_ACCOUNTS a WITH (NOLOCK) 
			INNER JOIN OE_ACCOUNT b WITH (NOLOCK) ON  a.OE_ACCOUNT_ID = b.ID
	WHERE	a.PRICING_REQUEST_ID = @p_pricing_request_id
)
ORDER BY	option_id

