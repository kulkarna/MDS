/*******************************************************************************
 * usp_ProductOfferStatusUpdate
 * Updates offer "active" status for specified ID
 *
 * History
 *******************************************************************************
 * 6/9/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductOfferStatusUpdate]
	@OfferActivationID	int,
	@IsActive			tinyint,
	@UserID				int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@TimeStamp			datetime,
			@IsActiveCurrent	int
    SET		@TimeStamp	= GETDATE()
    
	SELECT	@IsActiveCurrent = IsActive
	FROM	OfferActivation WITH (NOLOCK)
	WHERE	OfferActivationID = @OfferActivationID	    
	
	IF @IsActiveCurrent <> @IsActive
		BEGIN
			UPDATE	LibertyPower..OfferActivation
			SET		IsActive			= @IsActive
			WHERE	OfferActivationID	= @OfferActivationID
			
			EXEC usp_OfferActivationHistoryInsert @OfferActivationID, @UserID, @IsActive, @TimeStamp
		END
	
	SELECT	OfferActivationID, ProductConfigurationID, Term, IsActive
	FROM	OfferActivation WITH (NOLOCK)
	WHERE	OfferActivationID = @OfferActivationID	

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
