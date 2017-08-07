

CREATE PROC [dbo].[usp_deal_pricing_upd]
( 
@p_deal_pricing_id int 
, @p_username varchar(50) 
, @p_account_name varchar(50) 
, @p_sales_channel_role varchar(50)
, @p_comm_rate money
, @p_date_expired datetime
, @ContractRate	decimal(9,6)
, @Commission	decimal(9,6)
, @Cost DECIMAL(9,6)
, @HasPassThrough int
, @BackToBack int
) 
AS 
BEGIN 
	UPDATE [lp_deal_capture].[dbo].[deal_pricing]
	   SET [account_name] = @p_account_name
		  ,[sales_channel_role] = @p_sales_channel_role 
		  ,[commission_rate] = @p_comm_rate
		  ,[date_expired] = @p_date_expired
		  ,[modified_by] = @p_username
		  ,[date_modified] = getdate()
	 WHERE deal_pricing_id  = @p_deal_pricing_id 

	UPDATE	deal_pricing_detail
	SET		ContractRate	= @ContractRate,
			Commission		= @Commission, 
			HasPassThrough = @HasPassThrough,
			Cost = @Cost,
			BackToBack = @BackToBack
			
	WHERE deal_pricing_id	= @p_deal_pricing_id 
END 

