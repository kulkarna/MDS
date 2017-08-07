

/*******************************************************************************
 * usp_ProdConfigChannelAccessSelect
 * Selects multi-term product access records
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigChannelAccessSelect]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ID, ProductConfigurationID, ChannelID
	FROM	Libertypower..ProdConfigChannelAccess WITH (NOLOCK) 
	WHERE	ProductConfigurationID = CASE WHEN @ProductConfigurationID = -1 THEN ProductConfigurationID ELSE @ProductConfigurationID END

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


