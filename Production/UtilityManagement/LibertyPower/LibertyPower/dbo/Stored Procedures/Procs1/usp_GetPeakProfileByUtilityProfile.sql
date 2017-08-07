
/*******************************************************************************
 * usp_GetPeakProfileByUtilityProfile
 * retrieves the peak profile data per date range
 *
 * History
 *******************************************************************************
 * 11/17/2008 - Eduardo Patino
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GetPeakProfileByUtilityProfile]
(
	@UtilityCode	varchar(50),
	@LoadShapeId	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime
)
AS
/*
select t1.DailyProfileID, UtilityCode, LoadShapeId, ProfileDate, DailyValue, PeakRatio, PeakValue, OffPeakValue, t1.Created, t1.CreatedBy
from PeakOffPeakDailyProfile t1 inner join DailyProfile t2 on t1.dailyprofileid = t2.dailyprofileid
where utilitycode = 'bge' and loadshapeid = 'gl' order by 2, 3, 4--and profiledate between '2006-10-30' and '2006-11-08'
exec usp_GetPeakProfileByUtilityProfile 'bge', 'gs', '2006-10-30', '2006-11-08'
*/
BEGIN
	SET NOCOUNT ON;

	SELECT	t1.DailyProfileID, UtilityCode, LoadShapeId, ProfileDate, DailyValue, PeakRatio, PeakValue, OffPeakValue
	FROM	PeakOffPeakDailyProfile t1 inner join DailyProfile t2 on t1.dailyprofileid = t2.dailyprofileid
	WHERE	utilitycode = @UtilityCode
		AND	loadshapeid = @LoadShapeId
		AND profiledate BETWEEN @BeginDate AND @EndDate
	ORDER BY utilitycode, loadshapeid, profiledate

    SET NOCOUNT OFF;
END
-- Copyright 11/17/2008 Liberty Power
