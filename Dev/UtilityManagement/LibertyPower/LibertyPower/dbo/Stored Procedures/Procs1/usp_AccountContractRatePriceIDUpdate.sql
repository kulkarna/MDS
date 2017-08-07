/*******************************************************************************
 * usp_AccountContractRatePriceIDUpdate
 * Updates account contract rate record with price id
 *
 * History
 *******************************************************************************
 * 3/30/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountContractRatePriceIDUpdate]
	@AccountNumber	varchar(30),
	@PriceID		bigint
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	acr
    SET		PriceID = @PriceID
    FROM	Libertypower..AccountContractRate acr WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract ac WITH (NOLOCK) ON acr.AccountContractID = ac.AccountContractID
			INNER JOIN Libertypower..Account a WITH (NOLOCK) ON a.AccountID = ac.AccountID
	WHERE	a.AccountNumber = @AccountNumber
	AND		ac.AccountContractID = (SELECT TOP 1 ac2.AccountContractID FROM Libertypower..AccountContract ac2 WHERE a.AccountID = ac2.AccountID ORDER BY ac2.AccountContractID DESC)

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
