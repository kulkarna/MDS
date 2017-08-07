/*******************************************************************************
 * usp_
 * Desc
 *
 * History
 *******************************************************************************
 * 1/3/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_zIstaUsageRequestUpdate]
	@PricingRequestID	varchar(25)
AS
BEGIN
    SET NOCOUNT ON;
    
	UPDATE	Workspace..PjmPricingRequests010312
	SET		IsProcessed			= 1
	WHERE	PricingRequestID	= @PricingRequestID

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

