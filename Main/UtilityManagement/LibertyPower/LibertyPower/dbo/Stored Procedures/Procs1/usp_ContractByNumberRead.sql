

/*
*
* PROCEDURE:	[usp_ContractByNumberRead]
*
* DEFINITION:  Selects record  from Contract based on filter
*
* RETURN CODE: 
*
* REVISIONS:	7/13/2011
*/

CREATE PROCEDURE [dbo].[usp_ContractByNumberRead]
	@Number		VARCHAR(50)
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	SELECT TOP(1) *
	FROM LibertyPower.dbo.[Contract] with (nolock)
	WHERE Number = @Number
	;
	
END	
