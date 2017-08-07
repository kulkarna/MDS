/*
Modified 3/5/09
To allow all markets to be selected for Liberty Power employees
for drop-down controls on web pages
*******************************************************************************
* 04/26/2012 - Jose Munoz - SWCS
* Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
		and use the new table in libertypower database
*******************************************************************************

-- exec usp_market_sel_listbyusername 'admin'
-- exec usp_market_sel_listbyusername_jmunoz 'admin'

*/
CREATE procedure [dbo].[usp_market_sel_listbyusername_jmunoz]
(@p_username                                        nchar(100),
 @p_union_select                                    varchar(15) = ' ',
 @p_contract_type									varchar(15)	= 'PAPER')
as
 
declare @w_user_id                                  int

select @w_user_id                                   = UserID
from libertypower..[User] with (NOLOCK INDEX = User__Username_I)
where Username                                      = @p_username 

if @p_union_select                                  = 'NONE'
begin
	if lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
		begin
		   select a.option_id,
				  a.return_value
		   from (select seq                                 = 1,
						option_id                           = 'None',
						return_value                        = 'NN'
				 union
				 select distinct
						seq                                 = 2,
						option_id                           = ltrim(rtrim(d.RetailMktDescp)),
						return_value                        = ltrim(rtrim(d.MarketCode))
				 from libertypower..Market d with (NOLOCK) 
					  --lp_common..common_wholesale_market e with (NOLOCK INDEX = common_wholesale_market_idx)
				 where d.MarketCode in (	select retail_mkt_id 
											from lp_common..utility_permission WITH (NOLOCK)
											where (paper_contract_only = 0 or paper_contract_only = case when (left(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') then 1 else 0 end))) a
		   order by a.seq, a.option_id
		end
	else
		begin
		   select a.option_id,
				  a.return_value
		   from (select seq                                 = 1,
						option_id                           = 'None',
						return_value                        = 'NN'
				 union
				 select distinct
						seq                                 = 2,
						option_id                           = ltrim(rtrim(d.RetailMktDescp)),
						return_value                        = ltrim(rtrim(c.retail_mkt_id))
				 from libertypower..[UserRole] a with (NOLOCK)
				 inner join libertypower..[Role] b with (NOLOCK)
				 on b.RoleID					= a.RoleID
				 inner join lp_security..security_role_retail_mkt c with (NOLOCK INDEX = security_role_retail_mkt_idx)
				 on c.role_name					= b.RoleName
				 inner join libertypower..Market d with (NOLOCK)
				 on d.MarketCode				= c.retail_mkt_id
				 inner join libertypower..WholesaleMarket e with (NOLOCK)
				 on e.ID						= d.WholesaleMktId
				 where a.UserID                 = @w_user_id 
				 and   d.InactiveInd			= '0'
				 and   e.InactiveInd			= '0' 
				 and   d.MarketCode				in (select retail_mkt_id 
													from lp_common..utility_permission WITH (NOLOCK)
													where (paper_contract_only = 0 or paper_contract_only = case when (left(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') then 1 else 0 end))) a
		   order by a.seq, a.option_id
		end
end
else
begin
	if lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
		begin
		   select distinct
				  option_id                                 = ltrim(rtrim(d.RetailMktDescp)),
				  return_value                              = ltrim(rtrim(d.MarketCode))
		   from libertypower..Market d with (NOLOCK)
				--lp_common..common_wholesale_market e with (NOLOCK INDEX = common_wholesale_market_idx)
		   where d.MArketCode in (	select retail_mkt_id 
									from lp_common..utility_permission WITH (NOLOCK)
									where (paper_contract_only = 0 or paper_contract_only = case when (left(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') then 1 else 0 end))
		   order by option_id
		end
	else
		begin
		   select distinct
				  option_id                                 = ltrim(rtrim(d.RetailMktDescp)),
				  return_value                              = ltrim(rtrim(c.retail_mkt_id))
			from libertypower..[UserRole] a with (NOLOCK)
			inner join libertypower..[Role] b with (NOLOCK)
			on b.RoleID						= a.RoleID
			inner join lp_security..security_role_retail_mkt c with (NOLOCK INDEX = security_role_retail_mkt_idx)
			on c.role_name					= b.RoleName
			inner join libertypower..Market d with (NOLOCK)
			on d.MarketCode					= c.retail_mkt_id
			inner join libertypower..WholesaleMarket e with (NOLOCK)
			on e.ID								= d.WholesaleMktId
			where a.UserID                      = @w_user_id 
			and   d.InactiveInd                 = '0'
			and   e.InactiveInd                 = '0'
			and   d.MarketCode in (	select retail_mkt_id 
										from lp_common..utility_permission	WITH (NOLOCK)
										where (paper_contract_only = 0 or paper_contract_only = case when (left(@p_contract_type, 5) = 'PAPER' or @p_contract_type = 'PRE-PRINTED') then 1 else 0 end))
		   order by option_id
		end
end


