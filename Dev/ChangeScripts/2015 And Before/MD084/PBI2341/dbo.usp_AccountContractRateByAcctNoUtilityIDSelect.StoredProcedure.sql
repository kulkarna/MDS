USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]    Script Date: 10/26/2012 17:04:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_AccountContractRateByAcctNoUtilityIDSelect
 * Gets account contract rate record(s) for specified account number and utility ID
 *
 * History
 *******************************************************************************
 * 10/26/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountContractRateByAcctNoUtilityIDSelect]
	@AccountNumber	varchar(30),
	@UtilityID		int
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

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
