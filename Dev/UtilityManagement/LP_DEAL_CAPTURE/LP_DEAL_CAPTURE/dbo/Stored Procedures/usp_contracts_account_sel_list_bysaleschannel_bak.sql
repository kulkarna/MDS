--exec usp_contracts_account_sel_list_bysaleschannel 'libertypower\dmarino'

CREATE procedure [dbo].[usp_contracts_account_sel_list_bysaleschannel_bak] 
(@p_username                                        nchar(100),
 @p_view                                            varchar(35) = 'ALL',
 @p_rec_sel                                         int = 50)
as

set rowcount @p_rec_sel
 
if @p_view                                          = 'ALL'
begin
   select a.status,
          a.contract_nbr,
          a.account_number,
          a.utility_account_number,
          a.retail_mkt_id,
          a.utility_id,
          a.product_id,
          a.rate_id,
          a.rate
   from (select a.status,
                a.contract_nbr,
                e.account_number,
                utility_account_number = e.account_number,
                e.retail_mkt_id,
                e.utility_id,
                e.product_id,
                e.rate_id,
                e.rate
         from deal_contract a with (NOLOCK INDEX = deal_contract_idx),
              lp_portal..Users b with (NOLOCK INDEX = IX_Users),
              lp_portal..UserRoles c with (NOLOCK INDEX = IX_UserRoles),
              lp_portal..Roles d with (NOLOCK INDEX = IX_RoleName),
              deal_contract_account e with (NOLOCK INDEX = deal_contract_account_idx)
         where (a.status                         like 'DRAFT%'
         or     a.status                            = 'RUNNING')
         and   b.Username                           = @p_username
         and   b.UserID                             = c.UserID
         and   c.RoleID                             = d.RoleID
         and   d.RoleName                           = a.sales_channel_role
         and   a.contract_nbr                       = e.contract_nbr
         and   e.status                            <> 'SENT'
         union
         select d.status,
                d.contract_nbr,
                d.account_number,
                utility_account_number = d.account_number,
                d.retail_mkt_id,
                d.utility_id,
                d.product_id,
                d.rate_id,
                d.rate
         from lp_portal..Users a with (NOLOCK INDEX = IX_Users),
              lp_portal..UserRoles b with (NOLOCK INDEX = IX_UserRoles),
              lp_portal..Roles c with (NOLOCK INDEX = IX_RoleName),
              lp_account..account d with (NOLOCK INDEX = account_idx3)
         where a.Username                           = @p_username
         and   a.UserID                             = b.UserID
         and   b.RoleID                             = c.RoleID
         and   c.RoleName                           = d.sales_channel_role) a
   order by a.account_number
end



