USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_WorkflowAssignmentsSelect]    Script Date: 08/23/2012 16:29:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 2012-06-11
-- Description:	Returns the workflow assignments by workflow id
-- Updated:		Ryan Russon [08-07-2012] - Add all columns from WorkflowAssignment for use in Workflow Assignment editor
-- Usage:		EXEC usp_WorkflowAssignmentsSelect @WorkflowID=2
-- =============================================
ALTER PROCEDURE [dbo].[usp_WorkflowAssignmentsSelect](
	@WorkflowId		int = NULL
)

AS

BEGIN

	SET NOCOUNT ON;

	SELECT
		WA.WorkflowAssignmentId,
		W.WorkflowId,
		W.WorkflowName,
		W.WorkflowDescription,
		--W.IsActive AS IsActiveWorkflow,
		W.IsActive,
		W.[Version],
		W.IsRevisionOfRecord,
		WA.MarketId,
		IsNull(M.RetailMktDescp, 'ALL')			AS MarketName,
		WA.UtilityId,
		IsNull(U.ShortName, 'ALL')				AS UtilityName,
		WA.ContractTypeId,
		WA.ContractDealTypeId,
		WA.ContractTemplateTypeId,
		WA.CreatedBy,
		WA.DateCreated,
		WA.UpdatedBy,
		WA.DateUpdated
	FROM
		LibertyPower..Workflow					W WITH (NOLOCK)
		JOIN LibertyPower..WorkflowAssignment	WA WITH (NOLOCK)
			ON W.WorkflowID = WA.WorkflowID
		LEFT JOIN LibertyPower..Market			M WITH (NOLOCK)
			ON M.ID = WA.MarketId
		LEFT JOIN LibertyPower..Utility			U WITH (NOLOCK)
			ON U.ID = WA.UtilityId
	WHERE (@WorkflowId IS NULL		OR		W.WorkflowId = @WorkflowId)

END



GO


