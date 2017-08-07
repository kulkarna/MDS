
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Sets the flag IsDeleted for a task type
-- =============================================

CREATE PROCEDURE [dbo].[usp_TaskTypeDelete] 
(
	@TaskTypeID         int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [LibertyPower].[dbo].[TaskType]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE TaskTypeID = @TaskTypeID
		
END
----------------------------------------------------------------------------------------------------------


