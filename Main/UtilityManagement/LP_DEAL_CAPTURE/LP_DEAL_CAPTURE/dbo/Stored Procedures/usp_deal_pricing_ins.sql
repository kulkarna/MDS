


CREATE PROC [dbo].[usp_deal_pricing_ins] 
( @p_username varchar(50) 
, @p_account_name varchar(50) 
, @p_sales_channel_role varchar(50)
, @p_comm_rate money
, @p_date_expired datetime
, @p_result_ind char(1)  = 'N'
)
AS 
BEGIN 

	INSERT INTO [lp_deal_capture].[dbo].[deal_pricing]
           ([account_name]
           ,[sales_channel_role]
           ,[commission_rate]
           ,[date_expired]
           ,[username]
           )
     VALUES
           (@p_account_name
           ,@p_sales_channel_role
           ,@p_comm_rate
           ,@p_date_expired
           ,@p_username
           )

	If @p_result_ind = 'Y'
	BEGIN 
		SELECT deal_pricing_id = scope_identity()
	END 

END 

