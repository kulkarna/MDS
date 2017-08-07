

/*
*
* PROCEDURE:	[usp_AccountContractRateRead]
*
* DEFINITION:  Reads a record into AccountContractRate Table
*
* RETURN CODE: 
*
* REVISIONS:	6/24/2011 Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountContractRateSelect]
	@AccountContractRateID	INT
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	SELECT *
	FROM  LibertyPower.dbo.AccountContractRate (NOLOCK)
	WHERE AccountContractRateID  = @AccountContractRateID ;
	
END
