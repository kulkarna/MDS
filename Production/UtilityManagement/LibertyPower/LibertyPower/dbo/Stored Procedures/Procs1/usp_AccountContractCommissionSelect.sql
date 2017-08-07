

/*
*
* PROCEDURE:	[usp_AccountContractCommissionRead]
*
* DEFINITION:  Inserts a record into AccountContractCommission Table
*
* RETURN CODE: 
*
* REVISIONS:	6/24/2011 Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountContractCommissionSelect]
	@AccountContractCommissionID	INT
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	SELECT *
	FROM  LibertyPower.dbo.AccountContractCommission (NOLOCK)
	WHERE AccountContractCommissionID  = @AccountContractCommissionID;
	
END
