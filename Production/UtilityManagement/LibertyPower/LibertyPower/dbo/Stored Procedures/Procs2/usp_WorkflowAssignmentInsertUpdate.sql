

-- =============================================
-- Author:		Ryan Russon
-- Create date: 2012-08-10
-- Description:	Inserts or updates a workflow assignment, just like EF does effortlessly
-- =============================================
CREATE PROCEDURE [dbo].[usp_WorkflowAssignmentInsertUpdate] 
(
	@WorkflowAssignmentId	int	= NULL,		--INSERT if this value is NULL
	@WorkflowId				int,
	@MarketId				int = NULL,
	@UtilityId				int = NULL,
	@ContractTypeId			int,
	@ContractDealTypeId		int,
	@ContractTemplateTypeId	int,
	@CreatedBy				nvarchar(100) = NULL,
	@UpdatedBy				nvarchar(100) = NULL
)

AS

BEGIN
	
	SET NOCOUNT ON;

	--Check to see if a different workflow replicates the same criteria for assignment
	DECLARE @WorkflowName	VARCHAR(200)
	
	SELECT TOP 1
		@WorkflowName = W.WorkflowName
	FROM [LibertyPower]..[WorkflowAssignment]		wa WITH (NOLOCK)
	JOIN LibertyPower..Workflow						w WITH (NOLOCK)
		ON W.WorkflowID = WA.WorkflowID
	WHERE W.WorkflowId <> @WorkflowId
		AND (MarketId = @MarketId		or (MarketId IS NULL and @MarketId IS NULL))
		AND (UtilityId = @UtilityId		or (UtilityId IS NULL and @UtilityId IS NULL))
		AND ContractTypeId = @ContractTypeId
		AND ContractDealTypeId = @ContractDealTypeId
		AND ContractTemplateTypeId = @ContractTemplateTypeId

	IF @WorkflowName IS NOT NULL		and		@WorkflowName <> ''
	BEGIN
		SELECT 'These criteria are already assigned to Workflow "' + @WorkflowName + '."'		 AS 'WorkflowAssignmentId'	--Return error message for UI display
		RETURN
	END


	IF (@WorkflowAssignmentId IS NULL)
	BEGIN
		INSERT INTO [LibertyPower]..[WorkflowAssignment] (
			[WorkflowId],
			[MarketId],
			[UtilityId],
			[ContractTypeId],
			[ContractDealTypeId],
			[ContractTemplateTypeId],
			[DateCreated],
			[DateUpdated],
			[CreatedBy]
			--[UpdatedBy]
		 ) VALUES (
			@WorkflowId,
			@MarketId,
			@UtilityId,
			@ContractTypeId,
			@ContractDealTypeId,
			@ContractTemplateTypeId,
			GETDATE(),
			GETDATE(),
			@CreatedBy
)			   
		SELECT @@IDENTITY AS 'WorkflowAssignmentId'					--Return new ID
	END
	
	ELSE
	
	BEGIN
		UPDATE [LibertyPower]..[WorkflowAssignment]
		SET 
			[WorkflowId] = @WorkflowId,
			[MarketId] = @MarketId,
			[UtilityId] = @UtilityId,
			[ContractTypeId] = @ContractTypeId,
			[ContractDealTypeId] = @ContractDealTypeId,
			[ContractTemplateTypeId] = @ContractTemplateTypeId,
			[DateUpdated] = GETDATE(),
			[UpdatedBy] = @UpdatedBy
		WHERE WorkflowAssignmentID = @WorkflowAssignmentID
		
		SELECT @WorkflowAssignmentId AS 'WorkflowAssignmentId'		--Return original ID to be updated, to keep return of stored proc consistant
	END

END

