/*******************************************************************************
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
	@SortBy			varchar(100)	= '',
	@SortDirection	varchar(100)	= 'DESC',
	@MarketID		int				= -1,
	@UtilityID		int				= -1,
	@ZoneID			int				= -1,
	@ServiceClassID	int				= -1,
	@ChannelTypeID	int				= -1,
	@ProductTypeID	int				= -1,
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
	AND		p.SegmentID = CASE WHEN @SegmentID = -1 THEN p.SegmentID ELSE @SegmentID END
	AND		o.IsActive = CASE WHEN @IsActive = -1 THEN o.IsActive ELSE @IsActive END 
	
	SELECT	@RowCount = COUNT(ProductConfigurationID) FROM #temp
	
	IF @SortDirection = 'DESC'
		BEGIN
			WITH Configs AS
			(
				SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
						ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
						ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
						CreatedBy, DateCreated, RelativeStartMonth, productBrandID, 
						ROW_NUMBER() OVER (	ORDER BY 
											CASE	WHEN @SortBy = 'Market' THEN MarketID 
													WHEN @SortBy = 'Utility' THEN UtilityID 
													WHEN @SortBy = 'Zone' THEN ZoneID 
													WHEN @SortBy = 'ServiceClass' THEN ServiceClassID 
													WHEN @SortBy = 'ChannelType' THEN ChannelTypeID 
													WHEN @SortBy = 'ProductType' THEN ProductTypeID 
													WHEN @SortBy = 'Segment' THEN SegmentID 
													WHEN @SortBy = 'IsActive' THEN IsActive 
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
	ELSE
		BEGIN
			WITH Configs AS
			(
				SELECT	OfferActivationID, ProductConfigurationID, SegmentID, ChannelTypeID, 
						ProductTypeID, ProductName, MarketID, UtilityID, ZoneID, 
						ServiceClassID, Term, IsActive, LowerTerm, UpperTerm, IsTermRange, 
						CreatedBy, DateCreated, RelativeStartMonth, productBrandID, 
						ROW_NUMBER() OVER (	ORDER BY 
											CASE	WHEN @SortBy = 'Market' THEN MarketID 
													WHEN @SortBy = 'Utility' THEN UtilityID 
													WHEN @SortBy = 'Zone' THEN ZoneID 
													WHEN @SortBy = 'ServiceClass' THEN ServiceClassID 
													WHEN @SortBy = 'ChannelType' THEN ChannelTypeID 
													WHEN @SortBy = 'ProductType' THEN ProductTypeID 
													WHEN @SortBy = 'Segment' THEN SegmentID 
													WHEN @SortBy = 'IsActive' THEN IsActive 
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

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
