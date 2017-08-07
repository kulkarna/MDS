	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Updates a NodeLevel record
	-- =============================================
	CREATE PROCEDURE [dbo].[usp_HierarchyNodeLevelUpdate]
		@NodeLevelId int
		, @HierarchyTemplateId int
		, @ParentId int
		, @NodeTypeId int
		, @Name varchar(50)
		, @NodeLookupId int = null	
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Update HierarchyNodeLevel
		Set 
			HierarchyTemplateId = @HierarchyTemplateId 
			, ParentId = @ParentId 
			, HierarchyNodeTypeId = @NodeTypeId 
			, Name = @Name 
			, HierarchyNodeLookupId = @NodeLookupId 
		Where
			HierarchyNodeLevelId = @NodeLevelId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLevelUpdate';

