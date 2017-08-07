--exec usp_contract_account_sel_list 'WVILCHEZ', '2006-0000121'

CREATE procedure [dbo].[usp_contract_account_select_list_bak]
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
from lp_portal..Users
where Username                                      = @p_username

select ca.account_number,
	   ca.account_id,
       ca.status,
       ca.utility_id,
       ca.contract_type,
       ca.account_type,
       ca.customer_name_link,              
       ca.customer_address_link,
	   ca.customer_contact_link,
       ca.billing_address_link,
	   ca.billing_contact_link,
	   ca.owner_name_link,
	   ca.service_address_link,
	   ca.account_name_link,  
	   ca.additional_id_nbr, 
	   ca.additional_id_nbr_type,
	   ca.sales_channel_role,
	   ca.sales_rep,
	   ca.retail_mkt_id,
	   ca.product_id,
	   ca.date_deal,
	   ca.date_submit,
	   ca.business_type,
	   ca.business_activity,
	   ca.contract_eff_start_date,
	   ca.term_months,
	   ca.date_end,
	   ca.date_created,
	   ca.TaxStatus,
	   ca.origin,
	   ca.deal_type,
	   ca.customer_code,
	   ca.customer_group,
	   ca.SSNEncrypted,
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
       c.title,
       c.fax,
       c.email,
       ca.zone,
       dcc.date_comment,
       dcc.comment,
       cb.first_name AS "BillingFirstName",
	   cb.last_name AS "BillingLastName",
	   cb.title AS "BillingTitle",
	   cb.Phone AS "BillingPhone",
	   cb.fax AS "BillingFax",
	   cb.email AS "BillingEmail",
	   cn.full_name AS "CustomerName",
	   ow.full_name AS "OwnerName",
	   cus.address AS "CustomerAddress",
	   cus.suite AS "CustomerSuite",
	   cus.state AS "CustomerState",
	   cus.zip AS "CustomerZip",
	   cus.city AS "CustomerCity",
	   dca.contract_nbr_amend
              
from deal_contract_account ca with (NOLOCK INDEX = deal_contract_account_idx)
left join deal_name n ON ca.contract_nbr = n.contract_nbr AND ca.account_name_link = n.name_link
left join deal_contact c ON ca.contract_nbr = c.contract_nbr AND ca.customer_contact_link = c.contact_link
left join deal_address a ON ca.contract_nbr = a.contract_nbr AND ca.service_address_link = a.address_link
left join deal_address ba ON ca.contract_nbr = ba.contract_nbr AND ca.billing_address_link = ba.address_link
left join deal_address cus ON ca.contract_nbr = cus.contract_nbr AND ca.customer_address_link = cus.address_link
left join account_meters m ON ca.account_id = m.account_id
left join deal_contract_comment dcc ON ca.contract_nbr = dcc.contract_nbr
inner join lp_common..common_product_rate pr ON ca.product_id = pr.product_id AND ca.rate_id = pr.rate_id
left join lp_account..account_info ai ON ca.account_id = ai.account_id
left join deal_contact cb ON ca.contract_nbr = cb.contract_nbr AND ca.billing_contact_link = cb.contact_link
left join deal_name cn ON ca.contract_nbr = cn.contract_nbr AND ca.account_name_link = cn.name_link
left join deal_name ow ON ca.contract_nbr = ow.contract_nbr AND ca.account_name_link = ow.name_link
left join deal_contract_amend dca ON ca.contract_nbr = dca.contract_nbr
where ca.contract_nbr                                  = @p_contract_nbr
and   @p_account_number							   IN ('',ca.account_number)
order by ca.account_id desc







