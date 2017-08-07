
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-20
-- Description:	Sets the flag IsDeleted for a workflow
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowDelete] 
(
	@WorkflowID         int,
	@IsDeleted			bit,
    @UpdatedBy			nvarchar(50),
    @DateUpdated		datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[Workflow]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowID = @WorkflowID
		
    
END

----------------------------------------------------------------------------------------------------------


