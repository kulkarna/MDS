
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Returns workflow task logics of a 
-- workflow task
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicSelect] 
(
	@WorkflowTaskLogicID int = null,
	@WorkflowTaskID      int
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [WorkflowTaskLogicID]
		  ,[WorkflowTaskID]
		  ,[LogicParam]
		  ,[LogicCondition]
		  ,[IsAutomated]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	 FROM [LibertyPower].[dbo].[WorkflowTaskLogic]
	 WHERE WorkflowTaskID = @WorkflowTaskID
	   AND (@WorkflowTaskLogicID is null OR WorkflowTaskLogicID = @WorkflowTaskID) 
	   AND (IsDeleted is null OR IsDeleted = 0)
		
    
END
