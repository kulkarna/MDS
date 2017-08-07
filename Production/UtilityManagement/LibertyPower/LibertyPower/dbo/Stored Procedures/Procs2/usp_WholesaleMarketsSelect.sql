/*******************************************************************************
 * usp_WholesaleMarketsSelect
 * Kets wholsale market records
 *
 * History
 *******************************************************************************
 * 2/3/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_WholesaleMarketsSelect]

AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, WholesaleMktId, WholesaleMktDescp, DateCreated, Username, InactiveInd, ActiveDate, Chgstamp
	FROM	Libertypower..WholesaleMarket WITH (NOLOCK)
	ORDER BY WholesaleMktDescp

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
