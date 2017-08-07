-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/6/2013
-- Description:	Get external enity type
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityTypeSelect] 3
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityTypeSelect]
	@Id int = null
AS
BEGIN
	SET NOCOUNT ON;

    SELECT *
	FROM LibertyPower..ExternalEntityType  (NOLOCK)
	WHERE ID = ISNULL(@Id, ID)
			
	SET NOCOUNT OFF;
END
