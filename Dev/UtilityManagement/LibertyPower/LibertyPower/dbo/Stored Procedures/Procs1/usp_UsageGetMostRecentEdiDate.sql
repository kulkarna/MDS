-- usp_UsageGetMostRecentEdiDate 'PSEG','PE000008386550109747'
-- gets date of most recent EDI usage for a given account
CREATE PROCEDURE [dbo].[usp_UsageGetMostRecentEdiDate] 
	@UtilityCode				VARCHAR(50), 
	@AccountNumber			  	VARCHAR(50) 
AS
BEGIN

    SELECT TOP 1 UtilityCode, AccountNumber, EndDate
    FROM lp_transactions..EdiUsage (nolock) t1 inner join lp_transactions.dbo.EdiAccount (nolock) t2 on t1.ediaccountid = t2.id
    WHERE AccountNumber = @AccountNumber and UtilityCode = @UtilityCode
    ORDER BY EndDate DESC

END





            


















