USE libertypower
GO

-- =============================================      
-- Author:        <Vikas Sharma>      
-- Create date: <05-11-2016>      
-- Description:   <This Procedure Fetch the Records to call Submit Historical usage>      
-- =============================================      
ALTER PROCEDURE [dbo].[Usp_GetAccountDetails] @ListAccounts
AS
ListAccount ReadOnly AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from      
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	SELECT a.AccountID
		,a.AccountNumber
		,af.BillingAccount
		,af.name_key AS 'NameKey'
		,a.UtilityID
		,u.UtilityCode
		,U.DunsNumber
	FROM LibertyPower..Account a(NOLOCK)
	LEFT JOIN LibertyPower..Utility(NOLOCK) u ON a.UtilityID = u.ID
	LEFT OUTER JOIN @ListAccounts LA ON La.AccountNumber = a.AccountNumber
		AND la.utilityCode = u.utilityCode
	LEFT JOIN Lp_Account..account_info af(NOLOCK) ON a.AccountIdLegacy = af.account_id
END
