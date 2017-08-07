
/*******************************************************************************
 * [usp_RateCodeSelectByRateAndMeterType]
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeSelectByRateAndMeterType]  
	@Utility					varchar(32),
	@Price					float,
	@ContextDate		DateTime,
	@MeterType			varchar(32)
AS
	SELECT		TOP 1 
						RateCode.ID, 
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
	WHERE RateCode.Utility = @Utility 
	AND Rate.Price >= @Price
	AND @ContextDate >= Rate.EffectiveDate
	AND @ContextDate <= Rate.ExpirationDate
	AND Rate.EffectiveDate <> Rate.ExpirationDate 
	AND RateCode.MeterType = @MeterType
	Order by  Rate.Price

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeSelectByRateAndMeterType';

