-- =============================================
-- Author:		fmedeiros
-- Create date: 3/23/2013
-- Description:	Insert a new external entity
-- =============================================
-- Modified:	Gail Mangaroo 
-- Modified Date: 5/1/2013
-- Added EntityKey and EntitytypeId
-- =============================================
CREATE PROCEDURE [dbo].[usp_ExternalEntityInsert]
	@EntityKey int 
	,@EntityType int 
	,@showAs int
	,@inactive bit
	,@createdBy int
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO ExternalEntity (EntityKey, EntityTypeID, Inactive, DateCreated, CreatedBy, ShowAs)
	VALUES (@EntityKey,@EntityType, @inactive, GETDATE(), @createdBy, @showAs)
        
    SELECT SCOPE_IDENTITY();
END
