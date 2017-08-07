

/*
*
* PROCEDURE:	[usp_AccountContractUpdate]
*
* DEFINITION:  Updates a record into AccountContract Table
*
* RETURN CODE: 
*
* REVISIONS:	6/22/2011 Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountContractUpdate]
	@AccountContractID	INT,
	@AccountID	INT = NULL,
	@ContractID INT = NULL,
	@RequestedStartDate DATETIME,
	@SendEnrollmentDate DATETIME,
	@ModifiedBy INT,
	@IsSilent BIT = 0,
	@MigrationComplete BIT = NULL
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
		
	UPDATE [LibertyPower].[dbo].[AccountContract]
	SET [AccountID] = ISNULL(@AccountID, [AccountID]),
		[ContractID] = ISNULL(@ContractID, [ContractID]),
        [RequestedStartDate] = @RequestedStartDate,
        [SendEnrollmentDate] = @SendEnrollmentDate,
        [Modified] = GETDATE(),
        [ModifiedBy] = @ModifiedBy,
        [MigrationComplete] = ISNULL(@MigrationComplete, MigrationComplete)
    WHERE AccountContractID = @AccountContractID;
    
    IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountContractSelect @AccountContractID  ;
	
	RETURN @AccountContractID;
END
