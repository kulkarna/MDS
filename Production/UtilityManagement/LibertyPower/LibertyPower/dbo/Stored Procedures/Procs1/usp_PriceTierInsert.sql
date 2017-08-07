/*******************************************************************************
 * usp_PriceTierInsert
 * Inserts new price tier record
 *
 * History
 *******************************************************************************
 * 3/27/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceTierInsert]
	@Name			varchar(50), 
	@Description	varchar(100), 
	@MinMwh			int, 
	@MaxMwh			int,
	@IsActive		tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@PriceTierID	int,
			@SortOrder		int
			
	SELECT @SortOrder = (MAX(SortOrder) + 1) FROM Libertypower..DailyPricingPriceTier WITH (NOLOCK)
    
    INSERT INTO	Libertypower..DailyPricingPriceTier (Name, [Description], MinMwh, MaxMwh, SortOrder, IsActive)
    VALUES		(@Name, @Description, @MinMwh, @MaxMwh, @SortOrder, @IsActive)
    
    SELECT	@PriceTierID = SCOPE_IDENTITY()
    
    SELECT	ID, Name, [Description], MinMwh, MaxMwh, SortOrder, IsActive
    FROM	Libertypower..DailyPricingPriceTier WITH (NOLOCK)
    WHERE	ID = @PriceTierID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
