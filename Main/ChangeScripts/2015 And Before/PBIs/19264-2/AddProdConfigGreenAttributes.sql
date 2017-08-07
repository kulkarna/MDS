DECLARE	@ProductConfigurationID	int,
		@LocationID				int,
		@RecTypeID				int,
		@PercentageID			int,
		@GreenLocationRecTypeID	int
		
DECLARE	@ProdConfigTable TABLE (ProductConfigurationID int)
DECLARE	@AttributesTable TABLE (ProductConfigurationID int, PercentageID int, GreenLocationRecTypeID int)	

--  National Green E  ----------------------------------------------------		
SELECT	@LocationID				= ID
FROM	LibertyPower..GreenLocation WITH (NOLOCK)
WHERE	Location				= 'National'

SELECT	@RecTypeID				= ID
FROM	LibertyPower..GreenRecType WITH (NOLOCK)
WHERE	RecType					= 'Green-eAny'

SELECT	@PercentageID			= ID
FROM	LibertyPower..GreenPercentage WITH (NOLOCK)
WHERE	[Percent]				= 100

SELECT	@GreenLocationRecTypeID	= GreenLocationRecTypeID
FROM	LibertyPower..GreenLocationRecType WITH (NOLOCK)
WHERE	LocationID				= @LocationID
AND		RecTypeID				= @RecTypeID

INSERT	INTO @ProdConfigTable
SELECT	ProductConfigurationID
FROM	LibertyPower..ProductConfiguration WITH (NOLOCK)
WHERE	ProductTypeID			= 8
AND		ProductBrandID			= 19
ORDER BY ProductConfigurationID

WHILE (SELECT COUNT(ProductConfigurationID) FROM @ProdConfigTable) > 0
	BEGIN
		SELECT TOP 1 @ProductConfigurationID = ProductConfigurationID FROM @ProdConfigTable
		
		INSERT	INTO @AttributesTable
		SELECT	@ProductConfigurationID, @PercentageID, @GreenLocationRecTypeID
		
		DELETE FROM @ProdConfigTable WHERE ProductConfigurationID = @ProductConfigurationID
	END
	
--  IL Wind  -------------------------------------------------------------		
SELECT	@LocationID				= ID
FROM	LibertyPower..GreenLocation WITH (NOLOCK)
WHERE	Location				= 'IL'

SELECT	@RecTypeID				= ID
FROM	LibertyPower..GreenRecType WITH (NOLOCK)
WHERE	RecType					= 'ARESNonWind'

SELECT	@PercentageID			= ID
FROM	LibertyPower..GreenPercentage WITH (NOLOCK)
WHERE	[Percent]				= 100

SELECT	@GreenLocationRecTypeID	= GreenLocationRecTypeID
FROM	LibertyPower..GreenLocationRecType WITH (NOLOCK)
WHERE	LocationID				= @LocationID
AND		RecTypeID				= @RecTypeID

INSERT	INTO @ProdConfigTable
SELECT	ProductConfigurationID
FROM	LibertyPower..ProductConfiguration WITH (NOLOCK)
WHERE	ProductTypeID			= 8
AND		ProductBrandID			= 18
ORDER BY ProductConfigurationID

WHILE (SELECT COUNT(ProductConfigurationID) FROM @ProdConfigTable) > 0
	BEGIN
		SELECT TOP 1 @ProductConfigurationID = ProductConfigurationID FROM @ProdConfigTable
		
		INSERT	INTO @AttributesTable
		SELECT	@ProductConfigurationID, @PercentageID, @GreenLocationRecTypeID
		
		DELETE FROM @ProdConfigTable WHERE ProductConfigurationID = @ProductConfigurationID
	END	
	
--  Fixed PA Green  ------------------------------------------------------	
SELECT	@LocationID				= ID
FROM	LibertyPower..GreenLocation WITH (NOLOCK)
WHERE	Location				= 'PA'

SELECT	@RecTypeID				= 37

SELECT	@PercentageID			= ID
FROM	LibertyPower..GreenPercentage WITH (NOLOCK)
WHERE	[Percent]				= 100

