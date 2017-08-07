USE lp_deal_capture
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	9/17/2013																		*
 *	Descp:		get the pricing request for a rate/product										*
 *	Modified:	
 *  exec:		usp_GetPricingRequest 'ONCOR_FX', '1000000441'									*
 ********************************************************************************************** */
 
CREATE	PROCEDURE	[dbo].[usp_GetPricingRequest]
(	@ProductId AS VARCHAR(50),
	@RateId AS INT
)
AS

BEGIN
	SET NOCOUNT ON;
	
	  SELECT	p.pricing_request_id AS PricingRequest
			
      FROM		lp_deal_capture..deal_pricing p (nolock)

      INNER		JOIN lp_deal_capture..deal_pricing_detail d (nolock)
      ON		p.deal_pricing_id = d.deal_pricing_id
      
      WHERE		d.product_id = @ProductId
      AND		d.rate_id = @RateId
    
      SET NOCOUNT OFF;
END

