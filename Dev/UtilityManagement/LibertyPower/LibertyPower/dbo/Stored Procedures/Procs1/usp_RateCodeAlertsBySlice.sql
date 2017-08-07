

/*******************************************************************************
 * [usp_RateCodeAlertsBySlice]
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateCodeAlertsBySlice]  
	@Utility					varchar(32),
	@ContextDate		DateTime,
	@ServiceClass		varchar(50),
	@Zone					varchar(16),
	@MeterType			varchar(16)
AS
	DECLARE @Count INT
	DECLARE @RateCodeFormat VARCHAR(5)
	SET @RateCodeFormat = (SELECT u.rate_code_fields from lp_common..common_utility u WHERE u.utility_id = @Utility)
	
	--Unknown, None, ServiceClass, Zone, MeterType, ServiceClassAndZone
	
	if 	@RateCodeFormat = '0' OR @RateCodeFormat = '1' --Unknown or None
	BEGIN

		SET @Count = (SELECT COUNT(Rate.Price)
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate)/10
		
		SELECT TOP (@Count) Rate.Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		ORDER BY Rate.Price 

		SELECT TOP (@Count) Rate.Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		ORDER BY Rate.Price desc

	END
	ELSE IF @RateCodeFormat = '5' --ServiceClassAndZone
	BEGIN
	
		SET @Count = (SELECT COUNT(Rate.Price)
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ServiceClass = @ServiceClass
		AND RateCode.ZoneCode = @Zone 	)/10
		
		SELECT TOP (@Count) Rate.Price AS Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ServiceClass = @ServiceClass
		AND RateCode.ZoneCode = @Zone
		ORDER BY Rate.Price

		SELECT TOP (@Count) Rate.Price AS Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ServiceClass = @ServiceClass
		AND RateCode.ZoneCode = @Zone
		ORDER BY Rate.Price desc
			
	END
	ELSE IF @RateCodeFormat = '2' --ServiceClass
	BEGIN
		SET @Count = (SELECT COUNT(Rate.Price)
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ServiceClass = @ServiceClass )/10
		
		SELECT TOP (@Count) Rate.Price AS Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ServiceClass = @ServiceClass	
		ORDER BY Rate.Price 

		SELECT TOP (@Count) Rate.Price AS Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ServiceClass = @ServiceClass	
		ORDER BY Rate.Price desc
	
	
	END
	ELSE IF @RateCodeFormat = '3' --Zone
	BEGIN
		SET @Count = (SELECT COUNT(Rate.Price)
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ZoneCode = @Zone	)/10
		
		SELECT TOP (@Count) Rate.Price AS Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ZoneCode = @Zone
		ORDER BY Rate.Price 

		SELECT TOP (@Count) Rate.Price AS Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.ZoneCode = @Zone
		ORDER BY Rate.Price desc
	
	END	
	ELSE IF @RateCodeFormat = '4' --MeterType
	BEGIN
		SET @Count = (SELECT COUNT(Rate.Price)
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.MeterType = @MeterType	)/10
		
		SELECT TOP (@Count) Rate.Price AS Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.MeterType = @MeterType		
		ORDER BY Rate.Price 

		SELECT TOP (@Count) Rate.Price AS Price
		FROM	RateCode LEFT JOIN Rate ON RateCode.ID = Rate.RateCodeID  
		WHERE RateCode.Utility = @Utility 
		AND @ContextDate >= Rate.EffectiveDate
		AND @ContextDate <= Rate.ExpirationDate
		AND Rate.EffectiveDate <> Rate.ExpirationDate
		AND RateCode.MeterType = @MeterType		
		ORDER BY Rate.Price desc
	
	END	
	
	

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeAlertsBySlice';

