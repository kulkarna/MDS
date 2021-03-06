USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomRateByPriceIDSelect]    Script Date: 08/30/2013 16:24:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CustomRateByPriceIDSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CustomRateByPriceIDSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CustomRateByPriceIDSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_CustomRateByPriceIDSelect
 * Gets custom data for price record
 *
 * History
 *******************************************************************************
 * 8/29/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_CustomRateByPriceIDSelect]
	@PriceID	bigint
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	pd.product_id AS ProductId, pd.rate_id AS RateId, pd.ContractRate, pd.Cost, pd.Commission, 
			pd.ETP, d.date_expired AS ExpirationDate, pd.PriceID, p.Term, p.StartDate, p.GrossMargin
    FROM	lp_deal_capture..deal_pricing_detail pd WITH (NOLOCK)
			INNER JOIN lp_deal_capture..deal_pricing d WITH (NOLOCK) ON pd.deal_pricing_id = d.deal_pricing_id
			INNER JOIN Libertypower..Price p WITH (NOLOCK) ON pd.PriceID = p.ID
    WHERE	pd.PriceID = @PriceID  

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
