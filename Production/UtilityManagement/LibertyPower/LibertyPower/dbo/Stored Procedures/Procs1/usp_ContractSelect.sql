


/*
*
* PROCEDURE:	[usp_ContractRead]
*
* DEFINITION:  Selects record  from Contract
*
* RETURN CODE: 
*
* REVISIONS:	6/21/2011
*/


CREATE PROCEDURE [dbo].[usp_ContractSelect]
	@ContractID INT
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	SELECT *
	FROM [LibertyPower].[dbo].[Contract] with (nolock)
	WHERE [ContractID] = @ContractID
	
	
END	


