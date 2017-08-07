USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskHasLogicCheck]    Script Date: 08/13/2012 19:13:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==========================================================================================
-- Author:		Al Tafur
-- Create date: 2012-07-09
-- Description:	Checks if a specific workflowtask has logic assigned
-- test:  exec usp_workflowtaskhaslogiccheck 4
-- ==========================================================================================

CREATE PROCEDURE  [dbo].[usp_WorkflowTaskHasLogicCheck] 
(
	@WorkflowTaskID      int
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT count(*)
  FROM [LibertyPower].[dbo].[WorkflowPathLogic]
  WHERE WorkflowTaskID = @WorkflowTaskID
	
    
END


GO


