 /*
 *******************************************************************************
 * 04/26/2012 - Jose Munoz - SWCS
 * Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
			and use the new table in libertypower database
 *******************************************************************************
*/   
 
CREATE FUNCTION [dbo].[ufn_is_rate_accessible_jmunoz]
( @p_product_id				varchar(30) 
, @p_rate_id				int 
, @p_sales_channel_role		varchar(50)
, @p_username				varchar(50)
, @p_contract_nbr			varchar(25) 
) 
RETURNS BIT 
AS 
BEGIN 

	DECLARE @COUNT int
	DECLARE @SUBMIT_COUNT int 
	
	SET @SUBMIT_COUNT = 0 

	IF ltrim(rtrim(isnull(@p_contract_nbr, ''))) <> '' 
	BEGIN 
		SELECT @SUBMIT_COUNT = count ( * ) 
		FROM ( Select contract_nbr 
				from deal_contract WITH (NOLOCK)
				where contract_nbr = @p_contract_nbr and @p_contract_nbr <> '' and product_id = @p_product_id and rate_id = @p_rate_id
			   UNION 		
				Select contract_nbr 
				from deal_contract_account WITH (NOLOCK)
				where contract_nbr = @p_contract_nbr and  @p_contract_nbr <> '' and product_id = @p_product_id and rate_id = @p_rate_id
			 ) as t
	END 

	SELECT @COUNT = count(*)

	FROM lp_common..common_product_rate pr WITH (NOLOCK)
		LEFT JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK)
		ON pr.product_id		= dpd.product_id 
		AND pr.rate_id			= dpd.rate_id  
		LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK)
		ON dp.deal_pricing_id	= dpd.deal_pricing_id
    WHERE pr.product_id = @p_product_id 
		 AND pr.rate_id = @p_rate_id
		 AND ( -- no custom pricing 
			  dp.deal_pricing_id is null 
			  OR 
				( -- rate has not expired 
				  dp.date_expired > convert(char(08), getdate(), 112)
				  AND( -- user has access to deal pricing
		 				dp.sales_channel_role		= @p_username 
						OR dp.sales_channel_role	= @p_sales_channel_role 
						OR dp.sales_channel_role	in 
						(SELECT b.RoleName 
							FROM libertypower..[UserRole]		a WITH (NOLOCK)
								INNER JOIN libertypower..[Role] b WITH (NOLOCK)
								ON a.RoleID = b.RoleID  
								INNER JOIN libertypower..[User] u with (NOLOCK INDEX = IX_Users)  ON a.userID = u.UserID
							WHERE Username = @p_username
						)
						OR lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1 
					 )
				  AND( -- rate has not already been submitted or exists on the current contract
			 		   dpd.rate_submit_ind = 0 OR @SUBMIT_COUNT > 0 
					  )
				  )
			  )

	RETURN case when  @count > 0 then 1 else 0 end

END 

