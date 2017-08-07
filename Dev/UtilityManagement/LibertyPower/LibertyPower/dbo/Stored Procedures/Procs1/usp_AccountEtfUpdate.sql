
CREATE PROCEDURE [dbo].[usp_AccountEtfUpdate]
	@EtfID int
	,@AccountID int
	,@EtfProcessingStateID int
	,@EtfEndStatusID int
	,@ErrorMessage varchar(255)
	,@EtfAmount decimal(10,2)
	,@DeenrollmentDate datetime
	,@IsEstimated bit
	,@IsPaid bit = 0
	,@CalculatedDate datetime
	,@EtfFinalAmount decimal(10,2)
	,@LastUpdatedBy nchar(100)
	,@EtfCalculatorType nchar(50)
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [AccountEtf]
		SET [AccountID] = @AccountID
		,[EtfProcessingStateID] = @EtfProcessingStateID
		,[EtfEndStatusID] = @EtfEndStatusID
		,[ErrorMessage] = @ErrorMessage
		,[EtfAmount] = @EtfAmount
		,[DeenrollmentDate] = @DeenrollmentDate
		,[IsEstimated] = @IsEstimated
		,[IsPaid] = @IsPaid
		,[CalculatedDate] = @CalculatedDate
		,[EtfFinalAmount] = @EtfFinalAmount
		,[LastUpdatedBy] = @LastUpdatedBy
		,[EtfCalculatorType] = @EtfCalculatorType
	WHERE [EtfID] = @EtfID

	SET NOCOUNT OFF;

END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfUpdate';

