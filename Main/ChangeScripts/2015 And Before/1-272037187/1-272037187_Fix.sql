USE [Lp_common]
GO

/****** Object:  StoredProcedure [dbo].[usp_product_val]    Script Date: 10/28/2013 15:55:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_product_val 'WVILCHEZ', 'I', 'ALL', 'PRODUCT-01', 'PRODUCT-01 PEAK', 'FIXED', 'CON ED', 'DAYLY', 15  

-- ******* Modified by Chowdary  SR 1-272037187 **************------------- 
-- Date Modified: 10/28/2013  Commented out the IF Condition where it returns the error on finding the records.
-- ******* END *****************************************************************************************************
  
   
ALTER PROCEDURE [dbo].[usp_product_val]  
(@p_username                                        nchar(100),  
 @p_action                                          char(01),  
 @p_edit_type                                       varchar(100),  
 @p_product_id                                      char(20),  
 @p_product_descp                                   varchar(50),  
 @p_product_category                                char(20),  
 @p_product_subcategory                                char(20),  
 @p_utility_id                                      char(15),  
 @p_frecuency                                       varchar(10),  
 @p_error                                           char(01) = ' ',  
 @p_msg_id                                          char(08) = ' ',  
 @p_descp                                           varchar(250) = ' ',  
 @p_result_ind                                      char(01) = 'Y')  
as  

SET NOCOUNT ON;

declare @w_error                                    char(01)  
declare @w_msg_id                                   char(08)  
declare @w_descp                                    varchar(250)  
declare @w_return                                   int  
   
select @w_error                                     = 'I'  
select @w_msg_id                                    = '00000001'  
select @w_descp                                     = ' '  
select @w_return                                    = 0  
  
declare @w_application                              varchar(20)  
select @w_application                               = 'COMMON'  
   
if @p_edit_type                                     = 'ALL'  
or @p_edit_type                                     = 'PRODUCT_ID'  
begin  
   
   if @p_product_id                                is null  
   or @p_product_id                                 = ' '  
   begin  
      select @w_application                         = 'COMMON'  
      select @w_error                               = 'E'  
      select @w_msg_id                              = '00000032'  
      select @w_return                              = 1  
      goto goto_select  
   end  
   
   if @p_action                                     = 'I'  
   begin  
      if exists(select *  
                from common_product WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_idx)  
                where product_id                    = @p_product_id)  
      begin  
         select @w_application                      = 'COMMON'  
         select @w_error                            = 'E'  
         select @w_msg_id                           = '00000033'  
         select @w_return                           = 1  
         goto goto_select  
      end  
   end  
end  
   
if @p_edit_type                                     = 'ALL'  
or @p_edit_type                                     = 'PRODUCT_DESCP'  
begin  
   
   if @p_product_descp                             is null  
   or @p_product_descp                              = ' '  
   begin  
      select @w_application                         = 'COMMON'  
      select @w_error                               = 'E'  
      select @w_msg_id                              = '00000034'  
      select @w_return                              = 1  
      goto goto_select  
   end  
   
   -- CODE START By CHOWDARY SR 1-272037187  **************-------------------------
   --if exists(select *  
   --          from common_product WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_idx2)  
   --          where product_descp                    = @p_product_descp  
   --          and   product_id                      <> @p_product_id)  
   --begin  
   --   select @w_application                         = 'COMMON'  
   --   select @w_error                               = 'E'  
   --   select @w_msg_id                              = '00000035'  
   --   select @w_return                              = 1  
   --   goto goto_select  
   --end  
   --- CODE END CHOWDARY SR 1-272037187   *******------------------------------------------
   
end  
   
if @p_edit_type                                     = 'ALL'  
or @p_edit_type                                     = 'PRODUCT_CATEGORY'  
begin  
   
   if @p_product_category                          is null  
   or @p_product_category                           = ' '  
   begin  
      select @w_application                         = 'COMMON'  
      select @w_error                               = 'E'  
      select @w_msg_id                              = '00000036'  
      select @w_return                              = 1  
      goto goto_select  
   end  
   
end  
   
if @p_edit_type                                     = 'ALL'  
or @p_edit_type                                     = 'UTILITY_ID'  
begin  
   
   if @p_utility_id                                is null  
   or @p_utility_id                                 = ' '  
   begin  
      select @w_application                         = 'COMMON'  
      select @w_error                               = 'E'  
      select @w_msg_id                              = '00000005'  
      select @w_return                              = 1  
      goto goto_select  
   end  
   
end  
   
if @p_edit_type                                     = 'ALL'  
or @p_edit_type                                     = 'FRECUENCY'  
begin  
   
   if @p_frecuency                                 is null  
   or @p_frecuency                                  = ' '  
   begin  
      select @w_application                         = 'COMMON'  
      select @w_error                               = 'E'  
      select @w_msg_id                              = '00000037'  
      select @w_return                              = 1  
      goto goto_select  
   end  
   
end  
  
goto_select:  
   
if @w_error                                        <> 'N'  
begin  
   exec lp_common..usp_messages_sel @w_msg_id,  
                                    @w_descp output,  
                                    @w_application  
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
SET NOCOUNT OFF;
return @w_return

