-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/1/2013
-- Description:	inactivate the specified property 
-- =============================================
-- exec Libertypower..[usp_PropertyInactiveUpdate] 8 , 0, 0 
-- =============================================
CREATE PROCEDURE [dbo].[usp_PropertyInactiveUpdate]
	@Id int 
	, @Inactive bit
	, @ModifiedBy int 
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE Libertypower..Property 
	SET Inactive = @Inactive , Modified = GETDATE() , ModifiedBy = @ModifiedBy
	WHERE id = @Id
		
	SET NOCOUNT OFF;
END
