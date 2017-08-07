


CREATE proc [dbo].[usp_deal_pricing_sel]
(
@p_deal_pricing_id int 
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
		
		WHERE [deal_pricing_id] = @p_deal_pricing_id
			
END 

