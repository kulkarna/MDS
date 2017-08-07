	-- =============================================
	-- Author:		gworthington
	-- Create date: 9/22/09
	-- Description:	Returns the Hierarchy for a given Template
	-- =============================================
	CREATE PROCEDURE [dbo].[GetTemplateHierarchy] 
		@TemplateId int
	AS 
	BEGIN 
		SET NOCOUNT ON;

	-- --For Debugging-----------
	--DECLARE	@TemplateId int
	--SET		@TemplateId = 1
	-- --------------------------
		declare @CurrentLevelId int					-- Keep track of where we are in the Hierarchy template
		declare @CurrentLevelCounter int			-- Keep count of how many levels.
		declare @SelectString varchar(max)			-- String to hold the SELECT statement columns and Aliases
		declare @OrderString varchar(max)			-- String to hold the ORDER statement columns
		declare @JoinString varchar(max)			-- String to hold the Joins for each level
		Declare @CurrentLevelAlias as varchar(100)	-- Used to create an alias for the join to the Current Level
		Declare @ParentLevelAlias as varchar(100)	-- Used to create an alias for the join to the Child Level
		
		Set @CurrentLevelId = -1					-- We start from the Root level of the Template
		set @CurrentLevelCounter = 0				-- We'll have a zero based counter.
		Set @SelectString = ''
		Set @OrderString = ''
		Set @JoinString = ''

		Declare @ContinueLoop int					-- Determine if we should continue looping.  A Zero means we should stop

		While Exists(Select 1 From HierarchyNodeLevel 
						Where HierarchyTemplateId = @TemplateId
						And ParentId = @CurrentLevelId)
		BEGIN
			-- Determine the child level's Id
			Select @CurrentLevelId = HierarchyNodeLevelId 
			From HierarchyNodeLevel where HierarchyTemplateId = @TemplateId
			And ParentId = @CurrentLevelId

			-- create node aliases for the current node and its child node
			Set @CurrentLevelAlias = 'N'+cast(@CurrentLevelCounter as varchar(10))
			Set @ParentLevelAlias = 'N'+cast((@CurrentLevelCounter - 1)as varchar(10))
			
			-- Determine if the Current level has children levels 
			Select @ContinueLoop = count(HierarchyNodeLevelId)
			From HierarchyNodeLevel Where HierarchyTemplateId = @TemplateId
			And ParentId = @CurrentLevelId
			Declare @DisplayName varchar(50)
			
			-- Get column's display name from the NodeLevel table.
			Select @DisplayName = Name From HierarchyNodeLevel where HierarchyNodeLevelId = @CurrentLevelId
			-- Build the Select and Order strings.
			Set @SelectString = @SelectString + @CurrentLevelAlias +'.Value as [' + @DisplayName + ']' 
			Set @OrderString = @OrderString + @CurrentLevelAlias +'.Value ' 
			 
			If @ContinueLoop = 1
			Begin
				Set @SelectString = @SelectString + ', '
				Set @OrderString = @OrderString + ', '
			End
			If @CurrentLevelCounter > 0
				Begin
				-- Create a join string to join the current node level to its children.
				Set @JoinString = @JoinString + ' Left Outer Join LibertyPower..Node '+ @CurrentLevelAlias 
						+ ' on '+ @ParentLevelAlias +'.NodeId = '+ @CurrentLevelAlias +'.ParentId'
						
				End					
			Set @CurrentLevelCounter = @CurrentLevelCounter + 1		
		END

		-- Put the pieces together
		Declare @SqlString varchar(max)
		set @SqlString = 'Select ' + @SelectString 
			+ ' From HierarchyNodeLevel NL ' 
			+ ' Left outer Join LibertyPower..HierarchyNode N0 on N0.HierarchyNodeLevelId = NL.HierarchyNodeLevelId ' 
			+ @JoinString 
			+ ' Where NL.parentId = -1 And NL.HierarchyTemplateID = ' + cast(@TemplateId as varchar(3))
			+ ' Order By ' + @OrderString
		print @SqlString
		-- Execute the generated sql statement
		exec(@SqlString)
	END
