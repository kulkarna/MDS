	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Get a Node record by NodeId
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeGetByNodeId]
		@NodeId int
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyNodeId, HierarchyNodeLevelId, ParentId, Value, Description
		From dbo.HierarchyNode
		Where HierarchyNodeId = @NodeId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeGetByNodeId';

