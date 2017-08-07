




-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/16/2007
-- Description:	Select and concatenate utlity_id and desc, product_id and desc, rate_id, rate and desc
-- =============================================
CREATE PROCEDURE [dbo].[usp_print_contract_multi_rate_sel]
(@p_username                                        nchar(100),
 @p_product_id                                      char(20),
 @p_show_active_flag								tinyint = 0
)
as
 
SELECT     
	option_id = ltrim(rtrim(b.rate_descp)),
	return_value = (ltrim(rtrim(a.utility_id)) + '|' + ltrim(rtrim(c.utility_descp)) + '|' + ltrim(rtrim(b.product_id)) + '|' + ltrim(rtrim(a.product_descp)) + '|' + CAST(b.rate_id AS varchar(5)) + '|' + CAST(b.rate AS varchar(20)) + '|' + b.rate_descp)
FROM         
	lp_common..common_product a 
	INNER JOIN
	lp_common..common_product_rate b ON a.product_id = b.product_id 
	INNER JOIN
	lp_common..common_utility c ON a.utility_id = c.utility_id
WHERE     
	b.product_id = @p_product_id

