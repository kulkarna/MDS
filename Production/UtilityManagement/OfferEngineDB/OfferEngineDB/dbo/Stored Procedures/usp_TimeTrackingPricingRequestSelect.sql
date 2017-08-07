/*******************************************************************************
 * usp_TimeTrackingPricingRequestSelect
 * Get time records of Offer Engine events for a specified pricing request
 *
 * History
 *******************************************************************************
 * 3/25/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_TimeTrackingPricingRequestSelect]                                                                                   
	@PricingRequestId	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT		PricingRequestId, PricingEvent, [TimeStamp]
	FROM		TimeTracking WITH (NOLOCK)
	WHERE		PricingRequestId = @PricingRequestId
	ORDER BY	[TimeStamp]

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

