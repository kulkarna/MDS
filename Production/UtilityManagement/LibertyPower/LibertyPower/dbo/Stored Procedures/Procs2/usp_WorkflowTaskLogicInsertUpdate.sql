
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Inserts or updates workflow task logics
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicInsertUpdate] 
(
	@WorkflowTaskLogicID int = 0,
	@WorkflowTaskID      int,
	@LogicParam			 nvarchar(50),
    @LogicCondition		 int,
    @IsAutomated		 bit,
    @CreatedBy			 nvarchar(50) = null,
    @DateCreated		 datetime = null,
    @UpdatedBy			 nvarchar(50),
    @DateUpdated		 datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WorkFlowTaskLogicID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[WorkflowTaskLogic]
           ([WorkflowTaskID]
           ,[LogicParam]
           ,[LogicCondition]
           ,[IsAutomated]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[DateCreated]
           ,[UpdatedBy]
           ,[DateUpdated])
		 VALUES
			   (@WorkflowTaskID
			   ,@LogicParam
			   ,@LogicCondition
			   ,@IsAutomated
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
	           
		 SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WorkflowTaskLogic]
		   SET [LogicParam] = @LogicParam
			  ,[LogicCondition] = @LogicCondition
			  ,[IsAutomated] = @IsAutomated
			  ,[CreatedBy] = @CreatedBy
			  ,[DateCreated] = @DateCreated
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		WHERE WorkflowTaskLogicID = @WorkflowTaskLogicID
		  AND WorkflowTaskID = @WorkflowTaskID
	END
		
    
END
----------------------------------------------------------------------------------------------------------


