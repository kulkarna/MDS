	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Get Root NodeLevel records by TemplateId
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeLevelRootGetByHierarchyTemplateId]
		@HierarchyTemplateId int
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyNodeLevelId, HierarchyTemplateId, ParentId, HierarchyNodeTypeId, Name, HierarchyNodeLookupId
		From dbo.HierarchyNodeLevel
		Where HierarchyTemplateId = @HierarchyTemplateId
		And ParentId = -1
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLevelRootGetByHierarchyTemplateId';

