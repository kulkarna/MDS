
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/14/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_offer_status_sel]

@p_offer_id		varchar(50)

AS

SELECT	STATUS
FROM	OE_OFFER WITH (NOLOCK)
WHERE	OFFER_ID = @p_offer_id

