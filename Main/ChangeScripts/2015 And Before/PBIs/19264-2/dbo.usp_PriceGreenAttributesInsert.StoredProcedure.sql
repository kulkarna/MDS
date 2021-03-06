USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PriceGreenAttributesInsert]    Script Date: 01/07/2014 07:39:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceGreenAttributesInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PriceGreenAttributesInsert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PriceGreenAttributesInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_PriceGreenAttributesInsert
 * Inserts green attribute data
 *
 * History
 *******************************************************************************
 * 11/20/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceGreenAttributesInsert]

AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE	@ProductConfigurationID	int,
			@SegmentID				int,
			@ChannelTypeID			int,
			@ProductTypeID			int,
			@ProductBrandID			int,
			@MarketID				int,
			@UtilityID				int,
			@ZoneID					int,
			@ServiceClassID			int,
			@ProductCrossPriceSetID	int,
			@Message				varchar(MAX)
			
	SET @Message =  ''Price green attributes process beginning.''
	EXEC usp_DailyPricingLogInsert_New 3, 6, @Message, NULL, 0				

	CREATE TABLE #ConfigTable	(ProductConfigurationID int, SegmentID int, ChannelTypeID int, ProductTypeID int,
								ProductBrandID int, MarketID int, UtilityID int, ZoneID int, ServiceClassID int)
								
	CREATE TABLE #PriceTable	(SegmentID int, ChannelTypeID int, ProductTypeID int,ProductBrandID int, 
								MarketID int, UtilityID int, ZoneID int, ServiceClassID int, ProductCrossPriceID int )								

	BEGIN TRY
		BEGIN TRAN
		
		SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
		FROM	Libertypower..ProductCrossPrice WITH (NOLOCK)		
									
		INSERT		INTO #ConfigTable
		SELECT		p.ProductConfigurationID, SegmentID, ChannelTypeID, ProductTypeID, ProductBrandID, MarketID, UtilityID, ZoneID, ServiceClassID
		FROM		Libertypower..ProductConfiguration p WITH (NOLOCK)
		INNER JOIN	Libertypower..ProductConfigGreenAttributes a WITH (NOLOCK) ON p.ProductConfigurationID = a.ProductConfigurationID
		
		INSERT	INTO #PriceTable
		SELECT	SegmentID, ChannelTypeID, ProductTypeID, ProductBrandID, MarketID, UtilityID, ZoneID, ServiceClassID, ProductCrossPriceID
		FROM	Libertypower..Price WITH (NOLOCK)
		WHERE	ProductCrossPriceSetID	= @ProductCrossPriceSetID	
		AND		ProductTypeID			= 8
		
		CREATE NONCLUSTERED INDEX ndx_PriceGreen
		ON #PriceTable (ChannelTypeID, ProductTypeID, MarketID, UtilityID, SegmentID, ZoneID, ServiceClassID, ProductBrandID)
		INCLUDE (ProductCrossPriceID)		

		WHILE (SELECT COUNT(ProductConfigurationID) FROM #ConfigTable) > 0
			BEGIN
				SELECT	TOP 1 @ProductConfigurationID = ProductConfigurationID, @SegmentID = SegmentID, @ChannelTypeID = ChannelTypeID, 
						@ProductTypeID = ProductTypeID, @ProductBrandID = ProductBrandID, @MarketID = MarketID, @UtilityID = UtilityID, 
						@ZoneID = ZoneID, @ServiceClassID = ServiceClassID
				FROM	#ConfigTable
				
				INSERT	INTO Libertypower..PriceGreenAttributes
				SELECT	DISTINCT ProductCrossPriceID, @ProductConfigurationID
				FROM	#PriceTable WITH (NOLOCK)
				WHERE	SegmentID				= @SegmentID
				AND		ChannelTypeID			= @ChannelTypeID
				AND		ProductTypeID			= @ProductTypeID
				AND		ProductBrandID			= @ProductBrandID
				AND		MarketID				= @MarketID
				AND		UtilityID				= @UtilityID
				AND		ZoneID					= @ZoneID
				AND		ServiceClassID			= @ServiceClassID
				
				DELETE FROM #ConfigTable WHERE ProductConfigurationID = @ProductConfigurationID
			END
		
		COMMIT TRAN
			
		SET @Message =  ''Price green attributes process completed.''
		EXEC usp_DailyPricingLogInsert_New 3, 6, @Message, NULL, 0		
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @Message =  ''Price green attributes process - Error occurred. '' +  ERROR_MESSAGE()
		EXEC usp_DailyPricingLogInsert_New 1, 6, @Message, NULL, 0			
	END CATCH			
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
