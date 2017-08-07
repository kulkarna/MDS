CREATE PROC usp_AccountPropertyHistory_SELECT_ByUtilityIdIntAndAccountNumber
	@UtilityId NVARCHAR(80),
	@AccountNumber NVARCHAR(50)
AS
BEGIN

	SELECT 
		[AccountPropertyHistoryID]
		,[UtilityID]
		,[AccountNumber]
		,[FieldName]
		,[FieldValue]
		,[EffectiveDate]
		,[ExpirationDate]
		,[FieldSource]
		,[CreatedBy]
		,[DateCreated]
		,[LockStatus]
		,[Active]
	FROM 
		[dbo].[AccountPropertyHistory] (NOLOCK) 
	WHERE
		LTRIM(RTRIM(UtilityID)) = LTRIM(RTRIM(@UtilityId))
		AND LTRIM(RTRIM(AccountNumber)) = LTRIM(RTRIM(@AccountNumber))

END
