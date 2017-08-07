

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/5/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_status_upd]

@p_offer_id		varchar(50),
@p_status		varchar(50)

AS

UPDATE	OE_OFFER
SET		STATUS		= @p_status
WHERE	OFFER_ID	= @p_offer_id

EXEC	usp_zprocess_tracking_ins '', @p_offer_id, @p_status, '', 'StatusChange', 'Completed'

