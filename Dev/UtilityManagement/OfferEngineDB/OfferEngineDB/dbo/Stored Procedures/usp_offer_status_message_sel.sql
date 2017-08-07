
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/18/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_status_message_sel]

@p_offer_id		varchar(50),
@p_status		varchar(50)

AS

SELECT	[MESSAGE]
FROM	OE_OFFER_STATUS_MESSAGE WITH (NOLOCK)
WHERE	OFFER_ID	= @p_offer_id
AND		STATUS		= @p_status


