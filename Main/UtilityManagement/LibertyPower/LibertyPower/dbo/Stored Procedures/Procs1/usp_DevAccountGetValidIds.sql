
-- EXEC [usp_DevAccountGetValidIds] 0, null
-- EXEC [usp_DevAccountGetValidIds] null, null

CREATE PROCEDURE [dbo].[usp_DevAccountGetValidIds]
	@MigrationComplete BIT = NULL,
	@MarketId VARCHAR(10) = NULL,
	@IsRenewals BIT = 0
as
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	IF @IsRenewals != 1
	BEGIN 
		IF @MarketId IS NULL OR LTRIM(RTRIM(@MarketId)) = '' 	
			SELECT A.AccountID
			FROM Libertypower..Account A
			JOIN lp_account..account_bak B ON A.AccountID = B.AccountID 
			WHERE A.MigrationComplete = ISNULL(@MigrationComplete, A.MigrationComplete)
		ELSE
			SELECT A.AccountID
			FROM Libertypower..Account A
			JOIN lp_account..account_bak B ON A.AccountID = B.AccountID AND B.retail_mkt_id = @MarketId
			WHERE A.MigrationComplete = ISNULL(@MigrationComplete, A.MigrationComplete)
	END
	ELSE
	BEGIN
		SELECT A.AccountID
		FROM   Libertypower..Account A
		WHERE A.AccountIdLegacy IN
		(SELECT r.account_id FROM lp_account..account_renewal_bak r)
	END	

END	
