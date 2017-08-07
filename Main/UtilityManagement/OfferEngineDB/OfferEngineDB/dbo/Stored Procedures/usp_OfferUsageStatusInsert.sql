/*******************************************************************************
 * usp_OfferUsageStatusInsert
 * To flag offer as having usage errors
 *
 * History
 *******************************************************************************
 * 4/9/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferUsageStatusInsert]                                                                                    
	@OfferId	varchar(50),
	@HasErrors	tinyint
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	OfferUsageStatus (OfferId, HasErrors)
	VALUES		(@OfferId, @HasErrors)

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

