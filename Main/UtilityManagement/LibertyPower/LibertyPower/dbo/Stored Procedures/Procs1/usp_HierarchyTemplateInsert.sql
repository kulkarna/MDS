	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Inserts a new HierarchyTemplate record
	-- =============================================
	Create PROCEDURE [dbo].[usp_HierarchyTemplateInsert]
		@Name varchar(50)
		, @Description varchar(150)
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Insert into HierarchyTemplate
		( Name, Description)
		values
		(@Name, @Description)
		
		Select @@IDENTITY
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyTemplateInsert';

