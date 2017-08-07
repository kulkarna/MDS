
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/26/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_utility_ins]

@p_offer_id			varchar(50),
@p_utility_id		varchar(50)

AS

IF NOT EXISTS (	SELECT	NULL
				FROM	OE_OFFER_UTILITIES WITH (NOLOCK)
				WHERE	OFFER_ID = @p_offer_id AND UTILITY = @p_utility_id)
	BEGIN
		INSERT INTO OE_OFFER_UTILITIES (OFFER_ID, UTILITY)
		VALUES		(@p_offer_id, @p_utility_id)

		IF @@ERROR <> 0 OR @@ROWCOUNT = 0
			SELECT 1
		ELSE
			SELECT 0
	END
ELSE
	SELECT 0

