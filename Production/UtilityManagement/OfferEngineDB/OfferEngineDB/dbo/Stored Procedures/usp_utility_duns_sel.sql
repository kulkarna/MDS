
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/2/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_utility_duns_sel]

@p_utility_id		varchar(50)

AS

SELECT	u.duns_number, CASE WHEN @p_utility_id = 'DELDE' THEN e.duns_number + 'P' ELSE e.duns_number END
FROM	lp_common..common_utility u WITH (NOLOCK) 
		INNER JOIN lp_common..common_entity e WITH (NOLOCK) ON u.entity_id = e.entity_id
WHERE	u.utility_id = @p_utility_id


