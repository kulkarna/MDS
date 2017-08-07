

/*
*
* PROCEDURE:	usp_AccountUsage_S
*
* DEFINITION:  Selects all records from AccountUsage
*
* RETURN CODE: 
*
* REVISIONS:	6/9/2011 11:58:55 AM	Angel Nieves	New
*/


CREATE PROCEDURE [dbo].[usp_AccountUsageSelect]
	@AccountUsageID INT
AS 
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

SELECT *
FROM [dbo].[AccountUsage] WITH (NOLOCK)
WHERE [AccountUsageID] = @AccountUsageID
;
	
	
END

