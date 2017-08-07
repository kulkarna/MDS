-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 4/26/2013
-- Description:	Get External References
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetExternalEntityById]
	@Id int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT  *     
	FROM
	    ExternalEntity
	
	WHERE 
		Inactive = 0
		AND ID = ISNULL(@Id, ID)
		
END
