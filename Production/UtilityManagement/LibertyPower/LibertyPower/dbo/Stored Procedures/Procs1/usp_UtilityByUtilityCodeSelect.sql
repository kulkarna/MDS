
/*******************************************************************************
 * usp_UtilityByUtilityCodeSelect
 * To get utility using the utility code
 *
 * History
 *******************************************************************************
 * 7/23/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 1/20/2011 - Isabelle Tamanini
 * Added PorOption to select clause
 * Ticket 19975
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityByUtilityCodeSelect]
	@UtilityCode	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    EXEC LibertyPower.dbo.usp_UtilitySelect @UtilityCode = @UtilityCode

    
	--SELECT	ID, UtilityCode, FullName, ShortName--, Recourse -- field added INF76b
	--		, SSNIsRequired -- ticket 14817
	--		, MarketID
	--		, PorOption
	--FROM	Utility
	--WHERE	UtilityCode	= @UtilityCode
    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
