﻿
/*******************************************************************************
 * usp_RateCodesSelectAll
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodesSelectAll]  
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
	Order by RateCode.Utility, RateCode.ID, Rate.EffectiveDate, Rate.Price

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodesSelectAll';

