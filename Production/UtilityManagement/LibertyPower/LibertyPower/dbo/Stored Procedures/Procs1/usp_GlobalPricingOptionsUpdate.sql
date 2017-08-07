/*******************************************************************************
 * usp_GlobalPricingOptionsUpdate
 * Updates global pricing option for specified record
 *
 * History
 *******************************************************************************
 * 4/16/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GlobalPricingOptionsUpdate]
	@ID				int,
	@UsageTolerance	decimal(12,6)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE	GlobalPricingOptions
    SET		UsageTolerance	= @UsageTolerance
    WHERE	ID				= @ID

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
