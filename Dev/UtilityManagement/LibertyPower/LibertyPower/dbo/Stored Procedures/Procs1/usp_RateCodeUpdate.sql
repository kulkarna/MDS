
/*******************************************************************************
 * usp_RateCodeUpdate
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeUpdate]  
	@ID						int,
	@Market				varchar(16),                                                                                  
	@Utility					varchar(32),
	@Code					varchar(32),
	@PricingOption	varchar(32),
	@SupplierRateCode varchar(50),
	@ProgramNumber varchar(16),
	@PricingGroup varchar(16),
	@ServiceClass varchar(32),
	@ZoneCode varchar(16),
	@MeterType varchar(16),
	@ModifiedBy			int

AS
IF EXISTS (SELECT Utility, Code FROM RateCode WHERE ID = @ID)
BEGIN TRANSACTION

	UPDATE RateCode 
	SET Market = @Market,
	Utility = @Utility,
	Code = @Code,
	PricingOption = @PricingOption,
	SupplierRateCode = @SupplierRateCode,
	ProgramNumber = @ProgramNumber,
	PricingGroup = @PricingGroup,
	ServiceClass = @ServiceClass,
	ZoneCode = @ZoneCode,
	MeterType = @MeterType,
	ModifiedBy = @ModifiedBy,
	DateModified = getdate()
	WHERE 
	ID = @ID

if @@ERROR = 0 
	COMMIT                                                                                                                                       
ELSE
	ROLLBACK    
-- Copyright 2009 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeUpdate';

