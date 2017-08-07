-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/1/2013
-- Description:	inactivate the specified entity 
-- =============================================
-- exec LibertyPower..[usp_ExternalEntityValueInactiveUpdate] 8468 , 0 , 0
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityValueInactiveUpdate]
	@Id int 
	, @Inactive bit
	, @ModifiedBy int 
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE LibertyPower..ExternalEntityValue 
	SET Inactive = @Inactive , Modified = GETDATE() , ModifiedBy = @ModifiedBy
	WHERE id = @Id
		
	SET NOCOUNT OFF;
END
