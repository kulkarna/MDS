


/*
*
* PROCEDURE:	[usp_AccountFilterRead]
*
* DEFINITION:  Selects all records from Account matching the filter criteria, if no 
			parameter is submitted (or null) then is ignored and not used in the query
				
*
* RETURN CODE: 
*
* REVISIONS:	9/25/2011
*/


CREATE PROCEDURE [dbo].[usp_AccountUsageFilterSelect]
	@AccountID		INT	= NULL,
	@EffectiveDate	DATETIME = NULL
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	SELECT *
	FROM LibertyPower.[dbo].[AccountUsage] AU (NOLOCK)
	WHERE	AU.AccountID = ISNULL(@AccountID, AU.AccountID)
	AND		AU.EffectiveDate = ISNULL(@EffectiveDate, AU.EffectiveDate);
	
END	

