
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-15
-- Description:	Sets the flag IsDeleted for a workflow
-- task logic
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskLogicDelete] 
(
	@WorkflowTaskLogicID int,
	@IsDeleted			 bit,
    @UpdatedBy			 nvarchar(50),
    @DateUpdated		 datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [LibertyPower].[dbo].[WorkflowTaskLogic]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowTaskLogicID = @WorkflowTaskLogicID
		
END

----------------------------------------------------------------------------------------------------------


