-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/12/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_annual_usage_sel]

@p_offer_id		varchar(50)

AS

SELECT	SUM(b.ANNUAL_USAGE) AS TOTAL_ANNUAL_USAGE
FROM	OE_OFFER_ACCOUNTS a INNER JOIN OE_ACCOUNT b ON a.OE_ACCOUNT_ID = b.ID
WHERE	a.OFFER_ID = @p_offer_id 
