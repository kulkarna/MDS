/*******************************************************************************
 * usp_ActiveOfferUpdate
 * Updates active offer status for specified ID
 *
 * History
 *******************************************************************************
 * 6/9/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ActiveOfferUpdate]
	@OfferActivationID	int,
	@IsActive			tinyint
AS
BEGIN
    SET NOCOUNT ON;
	
	UPDATE	LibertyPower..OfferActivation
	SET		IsActive			= @IsActive
	WHERE	OfferActivationID	= @OfferActivationID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
