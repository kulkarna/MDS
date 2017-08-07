/*******************************************************************************
 * usp_OfferIdsSelect
 * Get offer ids
 *
 * History
 *******************************************************************************
 * 2/23/2009
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferIdsSelect]                                                                                    

AS
BEGIN
    SET NOCOUNT ON;

	SELECT		OFFER_ID
	FROM		OE_OFFER WITH (NOLOCK)
	ORDER BY	OFFER_ID

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power

