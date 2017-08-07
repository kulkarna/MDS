USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]    Script Date: 12/14/2012 11:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AccountContractRateByAcctNoUtilityIDSelect
 * Gets account contract rate record(s) for specified account number and utility ID
 *
 * History
 *******************************************************************************
 * 10/26/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]
	@AccountNumber	varchar(30),
	@UtilityID		int,
	@IsRenewal		bit	= 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	acr.AccountContractRateID, acr.AccountContractID, acr.LegacyProductID, acr.Term, acr.RateID, acr.Rate, 
			acr.RateCode, acr.RateStart, acr.RateEnd, acr.IsContractedRate, acr.HeatIndexSourceID, acr.HeatRate, 
			acr.TransferRate, acr.GrossMargin, acr.CommissionRate, acr.AdditionalGrossMargin, acr.Modified, 
			acr.ModifiedBy, acr.DateCreated, acr.CreatedBy, acr.PriceID
    FROM	Libertypower..AccountContractRate acr WITH (NOLOCK)
			INNER JOIN Libertypower..AccountContract ac WITH (NOLOCK) ON acr.AccountContractID = ac.AccountContractID
			INNER JOIN Libertypower..Account a WITH (NOLOCK) ON a.AccountID = ac.AccountID
	WHERE	a.AccountNumber			= @AccountNumber
	AND		a.UtilityID				= @UtilityID
	AND		acr.IsContractedRate	= 1
	AND		ac.ContractID			= CASE WHEN @IsRenewal = 0 THEN a.CurrentContractID ELSE a.CurrentRenewalContractID END

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power

