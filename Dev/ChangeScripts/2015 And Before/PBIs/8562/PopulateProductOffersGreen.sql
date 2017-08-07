USE Libertypower
GO

DECLARE	@ProductConfigurationID		int,
		@SegmentID					int, 
		@ChannelTypeID				int, 
		@ProductTypeID				int, 
		@MarketID					int, 
		@UtilityID					int, 
		@ZoneID						int, 
		@ServiceClassID				int,
		@Term						int, 
		@RelativeStartMonth			int, 
		@ProductBrandID				int,
		@Name						varchar(100),
		@ProductName				varchar(50),
		@Now						datetime,
		@ProductConfigurationIDNew	int

SET		@Now			= GETDATE()
SET		@ProductTypeID	= 8 -- green product type 
SET		@ProductBrandID	= 18 -- green product brand

DECLARE @ConfigsToDelete TABLE (ProductConfigurationID int)
						
DECLARE @Configs TABLE (ProductConfigurationID int, SegmentID int, ChannelTypeID int, MarketID int, 
						UtilityID int, ZoneID int, ServiceClassID int)

BEGIN TRAN TRANDELETE

-- delete any existing green configurations  -----------------------------------------------------------------------
INSERT	INTO @ConfigsToDelete
SELECT	DISTINCT ProductConfigurationID
FROM	ProductConfiguration WITH (NOLOCK)
WHERE	ProductTypeID = 8

DELETE
FROM	OfferActivation
WHERE	ProductConfigurationID IN (SELECT ProductConfigurationID FROM @ConfigsToDelete)

DELETE
FROM	ProductConfigurationPriceTiers
WHERE	ProductConfigurationID IN (SELECT ProductConfigurationID FROM @ConfigsToDelete)

DELETE
FROM	ProductConfiguration
WHERE	ProductConfigurationID IN (SELECT ProductConfigurationID FROM @ConfigsToDelete)

-----------------------------------------------------------------------------------------------------------------------------

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN TRANDELETE
		PRINT 'Error occurred. No product configurations were created.'
	END
