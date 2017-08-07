
/********************************************************************************
* usp_VRE_CostComponentsUpdate
* Procedure to update rows in the VRECostComponents table.

* History
********************************************************************************
* 06/09/2010  - SWCS / David Maia
* Created.

********************************************************************************/

CREATE procedure [dbo].[usp_VRE_CostComponentsUpdate] ( 	
	@UtilityCode										varchar(50)
	,@Energy											bit = 0
	,@EnergyLoss										bit = 0
	,@AncillaryService									bit = 0
	,@OtherAncillaryService							bit = 0
	,@RPSPrice											bit = 0
	,@UCap												bit = 0
	,@TCap												bit = 0
	,@ARRCharge											bit = 0
	,@ARRChargeValue									int = 0
	,@BillingTransactionFee								bit = 0
	,@POR												bit = 0
	,@FinanceFee										bit = 0
	,@ARCreditReserve									bit = 0
	,@Markup											bit = 0
	,@MiscAdder											bit = 0
	,@MiscAdderDollarsPerMWh					decimal(18, 10) = 0
	,@Error												char(01) = ' '
	,@MsgId												char(08) = ' '
	,@Descp												varchar(250) = ' '
	,@ResultInd											char(01) = 'Y'	
	,@MeterReadOverlap								bit = 0
	,@DefaultIsoZone									varchar(50) = ''	
	,@DefaultLoadShapeId							varchar(50) = ''
	
	)
as

set nocount on 

 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
 
select @w_error = 'I', @w_msg_id = '00000001', @w_descp = ' ', @w_return = 0
 
declare @w_new_chgstamp smallint
 

update VRECostComponents set
	Energy                                           = @Energy
	,EnergyLoss                                      = @EnergyLoss
	,AncillaryService                                = @AncillaryService
	,OtherAncillaryService                        = @OtherAncillaryService
	,RPSPrice                                        = @RPSPrice
	,UCap										     = @UCap
	,TCap											 = @TCap
	,ARRCharge                                       = @ARRCharge
	,ARRChargeValue                                  = @ARRChargeValue
	,BillingTransactionFee                           = @BillingTransactionFee
	,POR											 = @POR
	,FinanceFee                                      = @FinanceFee
	,ARCreditReserve                                 = @ARCreditReserve
	,Markup											 = @Markup
	,MiscAdder                                       = @MiscAdder
	,MiscAdderDollarsPerMWh					=@MiscAdderDollarsPerMWh
	,MeterReadOverlap								=@MeterReadOverlap
	,DefaultIsoZone									=@DefaultIsoZone
	,DefaultLoadShapeId							=@DefaultLoadShapeId
where UtilityCode                                    = @UtilityCode

if @@error <> 0 or @@rowcount = 0
begin
   if exists(select * 
             from lp_common..common_utility
             where utility_id = @UtilityCode)
      select @w_error = 'E', @w_msg_id= '00000003', @w_return = 1
   else
      select @w_error = 'E', @w_msg_id = '00000004', @w_return = 1
end

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



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_CostComponentsUpdate';

