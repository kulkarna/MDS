

/********************************************************************************
* usp_VRE_CostComponentsSelect
* Procedure to search rows in the VRECostComponents table

********************************************************************************/

CREATE procedure [dbo].[usp_VRE_CostComponentsSelect] ( 
	 @UtilityCode		varchar(50)
	,@ContextDate		datetime
	)
as

set nocount on 

SELECT TOP 1
	ID,
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
	DateCreated,
	CreatedBy

FROM VRECostComponents with (nolock)
WHERE UtilityCode	= @UtilityCode
AND	  DateCreated	<= @ContextDate
ORDER BY DateCreated DESC
set nocount off





GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_CostComponentsSelect';

