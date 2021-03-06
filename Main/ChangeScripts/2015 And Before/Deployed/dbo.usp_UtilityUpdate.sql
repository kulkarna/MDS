
USE [Libertypower]
GO

BEGIN TRANSACTION _STRUCTURE_
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
/********************************************************************************
* usp_UtilityUpdate
* Procedure to update rows in the Utility

* History
********************************************************************************
* 02/24/2010  - SWCS / Jose Munoz
* Created.

* 04/07/2010  - Jose  Munoz
* Modify:	Ticket 14817
			Add field SSNIsRequired into utility table 	

* 05/03/2012  - Sheri Scott
* Modify:	Commented all references to Field01 through Field15	
********************************************************************************/

DROP PROCEDURE [dbo].[usp_UtilityUpdate]
GO

CREATE procedure [dbo].[usp_UtilityUpdate] ( 	
	@UtilityCode                                      varchar(50)
	,@FullName                                         varchar(100)
	,@ShortName                                        varchar(50)=''
	,@MarketID                                         Integer
	,@DunsNumber                                       varchar(30)	
	,@EntityId                                         varchar(15)
	,@EnrollmentLeadDays                               Integer
	,@BillingType                                      varchar(15)
	,@AccountLength                                    Integer
	,@AccountNumberPrefix                              varchar(10)
	,@LeadScreenProcess                                varchar(15)
	,@DealScreenProcess                                varchar(15)
	,@PorOption                                        varchar(3)='NO'
	--,@Field01Label                                     varchar(20)
	--,@Field01Type                                      varchar(30)
	--,@Field02Label                                     varchar(20)
	--,@Field02Type                                      varchar(30)
	--,@Field03Label                                     varchar(20)
	--,@Field03Type                                      varchar(30)
	--,@Field04Label                                     varchar(20)
	--,@Field04Type                                      varchar(30)
	--,@Field05Label                                     varchar(20)
	--,@Field05Type                                      varchar(30)
	--,@Field06Label                                     varchar(20)
	--,@Field06Type                                      varchar(30)
	--,@Field07Label                                     varchar(20)
	--,@Field07Type                                      varchar(30)
	--,@Field08Label                                     varchar(20)
	--,@Field08Type                                      varchar(30)
	--,@Field09Label                                     varchar(20)
	--,@Field09Type                                      varchar(30)
	--,@Field10Label                                     varchar(20)
	--,@Field10Type                                      varchar(30)	
	,@UserName                                         nchar(400)
	,@InactiveInd                                      char(1)='0'	
	,@ChgStamp                                         smallint=0
	,@MeterNumberRequired                              smallint=0
	,@MeterNumberLength                                smallint=0
	,@AnnualUsageMin                                   Integer=0	
	,@Qualifier                                        varchar(50) = ''
	,@EdiCapable                                       smallint = 0
	,@WholeSaleMktID                                   varchar(50) = ''
	,@Phone                                            varchar(30)
	,@RateCodeRequired                                 tinyint = 0
	,@HasZones                                         tinyint = 0
	,@ZoneDefault                                      Integer = 0
	,@Field11Label                                     varchar(20)='NONE' 
	,@Field11Type                                      varchar(30)='NONE'
	,@Field12Label                                     varchar(20)='NONE'
	,@Field12Type                                      varchar(30)='NONE'
	,@Field13Label                                     varchar(20)='NONE'
	,@Field13Type                                      varchar(30)='NONE'
	,@Field14Label                                     varchar(20)='NONE'
	,@Field14Type                                      varchar(30)='NONE'
	,@Field15Label                                     varchar(20)='NONE'
	,@Field15Type                                      varchar(30)='NONE'
	,@RateCodeFormat                                   varchar(20) = NULL
	,@RateCodeFields                                   varchar(50) = NULL
	,@Error							                   char(01) = ' '
	,@MsgId											   char(08) = ' '
	,@Descp										       varchar(250) = ' '
	,@ResultInd										   char(01) = 'Y'		
	,@OldChgstamp				                       smallint
	,@PaperContractOnly							       int
	,@SSNIsRequired										bit = null -- ticket 14817
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
	,ShortName                                          = @ShortName
	,MarketID                                           = @MarketID
	,DunsNumber                                         = @DunsNumber	
	,EntityId                                           = @EntityId
	,EnrollmentLeadDays                                 = @EnrollmentLeadDays
	,BillingType                                        = @BillingType
	,AccountLength                                      = @AccountLength
	,AccountNumberPrefix                                = @AccountNumberPrefix
	,LeadScreenProcess                                  = @LeadScreenProcess
	,DealScreenProcess                                  = @DealScreenProcess
	,PorOption                                          = @PorOption
	--,Field01Label                                       = @Field01Label
	--,Field01Type = case when @Field01Label = ' ' then 'NONE' else @Field01Type end
	--,Field02Label                                       = @Field02Label
	--,Field02Type = case when @Field02Label = ' ' then 'NONE' else @Field02Type end
	--,Field03Label                                       = @Field03Label
	--,Field03Type = case when @Field03Label = ' ' then 'NONE' else @Field03Type end
	--,Field04Label                                       = @Field04Label
	--,Field04Type = case when @Field04Label = ' ' then 'NONE' else @Field04Type end
	--,Field05Label                                       = @Field05Label
	--,Field05Type = case when @Field05Label = ' ' then 'NONE' else @Field05Type end
	--,Field06Label                                       = @Field06Label
	--,Field06Type = case when @Field06Label = ' ' then 'NONE' else @Field06Type end
	--,Field07Label                                       = @Field07Label
	--,Field07Type = case when @Field07Label = ' ' then 'NONE' else @Field07Type end
	--,Field08Label                                       = @Field08Label
	--,Field08Type = case when @Field08Label = ' ' then 'NONE' else @Field08Type end
	--,Field09Label                                       = @Field09Label
	--,Field09Type = case when @Field09Label = ' ' then 'NONE' else @Field09Type end
	--,Field10Label                                       = @Field10Label
	--,Field10Type = case when @Field10Label = ' ' then 'NONE' else @Field10Type end	
	,UserName                                           = @UserName		
	,ChgStamp                                           = @ChgStamp
	,MeterNumberRequired                                = @MeterNumberRequired
	,MeterNumberLength                                  = @MeterNumberLength
	,AnnualUsageMin                                     = @AnnualUsageMin
	,Qualifier                                          = @Qualifier
	,EdiCapable                                         = @EdiCapable
	,WholeSaleMktID                                     = @WholeSaleMktID	
	,RateCodeRequired                                   = @RateCodeRequired
	,HasZones                                           = @HasZones
	,ZoneDefault                                        = @ZoneDefault
	--,Field11Label                                       = @Field11Label
	--,Field11Type = case when @Field11Label = ' ' then 'NONE' else @Field11Type end
	--,Field12Label                                       = @Field12Label
	--,Field12Type = case when @Field12Label = ' ' then 'NONE' else @Field12Type end
	--,Field13Label                                       = @Field13Label
	--,Field13Type = case when @Field13Label = ' ' then 'NONE' else @Field13Type end
	--,Field14Label                                       = @Field14Label
	--,Field14Type = case when @Field14Label = ' ' then 'NONE' else @Field14Type end
	--,Field15Label                                       = @Field15Label
	--,Field15Type = case when @Field15Label = ' ' then 'NONE' else @Field15Type end
	,RateCodeFormat = case when @RateCodeFormat is null then RateCodeFormat else @RateCodeFormat end --@RateCodeFormat
	,RateCodeFields = case when @RateCodeFields is null then RateCodeFields else @RateCodeFields end --@RateCodeFields
    ,InactiveInd = case when @InactiveInd = 'INACTIVE' then '1' else '0' end
    ,ActiveDate = case when @InactiveInd = 'INACTIVE' and InactiveInd = '0' then getdate() else ActiveDate end
    ,Phone = @Phone	
    ,SSNIsRequired = case when @SSNIsRequired is null then SSNIsRequired else @SSNIsRequired end --Ticket 14817
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
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT TRANSACTION _STRUCTURE_
GO

SET NOEXEC OFF
GO
