	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Get Node records by ParentId
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeGetByParentId]
		@ParentNodeId int
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyNodeId, HierarchyNodeLevelId, ParentId, Value, Description
		From dbo.HierarchyNode
		Where ParentId = @ParentNodeId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeGetByParentId';

