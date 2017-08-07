-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 5/1/2013
-- Description:	Updates an external entity record
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityUpdate]
	@ID int 
	,@EntityKey int 
	,@EntityType int 
	,@showAs int
	,@inactive bit
	,@modifiedBy int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE LibertyPower..ExternalEntity 
		SET EntityKey = @EntityKey
			, EntityTypeID =@EntityType
			, Inactive = @inactive
			, Modified = GETDATE() 
			, ModifiedBy = @modifiedBy
			, ShowAs = @showAs
	WHERE ID = @ID        
END
