	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/29/2009
	-- Description:	Updates a NodeLookup record
	-- =============================================
	create PROCEDURE [dbo].[usp_HierarchyNodeLookupUpdate]
		@NodeLookupId int	
		, @Name	nvarchar(50)
		, @Description nvarchar(50) = null
		, @LookupQuery varchar(1000)
	AS
	BEGIN
		SET NOCOUNT ON;
		
		Update HierarchyNodeLookup
		Set 
			Name = @Name
			, Description = @Description 
			, LookupQuery = @LookupQuery 
		Where
			HierarchyNodeLookupId = @NodeLookupId
	END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HierarchyNodeLookupUpdate';

