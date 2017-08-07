

/*
*
* PROCEDURE:	usp_AccountDetail
*
* DEFINITION:  Selects record from Account Detail
*
* RETURN CODE: 
*
* REVISIONS:	Jaime Forero
*/


CREATE PROCEDURE [dbo].[usp_AccountDetailSelect]
	@AccountDetailID INT = NULL,
	@AccountID INT = NULL
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	IF @AccountDetailID IS NULL AND @AccountID IS NULL
	BEGIN
		RAISERROR('@AccountDetailID and @AccountID cannot both be null. Cannot continue',11,1)
		RETURN -1;
	END
	

	IF @AccountDetailID IS NULL 
	BEGIN
		SELECT *
		FROM LibertyPower.[dbo].[AccountDetail] with (nolock)
		WHERE AccountID = @AccountID
		;
	END
	ELSE
	BEGIN
		SELECT *
		FROM LibertyPower.[dbo].[AccountDetail] with (nolock)
		WHERE AccountDetailID = @AccountDetailID
		;
	
	END
	
END	
