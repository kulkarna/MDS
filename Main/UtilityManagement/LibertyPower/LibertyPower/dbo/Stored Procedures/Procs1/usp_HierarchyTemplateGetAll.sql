	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Get all HierarchyTemplate records
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyTemplateGetAll]
		
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyTemplateId, Name, Description
		From dbo.HierarchyTemplate

	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyTemplateGetAll';

