

-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-10-25
-- Description:	Proc to start a workflow specifically for a given workflowid
-- Test:  begin tran exec [usp_WorkflowStartByWorkflowId] '2012-0332057',28,'libertypower\atafur'
-- commit / rollback
-- =============================================

CREATE PROCEDURE  [dbo].[usp_WorkflowStartByWorkflowId] 
(
	@pContractNumber	varchar(50),  -- ITEM NUMBER HAS TO MATCH THE ITEM TYPE FOR THE START TRANSACTION
	@pWorkflowId			int	,     -- THE WORKFLOWID IS PASSED IN AND IT'S DETERMINED BASED ON THE NATURE OF THE ITEM
    @pCreatedBy				nvarchar(50)	=	null,
    @pDateCreated			datetime		=	null,
    @pUpdatedBy				nvarchar(50)	=	null,
    @pDateUpdated			datetime		=	null
)
AS
BEGIN

/*DECLARE VARIABLES TO BE USED FOR THIS PROCESS*/	

    DECLARE @WorkflowId INT
    DECLARE @pContractId INT
	DECLARE @pContractTypeId INT

	SET NOCOUNT ON;
	
	SELECT @pContractId = ContractID,
		   @pContractTypeId = ContractTypeId
	FROM LibertyPower..[Contract] (NOLOCK)
	WHERE Number = @pContractNumber
	
	IF NOT EXISTS (SELECT * FROM LibertyPower..WIPTaskHeader (NOLOCK)
				   WHERE ContractId = @pContractId
				     AND WorkflowId = @pWorkflowId)
	BEGIN
	
		/* FIND THE WORKFLOWID ASSIGNED FOR THE GIVEN ITEM */
		SELECT  @WorkflowId = @pWorkflowId
		
		/* INSERT THE WIP HEADER RECORD */
		DECLARE	@TransactionDate datetime
		SET		@TransactionDate = getdate()

		DECLARE	@vWIPTaskHeaderId int

		EXEC	@vWIPTaskHeaderId = [dbo].[usp_WIPTaskHeaderInsertUpdate]
				@WIPTaskHeaderId	=	0,  -- 0 SINCE WE ARE ONLY MAKING AN INSERT
				@ContractId			=	@pContractId,
				@ContractTypeId		=	@pContractTypeId,
				@WorkflowId			=	@WorkflowId,
				@CreatedBy			=	@pCreatedBy,
				@DateCreated		=	@TransactionDate
		
		/* DETERMINE THE WORKFLOWTASKS FOR THE FOUND WORKFLOW */

		SELECT	wt.workflowid, wt.workflowtaskid, t.TaskTypeId, wt.tasksequence
		INTO	#tmpWorkflowTasks 
		FROM	libertypower..workflowtask wt (nolock)
		JOIN	libertypower..tasktype t (nolock)
		ON		wt.tasktypeid = t.tasktypeid
		WHERE	workflowid = @WorkflowId
		AND		wt.IsDeleted = 0

		/* INSERT THE WORKFLOWTASKS IN THE WORK IN PROCESS TASK TABLE */
		
		DECLARE @tmpWorkflowTaskId INT
		
		DECLARE cursorTaskId cursor FAST_FORWARD for
			SELECT workflowtaskid from #tmpWorkflowTasks
			
		OPEN cursorTaskId
		DECLARE @wTaskStatusId INT
		
		FETCH NEXT FROM cursorTaskId INTO @tmpWorkflowTaskId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- START STEP ON HOLD STATUS FOR ALL TASKTYPES
			
			SET @wTaskStatusId = 6 -- HOLD STATUS
			
			-- SET THE STATUS TO PENDING IF IT'S THE FIRST EXECUTION TASK
PRINT 'PROCESSING WORKFLOWTASKID = ' + cast (@tmpWorkflowTaskId as varchar(20)) + ' TO SET THE INITIAL STATUS'

			IF EXISTS (SELECT wt.*
							FROM	LibertyPower..WorkflowTask wt (NOLOCK)-- on wpl.workflowtaskid = wt.workflowtaskid
							WHERE	wt.WorkflowTaskId = @tmpWorkflowTaskId
									AND wt.TaskSequence = 1  -- FIRST EXECUTION TASK IN THE WORKFLOW
									AND wt.IsDeleted <> 1
						   )						  					   
			BEGIN
PRINT 'PROCESSING WORKFLOWTASKID = ' + cast (@tmpWorkflowTaskId as varchar(20)) + ' AS FIRST STEP'			
				SET @wTaskStatusId = 2 --PENDING
			END
						       
PRINT 'PROCESSING [usp_WIPTaskInsertUpdate] WITH TASKSTATUS = ' + cast (@wTaskStatusId as varchar(20))

			/* EXECUTE THE INSERT PROC WITH THE GIVEN PARAMS */
			EXEC	[dbo].[usp_WIPTaskInsertUpdate]
					@WIPTaskId = 0,
					@WIPTaskHeaderId = @vWIPTaskHeaderId,
					@WorkflowTaskId = @tmpWorkflowTaskId,
					@TaskStatusId = @wTaskStatusId,  
					@IsAvailable = 1,
					@CreatedBy = @pCreatedBy

			FETCH NEXT FROM cursorTaskId INTO @tmpWorkflowTaskId
		END
		
		CLOSE cursorTaskId
		
		DEALLOCATE cursorTaskId
		
	END
END

----------------------------------------------------------------------------------------------------------


