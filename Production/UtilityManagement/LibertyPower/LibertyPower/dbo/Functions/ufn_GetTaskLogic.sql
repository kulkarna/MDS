-- =============================================
-- Author:		Al Tafur
-- Create date: 08/29/2012
-- Description:	Returns the logic condition value for the given logic parameter and workflowid
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetTaskLogic] 
(
	@pWorkflowTaskId int,
	@pParamName varchar(50)	
)
RETURNS int
AS
BEGIN

	DECLARE @pLogicContidion INT

	SELECT		@pLogicContidion = LogicCondition
	  FROM		WorkflowTaskLogic (NOLOCK)
	 WHERE		WorkflowTaskId = @pWorkflowTaskId
	   and      LogicParam	=	@pParamName
    

	RETURN @pLogicContidion

END

----------------------------------------------------------------------------------------------------------


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetTaskLogic] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetTaskLogic] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

