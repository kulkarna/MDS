
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 7/21/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_file_types_sel]

AS

SELECT		file_type_id, file_type
FROM		pricing_file_type
ORDER BY	file_type
