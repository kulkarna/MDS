
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/25/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_utilities_by_offer_id_sel]

@p_offer_id		nvarchar(50)

AS

SELECT	DISTINCT a.UTILITY AS return_value, b.utility_descp AS option_id
FROM	OE_OFFER_UTILITIES a WITH (NOLOCK) INNER JOIN lp_common..common_utility b WITH (NOLOCK) ON a.UTILITY = b.utility_id
WHERE	OFFER_ID = @p_offer_id


