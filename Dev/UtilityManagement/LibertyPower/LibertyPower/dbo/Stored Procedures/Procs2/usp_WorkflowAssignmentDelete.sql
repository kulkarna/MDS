


-- =============================================
-- Author:		Ryan Russon
-- Create date: 2012-08-10
-- Description:	Deletes a workflow assignment
-- =============================================
CREATE PROCEDURE [dbo].[usp_WorkflowAssignmentDelete] 
(
	@WorkflowAssignmentId	int
)

AS

BEGIN
	
	SET NOCOUNT ON;
	DELETE FROM [LibertyPower]..[WorkflowAssignment]
	WHERE WorkflowAssignmentID = @WorkflowAssignmentID
	
END

