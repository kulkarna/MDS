

/*******************************************************************************
 * usp_SalesChannelMultiTermInsert
 * Inserts multi-term product access record for channel and utility
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelMultiTermInsert]
	@ChannelID	int,
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS	(	
						SELECT	1 
						FROM	Libertypower..SalesChannelMultiTerm WITH (NOLOCK) 
						WHERE	ChannelID	= @ChannelID
						AND		UtilityID	= @UtilityID
					)
		BEGIN
			INSERT INTO	Libertypower..SalesChannelMultiTerm (ChannelID, UtilityID)
			VALUES		(@ChannelID, @UtilityID)
		END

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


