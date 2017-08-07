﻿/*******************************************************************************
 * usp_DailyPricingUtilitiesSelect
 * Gets utilities for specified parameters
 *
 * History
 *******************************************************************************
 * 7/22/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingUtilitiesSelect]
	@p_username			nchar(100),
	@p_retail_mkt_id	char(02),
	@p_union_select		varchar(15)	= ' '
AS
BEGIN
    SET NOCOUNT ON;
    
	declare @w_user_id                                  int

	select @w_user_id                                   = UserID
	from lp_portal..Users with (NOLOCK INDEX = IX_Users)
	where Username                                      = @p_username 

	if @p_union_select                                  = 'NONE'
	begin
		if lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
			begin
			   select a.option_id, 
					  a.return_value
			   from (select seq                                 = 1,
							option_id                           = 'None',
							return_value                        = 'NONE'
					 union
					 select distinct 
							seq                                 = 2,
							option_id                           = d.utility_descp,
							return_value                        = ltrim(rtrim(c.utility_id))
					 from lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
						  lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
					 where c.utility_id                         = d.utility_id
					 and   d.retail_mkt_id                      = @p_retail_mkt_id
					 and   d.inactive_ind                       = '0') a
			   order by a.seq, a.option_id
			end
		else
			begin
			   select a.option_id, 
					  a.return_value
			   from (select seq                                 = 1,
							option_id                           = 'None',
							return_value                        = 'NONE'
					 union
					 select distinct 
							seq                                 = 2,
							option_id                           = d.utility_descp,
							return_value                        = ltrim(rtrim(c.utility_id))
					 from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
						  lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
						  lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
						  lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
					 where (a.UserID                            = @w_user_id 
					 and    a.RoleID                            = b.RoleID
					 and    b.RoleName                          = c.role_name)
					 and   c.utility_id                         = d.utility_id
					 and   d.retail_mkt_id                      = @p_retail_mkt_id
					 and   d.inactive_ind                       = '0') a
			   order by a.seq, a.option_id
			end
	end
	else
	begin
		if lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
			begin
				select distinct 
					  option_id                                 = d.utility_descp,
					  return_value                              = ltrim(rtrim(c.utility_id))
				from lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
					lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
				where c.utility_id                               = d.utility_id
				and   d.retail_mkt_id                            = @p_retail_mkt_id
				and   d.inactive_ind                             = '0'
				order by option_id
			end
		else
			begin
				select distinct 
					  option_id                                 = d.utility_descp,
					  return_value                              = ltrim(rtrim(c.utility_id))
				from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles_1),
					lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName),
					lp_security..security_role_utility c with (NOLOCK INDEX = security_role_utility_idx),
					lp_common..common_utility d with (NOLOCK INDEX = common_utility_idx)
				where (a.UserID                                  = @w_user_id 
				and    a.RoleID                                  = b.RoleID
				and    b.RoleName                                = c.role_name)
				and   c.utility_id                               = d.utility_id
				and   d.retail_mkt_id                            = @p_retail_mkt_id
				and   d.inactive_ind                             = '0'
				order by option_id
			end
	end    
/*
	DECLARE @w_user_id				int,
			@SalesChannel			varchar(50),
			@ChannelGroupID			int,
			@ChannelGroupIDLen		int,
			@ProductCrossPriceSetID	int
			
	SELECT	@w_user_id	= UserID
	FROM	lp_portal..Users WITH (NOLOCK)
	WHERE	Username	= @p_username 
			
	SET		@SalesChannel = REPLACE(@p_username , 'libertypower\', '') 

	SELECT	@ChannelGroupID	= ChannelGroupID
	FROM	LibertyPower..SalesChannel WITH (NOLOCK)
	WHERE	ChannelName		= @SalesChannel

	SET		@ChannelGroupIDLen = LEN(@ChannelGroupID)
	
	SELECT	@ProductCrossPriceSetID	= ProductCrossPriceSetID
	FROM	LibertyPower..ProductCrossPriceSet
	WHERE	EffectiveDate = (	SELECT MAX(EffectiveDate)
								FROM LibertyPower..ProductCrossPriceSet 
								WHERE EffectiveDate <= GETDATE()
							)	

	IF @p_union_select                                  = 'NONE'
		BEGIN
			IF lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
				BEGIN
				   SELECT a.option_id, 
						  a.return_value
				   FROM	(	SELECT seq                                 = 1,
								option_id                           = 'None',
								return_value                        = 'NONE'
							UNION
							SELECT	DISTINCT 
									seq                                 = 2,
									option_id                           = b.utility_descp,
									return_value                        = LTRIM(RTRIM(b.utility_id))
							FROM	lp_security..security_role_utility a WITH (NOLOCK)
									INNER JOIN lp_common..common_utility b WITH (NOLOCK) ON a.utility_id  = b.utility_id
									INNER JOIN lp_common..common_retail_market d WITH (NOLOCK) ON b.retail_mkt_id = d.retail_mkt_id
									INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK) ON d.ID = pc.MarketID AND b.ID = pc.UtilityID
									INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
									INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) ON pcp.MarketID = pc.MarketID
							WHERE	oa.IsActive					= 1							-- only pull utilities for active offers
							AND		pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID	-- and for utilities that have prices
							AND		pcp.ChannelGroupID			= @ChannelGroupID			-- and for sales channel group						
							AND		d.retail_mkt_id				= @p_retail_mkt_id
							AND		d.inactive_ind				= '0'
						) a
				   ORDER BY a.seq, a.option_id
				END
			ELSE
				BEGIN
				   SELECT	a.option_id, 
							a.return_value
				   FROM		(	SELECT	seq                                 = 1,
									option_id                           = 'None',
									return_value                        = 'NONE'
								UNION
								SELECT	DISTINCT 
										seq                                 = 2,
										option_id                           = b.utility_descp,
										return_value                        = LTRIM(RTRIM(b.utility_id))
								FROM	lp_portal..UserRoles ur WITH (NOLOCK)
										INNER JOIN lp_portal..Roles r WITH (NOLOCK) ON ur.RoleID = r.RoleID
										INNER JOIN lp_security..security_role_utility sru with (NOLOCK) ON r.RoleName = sru.role_name
										INNER JOIN lp_common..common_utility b with (NOLOCK) ON sru.utility_id = b.utility_id
										INNER JOIN lp_common..common_retail_market d WITH (NOLOCK) ON b.retail_mkt_id = d.retail_mkt_id
										INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK) ON d.ID = pc.MarketID AND b.ID = pc.UtilityID
										INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
										INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) ON pcp.MarketID = pc.MarketID
								WHERE	oa.IsActive					= 1							-- only pull utilities for active offers
								AND		pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID	-- and for utilities that have prices
								AND		pcp.ChannelGroupID			= @ChannelGroupID			-- and for sales channel group						
								AND		d.retail_mkt_id				= @p_retail_mkt_id					  
								AND		ur.UserID					= @w_user_id 
								AND		d.retail_mkt_id				= @p_retail_mkt_id
								AND		d.inactive_ind				= '0'
							) a
				   ORDER BY a.seq, a.option_id
				END
		END
	ELSE
		BEGIN
			IF lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
				BEGIN
					SELECT	DISTINCT 
							seq                                 = 2,
							option_id                           = b.utility_descp,
							return_value                        = LTRIM(RTRIM(b.utility_id))
					FROM	lp_security..security_role_utility a with (NOLOCK)
							INNER JOIN lp_common..common_utility b with (NOLOCK) ON a.utility_id  = b.utility_id
							INNER JOIN lp_common..common_retail_market d WITH (NOLOCK) ON b.retail_mkt_id = d.retail_mkt_id
							INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK) ON d.ID = pc.MarketID AND b.ID = pc.UtilityID
							INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
							INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) ON pcp.MarketID = pc.MarketID
					WHERE	oa.IsActive					= 1							-- only pull utilities for active offers
					AND		pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID	-- and for utilities that have prices
					AND		pcp.ChannelGroupID			= @ChannelGroupID			-- and for sales channel group						
					AND		d.retail_mkt_id				= @p_retail_mkt_id
					AND		d.inactive_ind				= '0'
					ORDER BY option_id
				END
			ELSE
				BEGIN
					SELECT	DISTINCT  
							seq                                 = 2,
							option_id                           = b.utility_descp,
							return_value                        = LTRIM(RTRIM(b.utility_id))
					FROM	lp_portal..UserRoles ur WITH (NOLOCK)
							INNER JOIN lp_portal..Roles r WITH (NOLOCK) ON ur.RoleID = r.RoleID
							INNER JOIN lp_security..security_role_utility sru with (NOLOCK) ON r.RoleName = sru.role_name
							INNER JOIN lp_common..common_utility b with (NOLOCK) ON sru.utility_id = b.utility_id
							INNER JOIN lp_common..common_retail_market d WITH (NOLOCK) ON b.retail_mkt_id = d.retail_mkt_id
							INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK) ON d.ID = pc.MarketID AND b.ID = pc.UtilityID
							INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
							INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) ON pcp.MarketID = pc.MarketID
					WHERE	oa.IsActive					= 1							-- only pull utilities for active offers
					AND		pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID	-- and for utilities that have prices
					AND		pcp.ChannelGroupID			= @ChannelGroupID			-- and for sales channel group						
					AND		d.retail_mkt_id				= @p_retail_mkt_id					  
					AND		ur.UserID					= @w_user_id 
					AND		d.retail_mkt_id				= @p_retail_mkt_id
					AND		d.inactive_ind				= '0'
					ORDER BY option_id
				END
		END
*/		

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power