	-- =============================================
	-- Author:		gworthington
	-- Create date: 10/29/2009
	-- Description:	Delete a NodeLevel record
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyNodeLevelDelete]
		@NodeLevelId int	
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Delete from  HierarchyNodeLevel
			Where HierarchyNodeLevelId = @NodeLevelId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLevelDelete';

