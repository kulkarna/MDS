/*******************************************************************************
 * usp_ForecastDailyUsageDetailInsert
 * Insert forecast daily usage detail record
 *
 * History
 *******************************************************************************
 * 4/1/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ForecastDailyUsageDetailInsert]                                                                                    
	@DailyUsageId	int,
	@Date			datetime,
	@Kwh			decimal(20,6)
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	ForecastDailyUsageDetail (DailyUsageId, [Date], Kwh)
	VALUES		(@DailyUsageId, @Date, @Kwh)	

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
