-- =============================================
-- Author:		fmedeiros
-- Create date: 3/25/2013
-- Description:	List all property's type 
-- =============================================
-- exec LibertyPower..[usp_PropertyTypeSelect]  null , 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyTypeSelect]
	@Id int = null,
	@PropertyId int = null
	, @IncludeInactive bit = 0 
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
	   ID
      ,PropertyID
      ,Name
      ,Inactive
      ,DateCreated
      ,CreatedBy
	FROM
		LibertyPower..PropertyType (NOLOCK)
	WHERE 1 =1 
		AND ID = ISNULL(@Id, ID)
		AND PropertyID = ISNULL(@PropertyId, PropertyID)
		AND (Inactive = 0 OR @IncludeInactive = 1 ) -- return inactive records if indicated
			
	SET NOCOUNT OFF;
END