ELSE 
	BEGIN
		COMMIT TRAN TRANDELETE

		-- insert product offers for CT, IL, MD, NJ, NY, PA, TX ---------------------------------------------------------------------			
		INSERT	INTO @Configs
		SELECT	DISTINCT ProductConfigurationID, SegmentID, ChannelTypeID, MarketID, UtilityID, ZoneID, ServiceClassID
		FROM	ProductConfiguration WITH (NOLOCK)
		WHERE	IsTermRange		= 0 -- super saver (0 no, 1 yes)
		AND		ProductTypeID	= 1
		AND		SegmentID		IN (2, 3, 4) -- SMB, RES and SOHO
		AND		MarketID		IN (3, 13, 10, 9, 7, 8, 1) -- CT, IL, MD, NJ, NY, PA, TX
		AND		ProductConfigurationID IN
				(
					SELECT	DISTINCT ProductConfigurationID
					FROM	OfferActivation WITH (NOLOCK)
					WHERE	IsActive = 1 -- active configs only
				)

		WHILE (SELECT COUNT(ProductConfigurationID) FROM @Configs) > 0
			BEGIN
				BEGIN TRAN TRANINSERT
				
				SELECT	TOP 1 @ProductConfigurationID = ProductConfigurationID, @SegmentID = SegmentID, @ChannelTypeID = ChannelTypeID, 
						@MarketID = MarketID, @UtilityID = UtilityID, @ZoneID = ZoneID, @ServiceClassID = ServiceClassID
				FROM	@Configs

				-- set relative start months
				SET	@RelativeStartMonth = 
				CASE WHEN @SegmentID = 2 THEN -- SMB ----------
					CASE WHEN @MarketID = 1 THEN 13 -- TX
					ELSE 12 END -- All Other markets		
				WHEN @SegmentID = 3 THEN -- RES ----------
					CASE WHEN @MarketID = 1 THEN 4 -- TX
					ELSE 3 END -- All Other markets
				WHEN @SegmentID = 4 THEN 6 -- SOHO	-------	
				END
				
				-- insert product offers ----------------------------------------------------------------------------------------------------
				SET	@ProductName	= 'Green'			
				SET	@Name = (SELECT	MarketCode			FROM Market							WHERE ID = @MarketID) + '-' + 
							(SELECT UtilityCode			FROM Utility						WHERE ID = @UtilityID) + '-' + 
							(SELECT zone				FROM lp_common..zone				WHERE zone_id = @ZoneID) + '-' + 
							CASE WHEN @ServiceClassID = -1 THEN 'All Others' ELSE (SELECT service_rate_class	FROM lp_common..service_rate_class	WHERE service_rate_class_id = @ServiceClassID) + '-' END + 
							(SELECT UPPER(LEFT(Name, 3))FROM ChannelType					WHERE ID = @ChannelTypeID) + '-' + 
							(SELECT AccountType			FROM AccountType					WHERE ID = @SegmentID) + '-Green'
						
				-- product configuration  ---------------------------------------------------------------------------------------------------
				INSERT	INTO ProductConfiguration
				SELECT	@Name, @SegmentID, @ChannelTypeID, @ProductTypeID, @MarketID, @UtilityID, @ZoneID, @ServiceClassID, 3, 
						@Now, @ProductName, @RelativeStartMonth, 0, @ProductBrandID, NULL, NULL
						
				SET		@ProductConfigurationIDNew = SCOPE_IDENTITY()
				
				-- price tiers  -------------------------------------------------------------------------------------------------------------
				INSERT	INTO ProductConfigurationPriceTiers
				SELECT	@ProductConfigurationIDNew, PriceTierID
				FROM	ProductConfigurationPriceTiers
				WHERE	ProductConfigurationID = @ProductConfigurationID
				
				-- offer activation  --------------------------------------------------------------------------------------------------------
				SET	@Term	= 12	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
				
				SET	@Term	= 24	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
				
				SET	@Term	= 36	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
				
				SET	@Term	= 48	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
				
				SET	@Term	= 60	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL											
				
				IF @@ERROR <> 0
					ROLLBACK TRAN TRANINSERT
				ELSE
					COMMIT TRAN TRANINSERT
					
				DELETE	FROM @Configs
				WHERE	ProductConfigurationID = @ProductConfigurationID			
			END
			
			PRINT 'Completed product offers for CT, IL, MD, NJ, NY, PA, TX'
		-----------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------

		-- insert product offers for DC, MA, ME, OH, RI  -----------------------------------------------------------------------------			
		INSERT	INTO @Configs
		SELECT	DISTINCT ProductConfigurationID, SegmentID, ChannelTypeID, MarketID, UtilityID, ZoneID, ServiceClassID
		FROM	ProductConfiguration WITH (NOLOCK)
		WHERE	IsTermRange		= 0 -- super saver (0 no, 1 yes)
		AND		ProductTypeID	= 1
		AND		SegmentID		IN (2) -- SMB
		AND		MarketID		IN (11, 4, 5, 16, 6) -- DC, MA, ME, OH, RI
		AND		ProductConfigurationID IN
				(
					SELECT	DISTINCT ProductConfigurationID
					FROM	OfferActivation WITH (NOLOCK)
					WHERE	IsActive = 1 -- active configs only
				)

		WHILE (SELECT COUNT(ProductConfigurationID) FROM @Configs) > 0
			BEGIN
				BEGIN TRAN TRANINSERT
				
				SELECT	TOP 1 @ProductConfigurationID = ProductConfigurationID, @SegmentID = SegmentID, @ChannelTypeID = ChannelTypeID, 
						@MarketID = MarketID, @UtilityID = UtilityID, @ZoneID = ZoneID, @ServiceClassID = ServiceClassID
				FROM	@Configs

				-- set relative start months
				SET	@RelativeStartMonth = 12
				
				-- insert product offers ----------------------------------------------------------------------------------------------------
				SET	@ProductName	= 'Green'			
				SET	@Name = (SELECT	MarketCode			FROM Market							WHERE ID = @MarketID) + '-' + 
							(SELECT UtilityCode			FROM Utility						WHERE ID = @UtilityID) + '-' + 
							(SELECT zone				FROM lp_common..zone				WHERE zone_id = @ZoneID) + '-' + 
							CASE WHEN @ServiceClassID = -1 THEN 'All Others' ELSE (SELECT service_rate_class	FROM lp_common..service_rate_class	WHERE service_rate_class_id = @ServiceClassID) + '-' END + 
							(SELECT UPPER(LEFT(Name, 3))FROM ChannelType					WHERE ID = @ChannelTypeID) + '-' + 
							(SELECT AccountType			FROM AccountType					WHERE ID = @SegmentID) + '-Green'
						
				-- product configuration  ---------------------------------------------------------------------------------------------------
				INSERT	INTO ProductConfiguration
				SELECT	@Name, @SegmentID, @ChannelTypeID, @ProductTypeID, @MarketID, @UtilityID, @ZoneID, @ServiceClassID, 3, 
						@Now, @ProductName, @RelativeStartMonth, 0, @ProductBrandID, NULL, NULL
						
				SET		@ProductConfigurationIDNew = SCOPE_IDENTITY()
				
				-- price tiers  -------------------------------------------------------------------------------------------------------------
				INSERT	INTO ProductConfigurationPriceTiers
				SELECT	@ProductConfigurationIDNew, PriceTierID
				FROM	ProductConfigurationPriceTiers
				WHERE	ProductConfigurationID = @ProductConfigurationID
				
				-- offer activation  --------------------------------------------------------------------------------------------------------
				SET	@Term	= 12	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
				
				SET	@Term	= 24	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
				
				SET	@Term	= 36	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
				
				SET	@Term	= 48	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
				
				SET	@Term	= 60	
				INSERT	INTO OfferActivation
				SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL											
				
				IF @@ERROR <> 0
					ROLLBACK TRAN TRANINSERT
				ELSE
					COMMIT TRAN TRANINSERT
					
				DELETE	FROM @Configs
				WHERE	ProductConfigurationID = @ProductConfigurationID			
			END
			
			PRINT 'Completed product offers for DC, MA, ME, OH, RI'
		-----------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------
	END