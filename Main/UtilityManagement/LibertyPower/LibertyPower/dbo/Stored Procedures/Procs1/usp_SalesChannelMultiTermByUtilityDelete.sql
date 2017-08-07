

/*******************************************************************************
 * usp_SalesChannelMultiTermByUtilityDelete
 * Deletes multi-term product access records for utility
 *
 * History
 *******************************************************************************
 * 9/12/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelMultiTermByUtilityDelete]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;

	DELETE FROM	Libertypower..SalesChannelMultiTerm
	WHERE	UtilityID = @UtilityID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


