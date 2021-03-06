USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMCustomDealAccountSelectContractID]    Script Date: 07/25/2013 16:26:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************
 *	Author:		cghazal																			*
 *	Created:	6/11/2013																		*
 *	Descp:		Get the all the custom deals since ProcessDate									*
 *	Modified:	7/26: Replace DealPricingID with CustomDealID																				*
 ********************************************************************************************** */
ALTER	PROCEDURE  [dbo].[usp_MtMCustomDealAccountSelectContractID]
( @AccountID AS INT,  @CustomDealID AS INT)
AS

BEGIN
	SET NOCOUNT ON;

	SELECT	distinct ContractID
	FROM	MtMAccount (nolock)
	WHERE	AccountID = @AccountID
	AND		CustomDealID = @CustomDealID
	
	SET NOCOUNT OFF;
END
