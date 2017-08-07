
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow by id
-- =============================================

CREATE PROCEDURE usp_WorkflowSelect 
(
	@WorkflowID int = null
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
	FROM [LibertyPower].[dbo].[Workflow] W (NOLOCK)
	WHERE (@WorkflowID is null OR W.WorkflowID = @WorkflowID)
	  AND (IsDeleted is null OR IsDeleted = 0)
    
END
