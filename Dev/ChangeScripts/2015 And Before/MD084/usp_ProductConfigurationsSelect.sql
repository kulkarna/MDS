USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductConfigurationsSelect]    Script Date: 09/27/2012 09:14:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductConfigurationsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductConfigurationsSelect]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductConfigurationsSelect]    Script Date: 09/27/2012 09:14:38 ******/
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
	@RowStart		int,
	@RowEnd			int,
	@SortBy			varchar(100),
	@SortDirection	varchar(100),
	@RowCount		int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	@RowCount = COUNT(ProductConfigurationID)
    FROM	ProductConfiguration WITH (NOLOCK);
	
	IF @SortDirection = ''DESC''
		BEGIN
			WITH Configs AS
			(
				SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, MarketID, 
						CASE WHEN UtilityID = 32 THEN 5 ELSE UtilityID END AS UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, RelativeStartMonth, ProductBrandID,
						ROW_NUMBER() OVER (ORDER BY case when @SortBy = ''Name'' THEN Name ELSE DateCreated END DESC) AS RowNumber
				FROM	ProductConfiguration
			) 
				SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
						MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
						RelativeStartMonth, ProductBrandID
			FROM Configs 
			WHERE RowNumber BETWEEN @RowStart AND @RowEnd
		END
	ELSE
		BEGIN
			WITH Configs AS
			(
				SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, MarketID, 
						CASE WHEN UtilityID = 32 THEN 5 ELSE UtilityID END AS UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, RelativeStartMonth, ProductBrandID,
						ROW_NUMBER() OVER (ORDER BY case when @SortBy = ''Name'' THEN Name ELSE DateCreated END ASC) AS RowNumber
				FROM	ProductConfiguration
			) 
				SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
						MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
						RelativeStartMonth, ProductBrandID
			FROM Configs 
			WHERE RowNumber BETWEEN @RowStart AND @RowEnd		
		END
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
