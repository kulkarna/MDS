---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 use[Lp_enrollment]
 Go
 -- =============================================

-- Updated: Sadiel Jarvis & Brahmaiah Chowdary Murakonda 6/17/2013

-- Migrated query to use INNER JOIN syntax. Updated join to account_additional_info table to be LEFT JOIN instead.

-- SD 1-90233447

-- =============================================
  
--exec usp_retention_detail_sel_list 'test', '200606-00000001', 'ALL', 0  
  
alter procedure [dbo].[usp_retention_detail_sel_list]  
(@p_username                                        nchar(100),  
 @p_call_request_id                                 char(15),  
 @p_view                                            varchar(35) = 'ALL',  
 @p_rec_sel                                         int = 50)  
as  
   
declare @w_account_id                               char(12)  
  
select @w_account_id                                = account_id  
from retention_header a WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = retention_header_idx)  
where call_request_id                               = @p_call_request_id  
  
--set rowcount @p_rec_sel  
   
if @p_view                                          = 'ALL'  
begin  
  
   select [select]                                  = case when a.[select] = 1   
                                                           or   b.account_id = @w_account_id  
                                                           then 'Yes'  
                                                           else 'No'    
                                                      end,  
          a.call_request_id,  
          a.phone,  
          a.account_id,  
          b.account_number,  
          f.status_descp,  
          g.sub_status_descp,  
          a.contract_nbr,  
          a.utility_id,  
          a.annual_usage,  
          account_name                              = d.full_name,  
          first_name                                = c.first_name,  
          last_name                                 = c.last_name,  
          owner_name                                = e.full_name,  
          profitability_factor                      = case when a.utility_id = 'CONED'  
                                                           then h.field_06_value  
                                                           else '0'  
                                                      end,  
          a.origin,  
          a.username,  
          a.date_created,  
          a.chgstamp,  
          'months_remaining'      = case when ltrim(rtrim(b.product_id))  = ltrim(rtrim(b.utility_id)) + '_VAR'  
              then cast(datediff(month, getdate(), b.date_end) as varchar(20)) + ' (default product)'  
              else cast(datediff(month, getdate(), b.date_end) as varchar(20))  
               end  
   from retention_detail a WITH (NOLOCK) inner join  --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = retention_detail_idx),  
        lp_account..account b WITH (NOLOCK) on a.account_id = b.account_id inner join  --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx),  
        lp_account..account_contact c WITH (NOLOCK) on b.account_id = c.account_id  and b.customer_contact_link = c.contact_link inner join  --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_contact_idx),  
        lp_account..account_name d WITH (NOLOCK) on b.account_id = d.account_id  and b.account_name_link = d.name_link inner join --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_name_idx),  
        lp_account..account_name e WITH (NOLOCK) on  b.account_id = e.account_id  and b.owner_name_link = e.name_link inner join --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_name_idx),  
        lp_account..enrollment_status f WITH (NOLOCK) on b.status = f.status inner join --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = enrollment_status_idx),  
        lp_account..enrollment_sub_status g WITH (NOLOCK) on b.status = g.status  and b.sub_status = g.sub_status left join --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = enrollment_sub_status_idx),  
        lp_account..account_additional_info h WITH (NOLOCK) on b.account_id = h.account_id --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_additional_info_idx)*/  
        
   where a.call_request_id                          = @p_call_request_id  
   order by a.[select] desc  
end  