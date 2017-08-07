

CREATE PROC [dbo].[usp_deal_pricing_detail_del]
( 
 @p_deal_pricing_detail_id			int ,
 @p_error                          char(01) = ' ' output,
 @p_msg_id                          char(08) = ' ' output,
 @p_descp                           varchar(250) = ' ' output,
 @p_result_ind                      char(01) = 'N'
)

AS 
BEGIN 

	
	DECLARE @rate_id int 
	DECLARE @product_id char(20) 
	DECLARE @eff_date datetime 
	DECLARE @rate_in_use bit 

	DECLARE @RC int 
	
	DECLARE @w_error   char(01) 
	DECLARE @w_msg_id  char(08)
	DECLARE @w_descp   varchar(250)
	DECLARE @w_descp_add   varchar(250) 

	SET @w_error = 'I'
	SET @w_msg_id = '00000001'
	SET @w_descp = 'Process completed successfully.'
	SET @w_descp_add = ' '

	DECLARE @w_return int 
	SET @w_return = 0 

	-- Get product_rate data 
	SELECT @rate_id = pr.rate_id, @product_id = pr.product_id, @eff_date = eff_date, @rate_in_use = isnull(rate_submit_ind  , 0)
	FROM lp_common..common_product_rate pr JOIN 
		[lp_deal_capture].[dbo].[deal_pricing_detail] d ON pr.product_id = d.product_id AND pr.rate_id = d.rate_id 
	WHERE deal_pricing_detail_id = @p_deal_pricing_detail_id

	IF @rate_in_use <> 1 
		BEGIN
			-- delete product_rate entry
			EXEC @RC = lp_common.dbo.usp_product_rate_del  '', @product_id, @rate_id, @eff_date , @w_error, @w_msg_id, @w_descp, 'N' 

			If @RC <> 0 OR @@Error <> 0 
			BEGIN 
				if ltrim(rtrim(isnull(@w_msg_id,''))) = '' 
					SET @w_msg_id  = '00000002'
				SET @w_descp_add  = 'Unable to delete product rate.'	
				SET @w_return = 1
				GOTO ERROR_LINE
			END

			-- delete deal_pricing_detail 
			DELETE [lp_deal_capture].[dbo].[deal_pricing_detail]
				WHERE deal_pricing_detail_id = @p_deal_pricing_detail_id 

			If @@Error <> 0 
			BEGIN 
				SET @w_msg_id  = '00000002'
				SET @w_descp_add  = 'Unable to delete custom rate'	
				SET @w_return = 1
				GOTO ERROR_LINE
			END
		END 
	ELSE
		BEGIN 
			SET @w_msg_id  = '00000002'
			SET @w_descp_add  = 'Rate is already in use, unable to delete.'	
			SET @w_return = 1
		END 		

ERROR_LINE:

	if  @w_return <> 0
		begin
			SET @w_error = 'E'
		   --select @w_msg_id                                 = '00000002'
		   exec lp_common..usp_messages_sel @w_msg_id, @w_descp output
		end
 
	if @p_result_ind                                    = 'Y'
	begin
	   select flag_error                                = @w_error,
			  code_error                                = @w_msg_id,
			  message_error                             = isnull(@w_descp, '')  + ' ' + isnull(@w_descp_add, '')
	end
 
	select @p_error = @w_error , 
			@p_msg_id = @w_msg_id,
			@p_descp = isnull(@w_descp, '')  + ' ' + isnull(@w_descp_add, '') 

	return @w_return
 
END 



