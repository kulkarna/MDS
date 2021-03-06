USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_WorkflowTaskInsertUpdate]    Script Date: 06/14/2012 15:35:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Inserts or updates workflow tasks
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskInsertUpdate] 
(
	@WorkflowID         int,
	@WorkflowTaskID     int = 0,
	@TaskSequence		int,
    @TaskTypeId int,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
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
