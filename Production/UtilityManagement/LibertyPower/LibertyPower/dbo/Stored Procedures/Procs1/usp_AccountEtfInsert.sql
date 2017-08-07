
CREATE PROCEDURE [dbo].[usp_AccountEtfInsert]
	@AccountID int
	,@EtfProcessingStateID int
	,@EtfEndStatusID int
	,@ErrorMessage varchar(255)
	,@EtfAmount decimal(10,2)
	,@DeenrollmentDate datetime
	,@IsEstimated bit
	,@IsPaid bit = 0
	,@CalculatedDate datetime
	,@EtfFinalAmount decimal(10,2)
	,@LastUpdatedBy nchar(100) = 'SYSTEM'
	,@EtfCalculatorType nchar(50)
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [AccountEtf]
		([AccountID]
		,[EtfProcessingStateID]
		,[EtfEndStatusID]
		,[ErrorMessage]
		,[EtfAmount]
		,[DeenrollmentDate]
		,[IsEstimated]
		,[IsPaid]
		,[CalculatedDate]
		,[EtfFinalAmount]
		,[LastUpdatedBy]
		,[EtfCalculatorType])
	VALUES
		(@AccountID
		,@EtfProcessingStateID
		,@EtfEndStatusID
		,@ErrorMessage
		,@EtfAmount
		,@DeenrollmentDate
		,@IsEstimated
		,@IsPaid
		,@CalculatedDate
		,@EtfFinalAmount
		,@LastUpdatedBy
		,@EtfCalculatorType)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfInsert';

