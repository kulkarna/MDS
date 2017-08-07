

/*******************************************************************************
 * usp_ProdConfigChannelAccessInsert
 * Inserts multi-term product access record for channel and prod config
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigChannelAccessInsert]
	@ProductConfigurationID	int,
	@ChannelID				int
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS	(	
						SELECT	1 
						FROM	Libertypower..ProdConfigChannelAccess WITH (NOLOCK) 
						WHERE	ProductConfigurationID	= @ProductConfigurationID
						AND		ChannelID				= @ChannelID
					)
		BEGIN
			INSERT INTO	Libertypower..ProdConfigChannelAccess (ProductConfigurationID, ChannelID)
			VALUES		(@ProductConfigurationID, @ChannelID)
		END

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


