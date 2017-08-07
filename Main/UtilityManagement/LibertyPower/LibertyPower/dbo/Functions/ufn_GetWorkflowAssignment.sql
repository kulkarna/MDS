-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 08/29/2012
-- Description:	Returns the workflow id for a given contract number
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetWorkflowAssignment] 
(
	@pContractId int
)
RETURNS int
AS
BEGIN

	DECLARE @pWorkflowId INT
	DECLARE @UtilityId INT
	DECLARE @MarketId INT
	DECLARE @ContractTypeId INT
	DECLARE @ContractDealTypeId INT
	DECLARE @ContractTemplateTypeId INT
 
	SELECT TOP 1 @UtilityId = A.UtilityId
		  ,@MarketId = A.RetailMktId
		  ,@ContractTypeId = C.ContractTypeId
		  ,@ContractDealTypeId = C.ContractDealTypeId
		  ,@ContractTemplateTypeId = C.ContractTemplateId
	FROM LibertyPower..Contract C (NOLOCK)
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.ContractId = C.ContractId
	JOIN LibertyPower..Account A (NOLOCK) ON A.AccountId = AC.AccountId
	WHERE C.ContractId = @pContractId
	
--set @UTILITYID = 14
--set @MarketId = 7
--Set @ContractTypeId = 2
--Set @ContractDealTypeid = 1
--Set @ContractTemplateTypeId = 1
 
    IF @ContractTemplateTypeId <> 0 AND
	   @ContractDealTypeId <> 0 AND
       @ContractTypeId <> 0 AND
       @MarketId <> 0 AND
       @UtilityId <> 0
    BEGIN
          SELECT @pWorkflowId = W.WorkflowId
            FROM Libertypower..WorkflowAssignment wa (NOLOCK)
            JOIN Libertypower..Workflow w (NOLOCK) ON wa.workflowid = w.workflowid
          WHERE wa.UtilityId = @UtilityId
             AND wa.MarketId = @MarketId
             AND wa.ContractTypeId = @ContractTypeId
             AND wa.ContractDealTypeId = @ContractDealTypeId
            AND wa.ContractTemplateTypeId = @ContractTemplateTypeId 
             AND w.IsActive = 1
             AND w.IsRevisionOfRecord = 1
             AND w.IsDeleted IS NULL    
    END
    
    IF @pWorkflowId IS NULL 
    BEGIN
          SELECT @pWorkflowId = W.WorkflowId
            FROM Libertypower..WorkflowAssignment wa (NOLOCK)
            JOIN Libertypower..Workflow w (NOLOCK) ON wa.workflowid = w.workflowid
          WHERE wa.MarketId = @MarketId
             AND wa.UtilityId IS NULL 
             AND wa.ContractTypeId = @ContractTypeId
             AND wa.ContractDealTypeId = @ContractDealTypeId
             AND wa.ContractTemplateTypeId = @ContractTemplateTypeId 
             AND w.IsActive = 1
             AND w.IsRevisionOfRecord = 1
             AND w.IsDeleted IS NULL                               
    END
    
    IF @pWorkflowId IS NULL
    BEGIN
          SELECT @pWorkflowId = W.WorkflowId
		    FROM Libertypower..WorkflowAssignment wa (NOLOCK)
		    JOIN Libertypower..Workflow w (NOLOCK) ON wa.workflowid = w.workflowid
		   WHERE wa.MarketId IS NULL
             AND wa.UtilityId IS NULL 
		     AND wa.ContractTypeId = @ContractTypeId
             AND wa.ContractDealTypeId = @ContractDealTypeId
             AND wa.ContractTemplateTypeId = @ContractTemplateTypeId 
		     AND w.IsActive = 1
		     AND w.IsRevisionOfRecord = 1
		     AND w.IsDeleted IS NULL                                
    END

	RETURN @pWorkflowId

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetWorkflowAssignment] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetWorkflowAssignment] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

