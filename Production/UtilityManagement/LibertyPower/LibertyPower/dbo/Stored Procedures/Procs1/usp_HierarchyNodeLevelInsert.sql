	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Inserts a new NodeLevel record
	-- =============================================
	CREATE PROCEDURE [dbo].[usp_HierarchyNodeLevelInsert]
		@HierarchyTemplateId int
		, @ParentId int
		, @NodeTypeId int
		, @Name varchar(50)
		, @NodeLookupId int	= null
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Insert into HierarchyNodeLevel
		(HierarchyTemplateId, ParentId, HierarchyNodeTypeId, Name, HierarchyNodeLookupId)
		values
		(@HierarchyTemplateId, @ParentId, @NodeTypeId, @Name, @NodeLookupId)
		
		Select @@IDENTITY
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLevelInsert';

