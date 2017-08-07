

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/21/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_utility_id_list_sel]

AS

SELECT		LTRIM(RTRIM(utility_id)) AS utility_id, LTRIM(RTRIM(account_number_prefix)) AS account_number_prefix, 
			LTRIM(RTRIM(retail_mkt_id)) AS retail_mkt_id
FROM		lp_common..common_utility WITH (NOLOCK)
WHERE		inactive_ind = 0

