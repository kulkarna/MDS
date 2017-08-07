
-- ======================================================================
-- Author:		Antonio Jr
-- Create date: 06/16/2009
-- Description:	Gets a list of DepositRateRules 
-- ======================================================================
CREATE PROCEDURE [dbo].[usp_DepositRateRule_SelectList]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT depositRateRuleID, RetailMarketID, UtilityID, Rate, CreatedBy, DateCreated, ExpiredBy, DateExpired
	FROM dbo.depositRateRule
	ORDER BY RetailMarketID, UtilityID
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositRateRule_SelectList';

