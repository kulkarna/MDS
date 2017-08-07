

-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/21/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_file_by_id_sel]

@p_pricing_id	int

AS

SELECT		p.pricing_id, p.retail_mkt_id, p.utility_id, p.display_name, 
			p.[file_name], p.file_path, p.link, p.file_type, ISNULL(t.file_type, '') AS file_type_name, 
			p.has_sub_menu, p.menu_level, p.pricing_id_parent
FROM		pricing p LEFT JOIN pricing_file_type t ON p.file_type = t.file_type_id
WHERE		p.pricing_id = @p_pricing_id

