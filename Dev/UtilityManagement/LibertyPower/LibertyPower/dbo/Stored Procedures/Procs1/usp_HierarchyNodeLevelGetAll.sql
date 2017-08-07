-- =============================================
-- Author:		gworthington
-- Create date: 10/26/2009
-- Description:	Get all NodeLevel records
-- =============================================
Create PROCEDURE [dbo].[usp_HierarchyNodeLevelGetAll]
	
AS
BEGIN
	SET NOCOUNT ON;
	
	Select HierarchyNodeLevelId, HierarchyTemplateId, ParentId, HierarchyNodeTypeId, Name, HierarchyNodeLookupId
	From dbo.HierarchyNodeLevel
	
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLevelGetAll';

