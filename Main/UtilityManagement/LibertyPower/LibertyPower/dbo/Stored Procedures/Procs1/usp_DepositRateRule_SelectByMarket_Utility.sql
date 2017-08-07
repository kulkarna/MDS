
-- ======================================================================
-- Author:		Antonio Jr
-- Create date: 06/10/2009
-- Description:	Gets DepositRateRules by Market_Id and Utility_Id 
-- ======================================================================
CREATE PROCEDURE [dbo].[usp_DepositRateRule_SelectByMarket_Utility]
	-- Add the parameters for the stored procedure here
	@p_Retail_market_id CHAR(2), 
	@p_utility_id CHAR(15)
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT depositRateRuleID, RetailMarketID, UtilityID, Rate, CreatedBy, DateCreated, ExpiredBy, DateExpired
	FROM dbo.depositRateRule
	WHERE RetailMarketID = @p_Retail_market_id AND
	      UtilityID = @p_utility_id
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositRateRule_SelectByMarket_Utility';

