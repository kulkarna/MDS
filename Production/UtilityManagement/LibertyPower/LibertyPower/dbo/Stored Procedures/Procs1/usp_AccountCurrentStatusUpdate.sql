
CREATE PROCEDURE usp_AccountCurrentStatusUpdate
	@AccountID INT,
	@Status VARCHAR(15),
	@SubStatus VARCHAR(15),
	@RenewalContract BIT = 0,
	@ModifiedBy	INT = NULL

AS
BEGIN
	DECLARE @AccountStatusID INT
	DECLARE @AccountContractID INT
	DECLARE @ContractID INT
	
	SELECT @ContractID = case when @RenewalContract = 0 then CurrentContractID else CurrentRenewalContractID end
	FROM LibertyPower..Account (NOLOCK)
	WHERE AccountID = @AccountID
		
	SELECT @AccountContractID = AccountContractID
	FROM LibertyPower.dbo.AccountContract (NOLOCK)
	WHERE AccountID = @AccountID AND ContractID = @ContractID
	
	SELECT top 1 @AccountStatusID = AccountStatusID
	FROM LibertyPower..AccountStatus (NOLOCK)
	WHERE AccountContractID = @AccountContractID
	ORDER BY 1 DESC

	EXEC [dbo].[usp_AccountStatusUpdate]
		@AccountStatusID = @AccountStatusID,
		@AccountContractID = @AccountContractID,
		@Status = @Status,
		@SubStatus = @SubStatus,
		@ModifiedBy	= @ModifiedBy,
		@IsSilent = 0
END








