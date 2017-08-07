/*******************************************************************************
 * usp_PriceTierUpdate
 * Updates price tier record
 *
 * History
 *******************************************************************************
 * 3/27/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PriceTierUpdate]
	@PriceTierID	int,
	@Name			varchar(50), 
	@Description	varchar(100), 
	@MinMwh			int, 
	@MaxMwh			int,
	@IsActive		tinyint
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	Libertypower..DailyPricingPriceTier 
    SET		Name			= @Name, 
			[Description]	= @Description, 
			MinMwh			= @MinMwh, 
			MaxMwh			= @MaxMwh,
			IsActive		= @IsActive
    WHERE	ID				= @PriceTierID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
