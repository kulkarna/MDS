



-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/11/2007
-- Description:	Insert multiple rate contracts
-- =============================================
-- Modified 1/25/2008 Gail Mangaroo
-- Added contract_print_type parameter - indicates whether contract is single / multi or custom rate
-- ================================================================

CREATE PROCEDURE [dbo].[usp_print_contracts_multi_rate_ins]
(@p_username                                        nchar(100),
 @p_retail_mkt_id                                   char(02),
 @p_qty                                             int,
 @p_request_id                                      varchar(20),
 @p_error                                           char(01) = ' ',
 @p_msg_id                                          char(08) = ' ',
 @p_descp                                           varchar(250) = ' ',
 @p_result_ind                                      char(01) = 'Y',
 @p_contract_rate_type								varchar(50) = ''
)
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0

declare @w_descp_add                                varchar(10)
select @w_descp_add                                 = ' '
 
declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_puc_certification_number                 varchar(20)
select @w_puc_certification_number                  = puc_certification_number
from lp_common..common_retail_market with (NOLOCK INDEX = common_retail_market_idx)
where retail_mkt_id                                 = @p_retail_mkt_id

declare @w_start_contract                           int
declare @w_contract_nbr                             char(12)


if @p_qty                                          <= 0
begin
   select @w_descp_add                              = '(Quantity)'
   goto goto_create_error
end


declare @w_rate                                     float
select @w_rate                                      = 0

declare @w_rate_descp                               varchar(50)
select @w_rate_descp                                = ' '

declare @w_contract_eff_start_date                  datetime
select @w_contract_eff_start_date                   = '19000101'

declare @w_grace_period                             int
select @w_grace_period                              = 0


declare @w_contract_template                        varchar(25)

set @w_contract_template =							'MultiRate.aspx'

/*
select @w_contract_template                         = contract_template
from lp_common..common_product_template with (NOLOCK INDEX = common_product_template_idx)
where product_id                                    = @p_product_id
and   getdate()                                    >= eff_date
and   getdate()                                     < due_date
and   inactive_ind                                  = '0'

if @@rowcount                                       = 0
begin
   select @w_descp_add                              = '(Template)'
   goto goto_create_error
end
*/


select @w_start_contract                            = 1
select @w_contract_nbr                              = ' '

while @w_start_contract                            <= @p_qty
begin

   exec @w_return = usp_get_key @p_username,
                                'CREATE CONTRACTS',
                                @w_contract_nbr output, 
                                'N'

   if @w_return                                    <> 0
   begin
      select @w_descp_add                           = '(Contract Number)'
      goto goto_create_error
   end

   select @w_return                                 = 0

	INSERT INTO [lp_deal_capture].[dbo].[deal_contract_print]
           ([request_id]
           ,[status]
           ,[contract_nbr]
           ,[username]
           ,[retail_mkt_id]
           ,[puc_certification_number]
           ,[utility_id]
           ,[product_id]
           ,[rate_id]
           ,[rate]
           ,[rate_descp]
           ,[term_months]
           ,[contract_eff_start_date]
           ,[grace_period]
           ,[date_created]
           ,[contract_template]
           ,[contract_rate_type])
    

   select @p_request_id,
          'PENDING',
          substring(@w_contract_nbr, 1, 12),
          @p_username,
          @p_retail_mkt_id,
          @w_puc_certification_number,
          'NONE',
          'NONE',
          '999999999',
          @w_rate,
          @w_rate_descp,
          0,
          @w_contract_eff_start_date,
          @w_grace_period,
          getdate(),
          @w_contract_template,
		  @p_contract_rate_type

   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      goto goto_create_error
   end

   select @w_start_contract                         = @w_start_contract + 1

end

select @w_return                                    = 0

update deal_contract_print set status = 'COMPLETED'
where request_id                                    = @p_request_id

goto goto_select

goto_create_error:

--   delete deal_contract_print
--   where request_id                                 = @p_request_id

select @w_application                               = 'DEAL'
select @w_error                                     = 'E'
select @w_msg_id                                    = '00000001'
select @w_return                                    = 1

goto_select:
 
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
   IF @p_request_id = 'SALESCHANNEL'
      select flag_error                                = @w_error,
             code_error                                = @w_msg_id,
             message_error                             = ISNULL(convert(varchar(250),@w_contract_nbr),@w_descp)
   ELSE
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




