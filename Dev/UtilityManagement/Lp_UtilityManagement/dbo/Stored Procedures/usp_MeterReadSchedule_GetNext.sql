
CREATE PROC usp_MeterReadSchedule_GetNext
	@UtilityIdInt INT,
	@TripNumber NVARCHAR(255),
	@ReferenceDate DATETIME,
	@ServiceAccountNumber NVARCHAR(255)
AS
BEGIN

	SELECT
		MRS.Id,
		MRS.ReadDate,
		UC.UtilityIdInt,
		Y.Year,
		M.Month,
		UT.TripNumber
	FROM
		dbo.[MeterReadSchedule] (NOLOCK) MRS
		INNER JOIN dbo.[UtilityCompany] (NOLOCK) UC
			ON MRS.UtilityCompanyId = UC.Id
		INNER JOIN dbo.[Year] (NOLOCK) Y
			ON MRS.YearId = Y.Id
		INNER JOIN dbo.[Month] (NOLOCK) M
			ON MRS.MonthId = M.Id
		INNER JOIN dbo.[UtilityTrip] (NOLOCK) UT
			ON MRS.UtilityTripId = UT.Id
	WHERE
		UC.UtilityIdInt = @UtilityIdInt
		AND UT.TripNumber = @TripNumber
		AND ReadDate = 
			(SELECT 
				MIN(ReadDate) 
			FROM 
				dbo.MeterReadSchedule (NOLOCK) M
				INNER JOIN dbo.UtilityCompany (NOLOCK) U
					ON M.UtilityCompanyId = U.Id
				INNER JOIN dbo.[UtilityTrip] (NOLOCK) T
					ON M.UtilityTripId = T.Id
			WHERE
				U.UtilityIdInt = @UtilityIdInt
				AND CONVERT(DATETIME, M.ReadDate, 101)  > @ReferenceDate
				AND T.TripNumber = @TripNumber)

END
GO

