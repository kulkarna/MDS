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

SET		@Now					= GETDATE()

DECLARE @ConfigsToDelete TABLE (ProductConfigurationID int)
						
DECLARE @Configs TABLE (ProductConfigurationID int, SegmentID int, ChannelTypeID int, ProductTypeID int, MarketID int, UtilityID int, ZoneID int, 
						ServiceClassID int, RelativeStartMonth int, ProductBrandID int)

BEGIN TRAN TRANDELETE

-- delete any existing 48 or 60 month configurations  -----------------------------------------------------------------------
INSERT	INTO @ConfigsToDelete
SELECT	DISTINCT ProductConfigurationID
FROM	OfferActivation WITH (NOLOCK)
WHERE	Term IN (48,60)

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
	ROLLBACK TRAN TRANDELETE
ELSE 
	COMMIT TRAN TRANDELETE
			
INSERT	INTO @Configs
SELECT	DISTINCT ProductConfigurationID, SegmentID, ChannelTypeID, ProductTypeID, MarketID, UtilityID, ZoneID, ServiceClassID, 
		12, -- relative start month
		ProductBrandID
FROM	ProductConfiguration WITH (NOLOCK)
WHERE	IsTermRange		= 0 -- super saver (0 no, 1 yes)
AND		ProductTypeID	= 1
AND		SegmentID		IN (2,3) -- smb and res
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
				@ProductTypeID = ProductTypeID, @MarketID = MarketID, @UtilityID = UtilityID, @ZoneID = ZoneID, 
				@ServiceClassID = ServiceClassID, @RelativeStartMonth = RelativeStartMonth, @ProductBrandID = ProductBrandID
		FROM	@Configs

		-- set relative start months to 12 for smb, 3 for res
		SET	@RelativeStartMonth = CASE WHEN @SegmentID = 3 THEN 3 ELSE 12 END
		
		-----------------------------------------------------------------------------------------------------------------------------
		-- 48 month  ----------------------------------------------------------------------------------------------------------------	
		-----------------------------------------------------------------------------------------------------------------------------	
		SET	@ProductName	= 'Standard 48 Term'
		SET	@Term			= 48				
		SET	@Name = (SELECT	MarketCode			FROM Market							WHERE ID = @MarketID) + '-' + 
					(SELECT UtilityCode			FROM Utility						WHERE ID = @UtilityID) + '-' + 
					(SELECT zone				FROM lp_common..zone				WHERE zone_id = @ZoneID) + '-' + 
					CASE WHEN @ServiceClassID = -1 THEN 'All Others' ELSE (SELECT service_rate_class	FROM lp_common..service_rate_class	WHERE service_rate_class_id = @ServiceClassID) + '-' END + 
					(SELECT UPPER(LEFT(Name, 3))FROM ChannelType					WHERE ID = @ChannelTypeID) + '-' + 
					(SELECT AccountType			FROM AccountType					WHERE ID = @SegmentID) + '-48'
				
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
		INSERT	INTO OfferActivation
		SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL
		
		-----------------------------------------------------------------------------------------------------------------------------
		-- 60 month  ----------------------------------------------------------------------------------------------------------------	
		-----------------------------------------------------------------------------------------------------------------------------	
		SET	@ProductName	= 'Standard 60 Term'
		SET	@Term			= 60				
		SET	@Name = (SELECT	MarketCode			FROM Market							WHERE ID = @MarketID) + '-' + 
					(SELECT UtilityCode			FROM Utility						WHERE ID = @UtilityID) + '-' + 
					(SELECT zone				FROM lp_common..zone				WHERE zone_id = @ZoneID) + '-' + 
					CASE WHEN @ServiceClassID = -1 THEN 'All Others' ELSE (SELECT service_rate_class	FROM lp_common..service_rate_class	WHERE service_rate_class_id = @ServiceClassID) + '-' END + 
					(SELECT UPPER(LEFT(Name, 3))FROM ChannelType					WHERE ID = @ChannelTypeID) + '-' + 
					(SELECT AccountType			FROM AccountType					WHERE ID = @SegmentID) + '-60'
				
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
		INSERT	INTO OfferActivation
		SELECT	@ProductConfigurationIDNew, @Term, 1, NULL, NULL		
		
		-----------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------
		
		IF @@ERROR <> 0
			ROLLBACK TRAN TRANINSERT
		ELSE
			COMMIT TRAN TRANINSERT
			
		DELETE	FROM @Configs
		WHERE	ProductConfigurationID = @ProductConfigurationID			
	END
