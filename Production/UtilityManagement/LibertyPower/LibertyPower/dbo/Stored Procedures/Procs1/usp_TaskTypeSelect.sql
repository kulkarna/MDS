
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-13
-- Description:	Returns the task types
-- =============================================

CREATE PROCEDURE usp_TaskTypeSelect 
(
	@IsActive int = 1
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [TaskTypeID]
		  ,[TaskName]
		  ,[IsActive]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	FROM [LibertyPower].[dbo].[TaskType] TT
	WHERE (@IsActive is null OR TT.IsActive = @IsActive)
	  AND (IsDeleted is null OR IsDeleted = 0)
    
END
