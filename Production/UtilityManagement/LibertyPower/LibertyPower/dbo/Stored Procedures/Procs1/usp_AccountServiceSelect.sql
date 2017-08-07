-- EXEC Libertypower.dbo.usp_AccountServiceSelect @legacy_account_id = '2010-0070089' 
-- EXEC Libertypower.dbo.usp_AccountServiceSelect @MostRecentOnly = 1
/*
Modified By:  Al Tafur
Modified On:  12.7.2011
Reason:		  SR - 1-5405805 Reported incorrect de-enrollment date.  The query was modified to order by AccountServiceID before the End date to make sure the most recent record is returned.
=========================================================
Modified:	Jaime Forero
Date:		01-25-2012
Reason:		Refactored for IT79
*/
CREATE PROCEDURE [dbo].[usp_AccountServiceSelect]
(
	@AccountID INT = null, 
	@legacy_account_id CHAR(12) = null, 
	@AccountNumber VARCHAR(30) = null, 
	@MostRecentOnly INT = 0
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	/** Refactored code: 	
	IF @legacy_account_id IS NULL
		SELECT @legacy_account_id = account_id
		FROM lp_account.dbo.account a
		WHERE account_number = @AccountNumber OR AccountID = @AccountID
	**/
	
	-- ***********************************************************************************
	-- IT79 Refactored Code Start
	IF @legacy_account_id IS NULL
		SELECT @legacy_account_id = AccountIdLegacy
		FROM LibertyPower..Account A (NOLOCK)
		WHERE A.AccountNumber = @AccountNumber OR A.AccountID = @AccountID

	
	SELECT MostRecent = 1
		, account_id =  A.AccountIDLegacy
		, S.StartDate
		, S.EndDate 
	FROM LibertyPower..Account A (NOLOCK)
	JOIN LibertyPower..AccountLatestService S (NOLOCK) ON A.AccountID = S.AccountID
	WHERE A.AccountIDLegacy = @legacy_account_id OR @legacy_account_id IS NULL
	
	-- IT79 Refactored Code END
	-- ***********************************************************************************

	/*
	SELECT row_number() over (partition by account_id order by StartDate desc, AccountServiceID desc , EndDate desc) as RecordNumber
		, account_id
		, StartDate
		, EndDate
	INTO #temp
	FROM libertypower..AccountService  (NOLOCK)
	WHERE account_id = @legacy_account_id OR @legacy_account_id IS NULL

	SELECT MostRecent = case when RecordNumber = 1 then 1 else 0 end
		, account_id
		, StartDate = lp_enrollment.dbo.ufn_date_format(StartDate,'<YYYY>-<MM>-<DD>')
		, EndDate = lp_enrollment.dbo.ufn_date_format(EndDate,'<YYYY>-<MM>-<DD>')
	FROM #temp
	WHERE (@MostRecentOnly = 0 OR RecordNumber = 1) -- We only send back the most recent service record per account if this option is selected.
	*/
END
