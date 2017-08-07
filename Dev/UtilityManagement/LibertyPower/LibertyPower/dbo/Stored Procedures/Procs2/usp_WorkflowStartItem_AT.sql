

-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Master proc to perform the start transaction for a given item
-- Test:  exec [usp_WorkflowStartItem] '123456','libertypower\atafur'
-- =============================================

CREATE PROCEDURE  [dbo].[usp_WorkflowStartItem_AT] 
(
	@pContractNumber	varchar(50),  -- ITEM NUMBER HAS TO MATCH THE ITEM TYPE FOR THE START TRANSACTION
    @pCreatedBy			nvarchar(50)	=	null,
    @pDateCreated		datetime		=	null,
    @pUpdatedBy			nvarchar(50)	=	null,
    @pDateUpdated		datetime		=	null
)
AS
BEGIN
--EXEC libertypower..[usp_WorkflowStartItem] @ContractId, @ContractTypeID, @CreatedBy
/*DECLARE VARIABLES TO BE USED FOR THIS PROCESS*/	

    DECLARE @WorkflowId INT
    DECLARE @pContractId INT
	DECLARE @pContractTypeId INT

	SET NOCOUNT ON;
	
	SELECT @pContractId = ContractID,
		   @pContractTypeId = ContractTypeId
	FROM LibertyPower..[Contract]
	WHERE Number = @pContractNumber
	
	IF NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTaskHeader
				   WHERE ContractId = @pContractId)
	BEGIN
	
		/*FIND THE WORKFLOWID ASSIGNED FOR THE GIVEN ITEM*/
		SELECT  @WorkflowId = dbo.ufn_GetWorkflowAssignment(@pContractId)
		
		/* INSERT THE WIP HEADER RECORD */
		DECLARE	@TransactionDate datetime
		SET		@TransactionDate = CURRENT_TIMESTAMP

		DECLARE	@vWIPTaskHeaderId int

		EXEC	@vWIPTaskHeaderId = [dbo].[usp_WIPTaskHeaderInsertUpdate]
				@WIPTaskHeaderId	=	0,  -- 0 SINCE WE ARE ONLY MAKING AN INSERT
				@ContractId			=	@pContractId,
				@ContractTypeId		=	@pContractTypeId,
				@WorkflowId			=	@WorkflowId,
				@CreatedBy			=	@pCreatedBy,
				@DateCreated		=	@TransactionDate
		
		/* DETERMINE THE WORKFLOWTASKS FOR THE FOUND WORKFLOW */
		
		SELECT	wt.workflowid, wt.workflowtaskid, t.TaskTypeId
		INTO	#tmpWorkflowTasks 
		FROM	libertypower..workflowtask wt (nolock)
		JOIN	libertypower..tasktype t (nolock)
		ON		wt.tasktypeid = t.tasktypeid
		WHERE	workflowid = @WorkflowId
		AND		wt.IsDeleted = 0
		
		/* INSERT THE WORKFLOWTASKS IN THE WORK IN PROCESS TASK TABLE */
		
		DECLARE @tmpWorkflowTaskId INT
		
		DECLARE cursorTaskId cursor for
			SELECT workflowtaskid from #tmpWorkflowTasks
			
		OPEN cursorTaskId
		
		FETCH NEXT FROM cursorTaskId INTO @tmpWorkflowTaskId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			DECLARE @wTaskStatusId INT
			-- START STEP ON HOLD STATUS FOR ALL TASKTYPES EXCEPT CREDIT CHECK
			
			IF EXISTS (SELECT 1 
			                 FROM #tmpWorkflowTasks
			                 WHERE WorkflowTaskId = @tmpWorkflowTaskId
			                 AND   TaskTypeId = 2)  --	CREDIT CHECK TYPE = 2
			   BEGIN
					SET @wTaskStatusId = 6
					IF NOT EXISTS (SELECT 1 
								   FROM LibertyPower..WorkflowPathLogic
								   WHERE WorkflowTaskId = @tmpWorkflowTaskId
									 AND ConditionTaskStatusId <> 7)
					BEGIN
						SET @wTaskStatusId = 7 --PENDINGSYS
					END
			   END
           ELSE
			   BEGIN
					SET @wTaskStatusId = 6
					IF NOT EXISTS (SELECT 1 
								   FROM LibertyPower..WorkflowPathLogic
								   WHERE WorkflowTaskId = @tmpWorkflowTaskId
									 AND ConditionTaskStatusId <> 2)
					BEGIN
						SET @wTaskStatusId = 2 --PENDING
					END
						       
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
		END
		
		CLOSE cursorTaskId
		
		DEALLOCATE cursorTaskId
		
		--UPDATE WIPT
		--SET TaskStatusId = 2 --PENDING
		--FROM LibertyPower..WIPTask WIPT
		--WHERE WIPT.WIPTaskHeaderId = @vWIPTaskHeaderId
		--  AND NOT EXISTS (SELECT 1 
		--				   FROM LibertyPower..WorkflowPathLogic (NOLOCK)
		--				   WHERE WorkflowTaskId = @tmpWorkflowTaskId
		--					 AND ConditionTaskStatusId <> 2)
		
	END
END

----------------------------------------------------------------------------------------------------------


