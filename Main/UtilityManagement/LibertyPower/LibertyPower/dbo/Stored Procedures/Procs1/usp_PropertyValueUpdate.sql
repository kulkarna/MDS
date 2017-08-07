-- =============================================
-- Author:		fmedeiros
-- Create date: 3/23/2013
-- Description:	Insert a new external entity
-- =============================================
-- Modified :   Gail Mangaroo 
--			:	5/2/2013
--			:	Added additional Feilds.
-- ============================================
-- 
-- ============================================
CREATE PROCEDURE [dbo].[usp_PropertyValueUpdate]
	 @id int 
	, @value varchar(100)
	, @internalRefId int
	, @propertyId int 
	, @propertyTypeId int 
	, @inactive bit
	, @modifiedBy int
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE LibertyPower..PropertyValue
	SET Value = @value
		, InternalRefID = @internalRefId
		, PropertyId = @propertyId 
		, PropertyTypeId = @propertyTypeId
		, Inactive = @inactive
		, Modified = GETDATE()
		, ModifiedBy = @modifiedBy
	WHERE ID = @id
	
END
