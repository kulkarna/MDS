
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_account_markets_sel] 

@p_pricing_request_id		varchar(50)

AS

SELECT	DISTINCT ISNULL(MARKET, '') AS MARKET
FROM	OE_ACCOUNT a WITH (NOLOCK) 
		INNER JOIN	OE_PRICING_REQUEST_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
WHERE	b.PRICING_REQUEST_ID = @p_pricing_request_id


