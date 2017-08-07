/*******************************************************************************
 * usp_GetPeakOffPeakHours
 * Return peak and off peak hours for a given date range
 *
 * History
 *******************************************************************************
 * 1/12/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GetPeakOffPeakHours]                                                                                    
	@BeginDate		datetime,
	@EndDate		datetime
AS
BEGIN
    SET NOCOUNT ON;

	SELECT		[Month], [Year], PeakHours, OffPeakHours
	FROM		PeakOffPeakHours WITH (NOLOCK)
	WHERE		CAST(CAST([Month] AS varchar(2)) + '/1/' + CAST([Year] AS varchar(4)) AS datetime) BETWEEN @BeginDate AND @EndDate
	ORDER BY	[Year], [Month]

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
