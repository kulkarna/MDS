

/*******************************************************************************
 * [usp_RateCodeRangeSelectByMeterType]
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeRangeSelectByMeterType]  
	@Utility					varchar(32),
	@ContextDate		DateTime,
	@LowPrice			float,
	@HighPrice			float,
	@MeterType			varchar(32)
AS
	
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
						Rate.ID  as [RateID], 
						Rate.RateCodeID, 
						Rate.Price,
						Rate.EffectiveDate,
						Rate.ExpirationDate,
						Rate.DateCreated as [RateDateCreated],
						Rate.CreatedBy as [RateCreatedBy],
						Rate.DateModified as [RateDateModified],
						Rate.ModifiedBy as [RateModifiedBy]	FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
	WHERE RateCode.Utility = @Utility 
	AND Rate.Price >= @LowPrice
	AND Rate.Price <= @HighPrice
	AND @ContextDate >= Rate.EffectiveDate
	AND @ContextDate <= Rate.ExpirationDate
	AND Rate.EffectiveDate <> Rate.ExpirationDate
	AND RateCode.MeterType = @MeterType
	Order by  Rate.Price


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeRangeSelectByMeterType';

