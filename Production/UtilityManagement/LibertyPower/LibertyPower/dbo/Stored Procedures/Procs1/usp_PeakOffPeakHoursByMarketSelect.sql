/*******************************************************************************
 * usp_PeakOffPeakHoursByMarketSelect
 * Return peak and off peak hours for a given market and date range
 *
 * History
 *******************************************************************************
 * 4/23/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PeakOffPeakHoursByMarketSelect]   
	@MarketCode		varchar(2),                                                                                 
	@BeginDate		datetime,
	@EndDate		datetime
AS
BEGIN
    SET NOCOUNT ON;

	IF EXISTS (SELECT NULL FROM PeakOffPeakHours WHERE Market = @MarketCode)
		BEGIN
			SELECT		[Month], [Year], PeakHours, OffPeakHours
			FROM		PeakOffPeakHours WITH (NOLOCK)
			WHERE		CAST(CAST([Month] AS varchar(2)) + '/1/' + CAST([Year] AS varchar(4)) AS datetime) BETWEEN @BeginDate AND @EndDate
			AND			Market = @MarketCode
			ORDER BY	[Year], [Month]
		END
	ELSE
		BEGIN
			SELECT		[Month], [Year], PeakHours, OffPeakHours
			FROM		PeakOffPeakHours WITH (NOLOCK)
			WHERE		CAST(CAST([Month] AS varchar(2)) + '/1/' + CAST([Year] AS varchar(4)) AS datetime) BETWEEN @BeginDate AND @EndDate
			AND			Market = 'ELSE'
			ORDER BY	[Year], [Month]
		END

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2010 Liberty Power
