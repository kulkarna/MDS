
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Inserts or updates workflow path logics
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowPathLogicInsertUpdate] 
(
	@WorkflowPathLogicID    int = 0,
	@WorkflowTaskID         int,
	@WorkflowTaskIDRequired int,
	@ConditionTaskStatusID  int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkflowPathLogicID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowPathLogic]
				   ([WorkflowTaskID]
				   ,[WorkflowTaskIDRequired]
				   ,[ConditionTaskStatusID]
				   ,[CreatedBy]
				   ,[DateCreated]
				   ,[UpdatedBy]
				   ,[DateUpdated]
				   ,[IsDeleted])
			 VALUES
				   (@WorkflowTaskID
				   ,@WorkflowTaskIDRequired
				   ,@ConditionTaskStatusID
				   ,@CreatedBy
				   ,@DateCreated
				   ,@UpdatedBy
				   ,@DateUpdated
				   ,0)
			   
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowPathLogic]
		   SET [WorkflowTaskID] = @WorkflowTaskID
			  ,[WorkflowTaskIDRequired] = @WorkflowTaskIDRequired
			  ,[ConditionTaskStatusID] = @ConditionTaskStatusID
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		WHERE WorkflowPathLogicID = @WorkflowPathLogicID
	END
		
    
END

----------------------------------------------------------------------------------------------------------


