
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Returns the task statuses
-- =============================================

CREATE PROCEDURE usp_TaskStatusSelect 
(
	@IsActive int = 1
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [TaskStatusID]
		  ,[StatusName]
		  ,[IsActive]
		  ,[CreatedBy]
		  ,[DateCreated]
		  ,[UpdatedBy]
		  ,[DateUpdated]
	FROM [LibertyPower].[dbo].[TaskStatus]
	WHERE (IsDeleted is null OR IsDeleted = 0)
	  AND (@IsActive is null OR IsActive = @IsActive)
    
END
