





-- =============================================
-- Author:		Gail Mangaroo 
-- Create date: 4/24/2008 dev 05/19/2008
-- Description:	Select and concatenate utlity_id and desc, product_id and desc, rate_id, rate and desc
-- =============================================
CREATE PROCEDURE [dbo].[usp_print_contract_multi_rate_sel_byusername]
(@p_username                                        nchar(100),
 @p_product_id                                      char(20),
 @p_show_active_flag								tinyint = 0
)
as
 BEGIN 

	DECLARE @w_sales_channel_prefix VARCHAR(100)  

	SELECT @w_sales_channel_prefix = sales_channel_prefix  
	FROM lp_common..common_config with (NOLOCK)  

	Declare @product_rate table ( seq int, rate_id int, rate_descp varchar(50), product_id varchar(30) )
	Declare @SalesChannelRole varchar(50) 
	select @SalesChannelRole = replace(@p_username , 'libertypower\', @w_sales_channel_prefix) 

	SELECT     
		option_id = 'Rate ' + CAST(b.rate AS varchar(20)) + ' - ' + ltrim(rtrim(b.rate_descp)),
		return_value = (ltrim(rtrim(a.utility_id)) + '|' + ltrim(rtrim(c.utility_descp)) + '|' + ltrim(rtrim(b.product_id)) + '|' + ltrim(rtrim(a.product_descp)) + '|' + CAST(b.rate_id AS varchar(5)) + '|' + CAST(b.rate AS varchar(20)) + '|' + b.rate_descp)
	FROM         
		lp_common..common_product a 
		INNER JOIN
		lp_common..common_product_rate b ON a.product_id = b.product_id 
		INNER JOIN
		lp_common..common_utility c ON a.utility_id = c.utility_id
	WHERE     
		b.product_id = @p_product_id 
		AND dbo.ufn_is_rate_accessible (b.product_id, b.rate_id, @SalesChannelRole, @p_username , '') = 1 
 
 END 

