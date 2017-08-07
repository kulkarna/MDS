


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/17/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_offer_utilities_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

INSERT INTO	OE_OFFER_UTILITIES
SELECT		@p_offer_id_clone, UTILITY
FROM		OE_OFFER_UTILITIES
WHERE		OFFER_ID = @p_offer_id
