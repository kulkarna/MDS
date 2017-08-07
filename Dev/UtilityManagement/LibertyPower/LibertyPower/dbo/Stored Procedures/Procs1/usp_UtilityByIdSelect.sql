
/*******************************************************************************
 * usp_UtilityByIdSelect
 * To get utility using the utility Id
 *
 * History
 *******************************************************************************
 * 5/19/2010 - George Worthington
 * Created.
 *******************************************************************************
 * 1/20/2011 - Isabelle Tamanini
 * Added PorOption to select clause
 * Ticket 19975
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityByIdSelect]
	@UtilityId	int
AS
BEGIN
    SET NOCOUNT ON;
    
    EXEC LibertyPower.dbo.usp_UtilitySelect @UtilityID = @UtilityId
    
	--SELECT	ID, UtilityCode, FullName, ShortName--, Recourse -- field added INF76b
	--		, SSNIsRequired -- ticket 14817
	--		, MarketID
	--		, PorOption
	--FROM	Utility
	--WHERE	ID	= @UtilityId
    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
