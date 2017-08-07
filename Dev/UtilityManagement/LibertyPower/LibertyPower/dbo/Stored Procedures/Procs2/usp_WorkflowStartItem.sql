

-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Master proc to perform the start transaction for a given item
-- Test:  exec [usp_WorkflowStartItem] '123456','libertypower\atafur'
-- =======================================
-- Modified: Jose Munoz 12/12/2012
-- add update status to 01000 10
-- =======================================
-- Modified: Isabelle Tamanini 2/13/2013
-- Adding code to ignore required tasks that are deleted when setting new tasks to pending
-- SR1-63461201
-- =======================================
-- Modified: Isabelle Tamanini 3/15/2013
-- Adding code to set Tablet review step to PENDINGSYS once it is created
-- SR1-78040921
-- =======================================


CREATE PROCEDURE  [dbo].[usp_WorkflowStartItem] 
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
	FROM LibertyPower..[Contract] (NOLOCK)
	WHERE Number = @pContractNumber
	
	IF NOT EXISTS (SELECT 1 FROM LibertyPower..WIPTaskHeader (NOLOCK)
				   WHERE ContractId = @pContractId)
	BEGIN
	
		/*FIND THE WORKFLOWID ASSIGNED FOR THE GIVEN ITEM*/
		SELECT  @WorkflowId = dbo.ufn_GetWorkflowAssignment(@pContractId)
		
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
		
		SELECT	wt.workflowid, wt.workflowtaskid, t.TaskTypeId
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
			
			SET @wTaskStatusId = 6
			IF NOT EXISTS (SELECT 1 
							FROM LibertyPower..WorkflowPathLogic (NOLOCK)
							WHERE WorkflowTaskId = @tmpWorkflowTaskId
								AND ConditionTaskStatusId <> 2
								AND IsDeleted = 0)
			BEGIN
				SET @wTaskStatusId = 2 --PENDING
				
				DECLARE @pTaskType CHAR(30)
				
				SELECT @pTaskType = TT.[TaskName]
				FROM [LibertyPower].[dbo].[WorkflowTask] WT  (NOLOCK)
				JOIN [LibertyPower].[dbo].[TaskType]	 TT  (NOLOCK) ON WT.TaskTypeId = TT.TaskTypeId
				WHERE WT.WorkflowTaskID = @tmpWorkflowTaskId 

				IF (@pTaskType in ('CHECK ACCOUNT', 'CREDIT CHECK', 'DOCUMENTS', 'PRICE VALIDATION', 'TABLET REVIEW'))
				BEGIN
					SELECT @wTaskStatusId = TaskStatusId
					FROM [LibertyPower].[dbo].[TaskStatus] TS (NOLOCK)
					WHERE TS.StatusName = 'PENDINGSYS'
					
					UPDATE Libertypower..AccountStatus
					SET [Status]			= '01000'
					,[SubStatus]			= '10'
					FROM Libertypower..AccountStatus ACS WITH (NOLOCK)
					INNER JOIN Libertypower..AccountContract AC WITH (NOLOCK)
					ON AC.AccountContractID			= ACS.AccountContractID
					WHERE AC.ContractId				= @pContractId
					
				END
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
		
		CLOSE cursorTaskId
		
		DEALLOCATE cursorTaskId
		
	END
END

----------------------------------------------------------------------------------------------------------



