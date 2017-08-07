
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 5/8/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_name_key_required_length_sel]

AS

SELECT	utility_id, required_length
FROM	lp_common..utility_required_data WITH (NOLOCK)
WHERE	account_info_field = 'name_key'

