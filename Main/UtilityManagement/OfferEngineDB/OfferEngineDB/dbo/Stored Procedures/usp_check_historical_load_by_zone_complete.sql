
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/10/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_check_historical_load_by_zone_complete]

@p_offer_id		varchar(50),
@p_status		varchar(50)

AS

IF EXISTS (	SELECT	NULL
			FROM	lp_historical_info..HistLoadByZone WITH (NOLOCK)
			WHERE	deal_id = @p_offer_id )
AND		(
			(	SELECT	COUNT(DISTINCT utility)
				FROM	lp_historical_info..HistLoadByZone WITH (NOLOCK)
				WHERE	deal_id = @p_offer_id )
			>= 
			(	SELECT	COUNT(DISTINCT a.Utility)
				FROM	OE_ACCOUNT a WITH (NOLOCK) INNER JOIN OE_OFFER_ACCOUNTS b WITH (NOLOCK) ON a.ID = b.OE_ACCOUNT_ID
				WHERE	b.OFFER_ID = @p_offer_id )
		)
	BEGIN
		UPDATE	OE_OFFER
		SET		STATUS		= @p_status
		WHERE	OFFER_ID	= @p_offer_id
		
		SELECT	'TRUE'
	END
ELSE
	SELECT	'FALSE'




