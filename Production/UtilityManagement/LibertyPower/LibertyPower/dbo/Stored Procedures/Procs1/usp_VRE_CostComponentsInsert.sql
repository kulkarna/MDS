

/********************************************************************************
* usp_VRE_CostComponentsInsert
* Procedure to insert rows in the VRECostComponents table.

* History
********************************************************************************
* 08/25/2010  - SWCS / Leandro Paiva
* Created.
********************************************************************************/

CREATE procedure [dbo].[usp_VRE_CostComponentsInsert] ( 	
	 @UtilityCode									varchar(50)
	,@Energy										bit = 0
	,@EnergyLoss									bit = 0
	,@AncillaryService								bit = 0
	,@OtherAncillaryService							bit = 0
	,@RPSPrice										bit = 0
	,@UCap											bit = 0
	,@TCap											bit = 0
	,@ARRCharge										bit = 0
	,@ARRChargeValue								int = 0
	,@BillingTransactionFee							bit = 0
	,@POR											bit = 0
	,@FinanceFee									bit = 0
	,@ARCreditReserve								bit = 0
	,@Markup										bit = 0
	,@MiscAdder										bit = 0
	,@MiscAdderDollarsPerMWh						decimal(18, 10) = 0
	,@ResultInd										char(1) = 'Y'
	,@Error											char(1) = ' '
	,@Descp											varchar(250) = ' '
	,@MsgId											char(8) = ' '
	,@MeterReadOverlap								bit = 0
	,@DefaultIsoZone								varchar(50) = ''	
	,@DefaultLoadShapeId							varchar(50) = ''
	,@ZoneJUCapPercent								decimal(5,4) = 0
	,@CreatedBy										int
	)
as

Begin
	set nocount on;

	declare @w_error                                    CHAR(01)
	declare @w_msg_id                                   CHAR(08)
	declare @w_descp                                    VARCHAR(250)
	declare @w_return                                   int
	 
	SELECT @w_error                                     = 'I'
	SELECT @w_msg_id                                    = '00000001'
	SELECT @w_descp                                     = ' '
	SELECT @w_return                                    = 0

	insert into VRECostComponents (
		UtilityCode,
		Energy,
		EnergyLoss,
		AncillaryService,
		OtherAncillaryService,
		RPSPrice,
		UCap,
		TCap,
		ARRCharge,
		ARRChargeValue,
		BillingTransactionFee,
		POR,
		FinanceFee,
		ARCreditReserve,
		Markup,
		MiscAdder,
		MiscAdderDollarsPerMWh,
		MeterReadOverlap,
		DefaultIsoZone,
		DefaultLoadShapeId,	
		ZoneJUCapPercent,
		CreatedBy
		)
	values 
		(
		@UtilityCode					
		,@Energy					
		,@EnergyLoss				
		,@AncillaryService			
		,@OtherAncillaryService	
		,@RPSPrice					
		,@UCap						
		,@TCap						
		,@ARRCharge					
		,@ARRChargeValue			
		,@BillingTransactionFee		
		,@POR						
		,@FinanceFee				
		,@ARCreditReserve			
		,@Markup					
		,@MiscAdder		
		,@MiscAdderDollarsPerMWh			
		,@MeterReadOverlap
		,@DefaultIsoZone
		,@DefaultLoadShapeId	
		,@ZoneJUCapPercent	
		,@CreatedBy
		)
	
	--select SCOPE_IDENTITY()
	
	IF @@error <> 0 or @@rowcount = 0
    SELECT @w_error = 'E', @w_msg_id = '00000002', @w_return = 1
 
	IF @w_error <> 'N'
	   EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp OUTPUT

	 
	IF @ResultInd = 'Y'
	begin
	   SELECT flag_error = @w_error, code_error = @w_msg_id, message_error = @w_descp
	   GOTO goto_return
	END
	 
	SELECT @Error = @w_error, @MsgId = @w_msg_id, @Descp = @w_descp
	 
	goto_return:
	return @w_return
		
	set nocount off;
	
End






GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_CostComponentsInsert';

