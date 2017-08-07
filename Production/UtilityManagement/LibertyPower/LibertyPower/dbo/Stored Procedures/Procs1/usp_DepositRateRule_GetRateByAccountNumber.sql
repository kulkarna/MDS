
-- ====================================================
-- Author:		Antonio Jr
-- Create date: 06/10/2009
-- Description:	Gets the rate given an account number
-- ====================================================

CREATE proc [dbo].[usp_DepositRateRule_GetRateByAccountNumber] 
	@p_account_number VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT rate =
      case when p.product_category = 'FIXED' then a.rate
           else pr.rate
           end
		FROM lp_account.dbo.account a 
		join lp_common.dbo.common_product p on a.product_id = p.product_id
		join lp_common.dbo.common_product_rate pr on a.product_id = pr.product_id and a.rate_id = pr.rate_id
		WHERE account_number = @p_account_number
		END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositRateRule_GetRateByAccountNumber';

