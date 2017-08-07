-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/10/2007
-- Description:	validate pricing
-- Modified
-- 8/16/2010
-- removed rate validation from history (for now, IT044)
-- =============================================
-- Modified
-- 10/13/2010
-- restored rate validation for ticket 18855
-- =============================================
-- Modified
-- 09/02/2011
-- Jose Munoz
-- Ticket : 1-2062001
-- =============================================


CREATE PROCEDURE [dbo].[usp_contract_pricing_val]
(@p_username                                        nchar(100),
 @p_action                                          char(01),
 @p_edit_type                                       varchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_retail_mkt_id                                   char(02),
 @p_utility_id                                      char(15),
 @p_product_id                                      char(20),
 @p_rate_id                                         int,
 @p_rate                                            float,
 @p_term_months                                     int,
 @p_enrollment_type                                 int,
 @p_requested_flow_start_date                       datetime,
 @p_contract_date									datetime = null,
 @p_customer_code                                   char(05) = '',
 @p_customer_group                                  char(100) = '',
 @p_application                                     varchar(20) output,
 @p_error                                           char(01) output,
 @p_msg_id                                          char(08) output,
 @p_process                                         varchar(15) = 'ONLINE',
 @PriceID											int)
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(100)
declare @w_rate_cap									float -- Added Ticket : 1-2062001

 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '
 
declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

exec @w_return = usp_contract_express_val @p_action,
                                          @p_contract_nbr,
                                          @p_account_number,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output

if @w_return                                       <> 0
begin
   if @p_process                                    = 'BATCH'
   begin

      select @w_descp_add                           = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

      exec usp_contract_error_ins 'DEAL_CAPTURE',
                                  @p_contract_nbr,
                                  @p_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
   end
   else
   begin
      if @p_process                              like 'BATCH_%'
      begin
      
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
         insert into #contract_error
         select @p_contract_nbr,
                @p_account_number,
                @w_application,
                @w_error,
                @w_msg_id,
                @w_descp_add
      end
      else
      begin
     
         goto goto_select
      end
   end
end


if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'RETAIL_MKT_ID'
begin
 
   if @p_retail_mkt_id                             is null
   or @p_retail_mkt_id                              = ' '
   or @p_retail_mkt_id                              = 'NN'
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000017'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add
         end
         else
         begin
            goto goto_select
         end
      end
   end
   if @p_process                                 like 'BATCH_%'
   begin
      if not exists(select retail_mkt_id
                    from lp_common..common_retail_market with (NOLOCK)
                    where retail_mkt_id             = @p_retail_mkt_id
                    and   inactive_ind              = '0')
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000017'
         select @w_return                           = 1

         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         insert into #contract_error
         select @p_contract_nbr,
                @p_account_number,
                @w_application,
                @w_error,
                @w_msg_id,
                @w_descp_add
      end
   end
end

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'UTILITY_ID'
begin
 
   if @p_utility_id                                is null
   or len(ltrim(rtrim(@p_utility_id)))              = 0
--   or @p_retail_mkt_id                              = 'NN'
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000006'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add
         end
         else
         begin
            goto goto_select
         end
      end
   end
   if @p_process                                 like 'BATCH_%'
   begin
      if not exists(select utility_id
                    from lp_common..common_utility with (NOLOCK)
                    where utility_id                = @p_utility_id
                    and   inactive_ind              = '0')
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000005'
         select @w_return                           = 1

         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         insert into #contract_error
         select @p_contract_nbr,
                @p_account_number,
                @w_application,
                @w_error,
                @w_msg_id,
                @w_descp_add
      end
   end
end

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'PRODUCT_ID'
begin
 
   if @p_product_id                                is null
   or len(ltrim(rtrim(@p_product_id)))              = 0
--   or @p_retail_mkt_id                              = 'NN'
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000032'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add
         end
         else
         begin
            goto goto_select
         end
      end
   end
end


if @p_process                                    like 'BATCH_%'
begin
   if exists(select null
             from #process
             where process                          = 1)
   begin
      select @w_error                               = 'E'
      select @w_return                              = 1
      select @w_msg_id                              = msg_id
      from #process
      
      select @w_descp_add                           = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
                                                    
                                                    
                                                    
      insert into #contract_error
      select @p_contract_nbr,
             @p_account_number,
             [application],
             @w_error,
             msg_id,
             ltrim(rtrim(descp_add))
           + ' '
           + ltrim(rtrim(@w_descp_add))
      from #process
      where process                                 = 1
   end

