-- =============================================
-- Author:		Al Tafur
-- Create date: 10/29/2012
-- Description:	Returns 1 If the workflow task passed in is the last one in the workflow given
-- =============================================
CREATE FUNCTION [dbo].[ufn_IsLastWorkflowTask] 
(
	@pWorkflowTaskId	int,
	@pWorkflowId		int
)
RETURNS int
AS
BEGIN

		DECLARE @MaxSequence			INT
		DECLARE @CurrentTaskSequence	INT
		DECLARE @IsLastTask				INT
		
		SET @IsLastTask = 0

		-- IDENTIFY THE MAXIMUM TASKSEQUENCE FOR THE GIVEN WORKFLOW
		SELECT	@MaxSequence = MAX(TaskSequence) 
		FROM	LibertyPower..workflowtask (nolock)
		WHERE	WorkflowId = @pWorkflowId

		-- IDENTIFY THE TASKSEQUENCE FOR THE GIVEN WORKFLOW TASK
		SELECT	@CurrentTaskSequence = TaskSequence
		FROM	LibertyPower..workflowtask (nolock)
		WHERE	WorkflowTaskId = @pWorkflowTaskId

		-- COMPARE THE SEQUENCES TO IDENTIFY IF IT'S THE LAST TASK IN THE WORKFLOW
		IF @CurrentTaskSequence = @MaxSequence
		BEGIN
			SET @IsLastTask = 1
		END

		RETURN @IsLastTask

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_IsLastWorkflowTask] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_IsLastWorkflowTask] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

