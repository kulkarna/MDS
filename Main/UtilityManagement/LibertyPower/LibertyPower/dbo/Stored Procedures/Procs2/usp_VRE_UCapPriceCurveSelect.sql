
CREATE PROCEDURE [dbo].[usp_VRE_UCapPriceCurveSelect]	
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
		SELECT	c.ID, c.ZoneId, c.[Month], c.[Year], c.UCapPrice, c.CreatedBy ,
				c.FileContextGuid, c.DateCreated
		FROM	VREUCapPriceCurve c WITH (NOLOCK)			
		WHERE	( ([Year] * 360 + [Month]) >= @startYearMonth ) 
		AND     ( ([Year] * 360 + [Month]) <  @endYearMonth ) 	
		 AND	(@ContextDate IS NULL OR c.DateCreated < @ContextDate)
		;
	END
	ELSE
	BEGIN
		SELECT	c.ID, c.ZoneId, c.[Month], c.[Year], c.UCapPrice, c.CreatedBy ,
				c.FileContextGuid, c.DateCreated
		FROM	VREUCapPriceCurve c WITH (NOLOCK)			
		WHERE c.ID IN
				(SELECT MAX(UC.ID)
				 FROM VREUCapPriceCurve UC WITH (NOLOCK)			
				 WHERE	( (UC.[Year] * 360 + UC.[Month]) >= @startYearMonth ) 
				 AND     ( (UC.[Year] * 360 + UC.[Month]) <  @endYearMonth )  
				  AND	(@ContextDate IS NULL OR UC.DateCreated < @ContextDate)
				 GROUP BY UC.ZoneId, UC.[Year], UC.[Month] )
		;
			
	END
	
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power







GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_UCapPriceCurveSelect';

