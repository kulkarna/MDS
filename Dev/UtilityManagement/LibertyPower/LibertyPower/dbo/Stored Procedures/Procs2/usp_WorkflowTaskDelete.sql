
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Sets the flag IsDeleted for a workflow task
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowTaskDelete] 
(
	@WorkflowTaskID     int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[WorkflowTask]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowTaskID = @WorkflowTaskID
		
    
END

----------------------------------------------------------------------------------------------------------


