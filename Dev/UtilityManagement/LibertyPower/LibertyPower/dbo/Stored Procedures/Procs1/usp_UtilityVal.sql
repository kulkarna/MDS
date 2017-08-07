 
CREATE PROCEDURE [dbo].[usp_UtilityVal]
-------------------------------------------------------------------------------------
-- Modified:	Sheri Scott
-- Date:		05/03/2012
-- Description:	Commented out all references to Field01 through Field15.
-------------------------------------------------------------------------------------
 
(@Username										nchar(100),
 @Action                                        char(01),
 @EditType									    varchar(100),
 @UtilityCode                                   char(15),
 @FullName		                                varchar(50),
 @DunsNumber                                    varchar(30),
 @MarketID										int,
 @EntityId                                      char(15),
 @EnrollmentLeadDays                            int,
 @AccountLength                                 int,
 @AccountNumberPrefix                           varchar(10),
 @BillingType							        varchar(15),	
 @LeadScreenProcess						        varchar(15),
 @DealScreenProcess                             varchar(15),
 --@Field01Label                                  varchar(15),
 --@Field01Type                                   varchar(30),
 --@Field02Label                                  varchar(15),
 --@Field02Type                                   varchar(30),
 --@Field03Label                                  varchar(15),
 --@Field03Type                                   varchar(30),
 --@Field04Label                                  varchar(15),
 --@Field04Type                                   varchar(30),
 --@Field05Label                                  varchar(15),
 --@Field05Type                                   varchar(30),
 --@Field06Label                                  varchar(15),
 --@Field06Type                                   varchar(30),
 --@Field07Label                                  varchar(15),
 --@Field07Type                                   varchar(30),
 --@Field08Label                                  varchar(15),
 --@Field08Type                                   varchar(30),
 --@Field09Label                                  varchar(15),
 --@Field09Type                                   varchar(30),
 --@Field10Label                                  varchar(15),
 --@Field10Type                                   varchar(30),
 --@Field11Label                                  varchar(15)=null,
 --@Field11Type                                   varchar(30)='NONE',
 --@Field12Label                                  varchar(15)=null,
 --@Field12Type                                   varchar(30)='NONE',
 --@Field13Label                                  varchar(15)=null,
 --@Field13Type                                   varchar(30)='NONE',
 --@Field14Label                                  varchar(15)=null,
 --@Field14Type                                   varchar(30)='NONE',
 --@Field15Label                                  varchar(15)=null,
 --@Field15Type                                   varchar(30)='NONE',
 @Error                                         char(01) = ' ',
 @MsgId                                        char(08) = ' ',
 @Descp                                         varchar(250) = ' ',
 @ResultInd                                    char(01) = 'Y')
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(10)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '
 
declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'
 
if @EditType                                     = 'ALL'
or @EditType                                     = 'UTILITY_ID'
begin
 
   if @UtilityCode                                is null
   or @UtilityCode                                = ' '
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000005'
      select @w_return                              = 1
      goto goto_select
   end
 
   if @Action                                     = 'I'
   begin
      if exists(select *
           from Utility
                where UtilityCode                   = @UtilityCode)
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000029'
         select @w_return                           = 1
         goto goto_select
      end
   end
end
 
if @EditType                                     = 'ALL'
or @EditType                                     = 'UTILITY_DESCP'
begin
 
   if @FullName                             is null
   or @FullName                              = ' '
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000028'
      select @w_return                              = 1
      goto goto_select
   end

   select @FullName                          = upper(@FullName)

   if exists(select *
             from Utility 
             where FullName                    = @FullName
             and   UtilityCode                      <> @UtilityCode)
   begin  
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000027'
      select @w_return                              = 1
      goto goto_select
   end
 
end
 
if @EditType                                     = 'ALL'
or @EditType                                     = 'DUNS_NUMBER'
begin
 
   if @DunsNumber                               is null
   or @DunsNumber                                = ' '
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000010'
      select @w_return                              = 1
      goto goto_select
   end
 
end
 
if @EditType                                     = 'ALL'
or @EditType                                     = 'RETAIL_MKT_ID'
begin
 
   if @MarketID                             is null
   or @MarketID                              = ' '
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000017'
      select @w_return                              = 1
      goto goto_select
   end
 
end
 
