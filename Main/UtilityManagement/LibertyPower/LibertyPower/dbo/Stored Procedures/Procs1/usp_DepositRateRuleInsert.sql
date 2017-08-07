
-- ========================================================
-- Author:		Antonio Jr
-- Create date: 06/11/2009
-- Description:	Inserts a record into DepositRateRule table
-- ========================================================
CREATE PROCEDURE [dbo].[usp_DepositRateRuleInsert] 
	@p_retail_market_id CHAR(2),
	@p_utility_id CHAR(15),
	@p_rate FLOAT,
	@p_created_by VARCHAR(50),
	@p_date_created DATETIME,
	@p_expired_by VARCHAR(50) = null,
	@p_date_expired DATETIME = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO DepositRateRule (RetailMarketID, UtilityID, Rate, CreatedBy, DateCreated, ExpiredBy, DateExpired)
    VALUES (@p_retail_market_id,@p_utility_id,@p_rate,@p_created_by,@p_date_created, @p_expired_by, @p_date_expired)
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositRateRuleInsert';

