
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/18/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_status_message_ins_upd]

@p_offer_id		varchar(50),
@p_status		varchar(50),
@p_message		text

AS

IF EXISTS (	SELECT	NULL
			FROM	OE_OFFER_STATUS_MESSAGE WITH (NOLOCK)
			WHERE	OFFER_ID	= @p_offer_id
			AND		STATUS		= @p_status)
	BEGIN
		UPDATE	OE_OFFER_STATUS_MESSAGE
		SET		[MESSAGE]		= @p_message,
				DATE_CREATED	= GETDATE()
		WHERE	OFFER_ID		= @p_offer_id
		AND		STATUS			= @p_status
	END
ELSE
	BEGIN
		INSERT INTO	OE_OFFER_STATUS_MESSAGE (OFFER_ID, STATUS, [MESSAGE])
		VALUES		(@p_offer_id, @p_status, @p_message)
	END


