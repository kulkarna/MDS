/*******************************************************************************
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
	@RowStart		int,
	@RowEnd			int,
	@SortBy			varchar(100),
	@SortDirection	varchar(100),
	@RowCount		int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	@RowCount = COUNT(ProductConfigurationID)
    FROM	LibertyPower.dbo.ProductConfiguration WITH (NOLOCK);
	
	IF @SortDirection = 'DESC'
		BEGIN
			WITH Configs AS
			(
				SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, MarketID, 
						CASE WHEN UtilityID = 32 THEN 5 ELSE UtilityID END AS UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, RelativeStartMonth, ProductBrandID,
						ROW_NUMBER() OVER (ORDER BY case when @SortBy = 'Name' THEN Name ELSE DateCreated END DESC) AS RowNumber
				FROM	LibertyPower.dbo.ProductConfiguration WITH(NOLOCK)
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
						CASE WHEN UtilityID = 32 THEN 5 ELSE UtilityID END AS UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, RelativeStartMonth, ProductBrandID,
						ROW_NUMBER() OVER (ORDER BY case when @SortBy = 'Name' THEN Name ELSE DateCreated END ASC) AS RowNumber
				FROM	LibertyPower.dbo.ProductConfiguration WITH(NOLOCK)
			) 
				SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
						MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
						RelativeStartMonth, ProductBrandID
			FROM Configs  WITH(NOLOCK)
			WHERE RowNumber BETWEEN @RowStart AND @RowEnd		
		END
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
