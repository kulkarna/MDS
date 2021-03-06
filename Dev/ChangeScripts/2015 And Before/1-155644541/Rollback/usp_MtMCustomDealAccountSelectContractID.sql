USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMCustomDealAccountSelectContractID]    Script Date: 08/12/2013 11:34:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************
 *	Author:		cghazal																			*
 *	Created:	6/11/2013																		*
 *	Descp:		Get the all the custom deals since ProcessDate									*
 *	Modified:																					*
 ********************************************************************************************** */
ALTER	PROCEDURE  [dbo].[usp_MtMCustomDealAccountSelectContractID]
( @AccountID AS INT,  @DealPricingID AS INT)
AS

BEGIN
	SET NOCOUNT ON;

	SELECT	distinct ContractID
	FROM	MtMAccount (nolock)
	WHERE	AccountID = @AccountID
	AND		DealPricingID = @DealPricingID
	
	SET NOCOUNT OFF;
END
