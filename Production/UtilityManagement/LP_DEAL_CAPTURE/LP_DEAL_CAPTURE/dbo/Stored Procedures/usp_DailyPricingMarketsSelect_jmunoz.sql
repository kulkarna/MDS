
/*******************************************************************************
 * usp_DailyPricingMarketsSelect
 * Gets markets for specified parameters
 *
 * History
 *******************************************************************************
 * 7/22/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
* 04/26/2012 - Jose Munoz - SWCS
* Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
		and use the new table in libertypower database
*******************************************************************************
*/

CREATE PROCEDURE [dbo].[usp_DailyPricingMarketsSelect_jmunoz]
	@p_username			nchar(100),
	@p_union_select		varchar(15),
	@p_contract_type	varchar(15)
AS
BEGIN
    SET NOCOUNT ON;

		SELECT	DISTINCT m.retail_mkt_descp AS option_id, m.retail_mkt_id AS return_value
		FROM	lp_common..common_retail_market m WITH (NOLOCK)
		JOIN	lp_security..security_role_retail_mkt s WITH (NOLOCK) ON m.retail_mkt_id = s.retail_mkt_id
		JOIN	libertypower..[Role]		r WITH (NOLOCK) ON r.RoleName = s.role_name		
		JOIN	libertypower..[UserRole]	ur WITH (NOLOCK) ON r.RoleID = ur.RoleID
		JOIN	libertypower..[User]		u WITH (NOLOCK) ON ur.userid = u.userid
		WHERE	u.Username	= @p_username
		AND		s.role_name <> 'All Utility Access'
		
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
			   FROM (SELECT seq                                 = 1,
							option_id                           = 'None',
							return_value                        = 'NN'
					 UNION
					 SELECT DISTINCT
							seq                                 = 2,
							option_id                           = d.retail_mkt_descp,
							return_value                        = ltrim(rtrim(d.retail_mkt_id))
					 FROM	lp_common..common_retail_market d WITH (NOLOCK)
							INNER JOIN lp_common..common_wholesale_market e WITH (NOLOCK) ON d.wholesale_mkt_id = e.wholesale_mkt_id
							INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK) ON d.ID = pc.MarketID
							INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
							INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) ON pcp.MarketID = pc.MarketID
					 WHERE	oa.IsActive					= 1							-- only pull markets for active offers
					 AND	pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID	-- and for markets that have prices
					 AND	pcp.ChannelGroupID			= @ChannelGroupID			-- and for sales channel group
					 AND	d.retail_mkt_id IN			(	SELECT	retail_mkt_id 
															FROM	lp_common..utility_permission
															WHERE	(paper_contract_only = 0 OR paper_contract_only = CASE WHEN (LEFT(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') THEN 1 ELSE 0 END))
														) a
			   ORDER BY a.seq, a.option_id
			END
		ELSE
			BEGIN
			   SELECT	a.option_id,
						a.return_value
			   FROM (SELECT seq                                 = 1,
							option_id                           = 'None',
							return_value                        = 'NN'
					 UNION
					 SELECT DISTINCT
							seq                                 = 2,
							option_id                           = d.retail_mkt_descp,
							return_value                        = LTRIM(RTRIM(d.retail_mkt_id))
					 FROM	lp_portal..UserRoles a WITH (NOLOCK)
							INNER JOIN lp_portal..Roles b WITH (NOLOCK) ON a.RoleID = b.RoleID
							INNER JOIN lp_security..security_role_retail_mkt c WITH (NOLOCK) ON b.RoleName = c.role_name
							INNER JOIN lp_common..common_retail_market d WITH (NOLOCK) ON c.retail_mkt_id = d.retail_mkt_id
							INNER JOIN lp_common..common_wholesale_market e WITH (NOLOCK) ON d.wholesale_mkt_id = e.wholesale_mkt_id
							INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK) ON d.ID = pc.MarketID
							INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
							INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) ON pcp.MarketID = pc.MarketID
					 WHERE	oa.IsActive					= 1							-- only pull markets for active offers
					 AND	pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID	-- and for markets that have prices
					 AND	pcp.ChannelGroupID			= @ChannelGroupID			-- and for sales channel group
					 AND	d.wholesale_mkt_id			= e.wholesale_mkt_id
					 AND	e.inactive_ind				= '0' 
					 AND	d.retail_mkt_id IN			(	SELECT	retail_mkt_id 
															FROM	lp_common..utility_permission
															WHERE	(paper_contract_only = 0 OR paper_contract_only = CASE WHEN (LEFT(@p_contract_type, 5) = 'PAPER' OR @p_contract_type = 'PRE-PRINTED') THEN 1 ELSE 0 END))
														) a
			   ORDER BY a.seq, a.option_id
			END
	END
ELSE
	BEGIN
		IF lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
			BEGIN
				SELECT	DISTINCT
						option_id                                 = d.retail_mkt_descp,
						return_value                              = LTRIM(RTRIM(d.retail_mkt_id))
				 FROM	lp_portal..UserRoles a WITH (NOLOCK)
						INNER JOIN lp_portal..Roles b WITH (NOLOCK) ON a.RoleID = b.RoleID
						INNER JOIN lp_security..security_role_retail_mkt c WITH (NOLOCK) ON b.RoleName = c.role_name
						INNER JOIN lp_common..common_retail_market d WITH (NOLOCK) ON c.retail_mkt_id = d.retail_mkt_id
						INNER JOIN lp_common..common_wholesale_market e WITH (NOLOCK) ON d.wholesale_mkt_id = e.wholesale_mkt_id
						INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK) ON d.ID = pc.MarketID
						INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
						INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) ON pcp.MarketID = pc.MarketID
				WHERE	oa.IsActive					= 1							-- only pull markets for active offers
				AND		pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID	-- and for markets that have prices
				AND		pcp.ChannelGroupID			= @ChannelGroupID			-- and for sales channel group
				AND		d.retail_mkt_id IN			(	SELECT	retail_mkt_id 
														FROM lp_common..utility_permission
														WHERE (paper_contract_only = 0 OR paper_contract_only = CASE WHEN (LEFT(@p_contract_type, 5) = 'PAPER' OR @p_contract_type = 'PRE-PRINTED') THEN 1 ELSE 0 END))
			   ORDER BY option_id
			END
		ELSE
			BEGIN
				SELECT	DISTINCT
						option_id                                 = d.retail_mkt_descp,
						return_value                              = LTRIM(RTRIM(d.retail_mkt_id))
				 FROM	lp_portal..UserRoles a WITH (NOLOCK)
						INNER JOIN lp_portal..Roles b WITH (NOLOCK) ON a.RoleID = b.RoleID
						INNER JOIN lp_security..security_role_retail_mkt c WITH (NOLOCK) ON b.RoleName = c.role_name
						INNER JOIN lp_common..common_retail_market d WITH (NOLOCK) ON c.retail_mkt_id = d.retail_mkt_id
						INNER JOIN lp_common..common_wholesale_market e WITH (NOLOCK) ON d.wholesale_mkt_id = e.wholesale_mkt_id
						INNER JOIN LibertyPower..ProductConfiguration pc WITH (NOLOCK) ON d.ID = pc.MarketID
						INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
						INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) ON pcp.MarketID = pc.MarketID
				WHERE	oa.IsActive					= 1							-- only pull markets for active offers
				AND		pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID	-- and for markets that have prices
				AND		pcp.ChannelGroupID			= @ChannelGroupID			-- and for sales channel group
				AND		d.wholesale_mkt_id                         = e.wholesale_mkt_id
				AND		e.inactive_ind                             = '0'
				AND		d.retail_mkt_id IN			(	SELECT	retail_mkt_id 
														FROM	lp_common..utility_permission
														WHERE	(paper_contract_only = 0 OR paper_contract_only = CASE WHEN (LEFT(@p_contract_type, 5) = 'PAPER' OR @p_contract_type = 'PRE-PRINTED') THEN 1 ELSE 0 END))
			   ORDER BY option_id
			END
	END
*/
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

