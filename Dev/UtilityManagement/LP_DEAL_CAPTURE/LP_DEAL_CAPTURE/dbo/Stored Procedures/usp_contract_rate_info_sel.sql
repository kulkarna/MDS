/*******************************************************************************
--exec usp_rate_sel_listbyusername @p_username=N'',@p_product_id=N'BGE-FIXED-12'   

--exec usp_rate_sel_listbyusername 'admin', 'PRODUCT-01 PEAK'
 
-- =====================================
-- Modified By: Jose Munoz
-- Modified 01/28/2010
-- Added HeatIndexSourceID and HeatRate columns in the select clause
-- Project IT037
-- =====================================
-- Modified By: Isabelle Tamanini
-- Modified 12/19/2011
-- Added checking to consider if the product is custom
-- SR1-5791110
-- =====================================
 */
CREATE PROCEDURE [dbo].[usp_contract_rate_info_sel]
(@p_username                                        nchar(100),
 @p_product_id                                      char(20),
 @p_term_months                                     int = null,
 @p_rate_id                                         int,
 @p_multi_rate_print								varchar(5) = 'FALSE',
 @p_contract_date									datetime)
AS
BEGIN
    SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @p_multi_rate_print = 'TRUE'
	BEGIN
		SELECT rate
		FROM multi_rates
		WHERE product_id = @p_product_id AND rate_id = @p_rate_id
	END
IF (CONVERT(CHAR(8), @p_contract_date, 1) <> CONVERT(CHAR(8), getdate(), 1))
	BEGIN
		SELECT TOP 1 a.rate, a.term_months, dpd.ContractRate, dpd.Commission
				,dpd.HeatIndexSourceID		
				,dpd.HeatRate
				,a.contract_eff_start_date --Project IT0051	
		FROM lp_common..product_rate_history a
		left join lp_deal_capture.dbo.deal_pricing_detail dpd on a.product_id = dpd.product_id and a.rate_id = dpd.rate_id 
		join lp_common..common_product p on p.product_id = a.product_id

		WHERE a.product_id = @p_product_id
		AND a.rate_id= @p_rate_id
		AND (a.eff_date= @p_contract_date OR p.IsCustom = 1)
		AND a.term_months = isnull(@p_term_months,a.term_months)
		ORDER BY a.date_created DESC
	END
ELSE
	BEGIN
		SELECT a.rate, a.term_months, dpd.ContractRate, dpd.Commission
				,dpd.HeatIndexSourceID		-- Project IT037
				,dpd.HeatRate		-- Project IT037
				,a.contract_eff_start_date --Project IT0051
		FROM lp_common..common_product_rate a
		left join lp_deal_capture.dbo.deal_pricing_detail dpd on a.product_id = dpd.product_id and a.rate_id = dpd.rate_id 
		join lp_common..common_product p on p.product_id = a.product_id

		WHERE a.product_id = @p_product_id
		AND a.rate_id= @p_rate_id
		--AND convert(char(08), getdate(), 112) >= a.eff_date
		--AND convert(char(08), getdate(), 112) < a.due_date
		AND a.term_months = isnull(@p_term_months,a.term_months)
		AND a.inactive_ind = '0'
	END

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
