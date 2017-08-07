
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Returns the path logics for a task
-- =============================================

CREATE PROCEDURE usp_WorkflowPathLogicSelect 
(
	@WorkflowTaskID int
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT WPL.[WorkflowPathLogicID]
		  ,WPL.[WorkflowTaskID]
		  ,WPL.[WorkflowTaskIDRequired]
		  ,WPL.[ConditionTaskStatusID]
		  ,WPL.[CreatedBy]
		  ,WPL.[DateCreated]
		  ,WPL.[UpdatedBy]
		  ,WPL.[DateUpdated]
		  ,TS.[StatusName]
		  ,TS.[IsActive] AS IsActiveTaskStatus
	FROM [LibertyPower].[dbo].[WorkflowPathLogic] WPL (NOLOCK)
	JOIN [LibertyPower].[dbo].[TaskStatus] TS         (NOLOCK) ON WPL.ConditionTaskStatusID = TS.TaskStatusID
	WHERE (WPL.IsDeleted is null OR WPL.IsDeleted = 0)
	  AND WPL.WorkflowTaskID = @WorkflowTaskID
    
END
