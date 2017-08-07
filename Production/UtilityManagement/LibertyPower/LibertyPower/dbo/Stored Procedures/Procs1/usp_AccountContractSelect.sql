

/*
*
* PROCEDURE:	[usp_AccountContractSelect]
*
* DEFINITION:  Inserts a record into AccountContract Table
*
* RETURN CODE: 
*
* REVISIONS:	9/2/2011 Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountContractSelect]
	@AccountContractID	INT
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	SELECT *
	FROM  LibertyPower.dbo.AccountContract (NOLOCK)
	WHERE AccountContractID  = @AccountContractID  ;
	
END
