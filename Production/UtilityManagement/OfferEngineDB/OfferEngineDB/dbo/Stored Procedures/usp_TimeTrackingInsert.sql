/*******************************************************************************
 * usp_TimeTrackingInsert
 * Insert time record of an Offer Engine event
 *
 * History
 *******************************************************************************
 * 3/25/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_TimeTrackingInsert]                                                                                   
	@PricingRequestId	varchar(50),
	@PricingEvent		tinyint
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	TimeTracking (PricingRequestId, PricingEvent, [TimeStamp])
	VALUES		(@PricingRequestId, @PricingEvent, GETDATE())

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

