-- =============================================
-- Author:		fmedeiros
-- Create date: 3/23/2013
-- Description:	Insert a new external entity
-- =============================================
-- Modified :   Gail Mangaroo 
--			:	5/2/2013
--			:	Added additional Feilds.
-- ============================================
-- exec 
-- ============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueInsert]
	@value varchar(100)
	, @internalRefId int
	, @propertyId int 
	, @propertyTypeId int 
	, @inactive bit
	, @createdBy int
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO LibertyPower..PropertyValue
	(Value, InternalRefID, propertyId, propertyTypeId, Inactive, DateCreated, CreatedBy)
	VALUES
	(@value, @internalRefId,@propertyId, @inactive,@propertyTypeId,  GETDATE(), @createdBy)
        
    SELECT SCOPE_IDENTITY();
END
