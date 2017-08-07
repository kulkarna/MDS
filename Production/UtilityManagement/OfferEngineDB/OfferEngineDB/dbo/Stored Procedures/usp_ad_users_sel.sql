
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/20/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_ad_users_sel]

AS

SELECT		0 AS [USER_ID], '0' AS USERNAME, '' AS [NAME], '' AS LASTNAME, 0 AS APPROVAL_THRESHOLD, 3 AS ROL_ID, '' AS MATPRICE_PATH, 'Select Analyst' AS FULLNAME
UNION
SELECT		[USER_ID], USERNAME, [NAME], LASTNAME, APPROVAL_THRESHOLD, ROL_ID, MATPRICE_PATH, (LEFT([NAME], 1) + ' ' + LASTNAME) AS FULLNAME
FROM		AD_USER WITH (NOLOCK)
ORDER BY	[NAME]


