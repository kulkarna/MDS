
CREATE PROCEDURE [dbo].[usp_VRE_TCapFactorCurveSelect]	
	@BeginDate		DATETIME,
	@EndDate		DATETIME,
	@FilterOldRecords BIT = NULL,
	@ContextDate	DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startYearMonth INT;
    DECLARE @endYearMonth INT;  
        
    SELECT @startYearMonth = Year(@BeginDate) * 360 + Month(@BeginDate);
    SELECT @endYearMonth   = Year(@EndDate) * 360 + Month(@EndDate);
    
    IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		SELECT	c.ID, c.ZoneId, c.[Month], c.[Year], c.TCapFactor,c.FileContextGuid ,
				c.DateCreated, c.CreatedBy
		FROM	VRETCapFactorCurve c WITH (NOLOCK)		
		WHERE	( ([Year] * 360 + [Month]) >= @startYearMonth ) 
		AND     ( ([Year] * 360 + [Month]) <  @endYearMonth ) 
		AND		(@ContextDate IS NULL OR c.DateCreated < @ContextDate)
		;
			
	END
	ELSE
	BEGIN
		SELECT	c.ID, c.ZoneId, c.[Month], c.[Year], c.TCapFactor, c.FileContextGuid ,
				c.DateCreated, c.CreatedBy
		FROM	VRETCapFactorCurve c WITH (NOLOCK)	
		WHERE c.ID IN
			(SELECT MAX(TC.ID)
			 FROM VRETCapFactorCurve TC WITH (NOLOCK)			
			 WHERE	( (TC.[Year] * 360 + TC.[Month]) >= @startYearMonth ) 
			 AND    ( (TC.[Year] * 360 + TC.[Month]) <  @endYearMonth )  
			 AND	(@ContextDate IS NULL OR TC.DateCreated < @ContextDate)
			 GROUP BY TC.ZoneId, TC.[Year], TC.[Month] )
		;	
	END
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power






GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_TCapFactorCurveSelect';

