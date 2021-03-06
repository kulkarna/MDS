USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductOffersSelect]    Script Date: 07/19/2013 16:00:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductOffersSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductOffersSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductOffersSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductOffersSelect
 * Gets product offers
 *
 * History
 *******************************************************************************
 * 6/8/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * Modified 5/2/2013 - Rick Deigsler
 * Pull only subsets
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductOffersSelect]
	@RowStart		int				= 1,
	@RowEnd			int				= 50,
	@SortBy			varchar(100)	= '''',
	@SortDirection	varchar(100)	= ''DESC'',
	@MarketID		int				= -1,
	@UtilityID		int				= -1,
	@ZoneID			int				= -1,
	@ServiceClassID	int				= -1,
	@ChannelTypeID	int				= -1,
	@ProductTypeID	int				= -1,
	@ProductName	varchar(200)	= '''',
	@SegmentID		int				= -1,
	@IsActive		int				= -1,
	@RowCount		int				= 50 OUTPUT	
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	o.OfferActivationID, p.ProductConfigurationID, p.SegmentID, p.ChannelTypeID, 
			p.ProductTypeID, p.ProductName, p.MarketID, p.UtilityID, p.ZoneID, 
			p.ServiceClassID, o.Term, o.IsActive, o.LowerTerm, o.UpperTerm, p.IsTermRange, 
			p.CreatedBy, p.DateCreated, p.RelativeStartMonth, p.ProductBrandID
	INTO	#temp
	FROM	LibertyPower..ProductConfiguration p WITH (NOLOCK)
			INNER JOIN LibertyPower..OfferActivation o WITH (NOLOCK) 
			ON p.ProductConfigurationID = o.ProductConfigurationID	
	WHERE	p.MarketID = CASE WHEN @MarketID = -1 THEN p.MarketID ELSE @MarketID END
	AND		p.UtilityID = CASE WHEN @UtilityID = -1 THEN p.UtilityID ELSE @UtilityID END
	AND		p.ZoneID = CASE WHEN @ZoneID = -1 THEN p.ZoneID ELSE @ZoneID END
	AND		p.ServiceClassID = CASE WHEN @ServiceClassID = -1 THEN p.ServiceClassID ELSE @ServiceClassID END
	AND		p.ChannelTypeID = CASE WHEN @ChannelTypeID = -1 THEN p.ChannelTypeID ELSE @ChannelTypeID END
	AND		p.ProductTypeID = CASE WHEN @ProductTypeID = -1 THEN p.ProductTypeID ELSE @ProductTypeID END
	AND		ProductName = CASE WHEN @ProductName = '''' THEN ProductName ELSE @ProductName END
	AND		p.SegmentID = CASE WHEN @SegmentID = -1 THEN p.SegmentID ELSE @SegmentID END
	AND		o.IsActive = CASE WHEN @IsActive = -1 THEN o.IsActive ELSE @IsActive END 
	
	SELECT	@RowCount = COUNT(OfferActivationID) FROM #temp
	
	-- Had to use multiple flow control blocks due to single CASE statements require that all branches have compatible data types. 
	-- Since character string in one CASE can''t be converted to an integer returned from another CASE, this will result in a conversion error.
		
	-- (table 0)
	IF @SortDirection = ''DESC''
		BEGIN
			IF @SortBy = ''Product''
				BEGIN
					WITH Configs AS
					(
						SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
								ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
								ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
								CreatedBy, DateCreated, RelativeStartMonth, productBrandID, 
								ROW_NUMBER() OVER (	ORDER BY ProductName DESC) AS RowNumber
						FROM	#temp
					) 							
					SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
							ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
							ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
							CreatedBy, DateCreated, RelativeStartMonth, ProductBrandID
					FROM Configs  WITH(NOLOCK)
					WHERE RowNumber BETWEEN @RowStart AND @RowEnd				
				END
			ELSE
				BEGIN
					WITH Configs AS
					(
						SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
								ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
								ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
								CreatedBy, DateCreated, RelativeStartMonth, productBrandID, 
								ROW_NUMBER() OVER (	ORDER BY 
													CASE	WHEN @SortBy = ''Market'' THEN MarketID 
															WHEN @SortBy = ''Utility'' THEN UtilityID 
															WHEN @SortBy = ''Zone'' THEN ZoneID 
															WHEN @SortBy = ''ServiceClass'' THEN ServiceClassID 
															WHEN @SortBy = ''ChannelType'' THEN ChannelTypeID 
															WHEN @SortBy = ''ProductType'' THEN ProductTypeID 
															WHEN @SortBy = ''Segment'' THEN SegmentID 
															WHEN @SortBy = ''Term'' THEN Term
															WHEN @SortBy = ''IsActive'' THEN IsActive 
															ELSE OfferActivationID 
													END DESC) AS RowNumber
						FROM	#temp
					) 							
					SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
							ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
							ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
							CreatedBy, DateCreated, RelativeStartMonth, ProductBrandID
					FROM Configs  WITH(NOLOCK)
					WHERE RowNumber BETWEEN @RowStart AND @RowEnd				
				END
		END
	ELSE
		BEGIN
			IF @SortBy = ''Product''
				BEGIN
					WITH Configs AS
					(
						SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
								ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
								ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
								CreatedBy, DateCreated, RelativeStartMonth, productBrandID, 
								ROW_NUMBER() OVER (	ORDER BY ProductName ASC) AS RowNumber
						FROM	#temp								
					) 								
					SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
							ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
							ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
							CreatedBy, DateCreated, RelativeStartMonth, ProductBrandID
					FROM Configs  WITH(NOLOCK)
					WHERE RowNumber BETWEEN @RowStart AND @RowEnd					
				END
			ELSE
				BEGIN
					WITH Configs AS
					(
						SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
								ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
								ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
								CreatedBy, DateCreated, RelativeStartMonth, productBrandID, 
								ROW_NUMBER() OVER (	ORDER BY 
													CASE	WHEN @SortBy = ''Market'' THEN MarketID 
															WHEN @SortBy = ''Utility'' THEN UtilityID 
															WHEN @SortBy = ''Zone'' THEN ZoneID 
															WHEN @SortBy = ''ServiceClass'' THEN ServiceClassID 
															WHEN @SortBy = ''ChannelType'' THEN ChannelTypeID 
															WHEN @SortBy = ''ProductType'' THEN ProductTypeID 
															WHEN @SortBy = ''Segment'' THEN SegmentID 
															WHEN @SortBy = ''Term'' THEN Term
															WHEN @SortBy = ''IsActive'' THEN IsActive 
															ELSE OfferActivationID 
													END ASC) AS RowNumber
						FROM	#temp								
					) 								
					SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
							ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
							ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
							CreatedBy, DateCreated, RelativeStartMonth, ProductBrandID
					FROM Configs  WITH(NOLOCK)
					WHERE RowNumber BETWEEN @RowStart AND @RowEnd					
				END
		END
		
	--************************************************************************
	-- the following tables are used for filters in offer activation tool
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
	
	-- products (table 4)
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
	
	-- terms (table 9)
	SELECT	DISTINCT Term, LowerTerm, UpperTerm, IsTermRange
	FROM	#temp
	ORDER BY Term, LowerTerm, UpperTerm
	
	-- terms (table 10)
	SELECT	DISTINCT IsActive
	FROM	#temp
	ORDER BY IsActive	
		
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
