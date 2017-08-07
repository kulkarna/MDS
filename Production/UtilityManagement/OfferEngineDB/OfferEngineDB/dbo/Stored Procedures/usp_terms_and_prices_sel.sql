
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_terms_and_prices_sel] 

@p_flow_start_date_id	varchar(50)

AS

SELECT	ID, TERMS_AND_PRICES_ID, FLOW_START_DATE_ID, 
		ISNULL(TERM, 0) AS TERM, 
		ISNULL(PRICE, 0) AS PRICE
FROM	OE_TERMS_AND_PRICES WITH (NOLOCK)
WHERE	FLOW_START_DATE_ID = @p_flow_start_date_id

