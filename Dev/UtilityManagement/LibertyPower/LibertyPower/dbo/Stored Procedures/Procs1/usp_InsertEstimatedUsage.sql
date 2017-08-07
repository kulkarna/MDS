
/*******************************************************************************
 * usp_InsertEstimatedUsage
 * Inserts usage into the estimated usage table
 *
 * History
 *******************************************************************************
 * 03/02/2011 - Eduardo Patino
 * Created.
 *
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_InsertEstimatedUsage]
	@AccountNumber			varchar(50),
	@UtilityCode			varchar(50),
	@MeterNumber			varchar(50)		= NULL,
	@FromDate				datetime,
	@ToDate					datetime,
	@TotalKwh				int,
	@DaysUsed				int				= NULL,
	@UserName				varchar(50),
	@UsageType				int = 6 -- 6 is Estimated; sometimes this will be 8 = Calendarized
AS
/*
select * from reasoncode
select top 20 * from EstimatedUsage (nolock)
*/
BEGIN
	SET NOCOUNT ON;

	-- eliminate time component
	SET	@FromDate = CAST(DATEPART(mm, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @FromDate) AS varchar(4))
	SET	@ToDate = CAST(DATEPART(mm, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @ToDate) AS varchar(4))

IF NOT EXISTS (
	SELECT	UtilityCode
	FROM	EstimatedUsage WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
		AND	UtilityCode		= @UtilityCode
		AND	FromDate		= @FromDate
		AND	ToDate			= @ToDate
		AND	TotalKwh		= @TotalKwh
		AND	MeterNumber		= @MeterNumber )

	BEGIN
		INSERT INTO	EstimatedUsage
					(AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, MeterNumber, UsageType, CreatedBy)
		VALUES		(@AccountNumber, @UtilityCode, @FromDate, @ToDate, @TotalKwh, @DaysUsed, @MeterNumber, @UsageType, @UserName)
	END

	SELECT	ID, AccountNumber, UtilityCode, FromDate, ToDate, TotalKwh, DaysUsed, Created, CreatedBy, MeterNumber, UsageType
	FROM	EstimatedUsage WITH (NOLOCK)
	WHERE	AccountNumber	= @AccountNumber
		AND	UtilityCode		= @UtilityCode
		AND	FromDate		= @FromDate
		AND	ToDate			= @ToDate
		AND	TotalKwh		= @TotalKwh
		AND	MeterNumber		= @MeterNumber
	ORDER BY 4 DESC

	SET NOCOUNT OFF;
END

-- Copyright 2011 Liberty Power

