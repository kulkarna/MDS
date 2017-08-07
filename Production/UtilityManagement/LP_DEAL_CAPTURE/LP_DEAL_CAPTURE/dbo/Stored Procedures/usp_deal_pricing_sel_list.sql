



CREATE proc [dbo].[usp_deal_pricing_sel_list] 
(
@p_username varchar(50) = '' ,
@p_sales_channel_role varchar(50) = '',
@p_show_expired int = 0 
) 
AS 
BEGIN 



		SELECT [deal_pricing_id]
		  ,[account_name]
		  ,[sales_channel_role]
		  ,[commission_rate]
		  ,[date_expired]
		  ,[username]
		  ,[date_created]

	  FROM [lp_deal_capture].[dbo].[deal_pricing]
		
		WHERE 
			( username = @p_username OR ltrim(rtrim(isnull(@p_username, ''))) = '' ) 
		AND ( sales_channel_role = @p_sales_channel_role OR ltrim(rtrim(isnull(@p_sales_channel_role, ''))) = '' ) 
		AND ( @p_show_expired = 1 OR ( @p_show_expired = 0 and isnull(date_expired, getdate() + 1 ) > getdate() )  )
END 


