

/*
*
* PROCEDURE:	usp_AccountStatus_I
*
* DEFINITION:  Inserts a record into AccountStatus
*
* RETURN CODE: 
*
* REVISIONS:	6/9/2011 11:58:55 AM	Angel Nieves	New
*/


CREATE PROCEDURE [dbo].[usp_AccountStatusInsert]
	@AccountContractID  INT,
	@Status		VARCHAR(15),
	@SubStatus	VARCHAR(15),
	@CreatedBy	INT,
	@ModifiedBy	INT,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	IF(@Status IS NULL OR @Status = '')
		SET @Status = '01000'
	
	IF(@SubStatus IS NULL OR @SubStatus = '')
		SET @SubStatus = '10'
	
	DECLARE @AccountStatusID INT;
	
	INSERT INTO [dbo].[AccountStatus]
	(	[AccountContractID],
		[Status],
		[SubStatus],
		[Modified],
		[ModifiedBy],
		[DateCreated],
		[CreatedBy]
	)
	VALUES
	(   
		@AccountContractID,
		@Status,
		@SubStatus,
		GETDATE(),
		@ModifiedBy,
		GETDATE(),
		@CreatedBy
	)

	SET @AccountStatusID = SCOPE_IDENTITY();
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountStatusSelect @AccountStatusID ;
		
	RETURN @AccountStatusID ;
END
