


CREATE procedure [dbo].[usp_import_account_HISTORY]
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

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @t_UpdDate                                  datetime

declare @w_UpdateTypeID                             int
declare @w_OldValue                                 int
declare @w_OldValueDate                             datetime
declare @w_NewValue                                 int
declare @w_NewValueDate                             datetime
declare @w_UpdDate                                  datetime

declare @w_getdate                                  datetime
select @w_getdate                                   = getdate()

declare @w_account_id                               char(12)
select @w_account_id                                = ''

declare @t_account_id                               char(12)
select @t_account_id                                = ''

declare @w_account_number                           varchar(30)
select @w_account_number                            = ''

declare @t_account_number                           varchar(30)
select @t_account_number                            = ''

declare @w_rowcount_his                             int
select @w_rowcount_his                              = 0

declare @w_status                                   varchar(15)
declare @w_sub_status                               varchar(15)

declare @w_username                                 nchar(100)
select @w_username                                  = 'libertypower\dmarino'

declare @w_rowcount                                 int

delete lp_account..account_status_history
from  lp_account..account_status_history
where account_id                                like 'A%'
and   date_created                                 < '20060626'

set rowcount 1

select @w_account_id                                = account_id,
       @w_account_number                            = account_number
from lp_account..account with (NOLOCK INDEX = account_idx)
where account_id                                    > @t_account_id
and   account_id                                 like 'A%'

select @w_rowcount                                  = @@rowcount


while @w_rowcount                                  <> 0
begin

set rowcount 0

      select @t_UpdDate                                = '19000101'

      select @t_account_id                             = @w_account_id
      select @t_account_number                         = @w_account_number

      set rowcount 1

      select @w_UpdateTypeID                           = UpdateTypeID,
             @w_OldValue                               = OldValue,
             @w_OldValueDate                           = OldValueDate,
             @w_NewValue                               = NewValue,
             @w_NewValueDate                           = NewValueDate,
             @w_UpdDate                                = UpdDate
      from Enrollment_Access..tblAccountHistory with (NOLOCK INDEX = tblAccountHistory_idx)
      where AccountNumber                              = @t_account_number
      and   UpdateTypeID                               = 1
      and   UpdDate                                    > @t_UpdDate
 
      select @w_rowcount_his                           = @@rowcount

      if @w_rowcount_his                              <> 0
      begin

         select @w_status                              = status,
                @w_sub_status                          = sub_status
         from lp_account..status_convertion
         where AccountStatusID                         = @w_OldValue

         select @w_return                                    = 0
--select 1002
         exec @w_return = lp_account..usp_account_status_history_ins @w_username,
                                                                     @w_account_id,
                                                                     @w_status,
                                                                     @w_sub_status,
                                                                     @w_getdate,
                                                                     'INIT LOAD',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     @w_UpdDate,
                                                                     @w_error output,
                                                                     @w_msg_id output,
                                                                     ' ',
                                                                     'N'


         if @w_return                                 <> 0
         begin
            --rollback tran
            set rowcount 0
            select @w_application                      = 'COMMON'
            select @w_error                            = 'E'
            select @w_msg_id                           = '00000051'
            select @w_return                           = 1
            select @w_descp_add                        = ' (Insert History Account) '
   
            goto goto_select
         end

      end

      while @w_rowcount_his                           <> 0
      begin

         set rowcount 0

         select @t_UpdDate                             = @w_UpdDate

         select @w_return                              = 1

         select @w_status                              = ''
         select @w_sub_status                          = ''

         select @w_status                              = status,
                @w_sub_status                          = sub_status
         from lp_account..status_convertion
         where AccountStatusID                         = @w_NewValue

--select 1003
         exec @w_return = lp_account..usp_account_status_history_ins @w_username,
                                                                     @w_account_id,
                                                                     @w_status,
                                                                     @w_sub_status,
                                                                     @w_UpdDate,
                                                                     'INIT LOAD',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     ' ',
                                                                     @w_UpdDate,
                                                                     @w_error output,
                                                                     @w_msg_id output,
                                                                     ' ',
                                                                     'N'


         if @w_return                                 <> 0
         begin
            --rollback tran
            set rowcount 0
            select @w_application                      = 'COMMON'
            select @w_error                            = 'E'
            select @w_msg_id                           = '00000051'
            select @w_return                           = 0
            select @w_descp_add                        = ' (Insert History Account) '

            goto goto_select
         end

         goto_next:

         set rowcount 1

         select @w_UpdateTypeID                        = UpdateTypeID,
                @w_OldValue                            = OldValue,
                @w_OldValueDate                        = OldValueDate,
                @w_NewValue                            = NewValue,
                @w_NewValueDate                        = NewValueDate,
                @w_UpdDate                             = UpdDate
         from Enrollment_Access..tblAccountHistory with (NOLOCK INDEX = tblAccountHistory_idx)
         where AccountNumber                              = @t_account_number
         and   UpdateTypeID                               = 1
         and   UpdDate                                    > @t_UpdDate

         select @w_rowcount_his                        = @@rowcount
   
      end

set rowcount 1

select @w_account_id                                = account_id,
       @w_account_number                            = account_number
from lp_account..account with (NOLOCK INDEX = account_idx)
where account_id                                    > @t_account_id
and   account_id                                 like 'A%'

select @w_rowcount                                  = @@rowcount

end

goto_select:
set rowcount 0
return @w_return

