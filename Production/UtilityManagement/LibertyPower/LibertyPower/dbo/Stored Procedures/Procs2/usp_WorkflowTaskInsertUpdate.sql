
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Inserts or updates workflow tasks
-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-10-29
-- Description:	Add logic to set the first step of every workflow to tasksequence 1
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskInsertUpdate] 
(
	@WorkflowID         int,
	@WorkflowTaskID     int = 0,
	@TaskSequence		int = 0,
    @TaskTypeId int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	-- AUTO-INCREMENT THE STEP SEQUENCE IN THE ORDER IN WHICH THEY ARE ENTERED
	IF NOT EXISTS ( SELECT	TaskSequence
				FROM	[LibertyPower].[dbo].[WorkflowTask] (nolock)
				WHERE	WorkflowId = @WorkflowId
				AND		isdeleted = 0
			  )
	BEGIN
		SET @TaskSequence = 1
	END
	ELSE
	BEGIN			  	
		SELECT	@TaskSequence = MAX(TaskSequence) + 1
				FROM	[LibertyPower].[dbo].[WorkflowTask] (nolock)
				WHERE	WorkflowId = @WorkflowId
				AND		isdeleted = 0			
	END
	IF (@WorkflowTaskID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowTask]
			   ([WorkflowID]
			   ,[TaskTypeID]
			   ,[TaskSequence]
			   ,[IsDeleted]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@WorkflowID
			   ,@TaskTypeId
			   ,@TaskSequence
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
		
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowTask]
		SET [TaskSequence] = @TaskSequence,
			[TaskTypeId] = @TaskTypeId,
			[UpdatedBy] = @UpdatedBy,
			[DateUpdated] = @DateUpdated
		WHERE WorkflowTaskID = @WorkflowTaskID
		AND WorkflowID = @WorkflowID
	END
		
    
END

----------------------------------------------------------------------------------------------------------