if @EditType                                     = 'ALL'
or @EditType                                     = 'ENTITY_ID'
begin
 
   if @EntityId                                 is null
   or @EntityId                                  = ' '
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000006'
      select @w_return                              = 1
      goto goto_select
   end
 
end

if @EditType                                     = 'ALL'
or @EditType                                     = 'ENROLLMENT_LEAD_DAYS'
begin
 
   if @EnrollmentLeadDays                      is null
   or @EnrollmentLeadDays                       < 0
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000030'
      select @w_return                              = 1
      goto goto_select
   end
 
end

if @EditType                                     = 'ALL'
or @EditType                                     = 'BILLING TYPE'
begin
 
   if @EnrollmentLeadDays                      is null
   or @EnrollmentLeadDays                       < 0
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000065'
      select @w_return                              = 1
      goto goto_select
   end
 
end

if @EditType                                     = 'ALL'
or @EditType                                     = 'DEAL SCREEN PROCESS'
begin
 
   if @DealScreenProcess                       is null
   or @DealScreenProcess                        = ' '
   or @DealScreenProcess                        = 'NONE'
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000081'
      select @w_return                              = 1
      goto goto_select
   end
 
end

--select @w_descp_add                                 = ' '

--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_01_LABEL'
--begin
 
--   if (@Field01Label                         is null
--   or  @Field01Label                            = ' ')
--   and @Field01Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '01'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
 
--end

--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_02_LABEL'
--begin
 
--   if (@Field02Label                         is null
--   or  @Field02Label                            = ' ')
--   and @Field02Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '02'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
 
--end
  
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_03_LABEL'
--begin
 
--   if (@Field03Label                         is null
--   or  @Field03Label                            = ' ')
--   and @Field03Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '03'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end

--end
 
 
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_04_LABEL'
--begin
 
--   if (@Field04Label                         is null
--   or  @Field04Label                            = ' ')
--   and @Field04Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '04'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
 
--end
 
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_05_LABEL'
--begin
 
--   if (@Field05Label                         is null
--   or  @Field05Label                            = ' ')
--   and @Field05Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '05'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
  
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_06_LABEL'
--begin
--   if (@Field06Label                         is null
--   or  @Field06Label                            = ' ')
--   and @Field06Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '06'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
  
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_07_LABEL'
--begin
--   if (@Field07Label                         is null
--   or  @Field07Label                            = ' ')
--   and @Field07Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '07'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
 

--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_08_LABEL'
--begin
--   if (@Field08Label                         is null
--   or  @Field08Label                            = ' ')
--   and @Field08Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '08'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
 
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_09_LABEL'
--begin
--   if (@Field09Label                         is null
--   or  @Field09Label                            = ' ')
--   and @Field09Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '09'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
  
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_10_LABEL'
--begin
--   if (@Field10Label                         is null
--   or  @Field10Label                            = ' ')
--   and @Field10Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '10'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end

--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_11_LABEL'
--begin
--   if (@Field11Label                         is null
--   or  @Field11Label                            = ' ')
--   and @Field11Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '11'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_11_LABEL'
--begin
--   if (@Field11Label                         is null
--   or  @Field11Label                            = ' ')
--   and @Field11Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '11'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_12_LABEL'
--begin
--   if (@Field12Label                         is null
--   or  @Field12Label                            = ' ')
--   and @Field12Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '12'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_13_LABEL'
--begin
--   if (@Field13Label                         is null
--   or  @Field13Label                            = ' ')
--   and @Field13Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '13'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_14_LABEL'
--begin
--   if (@Field14Label                         is null
--   or  @Field14Label                            = ' ')
--   and @Field14Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '14'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
--if @EditType                                     = 'ALL'
--or @EditType                                     = 'FIELD_15_LABEL'
--begin
--   if (@Field15Label                         is null
--   or  @Field15Label                            = ' ')
--   and @Field15Type                            <> 'NONE'
--   begin
--      select @w_descp_add                           = '15'
--      select @w_application                         = 'COMMON'
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000086'
--      select @w_return                              = 1
--      goto goto_select
--   end
--end
 
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
 
if @ResultInd                                    = 'Y'
begin
   select flag_error                                = @w_error,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end
 
select @Error                                     = @w_error,
       @MsgId                                    = @w_msg_id,
       @Descp                                     = @w_descp
 
goto_return:
return @w_return

