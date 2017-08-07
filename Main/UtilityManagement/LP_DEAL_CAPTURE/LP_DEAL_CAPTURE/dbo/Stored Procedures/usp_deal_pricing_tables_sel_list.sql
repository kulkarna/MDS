
--------------------------------------------------------------------------------
-- Updated 12/9/2009
-- Sofia Melo
-- Changed account type source from libertypower..AccountType
-- to lp_common..product_account_type
--------------------------------------------------------------------------------

-- exec usp_deal_pricing_tables_sel_list @p_account_name = 'nov', @p_order_by='1'
CREATE PROC [dbo].[usp_deal_pricing_tables_sel_list]
( 
  @p_username			 varchar(50) = '' 
 ,@p_sales_channel_role  varchar(50) = ''
 ,@p_market_id			 varchar(50) = ''
 ,@p_utility_id			 varchar(50) = ''
 ,@p_product_id			 varchar(50) = ''
 ,@p_account_name		 varchar(50) = ''
 ,@p_pricing_request_id  varchar(50) = ''
 ,@p_account_type		 int = 0
 ,@p_show_expired		 bit = 0
 ,@p_order_by            varchar(50) = ''
 ,@p_show_new_tables	 bit = 0
) 
AS 
BEGIN 

	SET NOCOUNT ON;
	
	declare @sqlQuery nvarchar(4000)
	declare @paramDefinition nvarchar(1000)
	
	set @sqlQuery = 'SELECT 
						 d.[deal_pricing_detail_id]
						,d.[deal_pricing_id]
						,d.[product_id]
						,d.[rate_id]
						,d.[date_created]
						,d.[username]
						,d.[date_modified]
						,d.[modified_by]
						,d.[MTM]
						,p.product_descp
						,d.ContractRate
						,CASE WHEN d.HasPassThrough = ''1'' THEN ''1'' ELSE ''0'' END AS HasPassThrough
						,CASE WHEN d.BackToBack = ''1'' THEN ''1'' ELSE ''0'' END AS BackToBack
						,d.HeatIndexSourceID -- Project IT037
						,d.HeatRate -- Project IT037
						,d.ExpectedTermUsage
						,d.ExpectedAccountsAmount
						,d.rate_submit_ind
						,p.account_type_id
						,p.utility_id
						,u.UtilityCode
						,m.MarketCode
						,dp.sales_channel_role
						,AccountType = at.account_type
						,dp.account_name
						,dp.date_expired
						,dp.pricing_request_id
						,d.PriceID
						,d.SelfGenerationID
					FROM [lp_deal_capture].[dbo].[deal_pricing_detail] d (NOLOCK)
						JOIN lp_deal_capture..deal_pricing dp (NOLOCK) ON dp.deal_pricing_id = d.deal_pricing_id
						JOIN lp_common.dbo.common_product_rate (NOLOCK) r ON d.product_id = r.product_id AND d.rate_id = r.rate_id 
						JOIN lp_common.dbo.common_product p (NOLOCK) ON d.product_id = p.product_id 
						JOIN LibertyPower..Utility u (NOLOCK) ON p.utility_id = u.utilityCode
						JOIN LibertyPower..Market m (NOLOCK) ON u.MarketID = m.ID  
						JOIN lp_common..product_account_type at (NOLOCK) on p.account_type_id = at.account_type_id                
					WHERE ( @x_show_expired = 1 OR ( @x_show_expired = 0 and isnull(date_expired, getdate() + 1 ) > getdate() )  )' 
    
    if @p_sales_channel_role <> ''
    	set @sqlQuery = @sqlQuery + ' and dp.sales_channel_role = @x_sales_channel_role'
       
    if @p_market_id <> ''
    	set @sqlQuery = @sqlQuery + ' and m.MarketCode = @x_market_id'
    
    if @p_utility_id <> ''
    	set @sqlQuery = @sqlQuery + ' and u.utilityCode = @x_utility_id'
    
    if @p_product_id <> ''
    	set @sqlQuery = @sqlQuery + ' and d.product_id = @x_product_id'
    	
    if @p_account_name <> ''
        set @sqlQuery = @sqlQuery + ' and dp.account_name like ' + '''' + '%' + @p_account_name + '%' + ''''

    if @p_pricing_request_id <> ''
        set @sqlQuery = @sqlQuery + ' and dp.pricing_request_id = @x_pricing_request_id'
        
    if @p_account_type <> 0
        set @sqlQuery = @sqlQuery + ' and p.account_type_id = @x_account_type'
        
    if @p_show_new_tables <> 0
		set @sqlQuery = @sqlQuery + ' and d.PriceID IS NOT NULL and p.IsCustom = 0'
        
    set @sqlQuery = @sqlQuery + ' ORDER BY ' + @p_order_by
	
	print @sqlQuery
	set @paramDefinition = '  @x_sales_channel_role  varchar(50)
							 ,@x_market_id			 varchar(50)
							 ,@x_utility_id			 varchar(50)
							 ,@x_product_id			 varchar(50)
							 ,@x_pricing_request_id	 varchar(50)
							 ,@x_account_type		 int
							 ,@x_show_expired		 bit '



	execute sp_Executesql  @sqlQuery
                          ,@paramDefinition
                          ,@x_sales_channel_role = @p_sales_channel_role
						  ,@x_market_id = @p_market_id
						  ,@x_utility_id = @p_utility_id
					 	  ,@x_product_id = @p_product_id
					 	  ,@x_pricing_request_id = @p_pricing_request_id
						  ,@x_account_type = @p_account_type
						  ,@x_show_expired = @p_show_expired
END 
