


/*
*
* PROCEDURE:	[usp_ContractFilterSelect]
*
* DEFINITION:  Selects record  from Contract table using filter
*
* Author: Jaime Forero
*
* REVISIONS:	10/1/2011

EXEC [usp_ContractFilterSelect] NULL
*/


CREATE PROCEDURE [dbo].[usp_ContractFilterSelect]
	-- @ContractID INT,
	@RetailMarketID INT
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF


	SELECT DISTINCT C.*
	FROM LibertyPower.dbo.[Contract] C with (nolock)
	JOIN Libertypower.dbo.AccountContract AC with (nolock) ON C.ContractID = AC.ContractID
	JOIN Libertypower.dbo.Account A with (nolock) ON AC.AccountID = A.AccountID
	WHERE A.RetailMktID = ISNULL(@RetailMarketID, A.RetailMktID)
	;
	
END	

