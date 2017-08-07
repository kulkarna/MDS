USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentDelete]    Script Date: 08/17/2012 16:14:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Ryan Russon
-- Create date: 2012-08-10
-- Description:	Deletes a workflow assignment
-- =============================================
CREATE PROCEDURE [dbo].[usp_WorkflowAssignmentDelete] 
(
	@WorkflowAssignmentId	int
)

AS

BEGIN
	
	SET NOCOUNT ON;
	DELETE FROM [LibertyPower]..[WorkflowAssignment]
	WHERE WorkflowAssignmentID = @WorkflowAssignmentID
	
END



GO


