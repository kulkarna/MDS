	-- =============================================
	-- Author:		gworthington
	-- Create date: 10/09/2009
	-- Description:	Gets all NodeLookup records
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeLookupGetAll]
		
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyNodeLookupId, Name, Description, LookupQuery
		From dbo.HierarchyNodeLookup
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLookupGetAll';

