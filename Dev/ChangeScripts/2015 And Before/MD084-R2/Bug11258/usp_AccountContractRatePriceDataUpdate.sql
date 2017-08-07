USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountContractRatePriceDataUpdate]    Script Date: 04/29/2013 15:22:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_AccountContractRatePriceDataUpdate
 * Updates account contract rate record with price data
 *
 * History
 *******************************************************************************
 * 2/6/2013 - Rick Deigsler
 * Created.
  *******************************************************************************
 * Modified 4/29/2013 - Rick Deigsler
 * Modified to only update term for fixed product.
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_AccountContractRatePriceDataUpdate]
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
			-- only update term if fixed product
			Term			= ISNULL((SELECT CASE WHEN ProductTypeID = 1 THEN Term ELSE NULL END FROM Libertypower..Price WITH (NOLOCK) WHERE ID = @PriceID), Term)
    FROM	Libertypower..AccountContractRate acr WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract ac WITH (NOLOCK) ON acr.AccountContractID = ac.AccountContractID
			INNER JOIN Libertypower..Account a WITH (NOLOCK) ON a.AccountID = ac.AccountID
			INNER JOIN Libertypower..[Contract] c WITH (NOLOCK) ON c.ContractID = ac.ContractID
	WHERE	c.Number		= @ContractNumber
	AND		a.AccountNumber = @AccountNumber

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
