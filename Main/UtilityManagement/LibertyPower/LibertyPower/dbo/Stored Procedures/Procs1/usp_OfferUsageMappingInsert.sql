
/*******************************************************************************
 * usp_OfferUsageMappingInsert
 * Insert association between offer accounts and usage records
 *
 * History
 *			07/30/2011 (EP) - adding usage type - IT022
 *******************************************************************************
 * 2/18/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferUsageMappingInsert]
	@OfferAccountsId	bigint,
	@UsageId			bigint,
	@UsageType			smallint
AS
BEGIN
    SET NOCOUNT ON;

	INSERT INTO	OfferUsageMapping (OfferAccountsId, UsageId, UsageType)
	VALUES		(@OfferAccountsId, @UsageId, @UsageType)

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

