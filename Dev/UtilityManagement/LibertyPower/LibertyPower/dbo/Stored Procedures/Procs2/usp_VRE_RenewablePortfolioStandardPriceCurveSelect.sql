

CREATE PROCEDURE [dbo].[usp_VRE_RenewablePortfolioStandardPriceCurveSelect]	
	@BeginDate	DATETIME,
	@EndDate	DATETIME,
	@FilterOldRecords BIT = NULL,
	@ContextDate	DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @startYearMonth INT;
    DECLARE @endYearMonth INT;  
        
    select @startYearMonth = Year(@BeginDate) * 360 + Month(@BeginDate);
    select @endYearMonth   = Year(@EndDate) * 360 + Month(@EndDate);
	
	IF @FilterOldRecords IS NULL OR @FilterOldRecords = 0
	BEGIN
		
	    SELECT	ID, Market, [Month], [Year], Price, CreatedBy, FileContextGuid, DateCreated
		FROM	VRERenewablePortfolioStandardPriceCurve C WITH (NOLOCK)
		WHERE	( ([Year] * 360 + [Month]) >= @startYearMonth ) 
		AND     ( ([Year] * 360 + [Month]) <  @endYearMonth ) 
		AND		(@ContextDate IS NULL OR C.DateCreated < @ContextDate)
		;
		    
    END
	ELSE
	BEGIN
	
		SELECT	ID, Market, [Month], [Year], Price, CreatedBy, FileContextGuid, DateCreated
		FROM	VRERenewablePortfolioStandardPriceCurve C WITH (NOLOCK)
		WHERE  C.ID IN
			(SELECT MAX(REN.ID)
			 FROM VRERenewablePortfolioStandardPriceCurve REN WITH (NOLOCK)		
			 WHERE	( (REN.[Year] * 360 + REN.[Month]) >= @startYearMonth ) 
			 AND    ( (REN.[Year] * 360 + REN.[Month]) <  @endYearMonth )  
			 AND	(@ContextDate IS NULL OR REN.DateCreated < @ContextDate)
			 GROUP BY REN.Market, REN.[Year], REN.[Month] )	
		;
	END
    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_RenewablePortfolioStandardPriceCurveSelect';

