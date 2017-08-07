-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/25/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_price_files_del]

@p_price_request_id		varchar(50),
@p_offer_id				varchar(50)

AS

DELETE FROM	OE_OFFER_PRICE_FILES
WHERE		REQUEST_ID	= @p_price_request_id
AND			OFFER_ID	= @p_offer_id
