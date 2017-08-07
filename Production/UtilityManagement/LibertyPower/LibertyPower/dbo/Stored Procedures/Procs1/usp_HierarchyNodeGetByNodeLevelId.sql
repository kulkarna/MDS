	-- =============================================
	-- Author:		gworthington
	-- Create date: 10/5/2009
	-- Description:	Get Node records by NodeLevelId
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeGetByNodeLevelId]
		@NodeLevelId int
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyNodeId, HierarchyNodeLevelId, ParentId, Value, Description
		From dbo.HierarchyNode
		Where HierarchyNodeLevelId = @NodeLevelId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeGetByNodeLevelId';

