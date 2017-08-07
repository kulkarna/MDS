/*******************************************************************************
 * usp_OfferUsageStatusDelete
 * Delete offer usage error status
 *
 * History
 *******************************************************************************
 * 4/9/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferUsageStatusDelete]                                                                                    
	@OfferId	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DELETE FROM	OfferUsageStatus
	WHERE		OfferId = @OfferId

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

