
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/8/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_name_key_required_length_by_utility_sel]

@p_utility_id		varchar(50)

AS

SELECT	required_length
FROM	lp_common..utility_required_data WITH (NOLOCK)
WHERE	utility_id = @p_utility_id AND account_info_field = 'name_key'


