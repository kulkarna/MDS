	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Updates a Node record
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeUpdate]
		@NodeId int
		, @NodeLevelId int
		, @ParentId int
		, @Value varchar(100)
		, @Description varchar(100)
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Update HierarchyNode
		Set 
			HierarchyNodeLevelId = @NodeLevelId
			, ParentId = @ParentId
			, Value = @Value
			, Description = @Description
		Where
			HierarchyNodeId = @NodeId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeUpdate';

