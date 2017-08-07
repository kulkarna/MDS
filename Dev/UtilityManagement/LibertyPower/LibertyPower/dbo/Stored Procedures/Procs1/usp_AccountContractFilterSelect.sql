

/*
*
* PROCEDURE:	[usp_AccountContractFilterSelect]
*
* DEFINITION:  Selects records in AccountContract Table based on filter criteria
*
* RETURN CODE: 
*
* REVISIONS:	10/3/2011 Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountContractFilterSelect]
	@AccountID	INT,
	@ContractID	INT
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	SELECT *
	FROM  LibertyPower.dbo.AccountContract (NOLOCK)
	WHERE AccountID  = ISNULL(@AccountID , AccountID )
	AND   ContractID = ISNULL(@ContractID, ContractID);
	
END
