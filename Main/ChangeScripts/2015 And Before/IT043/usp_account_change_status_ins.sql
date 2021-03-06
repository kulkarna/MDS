USE [lp_account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_change_status_ins]    Script Date: 10/04/2012 09:16:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Modified on	: 09/07/2011
-- By			: Jose Munoz
-- Ticket		: 1-2182678
-- Allow change status for 05000 25 to 05000 10
-- in ENROLLMENT-REENROLLMENT process.
-- =============================================
--exec usp_process_export 'libertypower\dmarino', 'LETTER', 'BGE'

ALTER procedure [dbo].[usp_account_change_status_ins]
(@p_username                                        nchar(100),
	@p_account_id                                      char(12),
	@p_process_id                                      varchar(50), 
	@p_error                                           char(01) = ' ' output,
	@p_msg_id                                          char(08) = ' ' output,
	@p_descp                                           varchar(250) = ' ' output,
	@p_result_ind                                      char(01) = 'Y')
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_return                                   int
declare @w_descp                                    varchar(250)
declare @w_descp_add                                varchar(100)

select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_return                                    = 0
select @w_descp                                     = ' ' 
select @w_descp_add                                 = ' ' 

declare @w_getdate                                  datetime
select @w_getdate                                   = getdate()

declare @w_getdate_str                              varchar(25)
select @w_getdate_str                               = convert(varchar(20), convert(datetime, @w_getdate))

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_status                                   varchar(15)
declare @w_sub_status                               varchar(15)
declare @w_contract_nbr                             char(12)
declare @w_account_type                             varchar(35)
declare @w_contract_type                            varchar(25)
declare @w_por_option                               varchar(03) 
declare @w_account_number                           varchar(30)

select @w_status                                    = status,
       @w_sub_status                                = sub_status,
       @w_contract_nbr                              = contract_nbr,
       @w_account_type                              = account_type,
       @w_contract_type                             = contract_type,
       @w_por_option                                = por_option
from lp_account..account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx)
where account_id                                    = @p_account_id

if @p_process_id                                    = 'ENROLLMENT-REENROLLMENT'
begin
/* Commented ticket 1-2182678
   if  ltrim(rtrim(@w_status)) 
   +   ltrim(rtrim(@w_sub_status))                 <> '1100020'
   and ltrim(rtrim(@w_status)) 
   +   ltrim(rtrim(@w_sub_status))                 <> '1100030'
   and ltrim(rtrim(@w_status)) 
   +   ltrim(rtrim(@w_sub_status))                 <> '1100040'
   and ltrim(rtrim(@w_status)) 
   +   ltrim(rtrim(@w_sub_status))                 <> '1100050'
   and ltrim(rtrim(@w_status)) 
   +   ltrim(rtrim(@w_sub_status))                 <> '91100010'
   and ltrim(rtrim(@w_status)) 
   +   ltrim(rtrim(@w_sub_status))                 <> '99999810'
   and ltrim(rtrim(@w_status)) 
   +   ltrim(rtrim(@w_sub_status))                 <> '99999910'
*/   

	if not (ltrim(rtrim(@w_status)) + ltrim(rtrim(@w_sub_status))
 	in ('1100020', '1100030', '1100040', '1100050', '91100010', '99999810', '99999910', '0500025'))
	begin
		select @w_application                         = 'ACCOUNT'
		select @w_error                               = 'E'
		select @w_msg_id                              = '00000013'
		select @w_return                              = 1
		goto goto_select
	end

	if  @w_status                                    = '11000'
	and @w_sub_status                                = '20'
	and exists(select a.account_id
              from lp_account..account a WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx),
                   ,lp_account..account_contact b WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_contact_idx),
                   ,lp_enrollment..retention_header c WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = retention_header_idx1),
                   ,lp_enrollment..retention_detail d WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = retention_detail_idx)
              where a.account_id                    = @p_account_id
              and   a.account_id                    = b.account_id
              and  (a.billing_contact_link          = b.contact_link
              or    a.customer_contact_link         = b.contact_link)
              and   b.phone                         = c.phone
              and  (call_status                     = 'O'
              or    call_status                     = 'A')
              and   c.call_request_id               = d.call_request_id
              and   a.account_id                    = d.account_id)
	begin
		select @w_application                         = 'ACCOUNT'
		select @w_error                               = 'E'
		select @w_msg_id                              = '00000012'
		select @w_return                              = 1
		goto goto_select
	end
end

declare @w_param_06                                 varchar(20)
declare @w_param_07                                 varchar(20)

select @w_param_06                                  = ' '
select @w_param_07                                  = ' '

begin tran change_account

exec @w_return = lp_account..usp_account_status_process @p_username,
                                                        @p_process_id,
                                                        @p_account_id,
                                                        'NONE',
                                                        @w_getdate_str,
                                                        @w_por_option,
                                                        @w_status,
                                                        @w_sub_status,
                                                        @w_contract_type,
                                                        @w_param_06 output,
                                                        @w_param_07 output,
                                                        ' ',
                                                        @w_error output,
                                                        @w_msg_id output,
                                                        @w_descp output,
                                                        @w_descp_add,
                                                        'N'

if @w_return                                       <> 0
begin
   rollback tran change_account
   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000051'
   select @w_descp_add                              = '(Status Process)'
   goto goto_select
end

--IT043
--if  @p_process_id                                    = 'ENROLLMENT-REENROLLMENT'
--and (@w_param_06                                     = '03000'
--or   @w_param_06                                     = '04000')
--and @w_param_07                                      = '20'
--begin

--   insert into lp_enrollment..check_account
--   select @w_contract_nbr,
--          @p_account_id,
--          'LETTER',
--          'ENROLLMENT',
--          'PENDING',
--          '19000101',
--          'LETTER',
--          '19000101',
--          'ONLINE',
--          ' ',
--          ' ',
--          '19000101',
--          ' ',
--          '19000101',
--          '19000101',
--          0,
--          @p_username,
--          @w_getdate,
--          0

--   if @@error                                      <> 0
--   or @@rowcount                                    = 0
--   begin
--      rollback tran change_account
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000051'
--      select @w_descp_add                           = '(Check Account)'
--      select @w_return                              = 1
--      goto goto_select
--   end

--end

commit tran change_account

-- delete account from queue since they are renewing
delete from lp_account..account_auto_renewal_queue where account_id = @p_account_id

goto_select:

set rowcount 0

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application

   select @w_descp                                  = ltrim(rtrim(@w_descp))
                                                    + ' '
                                                    + @w_descp_add
end
 
if @p_result_ind                                    = 'Y'
begin
   select flag_error                                = @w_error,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end
 
select @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:
return @w_return
