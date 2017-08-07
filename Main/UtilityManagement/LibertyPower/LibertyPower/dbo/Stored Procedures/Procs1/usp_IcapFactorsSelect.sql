
/*******************************************************************************
 * usp_IcapFactorsSelect
 * Get records for utility and load shape id that have Icap dates within the date range
 *
 * History
 *******************************************************************************
 * 2/12/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_IcapFactorsSelect]                                                                                    
	@UtilityCode	varchar(50),
	@LoadShapeId	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, UtilityCode, LoadShapeId, IcapDate, IcapFactor
	FROM	IcapFactors
	WHERE	UtilityCode	= @UtilityCode
	AND		LoadShapeId	= @LoadShapeId
	AND		(IcapDate BETWEEN @BeginDate AND @EndDate)

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
