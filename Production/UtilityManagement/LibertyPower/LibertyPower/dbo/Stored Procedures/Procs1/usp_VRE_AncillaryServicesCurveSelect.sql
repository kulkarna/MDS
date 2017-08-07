
CREATE PROCEDURE [dbo].[usp_VRE_AncillaryServicesCurveSelect]	
	@BeginDate		DATETIME = NULL,
	@EndDate		DATETIME = NULL,
	@FileContextGuid UNIQUEIDENTIFIER = NULL,
	@ZoneID		VARCHAR(50) = NULL,
	@FilterOldRecords BIT = NULL,
	@ContextDate	DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startYearMonth INT;
    DECLARE @endYearMonth INT;
    
	IF @BeginDate IS NULL
	SET @BeginDate = CAST('2000-01-01' AS DATETIME);
	
	IF @EndDate IS NULL
		SET @EndDate =  DATEADD(YEAR,10,GETDATE());
		
	SET @BeginDate = CAST(CAST(YEAR(@BeginDate)AS VARCHAR) +'-'+ CAST(MONTH(@BeginDate)AS VARCHAR) + '-01 00:00:00' AS DATETIME );
	
    SET @startYearMonth = Year(@BeginDate) * 360 + Month(@BeginDate);
    SET @endYearMonth   = Year(@EndDate) * 360 + Month(@EndDate);
    
    
	IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		SELECT	C.ID, C.ZoneID, C.[Month], C.[Year], C.Ancillary, 
				C.OtherAncillary, C.CreatedBy, C.FileContextGuid, C.DateCreated
		FROM	VREAncillaryServicesCurve C WITH (NOLOCK) 
		WHERE	C.FileContextGuid = ISNULL(@FileContextGuid,C.FileContextGuid)
		AND		C.ZoneID = ISNULL(@ZoneID, C.ZoneID)
		AND		( ([Year] * 360 + [Month]) >= @startYearMonth ) 
		AND     ( ([Year] * 360 + [Month]) <  @endYearMonth ) 
		AND		(@ContextDate IS NULL OR C.DateCreated < @ContextDate)
		;	    
    END
	ELSE
	BEGIN
		SELECT	C.ID, C.ZoneID, C.[Month], C.[Year], C.Ancillary, 
				C.OtherAncillary, C.CreatedBy, C.FileContextGuid, C.DateCreated
		FROM	VREAncillaryServicesCurve C WITH (NOLOCK) 
		WHERE   C.ID IN
			(SELECT MAX(ANC.ID)
			 FROM VREAncillaryServicesCurve ANC WITH (NOLOCK)			
			 WHERE	( (ANC.[Year] * 360 + ANC.[Month]) >= @startYearMonth ) 
			 AND    ( (ANC.[Year] * 360 + ANC.[Month]) <  @endYearMonth ) 
			 AND	C.FileContextGuid = ISNULL(@FileContextGuid,C.FileContextGuid)
			 AND	C.ZoneID = ISNULL(@ZoneID,C.ZoneID)
			 AND	(@ContextDate IS NULL OR C.DateCreated < @ContextDate)
			 GROUP BY ANC.ZoneID, ANC.[Year], ANC.[Month] )
		;
	END
    
    	
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_AncillaryServicesCurveSelect';

