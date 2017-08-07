
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/7/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_utility_list_sel]

@p_retail_mkt_id	varchar(25)	= ''

AS

--IF LEN(@p_retail_mkt_id) = 0
--	BEGIN
--		SELECT		'' AS utility_id, ' Select ...' AS utility_descp
--		UNION
--		SELECT		utility_id, utility_descp
--		FROM		lp_common..common_utility
--		ORDER BY	utility_descp
--	END
--ELSE
--	BEGIN
		SELECT		'' AS utility_id, ' Select ...' AS utility_descp
		UNION
		SELECT		utility_id, utility_descp
		FROM		lp_common..common_utility WITH (NOLOCK)
		WHERE		retail_mkt_id = CASE WHEN LEN(@p_retail_mkt_id) = 0 THEN NULL ELSE @p_retail_mkt_id END
		ORDER BY	utility_descp
--	END


