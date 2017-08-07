/*******************************************************************************
 * usp_AccountContractRatePriceDataUpdate
 * Updates account contract rate record with price data
 *
 * History
 *******************************************************************************
 * 2/6/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountContractRatePriceDataUpdate]
	@ContractNumber	varchar(50),
	@AccountNumber	varchar(30),
	@ProductID		varchar(20),
	@RateID			int,
	@Rate			float,
	@PriceID		bigint
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	acr
    SET		LegacyProductID	= @ProductID,
			RateID			= @RateID,
			Rate			= @Rate,
			PriceID			= @PriceID,
			Term			= ISNULL((SELECT Term FROM Libertypower..Price WITH (NOLOCK) WHERE ID = @PriceID), Term)
    FROM	Libertypower..AccountContractRate acr WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract ac WITH (NOLOCK) ON acr.AccountContractID = ac.AccountContractID
			INNER JOIN Libertypower..Account a WITH (NOLOCK) ON a.AccountID = ac.AccountID
			INNER JOIN Libertypower..[Contract] c WITH (NOLOCK) ON c.ContractID = ac.ContractID
	WHERE	c.Number		= @ContractNumber
	AND		a.AccountNumber = @AccountNumber

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
