/*******************************************************************************
 * usp_OfferActivationByProductConfigurationIDSelect
 * Gets offer activation by identity
 *
 * History
 *******************************************************************************
 * 6/4/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferActivationByProductConfigurationIDSelect]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	OfferActivationID, ProductConfigurationID, Term, IsActive, LowerTerm, UpperTerm
	FROM	OfferActivation WITH (NOLOCK)
	WHERE	ProductConfigurationID = @ProductConfigurationID
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_OfferActivationByProductConfigurationIDSelect';

