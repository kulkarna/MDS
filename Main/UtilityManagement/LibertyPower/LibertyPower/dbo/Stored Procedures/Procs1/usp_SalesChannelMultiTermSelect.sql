

/*******************************************************************************
 * usp_SalesChannelMultiTermSelect
 * Selects multi-term product access records for channel
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelMultiTermSelect]
	@ChannelID	int
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	t.ID, t.ChannelID, t.UtilityID, u.UtilityCode 
	FROM	Libertypower..SalesChannelMultiTerm t WITH (NOLOCK) 
			INNER JOIN Libertypower..Utility u WITH (NOLOCK) 
			ON t.UtilityID = u.ID
	WHERE	ChannelID	= @ChannelID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


