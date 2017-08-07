/*******************************************************************************
 * usp_ProductConfigurationPriceTiersFill
 * Populates with data
 *
 * History
 *******************************************************************************
 * 4/5/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationPriceTiersFill]

AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @ConfigTable TABLE	(ID int)
	DECLARE @TierTable TABLE	(ID int)

	DECLARE	@ConfigID	int,
			@TierID		int
			
	TRUNCATE TABLE Libertypower..ProductConfigurationPriceTiers		
			
	INSERT INTO @ConfigTable
	SELECT	DISTINCT ProductConfigurationID
	FROM	Libertypower..ProductConfiguration WITH (NOLOCK)
	ORDER BY ProductConfigurationID

	INSERT INTO @TierTable
	SELECT	DISTINCT ID
	FROM	Libertypower..DailyPricingPriceTier WITH (NOLOCK)
	WHERE	ID > 0
	ORDER BY ID

	WHILE (SELECT COUNT(ID) FROM @ConfigTable) > 0
		BEGIN
			SELECT TOP 1 @ConfigID = ID FROM @ConfigTable
			
			WHILE (SELECT COUNT(ID) FROM @TierTable) > 0
				BEGIN
					SELECT TOP 1 @TierID = ID FROM @TierTable
					
					INSERT INTO Libertypower..ProductConfigurationPriceTiers (ProductConfigurationID, PriceTierID)
					VALUES		(@ConfigID, @TierID)
					
					DELETE FROM @TierTable WHERE ID = @TierID
				END		
				
				INSERT INTO @TierTable
				SELECT	DISTINCT ID
				FROM	Libertypower..DailyPricingPriceTier WITH (NOLOCK)
				WHERE	ID > 0
				ORDER BY ID	
			
			DELETE FROM @ConfigTable WHERE ID = @ConfigID		
	END    

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
