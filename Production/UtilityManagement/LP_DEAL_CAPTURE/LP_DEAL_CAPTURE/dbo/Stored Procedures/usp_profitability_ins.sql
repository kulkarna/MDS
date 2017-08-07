create procedure dbo.usp_profitability_ins
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_application                                     varchar(20) = ' ' output,
 @p_error                                           char(01) = ' ' output,
 @p_msg_id                                          char(08) = ' ' output,
 @p_descp_add                                       varchar(100) = ' ' output)
as

declare @w_risk_request_id                          varchar(50)

declare @w_request_datetime                         varchar(20)

declare @w_header_enrollment_1                      varchar(08)
declare @w_header_enrollment_2                      varchar(08)

select @w_header_enrollment_1                       = header_enrollment_1,
       @w_header_enrollment_2                       = header_enrollment_2
from lp_deal_capture..deal_config

if convert(varchar(08), getdate(), 108)            <= @w_header_enrollment_1
begin
   select @w_request_datetime                       = convert(varchar(08), getdate(), 112) 
                                                    + ' '
                                                    + @w_header_enrollment_1
   select @w_risk_request_id                        = upper('DEAL-CAPTURE-' + @w_request_datetime)
end
else
begin
   select @w_request_datetime                       = convert(varchar(08), getdate(), 112) 
                                                    + ' '
                                                    + @w_header_enrollment_2
   select @w_risk_request_id                        = upper('DEAL-CAPTURE-' + @w_request_datetime)
end

if not exists(select request_id
              from lp_risk..web_header_enrollment with (NOLOCK)
              where request_id                      = @w_risk_request_id)
begin
   insert into lp_risk..web_header_enrollment
   select @w_risk_request_id,
          @w_request_datetime,
          'BATCH',
          'DEAL CAPTURE BATCH LOAD',
          getdate(),
          @p_username

   if  @@error                                     <> 0
   and @@rowcount                                   = 0
   begin
      select @p_application                         = 'COMMON'
      select @p_error                               = 'E'
      select @p_msg_id                              = '00000051'
      select @p_descp_add                           = ' (Insert Scraper Header) '
      return 1
   end
end

insert into lp_risk..web_detail
select @w_risk_request_id,
       account_number,
       'BATCH'
from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
where contract_nbr                                  = @p_contract_nbr

if  @@error                                        <> 0
and @@rowcount                                      = 0
begin
   select @p_application                            = 'COMMON'
   select @p_error                                  = 'E'
   select @p_msg_id                                 = '00000051'
   select @p_descp_add                              = ' (Insert Scraper Detail) '
   return 1
end

return 0