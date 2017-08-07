
CREATE PROCEDURE [dbo].[usp_VRE_LossFactorDataCurveSelect]	
	@BeginDate  	DATETIME,
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
		SELECT	a.ID, a.LossFactorId, a.[Month], a.[Year], a.LossFactor, 
		a.CreatedBy, a.DateCreated, a.FileContextGuid
		FROM	VRELossFactorItemDataCurve a WITH (NOLOCK)	 		
		WHERE	( ([Year] * 360 + [Month]) >= @startYearMonth ) 
		AND     ( ([Year] * 360 + [Month]) <  @endYearMonth )  
		AND		(@ContextDate IS NULL OR a.DateCreated < @ContextDate)
		;
	END
	ELSE
	BEGIN
	
		SELECT	PEC.ID, PEC.LossFactorId, PEC.[Month], PEC.[Year], 
		PEC.LossFactor, PEC.CreatedBy, PEC.FileContextGuid
		FROM VRELossFactorItemDataCurve PEC
		WHERE PEC.ID IN
			(SELECT MAX(C.ID)
			 FROM VRELossFactorItemDataCurve C WITH (NOLOCK)			
			 WHERE	( ([Year] * 360 + [Month]) >= @startYearMonth ) 
			 AND     ( ([Year] * 360 + [Month]) <  @endYearMonth )  
			 AND		(@ContextDate IS NULL OR C.DateCreated < @ContextDate)
			 GROUP BY C.LossFactorId, C.[Year], C.[Month] )
		;
	END
    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_LossFactorDataCurveSelect';

