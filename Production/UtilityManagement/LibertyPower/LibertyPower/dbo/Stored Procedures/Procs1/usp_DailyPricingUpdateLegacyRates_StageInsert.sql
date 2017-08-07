/*******************************************************************************
 * usp_DailyPricingUpdateLegacyRates_StageInsert
 * Inserts legacy rate into staging table
 *
 * History
 *******************************************************************************
 * 12/1/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE usp_DailyPricingUpdateLegacyRates_StageInsert
	@ProductID		varchar(20),
	@RateID			int,
	@Rate			decimal(16,10),
	@Terms			int,
	@EffectiveDate	datetime,
	@DueDate		datetime,
	@GrossMargin	decimal(9,6),
	@RateDesc		varchar(250)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO	DailyPricingUpdateLegacyRates_Stage (ProductId, RateId, Rate, Terms, EffDate, DueDate, GrossMargin, RateDescription) 
    VALUES		(@ProductID, @RateID, @Rate, @Terms, @EffectiveDate, @DueDate, @GrossMargin, @RateDesc) 

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingUpdateLegacyRates_StageInsert';

