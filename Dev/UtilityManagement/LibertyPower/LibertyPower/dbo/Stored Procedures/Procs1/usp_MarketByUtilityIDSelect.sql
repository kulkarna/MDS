
/*******************************************************************************
 * usp_MarketByUtilityIDSelect
 * Gets market for specified utility iD
 *
 * History
 *******************************************************************************
 * 1/3/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_MarketByUtilityIDSelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
	SELECT	DISTINCT u.MarketID, mkt.MarketCode, mkt.RetailMktDescp
	FROM	LibertyPower..Utility u WITH (NOLOCK)
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
	WHERE u.ID = @UtilityID 

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

