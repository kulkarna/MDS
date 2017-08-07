USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountIsBackToBack]    Script Date: 11/01/2012 14:19:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select back to back value of the acocunt/contract								*
 *	Modified:	use the view vw_AccountContractRate
 *  exec:		usp_AccountIsBackToBack '26778', '1889'											*
 ********************************************************************************************** */
 
ALTER	PROCEDURE	[dbo].[usp_AccountIsBackToBack]
(	@AccountID AS INT,
	@ContractID AS INT
)
AS

BEGIN
	SET NOCOUNT ON;
	
	  SELECT	Distinct
				ISNULL(d.BackToBack,0) AS BackToBack 
      FROM		LibertyPower..AccountContract ac (nolock)

      INNER		JOIN LibertyPower..vw_AccountContractRate acr (nolock)
      ON		ac.AccountContractID = acr.AccountContractID
      --AND		acr.IsContractedRate = 1

      INNER		JOIN Lp_common..common_product p (nolock)
      ON		acr.LegacyProductID = p.product_id
      
      LEFT		JOIN lp_deal_capture.dbo.deal_pricing_detail d (nolock)
      ON		acr.RateID = d.rate_id
      AND		p.product_id = d.product_id
      AND		p.IsCustom =  1
      
      WHERE		ac.AccountID = @AccountID
      AND		ac.ContractID = @ContractID
    
      SET NOCOUNT OFF;
END

