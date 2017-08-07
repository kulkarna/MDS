	-- =============================================
	-- Author:		gworthington
	-- Create date: 11/16/2009
	-- Description:	Deletes a new HierarchyTemplate record
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyTemplateDelete]
		@HierarchyTemplateId int

	AS
	BEGIN
		SET NOCOUNT ON;
		
		Delete From HierarchyTemplate
		Where
			HierarchyTemplateId = @HierarchyTemplateId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyTemplateDelete';

