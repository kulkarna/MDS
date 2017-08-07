
/********************************************************************************
* usp_UtilityUpdate
* Procedure to update rows in the Utility

* History
********************************************************************************
* Created --- ??????????????

* 4/30/2013  - Gail Mangaroo
* Modify: Added Locations and Profile Reference fields
*		: Also changed defaults for parameters to NULL, so that fields will only be updated
*			 with non NULL parameters and will not be overwritten with default values
********************************************************************************/
CREATE procedure [dbo].[usp_UtilityUpdate] ( 	
	@UtilityCode                                      varchar(50)
	,@FullName                                         varchar(100)
	,@ShortName                                        varchar(50)=null
	,@MarketID                                         Integer
	,@DunsNumber                                       varchar(30)	
	,@EntityId                                         varchar(15)
	,@EnrollmentLeadDays                               Integer
	,@BillingType                                      varchar(15)
	,@AccountLength                                    Integer
	,@AccountNumberPrefix                              varchar(10)
	,@LeadScreenProcess                                varchar(15)
	,@DealScreenProcess                                varchar(15)
	,@PorOption                                        varchar(3)=null
	,@UserName                                         nchar(400)
	,@InactiveInd                                      char(1)='0'	
	,@ChgStamp                                         smallint=null
	,@MeterNumberRequired                              smallint=null
	,@MeterNumberLength                                smallint=null
	,@AnnualUsageMin                                   Integer=null
	,@Qualifier                                        varchar(50)=null
	,@EdiCapable                                       smallint=null
	,@WholeSaleMktID                                   varchar(50)=null
	,@Phone                                            varchar(30)=null
	,@RateCodeRequired                                 tinyint=null
	,@HasZones                                         tinyint=null
	,@ZoneDefault                                      Integer=null
	,@Field11Label                                     varchar(20)=null 
	,@Field11Type                                      varchar(30)=null
	,@Field12Label                                     varchar(20)=null
	,@Field12Type                                      varchar(30)=null
	,@Field13Label                                     varchar(20)=null
	,@Field13Type                                      varchar(30)=null
	,@Field14Label                                     varchar(20)=null
	,@Field14Type                                      varchar(30)=null
	,@Field15Label                                     varchar(20)=null
	,@Field15Type                                      varchar(30)=null
	,@RateCodeFormat                                   varchar(20) = NULL
	,@RateCodeFields                                   varchar(50) = NULL
	,@Error							                   char(01) = ' '
	,@MsgId											   char(08) = ' '
	,@Descp										       varchar(250) = ' '
	,@ResultInd										   char(01) = 'Y'		
	,@OldChgstamp				                       smallint =null
	,@PaperContractOnly							       int =null
	,@SSNIsRequired										bit = null -- ticket 14817
	,@DeliveryLocationRefID								int = null
	,@SettlementLocationRefID							int = null
	,@DefaultProfileRefID								int = null
	)
as

set nocount on 

select @FullName                             = upper(@FullName)
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
 
select @w_error = 'I', @w_msg_id = '00000001', @w_descp = ' ', @w_return = 0
 
declare @w_new_chgstamp smallint
 
exec lp_common..usp_calc_chgstamp @OldChgstamp, @w_new_chgstamp output
 

update Utility set
	 UtilityCode                                        = @UtilityCode
	,FullName                                           = @FullName
	,ShortName                                          = iSNULL(@ShortName , ShortName ) 
	,MarketID                                           = @MarketID
	,DunsNumber                                         = @DunsNumber	
	,EntityId                                           = @EntityId
	,EnrollmentLeadDays                                 = @EnrollmentLeadDays
	,BillingType                                        = @BillingType
	,AccountLength                                      = @AccountLength
	,AccountNumberPrefix                                = @AccountNumberPrefix
	,LeadScreenProcess                                  = @LeadScreenProcess
	,DealScreenProcess                                  = @DealScreenProcess
	,PorOption                                          = iSNULL(@PorOption, PorOption)
	,UserName                                           = @UserName		
	,ChgStamp                                           = iSNULL(@ChgStamp, ChgStamp)
	,MeterNumberRequired                                = iSNULL(@MeterNumberRequired, MeterNumberRequired)
	,MeterNumberLength                                  = iSNULL(@MeterNumberLength, MeterNumberLength)
	,AnnualUsageMin                                     = iSNULL(@AnnualUsageMin, AnnualUsageMin)
	,Qualifier                                          = iSNULL(@Qualifier, Qualifier)
	,EdiCapable                                         = iSNULL(@EdiCapable, EdiCapable)
	,WholeSaleMktID                                     = iSNULL(@WholeSaleMktID, WholeSaleMktID)	
	,RateCodeRequired                                   = iSNULL(@RateCodeRequired, RateCodeRequired) 
	,HasZones                                           = iSNULL(@HasZones, HasZones)
	,ZoneDefault                                        = iSNULL(@ZoneDefault, ZoneDefault)
	,RateCodeFormat = case when @RateCodeFormat is null then RateCodeFormat else @RateCodeFormat end --@RateCodeFormat
	,RateCodeFields = case when @RateCodeFields is null then RateCodeFields else @RateCodeFields end --@RateCodeFields
    ,InactiveInd = case when @InactiveInd = 'INACTIVE' then '1' else '0' end
    ,ActiveDate = case when @InactiveInd = 'INACTIVE' and InactiveInd = '0' then getdate() else ActiveDate end
    ,Phone												= iSNULL(@Phone	, Phone)
    ,SSNIsRequired = case when @SSNIsRequired is null then SSNIsRequired else @SSNIsRequired end --Ticket 14817
    ,DeliveryLocationRefID								= iSNULL(@DeliveryLocationRefID, DeliveryLocationRefID)
    ,SettlementLocationRefID							= iSNULL(@SettlementLocationRefID, SettlementLocationRefID)
    ,DefaultProfileRefID								= iSNULL(@DefaultProfileRefID, DefaultProfileRefID)

where UtilityCode                                                = @UtilityCode

if @@error <> 0 or @@rowcount = 0
begin
   if exists(select * 
             from common_utility
             where utility_id = @UtilityCode)
      select @w_error = 'E', @w_msg_id= '00000003', @w_return = 1
   else
      select @w_error = 'E', @w_msg_id = '00000004', @w_return = 1
end

update	UtilityPermission
set		PaperContractOnly	= @PaperContractOnly
where	UtilityCode			= @UtilityCode
 
if @w_error <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id, @w_descp output
end
 
if @ResultInd = 'Y'
begin
   select flag_error = @w_error, code_error = @w_msg_id, message_error = @w_descp
   goto goto_return
end
 
select @Error = @w_error, @MsgId = @w_msg_id, @Descp = @w_descp
 
goto_return:
return @w_return


set nocount off

-- Copywrite LibertyPower 02/24/2010
