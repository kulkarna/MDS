-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/21/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_file_type_name_by_id_sel]

@p_file_type_id		int

AS

SELECT	file_type
FROM	pricing_file_type
WHERE	file_type_id = @p_file_type_id
