/*******************************************************************************
 * usp_ProductConfigurationInsert
 * Inserts/updates product configuration
 *
 * History
 *******************************************************************************
 * 6/4/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationInsert]
	@ProductConfigurationID	int,
	@Name					varchar(200),
	@SegmentID				int, 
	@ChannelTypeID			int, 
	@ProductTypeID			int, 
	@MarketID				int, 
	@UtilityID				int, 
	@ZoneID					int, 
	@ServiceClassID			int,
	@CreatedBy				int,
	@DateCreated			datetime,
	@IsTermRange			tinyint,
	@ProductName			varchar(200),
	@RelativeStartMonth		int,
	@ProductBrandID			int		
AS
BEGIN
    SET NOCOUNT ON;   
    
    IF @ProductConfigurationID = 0
		BEGIN
			INSERT INTO	ProductConfiguration (Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
						MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
						RelativeStartMonth, ProductBrandID)
			VALUES		(@Name, @SegmentID, @ChannelTypeID, @ProductTypeID, @ProductName, @MarketID, 
						@UtilityID, @ZoneID, @ServiceClassID, @CreatedBy, @DateCreated, @IsTermRange, 
						@RelativeStartMonth, @ProductBrandID)
			
			SET		@ProductConfigurationID = @@IDENTITY	
		END
	ELSE
		BEGIN
			UPDATE	ProductConfiguration 
			SET		Name					= @Name, 
					SegmentID				= @SegmentID, 
					ChannelTypeID			= @ChannelTypeID, 
					ProductTypeID			= @ProductTypeID, 
					ProductName				= @ProductName, 
					MarketID				= @MarketID, 
					UtilityID				= @UtilityID, 
					ZoneID					= @ZoneID, 
					ServiceClassID			= @ServiceClassID, 
					IsTermRange				= @IsTermRange, 
					RelativeStartMonth		= @RelativeStartMonth, 
					ProductBrandID			= @ProductBrandID,
					ModifiedBy				= @CreatedBy, 
					DateModified			= @DateCreated					
			WHERE	ProductConfigurationID = @ProductConfigurationID	
		END
		
	SELECT	ProductConfigurationID, Name, SegmentID, ChannelTypeID, ProductTypeID, ProductName, 
			MarketID, UtilityID, ZoneID, ServiceClassID, CreatedBy, DateCreated, IsTermRange, 
			RelativeStartMonth, ProductBrandID
	FROM	ProductConfiguration WITH (NOLOCK)
	WHERE	ProductConfigurationID = @ProductConfigurationID		
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
