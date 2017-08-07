-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/25/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_product_by_utility_id_sel]

@p_utility_id			varchar(50)

AS

SELECT	a.product_id AS option_od, a.product_descp AS return_value
FROM	common_product a WITH (NOLOCK), common_views b WITH (NOLOCK)
WHERE	a.utility_id = @p_utility_id
AND		b.process_id	= 'INACTIVE IND'
AND		b.return_value	= a.inactive_ind
