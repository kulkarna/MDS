

-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Master proc to perform the start transaction for a given item
-- Test:  exec [usp_WorkflowStartItem] '123456','libertypower\atafur'
-- =============================================

CREATE PROCEDURE  [dbo].[usp_WorkflowStartMigration043_especial] 
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
		AND @pContractId IS NOT NULL
		AND @pContractTypeId IS NOT NULL
	BEGIN
	
		/*FIND THE WORKFLOWID ASSIGNED FOR THE GIVEN ITEM*/
		SELECT  @WorkflowId = dbo.ufn_GetWorkflowAssignment(@pContractId)
		
		/* INSERT THE WIP HEADER RECORD */
		DECLARE	@TransactionDate datetime
		SET		@TransactionDate = CURRENT_TIMESTAMP

		DECLARE	@vWIPTaskHeaderId int

		EXEC	@vWIPTaskHeaderId	= [dbo].[usp_WIPTaskHeaderInsertUpdate]
				@WIPTaskHeaderId	=	0,  -- 0 SINCE WE ARE ONLY MAKING AN INSERT
				@ContractId			=	@pContractId,
				@ContractTypeId		=	@pContractTypeId,
				@WorkflowId			=	@WorkflowId,
				@CreatedBy			=	@pCreatedBy,
				@DateCreated		=	@TransactionDate
		
		DECLARE	@DummyWIPTaskHeaderId int

		EXEC	@DummyWIPTaskHeaderId	= [dbo].[usp_WIPTaskHeaderInsertUpdate]
				@WIPTaskHeaderId		=	0,  -- 0 SINCE WE ARE ONLY MAKING AN INSERT
				@ContractId				=	@pContractId,
				@ContractTypeId			=	@pContractTypeId,
				@WorkflowId				=	@WorkflowId,
				@CreatedBy				=	@pCreatedBy,
				@DateCreated			=	@TransactionDate
		
		/* DETERMINE THE WORKFLOWTASKS FOR THE FOUND WORKFLOW */
		
		SELECT	wt.workflowid, wt.workflowtaskid, t.taskname
		INTO	#tmpWorkflowTasks 
		FROM	libertypower..workflowtask wt (nolock)
		JOIN	libertypower..tasktype t (nolock) ON wt.tasktypeid = t.tasktypeid
		WHERE	workflowid = @WorkflowId AND wt.IsDeleted = 0
		
		SELECT	wt.workflowid, wt.workflowtaskid, t.taskname
		INTO	#tmpDummyWorkflowTasks 
		FROM	libertypower..workflowtask wt (nolock)
		JOIN	libertypower..tasktype t (nolock) ON wt.tasktypeid = t.tasktypeid
		WHERE	workflowid = 0
		
		SELECT ca.check_type, ca.approval_status, ca.approval_comments, ca.approval_eff_date, ca.date_created
		INTO #check_account
		FROM lp_enrollment..check_account_bak ca (nolock)
		WHERE ca.contract_nbr = @pContractNumber
		/* INSERT THE WORKFLOWTASKS IN THE WORK IN PROCESS TASK TABLE */
		
		DECLARE @tmpWorkflowTaskId INT
		--SELECT workflowtaskid from #tmpWorkflowTasks
		
		-- Transfer the steps which are inline with the workflow assigned.
		INSERT INTO [LibertyPower].[dbo].[WIPTask]
		      (WIPTaskHeaderId  , WorkflowTaskId    , TaskStatusId   , IsAvailable, CreatedBy  , DateCreated    , UpdatedBy  , DateUpdated         , TaskComment)
		SELECT @vWIPTaskHeaderId, wft.workflowtaskid, ts.TaskStatusID, 1          , @pCreatedBy, ca.date_created, @pCreatedBy, ca.approval_eff_date, ca.approval_comments
		FROM #check_account ca (nolock)
		JOIN #tmpWorkflowTasks wft ON ca.check_type = wft.taskname
		JOIN LibertyPower.dbo.TaskStatus ts ON ca.approval_status = ts.StatusName
		
		-- Transfer the steps which are not part of the current workflow design.  These still need a home.
		INSERT INTO [LibertyPower].[dbo].[WIPTask]
		      (WIPTaskHeaderId      , WorkflowTaskId     , TaskStatusId   , IsAvailable, CreatedBy  , DateCreated      , UpdatedBy  , DateUpdated         , TaskComment)
		SELECT @DummyWIPTaskHeaderId, dwft.workflowtaskid, ts.TaskStatusID, 1          , @pCreatedBy, ca.date_created  , @pCreatedBy, ca.approval_eff_date, ca.approval_comments
		FROM #check_account ca (nolock)
		LEFT JOIN #tmpWorkflowTasks wft ON ca.check_type = wft.taskname
		JOIN #tmpDummyWorkflowTasks dwft ON ca.check_type = dwft.taskname
		JOIN LibertyPower.dbo.TaskStatus ts ON ca.approval_status = ts.StatusName
		WHERE wft.workflowtaskid IS NULL
		
		-- If the contract is still in progress, we need to create the future steps as "ONHOLD"
		IF EXISTS (select * from #check_account where approval_status in ('PENDINGSYS','PENDING','INCOMPLETE'))
		BEGIN
			INSERT INTO [LibertyPower].[dbo].[WIPTask]
				  (WIPTaskHeaderId  , WorkflowTaskId    , TaskStatusId, IsAvailable, CreatedBy  , DateCreated, UpdatedBy  , DateUpdated         , TaskComment)
			SELECT @vWIPTaskHeaderId, wft.workflowtaskid, 6			  , 1          , @pCreatedBy, getdate()  , @pCreatedBy, ca.approval_eff_date, ca.approval_comments
			FROM #check_account ca (nolock)
			RIGHT JOIN #tmpWorkflowTasks wft ON ca.check_type = wft.taskname
			WHERE ca.check_type IS NULL		
			AND wft.taskname <> 'CHECK ACCOUNT'
		END
		
		RETURN 1
	END
	ELSE
	BEGIN
		RETURN 0
	END
END


