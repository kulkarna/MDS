
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/7/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_market_list_sel]

@p_pricing_request_id	varchar(50)	= '',
@p_offer_id				varchar(50)	= ''

AS

IF LEN(@p_pricing_request_id) = 0 AND LEN(@p_offer_id) = 0
	BEGIN
		SELECT		'' AS retail_mkt_id, ' Select ...' AS retail_mkt_descp
		UNION
		SELECT		retail_mkt_id, retail_mkt_descp + ' (' + LTRIM(RTRIM(wholesale_mkt_id)) + ')' AS retail_mkt_descp
		FROM		lp_common..common_retail_market WITH (NOLOCK)
		ORDER BY	retail_mkt_descp
	END
ELSE IF LEN(@p_pricing_request_id) > 0
	BEGIN
		SELECT		'' AS retail_mkt_id, ' Select ...' AS retail_mkt_descp
		UNION
		SELECT		retail_mkt_id, retail_mkt_descp + ' (' + LTRIM(RTRIM(wholesale_mkt_id)) + ')' AS retail_mkt_descp
		FROM		lp_common..common_retail_market WITH (NOLOCK)
		WHERE		retail_mkt_id IN (	SELECT	DISTINCT b.MARKET
										FROM	OE_PRICING_REQUEST_ACCOUNTS a WITH (NOLOCK)
												INNER JOIN OE_ACCOUNT b WITH (NOLOCK) ON a.OE_ACCOUNT_ID = b.ID
										WHERE	a.PRICING_REQUEST_ID = @p_pricing_request_id )
		ORDER BY	retail_mkt_descp
	END
ELSE
	BEGIN
		SELECT		'' AS retail_mkt_id, ' Select ...' AS retail_mkt_descp
		UNION
		SELECT		retail_mkt_id, retail_mkt_descp + ' (' + LTRIM(RTRIM(wholesale_mkt_id)) + ')' AS retail_mkt_descp
		FROM		lp_common..common_retail_market WITH (NOLOCK)
		WHERE		retail_mkt_id IN (	SELECT	DISTINCT b.MARKET
										FROM	OE_OFFER_ACCOUNTS a WITH (NOLOCK)
												INNER JOIN OE_ACCOUNT b WITH (NOLOCK) ON a.OE_ACCOUNT_ID = b.ID
										WHERE	a.OFFER_ID = @p_offer_id )
		ORDER BY	retail_mkt_descp
	END

