

/*******************************************************************************
 * usp_ProdConfigChannelAccessDelete
 * Deletes multi-term product access records for prod config
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProdConfigChannelAccessDelete]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;

	DELETE FROM	Libertypower..ProdConfigChannelAccess
	WHERE	ProductConfigurationID = @ProductConfigurationID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


