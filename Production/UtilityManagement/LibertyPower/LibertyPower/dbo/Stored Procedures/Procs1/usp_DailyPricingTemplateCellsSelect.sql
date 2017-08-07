/*******************************************************************************
 * usp_DailyPricingTemplateCellsSelect
 * Gets template cell positions
 *
 * History
 *******************************************************************************
 * 3/7/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingTemplateCellsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, CellPosition, Term, IsTermRange
    FROM	DailyPricingTemplateCells WITH (NOLOCK)

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
