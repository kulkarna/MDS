USE lp_common
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetMarketSalesTax]
(@MarketID          int = '',
 @EffectiveDate		datetime = '')
AS
BEGIN

	SELECT *
	FROM LibertyPower.dbo.MarketSalesTax
	WHERE (1=1)
	AND ((@MarketID = '') OR (MarketID = @MarketID))
	AND ((@EffectiveDate = '') OR (@EffectiveDate BETWEEN EffectiveStartDate AND ISNULL(EffectiveEndDate, GETDATE())))

END