end

declare @w_product_category		                    varchar(20)

select @w_product_category                          = product_category
from lp_common..common_product with (NOLOCK INDEX = common_product_idx)
where product_id                                    = @p_product_id


if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'RATE_ID'
begin


   if @p_rate_id                                   is null
   or ((@p_rate_id                                  = 0 
   and  @w_product_category                         = 'FIXED'))
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000042'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add
         end
         else
         begin
            goto goto_select
         end
      end
   end
end

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'RATE'
begin

   if @p_rate                                      is null
   or ((@p_rate                                    <= 0 
   and  @w_product_category                         = 'FIXED'))
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000045'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = ' - 1 (' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add,
                   getdate()
         end
         else
         begin
            goto goto_select
         end
      end
   end
end

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'TERM_MONTHS'
begin
 
   if (@p_term_months                              is null
   or  @p_term_months                              <= 0)
   and exists(select contract_type
              from deal_contract with (NOLOCK INDEX = deal_contract_idx)
              where contract_nbr                    = @p_contract_nbr
              and   contract_type                   = 'CORPORATE')
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000030'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add
         end
         else
         begin
            goto goto_select
         end
      end
   end
end

if @p_process                                    like 'BATCH_%'
begin
   if not exists (select return_value
                  from lp_common..common_views
                  where process_id                  = 'ENROLLMENT TYPE'
                  and   return_value                = @p_enrollment_type)
   begin
      select @w_application                         = 'RISK'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000103'
      select @w_return                              = 1

      select @w_descp_add                           = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

      insert into #contract_error
      select @p_contract_nbr,
             @p_account_number,
             @w_application,
             @w_error,
             @w_msg_id,
             @w_descp_add

   end
end

if  @p_retail_mkt_id                               <> 'TX'
and @p_enrollment_type                             <> 1
begin

   select @w_application                            = 'RISK'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000103'
   select @w_return                                 = 1

   if @p_process                                    = 'BATCH'
   begin
      select @w_descp_add                           = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

      exec usp_contract_error_ins 'DEAL_CAPTURE',
                                  @p_contract_nbr,
                                  @p_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
   end
   else
   begin
      if @p_process                              like 'BATCH_%'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
         insert into #contract_error
         select @p_contract_nbr,
                @p_account_number,
                @w_application,
                @w_error,
                @w_msg_id,
                @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end
end

declare @w_date_created                             datetime
select @w_date_created                              = getdate()

if @p_retail_mkt_id                                 = 'TX'
begin

   if datepart(dw, @p_requested_flow_start_date)    = 1
   or datepart(dw, @p_requested_flow_start_date)    = 7
   begin

      select @w_descp_add                           = ''
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00001053'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
   end
   
   if @p_enrollment_type                            = 8
   begin                                          
      if convert(char(06), @p_requested_flow_start_date, 112) + '01'
                                                    < dateadd(m, 1, convert(char(06), @w_date_created, 112) + '01')
      or convert(char(06), @p_requested_flow_start_date, 112) + '01'                      
                                                    > dateadd(m, 12, convert(char(06), @w_date_created, 112) + '01')
      begin
         select @w_descp_add                        = ''
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00001045'
         select @w_return                           = 1

         if @p_process                              = 'BATCH'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

            exec usp_contract_error_ins 'DEAL_CAPTURE',
                                        @p_contract_nbr,
                                        @p_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
         end
         else
         begin
            if @p_process                        like 'BATCH_%'
            begin
               select @w_descp_add                  = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
               insert into #contract_error
               select @p_contract_nbr,
                      @p_account_number,
                      @w_application,
                      @w_error,
                      @w_msg_id,
                      @w_descp_add
            end
            else
            begin
               goto goto_select
            end
         end
      end
      else
      begin
         select @w_descp_add                        = ''
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00001046'
         select @w_return                           = 1

         if @p_process                              = 'BATCH'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

            exec usp_contract_error_ins 'DEAL_CAPTURE',
                                        @p_contract_nbr,
                                        @p_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
         end
         else
         begin
            if @p_process                        like 'BATCH_%'
            begin
               select @w_descp_add                  = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
               insert into #contract_error
               select @p_contract_nbr,
                      @p_account_number,
                      @w_application,
                      @w_error,
                      @w_msg_id,
                      @w_descp_add
            end
            else
            begin
               goto goto_select
            end
         end
      end
   end
 
   if @p_enrollment_type                            = 4
   --or @p_enrollment_type                            = 3
   begin
      if @p_requested_flow_start_date               < case when datepart(dw, dateadd(d, 3, @w_date_created)) = 1
                                                           then dateadd(d, 4, @w_date_created)
                                                           when datepart(dw, dateadd(d, 3, @w_date_created)) = 7
                                                           then dateadd(d, 5, @w_date_created)
                                                           else dateadd(d, 3, @w_date_created)
                                                      end
      or @p_requested_flow_start_date               > case when datepart(dw, dateadd(d, 60, @w_date_created)) = 1
                                                           then dateadd(d, 58, @w_date_created)
                                                           when datepart(dw, dateadd(d, 60, @w_date_created)) = 7
                                                           then dateadd(d, 59, @w_date_created)
                                                           else dateadd(d, 60, @w_date_created)
                                                      end
      begin
         select @w_descp_add                        = ''
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00001041'
         select @w_return                           = 1

         if @p_process                              = 'BATCH'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

            exec usp_contract_error_ins 'DEAL_CAPTURE',
                                        @p_contract_nbr,
                                        @p_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
         end
         else
         begin
            if @p_process                        like 'BATCH_%'
            begin
               select @w_descp_add                  = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
               insert into #contract_error
               select @p_contract_nbr,
                      @p_account_number,
                      @w_application,
                      @w_error,
                      @w_msg_id,
                      @w_descp_add
            end
            else
            begin
               goto goto_select
            end
         end
      end
   end
/*
   if @p_enrollment_type                            = 4
   begin
      if @p_requested_flow_start_date               < dateadd(d, 3, @w_date_created)
      or @p_requested_flow_start_date               > dateadd(d, 60, @w_date_created)
      begin
         select @w_descp_add                        = ''
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00001040'
         select @w_return                           = 1

         if @p_process                              = 'BATCH'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

            exec usp_contract_error_ins 'DEAL_CAPTURE',
                                        @p_contract_nbr,
                                        @p_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
         end
         else
         begin
            if @p_process                        like 'BATCH_%'
            begin
               select @w_descp_add                  = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
               insert into #contract_error
               select @p_contract_nbr,
                      @p_account_number,
                      @w_application,
                      @w_error,
                      @w_msg_id,
                      @w_descp_add
            end
            else
            begin
               goto goto_select
            end
         end
      end
   end
*/
   if @p_enrollment_type                            = 6
   begin                                          
      if @p_requested_flow_start_date               < case when datepart(dw, dateadd(d, 5, @w_date_created)) = 1
                                                           then dateadd(d, 6, @w_date_created)
                                                           when datepart(dw, dateadd(d, 3, @w_date_created)) = 7
                                                           then dateadd(d, 7, @w_date_created)
                                                           else dateadd(d, 5, @w_date_created)
                                                      end
      begin
         select @w_descp_add                        = convert(char(10), case when datepart(dw, dateadd(d, 5, @w_date_created)) = 1
                                                                             then dateadd(d, 6, @w_date_created)
                                                                             when datepart(dw, dateadd(d, 3, @w_date_created)) = 7
                                                                             then dateadd(d, 7, @w_date_created)
                                                                             else dateadd(d, 5, @w_date_created)
                                                                        end, 101)
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00001042'
         select @w_return                           = 1

         if @p_process                              = 'BATCH'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

            exec usp_contract_error_ins 'DEAL_CAPTURE',
                                        @p_contract_nbr,
                                        @p_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
         end
         else
         begin
            if @p_process                        like 'BATCH_%'
            begin
               select @w_descp_add                  = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
               insert into #contract_error
               select @p_contract_nbr,
                      @p_account_number,
                      @w_application,
                      @w_error,
                      @w_msg_id,
                      @w_descp_add
            end
            else
            begin
               goto goto_select
            end
         end
      end
      if @p_requested_flow_start_date               > case when datepart(dw, dateadd(d, 14, @w_date_created)) = 1
                                                           then dateadd(d, 19, @w_date_created)
                                                           else dateadd(d, 18, @w_date_created)
                                                      end
      begin
         select @w_descp_add                        = ' '
                                                    + convert(char(10), case when datepart(dw, dateadd(d, 5, @w_date_created)) = 1
                                                                             then dateadd(d, 6, @w_date_created)
                                                                             when datepart(dw, dateadd(d, 3, @w_date_created)) = 7
                                                                             then dateadd(d, 7, @w_date_created)
                                                                             else dateadd(d, 5, @w_date_created)
                                                                        end, 101)
                                                    + ' and '
                                                    + convert(char(10), case when datepart(dw, dateadd(d, 14, @w_date_created)) = 1
                                                                             then dateadd(d, 19, @w_date_created)
                                                                             else dateadd(d, 18, @w_date_created)
                                                                        end, 101)
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00001052'
         select @w_return                           = 1

         if @p_process                              = 'BATCH'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

            exec usp_contract_error_ins 'DEAL_CAPTURE',
                                        @p_contract_nbr,
                                        @p_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
         end
         else
         begin
            if @p_process                        like 'BATCH_%'
            begin
               select @w_descp_add                  = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
               insert into #contract_error
               select @p_contract_nbr,
                      @p_account_number,
                      @w_application,
                      @w_error,
                      @w_msg_id,
                      @w_descp_add
            end
            else
            begin
               goto goto_select
            end
         end
      end
   end
 
   if @p_enrollment_type                            = 5
   begin                                          
      if @p_requested_flow_start_date               < case when datepart(dw, dateadd(d, -15, @w_date_created)) = 1
                                                           then dateadd(d, -20, @w_date_created)
                                                           when datepart(dw, dateadd(d, -15, @w_date_created)) = 2
                                                           then dateadd(d, -21, @w_date_created)
                                                           else dateadd(d, -19, @w_date_created)
                                                      end
      begin
         select @w_descp_add                        = ''
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00001043'
         select @w_return                           = 1

         if @p_process                              = 'BATCH'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

            exec usp_contract_error_ins 'DEAL_CAPTURE',
                                        @p_contract_nbr,
                                        @p_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
         end
         else
         begin
            if @p_process                        like 'BATCH_%'
            begin
               select @w_descp_add                  = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
               insert into #contract_error
               select @p_contract_nbr,
                      @p_account_number,
                      @w_application,
                      @w_error,
                      @w_msg_id,
                      @w_descp_add
            end
            else
            begin
               goto goto_select
            end
         end
      end
      --Due ticket 13349 
      --if @p_requested_flow_start_date               > dateadd(d, 90, @w_date_created)
      --begin
      --   select @w_descp_add                        = ''
      --   select @w_application                      = 'COMMON'
      --   select @w_error                            = 'E'
      --   select @w_msg_id                           = '00001044'
      --   select @w_return                           = 1
      --   if @p_process                              = 'BATCH'
      --   begin
      --      select @w_descp_add                     = '(' 
      --                                              + case when @p_account_number = 'CONTRACT'
      --                                                     then ' ' 
      --                                                     else ' Account Number '
      --                                                end
      --                                              + ltrim(rtrim(@p_account_number)) + ')'

      --      exec usp_contract_error_ins 'DEAL_CAPTURE',
      --                                  @p_contract_nbr,
      --                                  @p_account_number,
      --                                  @w_application,
      --                                  @w_error,
      --                                  @w_msg_id,
      --                                  @w_descp_add
      --   end
      --   else
      --   begin

      --      if @p_process                        like 'BATCH_%'
      --      begin
      --         select @w_descp_add                  = ' - 2 (' 
      --                                              + case when @p_account_number = 'CONTRACT'
      --                                                     then ' ' 
      --                                                     else ' Account Number '
      --                                                end
      --                                              + ltrim(rtrim(@p_account_number)) + ')'
      --         insert into #contract_error
      --         select @p_contract_nbr,
      --                @p_account_number,
      --                @w_application,
      --                @w_error,
      --                @w_msg_id,
      --                @w_descp_add
      --      end
      --      else
      --      begin
      --         goto goto_select
      --      end
      --   end
      --end
   end

end 
 
declare @w_product_rate                             float

declare @w_custom_cap                               float
print 'edit type is '
print @p_edit_type

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'CONTRACT_DATE'
begin
--------------------------------------------------------
	---MD084 implementation(multi-term)---
	DECLARE @IsMultiTerm bit
	SELECT @IsMultiTerm=pb.IsMultiTerm
	FROM Libertypower.dbo.ProductBrand pb INNER JOIN 
		Libertypower.dbo.Price p with(nolock) ON p.ProductBrandId=pb.ProductBrandId
	WHERE p.ID = @PriceID

	IF @IsMultiTerm=1
		BEGIN
			SELECT @w_product_rate = m.Price
			FROM Libertypower.dbo.ProductCrossPriceMulti m WITH (NOLOCK)
				INNER JOIN Libertypower.dbo.Price p WITH (NOLOCK)
					ON p.ProductCrossPriceID=m.ProductCrossPriceID
			WHERE	p.ID = @PriceID	and m.StartDate=
			(
				SELECT	Min(m.StartDate) 
				FROM Libertypower.dbo.ProductCrossPriceMulti m WITH (NOLOCK)
					INNER JOIN Libertypower.dbo.Price p WITH (NOLOCK)
						ON p.ProductCrossPriceID=m.ProductCrossPriceID
				WHERE	p.ID = @PriceID
			)
		END
	ELSE
		-- IT106
		-- first check for price in new price table
		BEGIN
			SELECT	@w_product_rate = Price
			FROM	Libertypower..Price WITH (NOLOCK)
			WHERE	ID = @PriceID
		END
------------------------------------------------------------	
	-- if price is not found, default to legacy rates
	IF @w_product_rate IS NULL
		BEGIN
			if @p_contract_date                             is not null
			begin
				print 'using rate history'
				select @w_product_rate = lp_common.dbo.udf_product_rate_history_rate_sel(@p_product_id, @p_rate_id, @p_contract_date)
			end
			-- get current rate
			else
			begin
				print 'using current rate'
				select	@w_product_rate					= @p_rate 
				from	lp_common..common_product_rate
				where	product_id						= @p_product_id 
				and		rate_id							= @p_rate_id
			end
		END

-- removed rate validation from history (for now, IT044)
-- code restored for ticket 18855
   print 'current rate is ' 
   print @w_product_rate
   print 'contract rate is '
   print @p_rate

   if  (cast(@p_rate as decimal(8,5)) < cast(@w_product_rate as decimal(8,5))) 
   and ((select is_flexible                        
         from lp_common..common_product 
         where product_id                           = @p_product_id 
         and   product_category                     ='FIXED') = 1)
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000045'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = ' - 3 (' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end 
      else
      begin
         goto goto_select
      end
   end

	/* Add Ticket 1-2062001 Begin*/
	SET @w_rate_cap = 0 
	SELECT @w_rate_cap = rate_cap FROM lp_deal_capture..deal_rate with (nolock)
	/* Add Ticket 1-2062001 End */

   select @w_custom_cap                             = isnull(d.commission_rate, 0) 
   from deal_pricing d join deal_pricing_detail dd 
                  on d.deal_pricing_id              = dd.deal_pricing_id 
   where dd.product_id                              = @p_product_id 
   and   dd.rate_id                                 = @p_rate_id
   
   if  (@p_rate                                     > (@w_product_rate + @w_custom_cap + @w_rate_cap)) -- update ticket 1-2062001
   and  ((select is_flexible 
          from lp_common..common_product 
          where product_id                          = @p_product_id) = 1)
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000044'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end

  -- if (lp_enrollment.dbo.ufn_date_only(@p_contract_date) < lp_enrollment.dbo.ufn_date_only(dateadd(day, -3, getdate()))) TEMPORARLY REMOVED TO ENTER SS CONTRACTS (AT 8/26/2010)
   if (lp_enrollment.dbo.ufn_date_only(@p_contract_date) < lp_enrollment.dbo.ufn_date_only(dateadd(day, -365, getdate())))
   or (lp_enrollment.dbo.ufn_date_only(@p_contract_date) > lp_enrollment.dbo.ufn_date_only(getdate()))
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000047'
      select @w_return                              = 1
      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end   
end

goto_select:

select @p_error                                     = @w_error
select @p_msg_id                                    = @w_msg_id
select @p_application                               = @w_application

return @w_return

