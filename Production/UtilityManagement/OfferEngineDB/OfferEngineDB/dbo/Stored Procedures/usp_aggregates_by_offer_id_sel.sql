
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_aggregates_by_offer_id_sel]

@p_offer_id		varchar(50)

AS

SELECT	UTILITY, ZONE, ICAP, TCAP, LOSSES, ACCEPT
FROM	OE_OFFER_AGGREGATES WITH (NOLOCK)
WHERE	OFFER_ID = @p_offer_id


