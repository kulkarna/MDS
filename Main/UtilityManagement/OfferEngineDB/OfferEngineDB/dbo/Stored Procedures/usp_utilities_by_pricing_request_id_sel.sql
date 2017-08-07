
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/25/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_utilities_by_pricing_request_id_sel]

@p_pricing_request_id		varchar(50),
@p_retail_mkt_id			varchar(25)

AS

SELECT		LTRIM(RTRIM(utility_descp)) AS option_id, LTRIM(RTRIM(utility_id)) AS return_value
FROM		lp_common..common_utility WITH (NOLOCK)
WHERE		retail_mkt_id = @p_retail_mkt_id
AND		utility_id IN
(
	SELECT	DISTINCT b.UTILITY
	FROM	OE_PRICING_REQUEST_ACCOUNTS a WITH (NOLOCK) 
			INNER JOIN OE_ACCOUNT b WITH (NOLOCK) ON a.OE_ACCOUNT_ID = b.ID
	WHERE	a.PRICING_REQUEST_ID = @p_pricing_request_id
)
ORDER BY	utility_descp ASC


