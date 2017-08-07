-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_aggregates_by_offer_id_ins]

@p_offer_id		varchar(50),
@p_utility		varchar(50),
@p_zone			varchar(50),
@p_icap			float,
@p_tcap			float,
@p_losses		float,
@p_accept		int

AS

SET			@p_utility = REPLACE(@p_utility, '&amp;', '&')

DELETE FROM	OE_OFFER_AGGREGATES
WHERE		OFFER_ID	= @p_offer_id
AND			UTILITY		= @p_utility
AND			(ZONE		= @p_zone OR ZONE IS NULL OR LEN(ZONE) = 0)

INSERT INTO	OE_OFFER_AGGREGATES (OFFER_ID, UTILITY, ZONE, ICAP, TCAP, LOSSES, ACCEPT)
VALUES		(@p_offer_id, @p_utility, @p_zone, @p_icap, @p_tcap, @p_losses, @p_accept)




