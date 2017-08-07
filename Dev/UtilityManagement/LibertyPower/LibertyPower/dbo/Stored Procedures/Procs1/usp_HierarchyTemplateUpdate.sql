	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Updates a new HierarchyTemplate record
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyTemplateUpdate]
		@HierarchyTemplateId int
		, @Name varchar(50)
		, @Description varchar(150)
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Update HierarchyTemplate
		Set 
			Name = @Name
			, Description = @Description
		Where
			HierarchyTemplateId = @HierarchyTemplateId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyTemplateUpdate';