SELECT	@GreenLocationRecTypeID	= GreenLocationRecTypeID
FROM	LibertyPower..GreenLocationRecType WITH (NOLOCK)
WHERE	LocationID				= @LocationID
AND		RecTypeID				= @RecTypeID

INSERT	INTO @ProdConfigTable
SELECT	ProductConfigurationID
FROM	LibertyPower..ProductConfiguration WITH (NOLOCK)
WHERE	ProductTypeID			= 8
AND		ProductBrandID			= 23
ORDER BY ProductConfigurationID

WHILE (SELECT COUNT(ProductConfigurationID) FROM @ProdConfigTable) > 0
	BEGIN
		SELECT TOP 1 @ProductConfigurationID = ProductConfigurationID FROM @ProdConfigTable
		
		INSERT	INTO @AttributesTable
		SELECT	@ProductConfigurationID, @PercentageID, @GreenLocationRecTypeID
		
		DELETE FROM @ProdConfigTable WHERE ProductConfigurationID = @ProductConfigurationID
	END	
	
--  Fixed CT Green  ------------------------------------------------------	
SELECT	@LocationID				= ID
FROM	LibertyPower..GreenLocation WITH (NOLOCK)
WHERE	Location				= 'CT'

SELECT	@RecTypeID				= 5

SELECT	@PercentageID			= ID
FROM	LibertyPower..GreenPercentage WITH (NOLOCK)
WHERE	[Percent]				= 100

SELECT	@GreenLocationRecTypeID	= GreenLocationRecTypeID
FROM	LibertyPower..GreenLocationRecType WITH (NOLOCK)
WHERE	LocationID				= @LocationID
AND		RecTypeID				= @RecTypeID

INSERT	INTO @ProdConfigTable
SELECT	ProductConfigurationID
FROM	LibertyPower..ProductConfiguration WITH (NOLOCK)
WHERE	ProductTypeID			= 8
AND		ProductBrandID			= 21
ORDER BY ProductConfigurationID

WHILE (SELECT COUNT(ProductConfigurationID) FROM @ProdConfigTable) > 0
	BEGIN
		SELECT TOP 1 @ProductConfigurationID = ProductConfigurationID FROM @ProdConfigTable
		
		INSERT	INTO @AttributesTable
		SELECT	@ProductConfigurationID, @PercentageID, @GreenLocationRecTypeID
		
		DELETE FROM @ProdConfigTable WHERE ProductConfigurationID = @ProductConfigurationID
	END	
	
--  Fixed MD Green  ------------------------------------------------------	
SELECT	@LocationID				= ID
FROM	LibertyPower..GreenLocation WITH (NOLOCK)
WHERE	Location				= 'MD'

SELECT	@RecTypeID				= 23

SELECT	@PercentageID			= ID
FROM	LibertyPower..GreenPercentage WITH (NOLOCK)
WHERE	[Percent]				= 100

SELECT	@GreenLocationRecTypeID	= GreenLocationRecTypeID
FROM	LibertyPower..GreenLocationRecType WITH (NOLOCK)
WHERE	LocationID				= @LocationID
AND		RecTypeID				= @RecTypeID

INSERT	INTO @ProdConfigTable
SELECT	ProductConfigurationID
FROM	LibertyPower..ProductConfiguration WITH (NOLOCK)
WHERE	ProductTypeID			= 8
AND		ProductBrandID			= 22
ORDER BY ProductConfigurationID

WHILE (SELECT COUNT(ProductConfigurationID) FROM @ProdConfigTable) > 0
	BEGIN
		SELECT TOP 1 @ProductConfigurationID = ProductConfigurationID FROM @ProdConfigTable
		
		INSERT	INTO @AttributesTable
		SELECT	@ProductConfigurationID, @PercentageID, @GreenLocationRecTypeID
		
		DELETE FROM @ProdConfigTable WHERE ProductConfigurationID = @ProductConfigurationID
	END	
	
INSERT	INTO Libertypower..ProductConfigGreenAttributes
SELECT	DISTINCT ProductConfigurationID, PercentageID, GreenLocationRecTypeID
FROM	@AttributesTable
ORDER BY ProductConfigurationID, GreenLocationRecTypeID, PercentageID