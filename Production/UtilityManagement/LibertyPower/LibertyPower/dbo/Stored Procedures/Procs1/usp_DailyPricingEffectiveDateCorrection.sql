/*******************************************************************************
 * usp_DailyPricingEffectiveDateCorrection
 *
 * This proc is called from a job.
 * This will correct the "effective date" field on non-pricing days 
 * which is important for reports and commissions.
 *
 * History
 *******************************************************************************
 * 6/30/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingEffectiveDateCorrection]

AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@Today		datetime,
			@Yesterday	datetime,
			@IsWorkDay	tinyint
			
	SET @Today = DATEADD(dd, DATEDIFF(dd, '2011-01-01', GETDATE()), '2011-01-01')
	SET @Yesterday = DATEADD(dd, DATEDIFF(dd, '2011-01-01', GETDATE())-1, '2011-01-01')			

	SELECT	@IsWorkDay	= IsWorkDay
	FROM	Libertypower..DailyPricingCalendar WITH (NOLOCK)
	WHERE	[Date]		= @Today

	IF @IsWorkDay = 0 -- not a work day
		BEGIN			
			UPDATE	lp_common..common_product_rate
			SET		eff_date = @Today
			FROM	lp_common..common_product_rate cpr
			JOIN	lp_common..common_product cp ON cpr.product_id = cp.product_id
			WHERE	cp.IsCustom		= 0 
			AND		cp.inactive_ind	= 0
			AND		cpr.eff_date	= @Yesterday
		END
	ELSE -- check yesterday, still need to update effective date for today if yesterday was not a work day but today is
		BEGIN
			SELECT	@IsWorkDay	= IsWorkDay
			FROM	Libertypower..DailyPricingCalendar WITH (NOLOCK)
			WHERE	[Date]		= @Yesterday

			IF @IsWorkDay = 0 -- not a work day
				BEGIN			
					UPDATE	lp_common..common_product_rate
					SET		eff_date = @Today
					FROM	lp_common..common_product_rate cpr
					JOIN	lp_common..common_product cp ON cpr.product_id = cp.product_id
					WHERE	cp.IsCustom		= 0 
					AND		cp.inactive_ind	= 0
					AND		cpr.eff_date	= @Yesterday
				END		
		END

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingEffectiveDateCorrection';

