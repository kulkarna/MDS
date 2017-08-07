	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Deletes a Node record
	-- =============================================
	CREATE PROCEDURE [dbo].[usp_HierarchyNodeDelete]
		@NodeId int
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Delete From HierarchyNode
		Where HierarchyNodeId = @NodeId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeDelete';

