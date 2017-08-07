USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow assignments
-- by workflow id
-- =============================================

CREATE PROCEDURE usp_WorkflowAssignmentsSelect 
(
	@WorkflowID int
)
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT W.[WorkflowID]
		  ,W.[WorkflowName]
		  ,W.[WorkflowDescription]
		  ,W.[IsActive] AS IsActiveWorkflow
		  ,W.[Version]
		  ,W.[IsRevisionOfRecord]
		  ,WA.[WorkflowAssignmentID]
		  ,WA.[MarketId]
		  ,WA.[UtilityId]
		  ,WA.[ContractTypeId]
		  ,WA.[ContractDealTypeId]
		  ,WA.[ContractTemplateTypeId]	
	FROM [LibertyPower].[dbo].[Workflow] W (NOLOCK)
	JOIN [LibertyPower].[dbo].[WorkflowAssignment] WA (NOLOCK) ON W.WorkflowID = WA.WorkflowID
	WHERE W.WorkflowID = @WorkflowID
    
END
GO
