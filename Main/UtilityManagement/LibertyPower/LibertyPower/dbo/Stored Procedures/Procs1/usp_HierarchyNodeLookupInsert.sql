	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Inserts a new NodeLookup record
	-- =============================================
	CREATE PROCEDURE [dbo].[usp_HierarchyNodeLookupInsert]
		@Name nvarchar(50)
		, @Description nvarchar(50) = null
		, @LookupQuery varchar(1000)
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Insert into HierarchyNodeLookup 
		(Name, Description, LookupQuery)
		values
		(@Name, @Description, @LookupQuery)
		
		Select @@IDENTITY
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLookupInsert';

