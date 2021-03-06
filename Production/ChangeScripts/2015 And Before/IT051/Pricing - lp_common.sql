USE [Lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_product_rate_ins]    Script Date: 07/25/2011 14:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- This sp insert a record into the lp_common.dbo.common_product_rate table.
-- 2007-02-12 modified by Eric Hernandez.  Changed insert command to allow easier column additions to the table.


    
--exec usp_product_rate_ins 'WVILCHEZ', 'PRODUCT-01', 1, '20050101', 0.18, 'RATE TEST 01', 3, '20060520', 'ZONE', 'J', 'BOTH', ' ', ' ', ' '      
    
GO			
    
     
ALTER PROCEDURE [dbo].[usp_product_rate_ins]    
(@p_username                                        nchar(100),    
 @p_product_id                                      char(20),    
 @p_rate_id                                         int,    
 @p_eff_date                                        datetime,    
 @p_rate                                            float,    
 @p_rate_descp                                      varchar(250),    
 @p_grace_period                                    int,    
 @p_contract_eff_start_date                         datetime,   
 @p_due_date                                        datetime,  
 @p_val_01                                          varchar(10),    
 @p_input_01                                        varchar(10),    
 @p_process_01                                      varchar(10),    
 @p_val_02                                          varchar(10),    
 @p_input_02                                        varchar(10),    
 @p_process_02                                      varchar(10),    
 @p_zone_id											int = null,
 @p_service_rate_class_id							int = null,
 @p_error                                           char(01) = ' ',    
 @p_msg_id                                          char(08) = ' ',    
 @p_descp                                           varchar(250) = ' ',    
 @p_result_ind                                      char(01) = 'Y',
 @p_term_months										int,
 @p_fixed_end_date									tinyint,
 @GrossMargin										decimal(9,6) = 0,
 @IndexType											varchar(50) = '',
 @BillingTypeID										int = null)    
as
declare @w_error                                    char(01)    
declare @w_msg_id                                   char(08)    
declare @w_descp                                    varchar(250)    
declare @w_return                                   int    
     
select @w_error                                     = 'I'    
select @w_msg_id                                    = '00000001'    
select @w_descp                                     = ' '    
select @w_return                                    = 0    
     
insert into common_product_rate    
(	product_id, rate_id, eff_date, rate, rate_descp, due_date, grace_period, 
	contract_eff_start_date, val_01, input_01, process_01, val_02, input_02, 
	process_02, service_rate_class_id, zone_id, date_created, username, 
	inactive_ind, active_date, chgstamp, term_months, fixed_end_date, GrossMargin, IndexType, BillingTypeID )  
values (@p_product_id, @p_rate_id, @p_eff_date, @p_rate, @p_rate_descp, 
		case when @p_fixed_end_date = 1 then @p_due_date else '30000101' end, 
		@p_grace_period, @p_contract_eff_start_date, @p_val_01, @p_input_01, 
		@p_process_01, @p_val_02, @p_input_02, @p_process_02, @p_service_rate_class_id, 
		@p_zone_id, getdate(), @p_username, '0', getdate(), 0,@p_term_months, @p_fixed_end_date, 
		@GrossMargin, @IndexType, @BillingTypeID)  
     
if @@error                                         <> 0    
or @@rowcount                                       = 0    
begin    
   select @w_error                                  = 'E'    
   select @w_msg_id                                 = '00000002'    
   select @w_return                                 = 1    
   goto goto_select    
end    
    
declare @w_eff_date_max                             datetime    
    
select @w_eff_date_max                              = isnull(max(eff_date), '19000101')    
from common_product_rate WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_rate_idx)    
where product_id                                    = @p_product_id    
and   rate_id                                       = @p_rate_id    
and   eff_date                                      < @p_eff_date    
     
if @w_eff_date_max                                  > '19000101'    
begin    
   update common_product_rate set due_date = dateadd(dd, -1, @p_eff_date)    
   from common_product_rate WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_rate_idx)    
   where product_id                                 = @p_product_id    
   and   rate_id                                    = @p_rate_id    
   and   eff_date                                   = @w_eff_date_max    
end    
    
goto_select:    
    
if @w_error                                        <> 'N'    
begin    
   exec lp_common..usp_messages_sel @w_msg_id,    
                                    @w_descp output    
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
