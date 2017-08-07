--exec usp_contract_submit_ins 'libertypower\dmarino', 'Contracto A1'
--usp_contract_submit 'libertypower\dmarino', 'ONLINE', 'A1'

CREATE procedure [dbo].[usp_genie_contract_submit]
(@p_username                                        nchar(100),
 @p_process                                         varchar(15),
 @p_contract_nbr                                    char(12),
 @p_contract_type                                   varchar(25) = ' ')
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_return                                   int
declare @w_descp                                    varchar(255)
declare @w_descp_add                                varchar(100)

select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_return                                    = 0
select @w_descp                                     = ' ' 
select @w_descp_add                                 = ' ' 

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

update deal_contract set status = 'RUNNING'
from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr

if (exists (select origin
            from deal_contract with (NOLOCK INDEX = deal_contract_idx)
            where contract_nbr                      = @p_contract_nbr
            and   origin                            = 'BATCH')
and @p_process                                      = 'ONLINE')
begin

   delete deal_contract_error
   from deal_contract_error with (NOLOCK INDEX = deal_contract_error_idx)
   where contract_nbr                               = @p_contract_nbr

   declare @w_request_id                            char(50)
   declare @w_exec_sql                              varchar(max)
   declare @w_dbname                                nvarchar(128)
   declare @w_server_name                           varchar(128)
   declare @w_job_name                              varchar(128)
   declare @w_dateexec                              datetime

   select @w_request_id                             = 'DEAL_CAPTURE-VALIDATION-'
                                                    + ltrim(rtrim(@p_contract_nbr))
   select @w_dbname                                 = 'lp_deal_capture'
   select @w_server_name                            = @@servername
   select @w_job_name                               = @w_request_id

   select @w_exec_sql                               = 'exec'
                                                    + ' '
                                                    + 'usp_contract_submit_val'
                                                    + ' '
                                                    + '''' + ltrim(rtrim(@p_username)) + ''''
                                                    + ', '
                                                    + '''' + ltrim(rtrim(@p_process)) + ''''
                                                    + ', '
                                                    + '''' + ltrim(rtrim(@p_contract_nbr)) + ''''
                                                    + ', '
                                                    + '''' + ltrim(rtrim(@p_contract_type)) + ''''
	
   exec @w_return = lp_common..usp_summit_job @p_username,
                                              @w_request_id,
                                              @w_exec_sql,
                                              @w_dbname,
                                              @w_server_name,
                                              @w_job_name,
                                              @w_dateexec,
                                              @w_error output,
                                              @w_msg_id output

	
end
else
begin
   delete deal_contract_error
   from deal_contract_error with (NOLOCK INDEX = deal_contract_error_idx)
   where contract_nbr                               = @p_contract_nbr
	
   exec @w_return = [usp_genie_contract_submit_val] @p_username,
                                            @p_process,
                                            @p_contract_nbr,
                                            @p_contract_type,
                                            @w_application output,
                                            @w_error output,
                                            @w_msg_id output,
                                            @w_descp_add output
                                            

   if @p_process                                    = 'BATCH'
   begin

      if @w_error                                   = 'E'
      begin
         update deal_contract set status = 'DRAFT - ERROR'
         from deal_contract with (NOLOCK INDEX = deal_contract_idx)
         where contract_nbr                        = @p_contract_nbr
      end
  
      return @w_return
   end
end

if @w_error                                         = 'E'
begin
   update deal_contract set status = 'DRAFT - ERROR'
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                           = @p_contract_nbr
end

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application

   select @w_descp                                  = ltrim(rtrim(@w_descp ))
                                                    + ' '
                                                    + @w_descp_add
end
 
select flag_error                                   = @w_error,
       code_error                                   = @w_msg_id,
       message_error                                = @w_descp

return @w_return
