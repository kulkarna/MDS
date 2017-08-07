
/*******************************************************************************
 * usp_DailyProfileSelect
 * Select daily profiles for specified parameters
 *
 * History
 *******************************************************************************
 * 1/20/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyProfileSelect]                                                                                    
	@UtilityCode	varchar(50),
	@LoadShapeId	varchar(100),
	@Zone			varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@Version	int

	SET	@BeginDate = CAST(DATEPART(mm, @BeginDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @BeginDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @BeginDate) AS varchar(4))
	SET	@EndDate = CAST(DATEPART(mm, @EndDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, @EndDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, @EndDate) AS varchar(4))


	SELECT	@Version	= MAX(Version)
	FROM	DailyProfileHeader WITH (NOLOCK)
	WHERE	UtilityCode	= @UtilityCode
	AND		LoadShapeID	= @LoadShapeID
	AND		((Zone = @Zone) OR (Zone = 'ALL'))

	SELECT		h.DailyProfileId, ISO, UtilityCode, LoadShapeID, Zone, [FileName], DateCreated, CreatedBy, Version, 
				DateProfile, PeakValue, OffPeakValue, DailyValue, PeakRatio
	FROM		DailyProfileHeader h WITH (NOLOCK) INNER JOIN DailyProfileDetail d WITH (NOLOCK) 
				ON h.DailyProfileId = d.DailyProfileId
	WHERE		UtilityCode = @UtilityCode
	AND			LoadShapeID = @LoadShapeId
	AND			((Zone = @Zone) OR (Zone = 'ALL'))
	AND			Version		= @Version
	AND			DateProfile BETWEEN @BeginDate AND @EndDate
	ORDER BY	DateProfile

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
