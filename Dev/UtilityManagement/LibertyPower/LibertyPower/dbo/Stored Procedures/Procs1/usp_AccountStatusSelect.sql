

/*
*
* PROCEDURE:	usp_AccountStatus_S
*
* DEFINITION:  Selects all records from AccountStatus
*
* RETURN CODE: 
*
* REVISIONS:	6/9/2011 11:58:55 AM	Angel Nieves	New
*/


CREATE PROCEDURE [dbo].[usp_AccountStatusSelect]
 @AccountStatusID INT
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	SELECT *
	FROM [dbo].[AccountStatus] WITH (NOLOCK)
	WHERE AccountStatusID = @AccountStatusID
	;


END


