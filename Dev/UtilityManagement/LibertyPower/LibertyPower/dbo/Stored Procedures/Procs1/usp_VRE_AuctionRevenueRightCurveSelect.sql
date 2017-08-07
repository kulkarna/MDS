
CREATE PROCEDURE [dbo].[usp_VRE_AuctionRevenueRightCurveSelect]	
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
		SELECT	ID, c.ZoneId, Price, [Month], c.[Year], c.CreatedBy,
				c.FileContextGuid, c.DateCreated
		FROM	VREAuctionRevenueRightPriceCurve c WITH (NOLOCK)			
		WHERE	( ([Year] * 360 + [Month]) >= @startYearMonth ) 
		AND     ( ([Year] * 360 + [Month]) <  @endYearMonth ) 
		AND		(@ContextDate IS NULL OR c.DateCreated < @ContextDate)
		;
		
    END
	ELSE
	BEGIN
	
		SELECT	ID, c.ZoneId, Price, [Month], c.[Year], c.CreatedBy,
				c.FileContextGuid, c.DateCreated
		FROM	VREAuctionRevenueRightPriceCurve c WITH (NOLOCK)			
		WHERE  c.ID IN
			(SELECT MAX(AU.ID)
			 FROM VREAuctionRevenueRightPriceCurve AU WITH (NOLOCK)			
			 WHERE	( (AU.[Year] * 360 + AU.[Month]) >= @startYearMonth ) 
			 AND    ( (AU.[Year] * 360 + AU.[Month]) <  @endYearMonth )  
			 AND	(@ContextDate IS NULL OR AU.DateCreated < @ContextDate)
			 GROUP BY AU.ZoneID, AU.[Year], AU.[Month] );
	END
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_AuctionRevenueRightCurveSelect';

