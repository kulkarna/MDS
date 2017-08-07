
Create PROCEDURE [dbo].[usp_VRE_RUCSettlementCurveInsert]
	@FileContextGUID UNIQUEIDENTIFIER,
	@MeterReadMonth DateTime = NULL,
	@SettlementMonth DateTime = NULL,
	@RUCCharge DECIMAL(5,2),	
	@CreatedBy INT
AS
BEGIN
   INSERT INTO [VRERUCSettlementCurve]
           (          
			[FileContextGUID],
			[MeterReadMonth],
			[SettlementMonth],
			[RUCCharge],			
			[CreatedBy]
           )
     VALUES
           (
			@FileContextGUID,
			@MeterReadMonth,
			@SettlementMonth,
			@RUCCharge,			
			@CreatedBy
			);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT 
			[ID],
			[FileContextGUID],
			[MeterReadMonth],
			[SettlementMonth],
			[RUCCharge],			
			[CreatedBy]
		FROM 
			[VRERUCSettlementCurve] 
		WHERE 
			ID = SCOPE_IDENTITY();
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_RUCSettlementCurveInsert';

