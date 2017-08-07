

CREATE PROCEDURE [dbo].[usp_AccountGetIDByNumberAndUtility] 
	@AccountNumber varchar(30),
	@UtilityID char(15)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT account_id 
		FROM account WITH (NOLOCK)
		WHERE account_number = @AccountNumber 
		AND utility_id = @UtilityID

	SET NOCOUNT OFF;
		
END


