/*******************************************************************************
 * usp_ProductConfigurationDelete
 * Deletes product configuration for specified ID
 *
 * History
 *******************************************************************************
 * 6/29/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationDelete]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;
   
	DELETE
	FROM	ProductConfiguration
	WHERE	ProductConfigurationID = @ProductConfigurationID
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ProductConfigurationDelete';

