-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/5/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_price_request_status_upd]

@p_price_request_id		varchar(50),
@p_status				varchar(50)

AS

UPDATE	OE_PRICING_REQUEST
SET		STATUS		= @p_status
WHERE	REQUEST_ID	= @p_price_request_id

