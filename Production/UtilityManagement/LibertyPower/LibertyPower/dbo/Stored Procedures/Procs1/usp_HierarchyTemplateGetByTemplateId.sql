	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Get a HierarchyTemplate by HierarchyTemplateId
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyTemplateGetByTemplateId]
		@HierarchyTemplateId int
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Select HierarchyTemplateId, Name, Description
		From dbo.HierarchyTemplate
		Where HierarchyTemplateId = @HierarchyTemplateId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyTemplateGetByTemplateId';

