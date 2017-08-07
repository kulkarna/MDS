-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/10/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_retail_mkt_id_list_sel]

AS

SELECT		LTRIM(RTRIM(retail_mkt_id)) AS retail_mkt_id
FROM		lp_common..common_retail_market WITH (NOLOCK)
