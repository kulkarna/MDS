USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow tasks by workflow id
-- =============================================

CREATE PROCEDURE usp_WorkflowTaskSelect 
(
	@WorkflowID		int = null,
	@WorkflowTaskID int = null
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT W.[WorkflowID]
		  ,W.[WorkflowName]
		  ,W.[WorkflowDescription]
		  ,W.[IsActive] AS IsActiveWorkflow
		  ,W.[Version]
		  ,W.[IsRevisionOfRecord] 
		  ,WT.[WorkflowTaskID]
		  ,WT.[TaskTypeID]
		  ,WT.[TaskSequence]
		  ,TT.[TaskName]
		  ,TT.[IsActive] AS IsActiveTaskType
	FROM [LibertyPower].[dbo].[Workflow]		 W   (NOLOCK)
	JOIN [LibertyPower].[dbo].[WorkflowTask]	 WT  (NOLOCK) ON W.WorkflowID = WT.WorkflowID
	JOIN [LibertyPower].[dbo].[TaskType]		 TT  (NOLOCK) ON WT.TaskTypeID = TT.TaskTypeID
	WHERE (@WorkflowID is null OR W.WorkflowID = @WorkflowID)
	  AND (@WorkflowTaskID is null OR WT.WorkflowTaskID = @WorkflowTaskID)
	  AND (WT.IsDeleted is null OR WT.IsDeleted = 0)
	ORDER BY WT.[TaskSequence]
    
END
GO
