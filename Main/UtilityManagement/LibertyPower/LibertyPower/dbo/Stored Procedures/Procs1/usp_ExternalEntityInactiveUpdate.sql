-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/1/2013
-- Description:	inactivate the specified entity 
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityInactiveUpdate] 23 , 0 , 0 
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityInactiveUpdate]
	@Id int 
	, @Inactive bit
	, @ModifiedBy int 
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE LibertyPower..ExternalEntity 
	SET Inactive = @Inactive , Modified = GETDATE() , ModifiedBy = @ModifiedBy
	WHERE id = @Id
		
	SET NOCOUNT OFF;
END
