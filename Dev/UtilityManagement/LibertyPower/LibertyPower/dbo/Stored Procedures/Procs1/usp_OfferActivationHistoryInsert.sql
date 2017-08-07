/*******************************************************************************
 * usp_OfferActivationHistoryInsert
 * Insert historical record for offer activation table
 *
 * History
 *******************************************************************************
 * 6/9/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferActivationHistoryInsert]
	@OfferActivationID	int,
	@UserID				int, 
	@IsActive			tinyint, 
	@DateUpdated		datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@OfferActivationHistoryID	int

	INSERT INTO	OfferActivationHistory (OfferActivationID, UserID, IsActive, DateUpdated)
	VALUES		(@OfferActivationID, @UserID, @IsActive, @DateUpdated)
	
	SET		@OfferActivationHistoryID = @@IDENTITY
	
	SELECT	OfferActivationHistoryID, OfferActivationID, UserID, IsActive, DateUpdated
	FROM	OfferActivationHistory WITH (NOLOCK)
	WHERE	OfferActivationHistoryID = @OfferActivationHistoryID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_OfferActivationHistoryInsert';

