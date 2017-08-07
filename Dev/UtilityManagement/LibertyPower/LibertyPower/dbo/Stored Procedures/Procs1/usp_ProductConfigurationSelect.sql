/*******************************************************************************
 * usp_ProductConfigurationSelect
 * Gets product configuration for specified ID
 *
 * History
 *******************************************************************************
 * 6/4/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationSelect]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
			MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
			RelativeStartMonth, ProductBrandID
	FROM	ProductConfiguration WITH (NOLOCK)
	WHERE	ProductConfigurationID = @ProductConfigurationID
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
