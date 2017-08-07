
-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-22
-- Description:	Sets the flag IsDeleted for a workflow path logic
-- =============================================

CREATE PROCEDURE [dbo].[usp_WorkflowPathLogicDelete] 
(
	@WorkflowPathLogicID     int,
	@IsDeleted	   		     bit,
    @UpdatedBy			     nvarchar(50),
    @DateUpdated		     datetime
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	UPDATE [LibertyPower].[dbo].[WorkflowPathLogic]
	   SET [IsDeleted] = @IsDeleted
		  ,[UpdatedBy] = @UpdatedBy
		  ,[DateUpdated] = @DateUpdated
	 WHERE WorkflowPathLogicID = @WorkflowPathLogicID
		
    
END

----------------------------------------------------------------------------------------------------------


