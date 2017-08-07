

/*
*
* PROCEDURE:	[usp_AccountContractCommissionCreate]
*
* DEFINITION:  Inserts a record into AccountContractCommission Table
*
* RETURN CODE: 
*
* REVISIONS:	6/24/2011 Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountContractCommissionInsert]
	@AccountContractID INT,
	@EvergreenOptionID INT = NULL,
	@EvergreenCommissionEnd DATETIME = NULL,
	@EvergreenCommissionRate FLOAT = NULL,
	@ResidualOptionID INT = NULL,
	@ResidualCommissionEnd DATETIME = NULL,
	@InitialPymtOptionID INT = NULL,
	@ModifiedBy INT,
	@CreatedBy INT,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	DECLARE @AccountContractCommissionID INT;
	
	INSERT INTO [LibertyPower].[dbo].[AccountContractCommission]
           ( 
			 [AccountContractID]
			,[EvergreenOptionID]
			,[EvergreenCommissionEnd]
			,[EvergreenCommissionRate]
			,[ResidualOptionID]
			,[ResidualCommissionEnd]
			,[InitialPymtOptionID]
			,[Modified]
			,[ModifiedBy]
			,[DateCreated]
			,[CreatedBy]
           )
     VALUES
           (
            @AccountContractID,
			@EvergreenOptionID,
			@EvergreenCommissionEnd,
			@EvergreenCommissionRate,
			@ResidualOptionID,
			@ResidualCommissionEnd,
			@InitialPymtOptionID,
            GETDATE(),
            @ModifiedBy,
            GETDATE(),
            @CreatedBy
            )
	;
	SET @AccountContractCommissionID  = SCOPE_IDENTITY();
	
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountContractCommissionSelect @AccountContractCommissionID;
		
	RETURN @AccountContractCommissionID  ;
	
	
END
