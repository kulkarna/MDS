-- =============================================
-- Author:		Hector Gomez
-- Create date: 8/24/2009
-- Description:	
-- This stored procedure will identify if there is a 
-- Product/Rate missing from the Product Rate History
-- table, this could be due to several loads with the same 
-- date within this table and not in a sequential manner.
-- For example: a product/rate has been loaded with eff date as 
-- follows, 8/13, 8/13, 8/15, 8/16 and as you can see 8/13 is 
-- loaded twice and just by looking at it the second 8/13 should
-- be 8/14.
-- =============================================
CREATE PROCEDURE usp_Verify_Product_Rate_History
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		DISTINCT
		acct.submitdate
		, acct.product
		, acct.rate_id
	FROM
		LP_Account.dbo.tblAccounts_vw acct
	WHERE
		0 = (
				SELECT COUNT(*) 
				FROM LibertyPower.dbo.AccountEventHistory aeh
				WHERE	
					accountid = account_id
					and acct.ContractNumber = aeh.ContractNumber
			)
		AND YEAR(submitdate)=2009
	ORDER BY 
		product, rate_id
END
