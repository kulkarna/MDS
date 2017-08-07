--exec usp_rate_sel_listbyusername @p_username=N'',@p_product_id=N'BGE-FIXED-12'   

--exec usp_rate_sel_listbyusername 'admin', 'PRODUCT-01 PEAK'
 
CREATE procedure [dbo].[usp_contract_rate_sel]
(@p_username                                        nchar(100),
 @p_product_id                                      char(20),
 @p_term_months                                     int = null,
 @p_rate_id                                         int,
 @p_multi_rate_print								varchar(5) = 'FALSE')
as

IF @p_multi_rate_print = 'TRUE'
	BEGIN
		SELECT rate
		FROM multi_rates
		WHERE product_id = @p_product_id AND rate_id = @p_rate_id
	END
ELSE
	BEGIN
		SELECT rate, term_months
		FROM lp_common..common_product_rate with (NOLOCK INDEX = common_product_rate_idx)
		WHERE product_id = @p_product_id
		AND rate_id= @p_rate_id
		AND convert(char(08), getdate(), 112) >= eff_date
		AND convert(char(08), getdate(), 112) < due_date
		AND term_months = isnull(@p_term_months,term_months)
		AND inactive_ind = '0'
	END










