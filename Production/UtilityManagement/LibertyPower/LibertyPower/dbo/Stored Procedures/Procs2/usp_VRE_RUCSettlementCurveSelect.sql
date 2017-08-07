
CREATE PROCEDURE [dbo].[usp_VRE_RUCSettlementCurveSelect]
	@ContextDate DateTime = null
AS
BEGIN
    SET NOCOUNT ON;
	   	
	Select 
		[ID],
		[FileContextGUID],
		[MeterReadMonth],
		[SettlementMonth],
		[RUCCharge],
		[DateCreated],
		[CreatedBy]
	From 
		VRERUCSettlementCurve C1 WITH (NOLOCK)
	Where	
		C1.ID in 
		( 
			Select 
				Max(C2.ID)
			From
				VRERUCSettlementCurve C2 WITH (NOLOCK)
			Where
				C1.MeterReadMonth = C2.MeterReadMonth And
				C1.SettlementMonth = C2.SettlementMonth And				
				(@ContextDate IS NULL OR C2.DateCreated < @ContextDate)			
		)
	Order By
		C1.DateCreated DESC		

    SET NOCOUNT OFF;
END




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_RUCSettlementCurveSelect';

