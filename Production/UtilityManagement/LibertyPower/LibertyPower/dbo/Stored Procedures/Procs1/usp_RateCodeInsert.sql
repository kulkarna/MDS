

/*******************************************************************************
 * usp_RateCodeInsert
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeInsert]  
	@Market				varchar(16),                                                                                  
	@Utility					varchar(32),
	@Code					varchar(32),
	@Rate					decimal(18,10),
	@EffectiveDate		datetime,
	@ExpirationDate datetime,
	@PricingOption	varchar(32),
	@SupplierRateCode varchar(50),
	@ProgramNumber varchar(16),
	@PricingGroup varchar(16),
	@ServiceClass varchar(50),
	@ZoneCode varchar(16),
	@MeterType varchar(16),
	@CreatedBy			int
AS


DECLARE @RateCodeID INT

IF NOT EXISTS (	SELECT Utility, Code, ServiceClass, ZoneCode, MeterType
								FROM RateCode
								WHERE Utility = @Utility and Code = @Code and ServiceClass = @ServiceClass and RateCode.ZoneCode = @ZoneCode and MeterType = @MeterType)
BEGIN
BEGIN TRANSACTION

	INSERT INTO RateCode( Market, Utility, Code,  PricingOption, SupplierRateCode, ProgramNumber, PricingGroup, ServiceClass, ZoneCode, MeterType, CreatedBy, ModifiedBy )
	VALUES(@Market, @Utility, @Code, @PricingOption, @SupplierRateCode, @ProgramNumber, @PricingGroup, @ServiceClass, @ZoneCode, @MeterType, @CreatedBy, @CreatedBy)

	SET @RateCodeID = SCOPE_IDENTITY()

	if(@RateCodeID IS NOT NULL)
	BEGIN
		INSERT INTO Rate( RateCodeID, Price, EffectiveDate, ExpirationDate, CreatedBy, ModifiedBy)
		VALUES( @RateCodeID, @Rate, @EffectiveDate, @ExpirationDate, @CreatedBy, @CreatedBy)
	END

 
IF @@ERROR = 0 
	COMMIT                                                                                                                                       
ELSE
	ROLLBACK  
	   
END
IF @RateCodeID IS NOT NULL
BEGIN	 
	SELECT		RateCode.ID, 
						RateCode.Market,
						RateCode.Utility,
						RateCode.Code,
						RateCode.PricingOption,
						RateCode.SupplierRateCode,
						RateCode.ProgramNumber,
						RateCode.PricingGroup,
						RateCode.ServiceClass, 
						RateCode.ZoneCode, 
						RateCode.MeterType,
						RateCode.DateCreated,
						RateCode.CreatedBy,
						RateCode.DateModified,
						RateCode.ModifiedBy,
						Rate.ID, 
						Rate.RateCodeID, 
						Rate.Price,
						Rate.EffectiveDate,
						Rate.ExpirationDate,
						Rate.DateCreated,
						Rate.CreatedBy,
						Rate.DateModified,
						Rate.ModifiedBy
	FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID 
	WHERE RateCode.ID = @RateCodeID
	END
	
    
-- Copyright 2009 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeInsert';

