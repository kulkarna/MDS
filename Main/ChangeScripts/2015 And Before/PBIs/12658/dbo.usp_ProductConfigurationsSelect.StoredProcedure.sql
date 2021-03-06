USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductConfigurationsSelect]    Script Date: 07/19/2013 16:00:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductConfigurationsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductConfigurationsSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductConfigurationsSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductConfigurationsSelect
 * Gets product configurations
 *
 * History
 *******************************************************************************
 * 6/4/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationsSelect]
	@RowStart			int				= 1,
	@RowEnd				int				= 50,
	@SortBy				varchar(100)	= '''',
	@SortDirection		varchar(100)	= ''DESC'',
	@ConfigName			varchar(200)	= '''',
	@MarketID			int				= -1,
	@UtilityID			int				= -1,
	@ZoneID				int				= -1,
	@ServiceClassID		int				= -1,
	@ChannelTypeID		int				= -1,
	@ProductTypeID		int				= -1,
	@ProductName		varchar(200)	= '''',
	@SegmentID			int				= -1,
	@IsTermRange		int				= -1,
	@RelativeStartMonth	int				= -1,
	@DateCreated		varchar(100)	= ''17530101'',
	@RowCount			int				= 50 OUTPUT	
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, MarketID, 
			UtilityID, ZoneID, ServiceClassID, IsTermRange, CreatedBy, DateCreated, RelativeStartMonth, ProductBrandID
	INTO	#temp
	FROM	LibertyPower..ProductConfiguration WITH (NOLOCK)
	WHERE	Name = CASE WHEN @ConfigName = '''' THEN Name ELSE @ConfigName END
	AND		MarketID = CASE WHEN @MarketID = -1 THEN MarketID ELSE @MarketID END
	AND		UtilityID = CASE WHEN @UtilityID = -1 THEN UtilityID ELSE @UtilityID END
	AND		ZoneID = CASE WHEN @ZoneID = -1 THEN ZoneID ELSE @ZoneID END
	AND		ServiceClassID = CASE WHEN @ServiceClassID = -1 THEN ServiceClassID ELSE @ServiceClassID END
	AND		ChannelTypeID = CASE WHEN @ChannelTypeID = -1 THEN ChannelTypeID ELSE @ChannelTypeID END
	AND		ProductTypeID = CASE WHEN @ProductTypeID = -1 THEN ProductTypeID ELSE @ProductTypeID END
	AND		ProductName = CASE WHEN @ProductName = '''' THEN ProductName ELSE @ProductName END
	AND		SegmentID = CASE WHEN @SegmentID = -1 THEN SegmentID ELSE @SegmentID END
	AND		IsTermRange = CASE WHEN @IsTermRange = -1 THEN IsTermRange ELSE @IsTermRange END
	AND		RelativeStartMonth = CASE WHEN @RelativeStartMonth = -1 THEN RelativeStartMonth ELSE @RelativeStartMonth END
	AND		DATEADD(dd, 0, DATEDIFF(dd, 0, DateCreated)) = CASE WHEN CAST(@DateCreated AS datetime) = CAST(''17530101'' AS datetime) THEN DATEADD(dd, 0, DATEDIFF(dd, 0, DateCreated)) ELSE CAST(@DateCreated AS datetime) END
	
	SELECT	@RowCount = COUNT(ProductConfigurationID) FROM #temp   
	
	-- Had to use multiple flow control blocks due to single CASE statements require that all branches have compatible data types. 
	-- Since character string in one CASE can''t be converted to the date time returned from another CASE, this will result in a conversion error.

	-- (table 0)
	IF @SortDirection = ''DESC''
		BEGIN
			IF @SortBy IN (''ConfigName'', ''ProductName'')
				BEGIN
					WITH Configs AS
					(
						SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, MarketID, 
								CASE WHEN UtilityID = 32 THEN 5 ELSE UtilityID END AS UtilityID, ZoneID, ServiceClassID, CreatedBy, 
								DateCreated, IsTermRange, RelativeStartMonth, ProductBrandID,
								ROW_NUMBER() OVER (ORDER BY 
													CASE	WHEN @SortBy = ''ConfigName'' THEN Name 
															ELSE ProductName 
													END DESC) AS RowNumber
						FROM	#temp
					) 
						SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
								MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
								RelativeStartMonth, ProductBrandID
					FROM Configs  WITH(NOLOCK)
					WHERE RowNumber BETWEEN @RowStart AND @RowEnd				
				END
			ELSE
				BEGIN
					WITH Configs AS
					(
						SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, MarketID, 
								CASE WHEN UtilityID = 32 THEN 5 ELSE UtilityID END AS UtilityID, ZoneID, ServiceClassID, CreatedBy, 
								DateCreated, IsTermRange, RelativeStartMonth, ProductBrandID,
								ROW_NUMBER() OVER (ORDER BY 
													CASE	WHEN @SortBy = ''Market'' THEN MarketID 
															WHEN @SortBy = ''Utility'' THEN UtilityID 
															WHEN @SortBy = ''Zone'' THEN ZoneID 
															WHEN @SortBy = ''ServiceClass'' THEN ServiceClassID 
															WHEN @SortBy = ''ChannelType'' THEN ChannelTypeID 
															WHEN @SortBy = ''ProductType'' THEN ProductTypeID 
															WHEN @SortBy = ''ProductName'' THEN ProductName 
															WHEN @SortBy = ''Segment'' THEN SegmentID 
															WHEN @SortBy = ''TermRange'' THEN IsTermRange 
															WHEN @SortBy = ''RelativeStartMonth'' THEN RelativeStartMonth 
															ELSE DateCreated 
													END DESC) AS RowNumber
						FROM	#temp
					) 
						SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
								MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
								RelativeStartMonth, ProductBrandID
					FROM Configs  WITH(NOLOCK)
					WHERE RowNumber BETWEEN @RowStart AND @RowEnd				
				END
		END
	ELSE
		BEGIN
			IF @SortBy IN (''ConfigName'', ''ProductName'')
				BEGIN
					WITH Configs AS
					(
						SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, MarketID, 
								CASE WHEN UtilityID = 32 THEN 5 ELSE UtilityID END AS UtilityID, ZoneID, ServiceClassID, CreatedBy, 
								DateCreated, IsTermRange, RelativeStartMonth, ProductBrandID,
								ROW_NUMBER() OVER (ORDER BY 
													CASE	WHEN @SortBy = ''ConfigName'' THEN Name 
															ELSE ProductName 
													END ASC) AS RowNumber
						FROM	#temp
					) 
						SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
								MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
								RelativeStartMonth, ProductBrandID
					FROM Configs  WITH(NOLOCK)
					WHERE RowNumber BETWEEN @RowStart AND @RowEnd				
				END
			ELSE
				BEGIN
					WITH Configs AS
					(
						SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, MarketID, 
								CASE WHEN UtilityID = 32 THEN 5 ELSE UtilityID END AS UtilityID, ZoneID, ServiceClassID, CreatedBy, 
								DateCreated, IsTermRange, RelativeStartMonth, ProductBrandID,
								ROW_NUMBER() OVER (ORDER BY 
													CASE	WHEN @SortBy = ''Market'' THEN MarketID 
															WHEN @SortBy = ''Utility'' THEN UtilityID 
															WHEN @SortBy = ''Zone'' THEN ZoneID 
															WHEN @SortBy = ''ServiceClass'' THEN ServiceClassID 
															WHEN @SortBy = ''ChannelType'' THEN ChannelTypeID 
															WHEN @SortBy = ''ProductType'' THEN ProductTypeID 
															WHEN @SortBy = ''ProductName'' THEN ProductName 
															WHEN @SortBy = ''Segment'' THEN SegmentID 
															WHEN @SortBy = ''TermRange'' THEN IsTermRange 
															WHEN @SortBy = ''RelativeStartMonth'' THEN RelativeStartMonth 
															ELSE DateCreated 
													END ASC) AS RowNumber
						FROM	#temp
					) 
						SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
								MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
								RelativeStartMonth, ProductBrandID
					FROM Configs  WITH(NOLOCK)
					WHERE RowNumber BETWEEN @RowStart AND @RowEnd				
				END	
		END
	
	--************************************************************************
	-- the following tables are used for filters in product configuration tool
	--************************************************************************
	
	-- segments (table 1)
	SELECT	DISTINCT SegmentID
	FROM	#temp	
	
	-- channel types (table 2)
	SELECT	DISTINCT ChannelTypeID
	FROM	#temp	
	
	-- product types (table 3)
	SELECT	DISTINCT ProductTypeID
	FROM	#temp	
	
	-- product names (table 4)
	SELECT	DISTINCT ProductName
	FROM	#temp	
	ORDER BY ProductName	
	
	-- markets (table 5)
	SELECT	DISTINCT MarketID
	FROM	#temp
	
	-- utilities (table 6)
	SELECT	DISTINCT UtilityID
	FROM	#temp	
	
	-- zones (table 7)
	SELECT	DISTINCT ZoneID
	FROM	#temp			
	
	-- service classes (table 8)
	SELECT	DISTINCT p.ServiceClassID, s.service_rate_class AS ServiceClass, s.utility_id AS UtilityCode
	FROM	#temp p
			INNER JOIN lp_common..service_rate_class s  WITH (NOLOCK) 
			ON p.ServiceClassID = s.service_rate_class_id			
	ORDER BY s.utility_id, s.service_rate_class	
	
	-- relative start months (table 9)
	SELECT	DISTINCT RelativeStartMonth
	FROM	#temp	
	ORDER BY RelativeStartMonth	
	
	-- created dates (table 10)
	SELECT	DISTINCT DATEADD(dd, 0, DATEDIFF(dd, 0, DateCreated)) AS DateCreated
	FROM	#temp	
	ORDER BY DateCreated DESC
	
	-- is term range (table 11)
	SELECT	DISTINCT IsTermRange
	FROM	#temp	
	ORDER BY IsTermRange							
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
