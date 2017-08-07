
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/22/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_flow_start_dates_sel]

@p_offer_id		varchar(50)

AS

SELECT	ID, FLOW_START_DATE_ID, OFFER_ID, ISNULL(FLOW_START_DATE, '') AS FLOW_START_DATE
FROM	OE_OFFER_FLOW_DATES WITH (NOLOCK)
WHERE	OFFER_ID = @p_offer_id

