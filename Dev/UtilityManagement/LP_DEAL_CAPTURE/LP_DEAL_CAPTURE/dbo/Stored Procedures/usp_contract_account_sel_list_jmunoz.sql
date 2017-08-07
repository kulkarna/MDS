 /*
 *******************************************************************************
 * 04/26/2012 - Jose Munoz - SWCS
 * Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
			and use the new table in libertypower database
 *******************************************************************************

exec usp_contract_account_sel_list 'WVILCHEZ', '2006-0000121'
*/   
 
CREATE procedure [dbo].[usp_contract_account_sel_list_jmunoz]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30))
as

declare @w_sales_channel_role                       nvarchar(50)

select @w_sales_channel_role                        = sales_channel_role
from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr

declare @w_user_id                                  int

select @w_user_id                                   = UserID
from libertypower..[User] with (NOLOCK INDEX = User__Username_I)
where Username                                      = @p_username

if not exists(select b.RoleName 
              from libertypower..[UserRole] a with (NOLOCK)
              INNER JOIN libertypower..[Role] b with (NOLOCK)
              ON b.RoleID							= a.RoleID
              where a.UserID                        = @w_user_id
              and   b.RoleName                      = @w_sales_channel_role)
begin 
   select account_number                            = ' ',
          status                                    = ' '
end

select ca.account_number,
       ca.status,
       ca.utility_id,
       n.full_name,
       a.address,
       a.suite,
       a.city,
       a.state,
       a.zip,
       ca.requested_flow_start_date,
       ca.enrollment_type,
       ba.address as "Billingaddress",
       ba.suite as "Billingsuite",
       ba.city as "Billingcity",
       ba.state as "Billingstate",
       ba.zip as "Billingzip",
       ca.rate_id,
       ca.rate,
       m.meter_number,
       pr.rate_descp,
       ca.customer_code,
       ai.name_key,
       ai.BillingAccount,
       ai.MeterDataMgmtAgent,
       ai.MeterServiceProvider,
       ai.MeterInstaller,
       ai.MeterReader,
       ai.SchedulingCoordinator,
       c.first_name,
       c.last_name,
       c.phone,
       ca.zone
from deal_contract_account ca with (NOLOCK INDEX = deal_contract_account_idx)
left join deal_name n ON ca.contract_nbr = n.contract_nbr AND ca.account_name_link = n.name_link
left join deal_contact c ON ca.contract_nbr = c.contract_nbr AND ca.customer_contact_link = c.contact_link
left join deal_address a ON ca.contract_nbr = a.contract_nbr AND ca.service_address_link = a.address_link
left join deal_address ba ON ca.contract_nbr = ba.contract_nbr AND ca.billing_address_link = ba.address_link
left join account_meters m ON ca.account_id = m.account_id
inner join lp_common..common_product_rate pr ON ca.product_id = pr.product_id AND ca.rate_id = pr.rate_id
left join lp_account..account_info ai ON ca.account_id = ai.account_id
where ca.contract_nbr                                  = @p_contract_nbr
and   @p_account_number							   IN ('',ca.account_number)
order by ca.account_id desc







