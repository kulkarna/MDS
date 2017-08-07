
-- ========================================================
-- Author:		Antonio Jr
-- Create date: 06/11/2009
-- Description:	Expires a record into DepositRateRule table
-- ========================================================
CREATE PROCEDURE [dbo].[usp_DepositRateRuleExpire] 
	@p_DepositRateRuleID INT,
	@p_expired_by VARCHAR(50),
	@p_date_expired DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    update DepositRateRule
     SET ExpiredBy = @p_expired_by ,
         DateExpired = @p_date_expired
    where (DepositRateRuleID = @p_DepositRateRuleID)
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositRateRuleExpire';

