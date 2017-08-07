/*******************************************************************************
 * usp_GlobalPricingOptionsSelect
 * Gets global pricing options
 *
 * History
 *******************************************************************************
 * 4/16/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_GlobalPricingOptionsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, UsageTolerance
    FROM	GlobalPricingOptions WITH (NOLOCK)

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
