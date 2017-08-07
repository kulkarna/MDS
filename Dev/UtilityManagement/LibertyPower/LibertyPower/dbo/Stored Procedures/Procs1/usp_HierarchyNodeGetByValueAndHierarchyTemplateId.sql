	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Get Node records by TemplateId and Node value
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeGetByValueAndHierarchyTemplateId]
		@HierarchyTemplateId int
		,@NodeValue nvarchar(100)
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyNode.HierarchyNodeId, HierarchyNode.HierarchyNodeLevelId, HierarchyNode.ParentId, HierarchyNode.Value, HierarchyNode.Description
		From dbo.HierarchyNode
		Join dbo.HierarchyNodeLevel on HierarchyNode.HierarchyNodeLevelId = HierarchyNodeLevel.HierarchyNodeLevelId
		Where HierarchyTemplateId = @HierarchyTemplateId
		And HierarchyNode.Value = @NodeValue
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeGetByValueAndHierarchyTemplateId';

