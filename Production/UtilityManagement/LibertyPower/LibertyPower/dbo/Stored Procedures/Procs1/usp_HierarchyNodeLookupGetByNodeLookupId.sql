	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Get NodeLookup record by NodeLookupId
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeLookupGetByNodeLookupId]
		@NodeLookupId int
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyNodeLookupId, Name, Description, LookupQuery
		From dbo.HierarchyNodeLookup
		Where HierarchyNodeLookupId = @NodeLookupId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLookupGetByNodeLookupId';

