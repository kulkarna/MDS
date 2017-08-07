	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Inserts a new Node record
	-- =============================================
	CREATE PROCEDURE [dbo].[usp_HierarchyNodeInsert]
		@NodeLevelId int
		, @ParentId int
		, @Value varchar(100)
		, @Description varchar(100)
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Insert into HierarchyNode
		(HierarchyNodeLevelId, ParentId ,Value, Description)
		values
		(@NodeLevelId, @ParentId, @Value, @Description)
		
		Select @@IDENTITY
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeInsert';

