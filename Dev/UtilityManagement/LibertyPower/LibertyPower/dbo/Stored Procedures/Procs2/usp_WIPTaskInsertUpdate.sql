


-- =============================================
-- Author:		Al Tafur
-- Create date: 2012-07-11
-- Description:	Inserts/updates the entire workflowtask record for a given WIP task header
-- =============================================

CREATE PROCEDURE [dbo].[usp_WIPTaskInsertUpdate] 
(
	@WIPTaskId			int= 0,
	@WIPTaskHeaderId    int,  
	@WorkflowTaskId	    int,
	@TaskStatusId	    int,
	@IsAvailable		int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50) = null,
    @DateUpdated		datetime = null
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@WIPTaskId = 0)
	BEGIN
	INSERT INTO [LibertyPower].[dbo].[WIPTask]
			   ([WIPTaskHeaderId]
			   ,[WorkflowTaskId]
			   ,[TaskStatusId]
			   ,[IsAvailable]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@WIPTaskHeaderId
			   ,@WorkflowTaskId
			   ,@TaskStatusId
			   ,@IsAvailable
			   ,@CreatedBy
			   ,ISNULL(@DateCreated,CURRENT_TIMESTAMP)
			   ,@UpdatedBy
			   ,@DateUpdated)
		   
		RETURN @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[WIPTask]
		   SET [WIPTaskHeaderId] = @WIPTaskHeaderId
			  ,[WorkflowTaskId] = @WorkflowTaskId
			  ,[TaskStatusId] = @TaskStatusId
			  ,[IsAvailable] = @IsAvailable
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = ISNULL(@DateUpdated,CURRENT_TIMESTAMP)
		 WHERE WIPTaskId = @WIPTaskId
		 AND   WorkflowTaskId = @WorkflowTaskId
	END
END

