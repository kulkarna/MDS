
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Inserts or updates task types
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaskTypeInsertUpdate] 
(
	@TaskTypeID         int = 0,
	@TaskName			nvarchar(25),
	@IsActive			bit,
    @CreatedBy			nvarchar(50) = null,
    @DateCreated		datetime = null,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@TaskTypeID = 0)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[TaskType]
			   ([TaskName]
			   ,[IsActive]
			   ,[IsDeleted]
			   ,[CreatedBy]
			   ,[DateCreated]
			   ,[UpdatedBy]
			   ,[DateUpdated])
		 VALUES
			   (@TaskName
			   ,@IsActive
			   ,0
			   ,@CreatedBy
			   ,@DateCreated
			   ,@UpdatedBy
			   ,@DateUpdated)
			   
		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE [LibertyPower].[dbo].[TaskType]
		   SET [TaskName] = @TaskName
			  ,[IsActive] = @IsActive
			  ,[UpdatedBy] = @UpdatedBy
			  ,[DateUpdated] = @DateUpdated
		 WHERE TaskTypeID = @TaskTypeID
	END
		
    
END
----------------------------------------------------------------------------------------------------------


