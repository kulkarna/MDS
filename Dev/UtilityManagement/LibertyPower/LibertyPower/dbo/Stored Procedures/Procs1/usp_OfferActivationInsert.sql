/*******************************************************************************
 * usp_OfferActivationInsert
 * Inserts offer activation
 *
 * History
 *******************************************************************************
 * 6/4/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_OfferActivationInsert]
	@ProductConfigurationID	int,
	@Term					int,
	@IsActive				int,
	@UserID					int,
	@LowerTerm				int = NULL, 
	@UpperTerm				int = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@OfferActivationID	int,
			@TimeStamp			datetime
    SET		@TimeStamp			= GETDATE()    
    
    IF NOT EXISTS	(
						SELECT	NULL
						FROM	OfferActivation
						WHERE	ProductConfigurationID	= @ProductConfigurationID
						AND		Term					= @Term
						AND		IsActive				= @IsActive
						AND		LowerTerm				= @LowerTerm
						AND		UpperTerm				= @UpperTerm
					)
	AND NOT EXISTS	(
						SELECT	NULL
						FROM	OfferActivation
						WHERE	ProductConfigurationID	= @ProductConfigurationID
						AND		Term					= @Term
						AND		IsActive				= @IsActive
						AND		LowerTerm				IS NULL
						AND		UpperTerm				IS NULL
					)	
		BEGIN
			INSERT INTO	OfferActivation (ProductConfigurationID, Term, IsActive, LowerTerm, UpperTerm)
			VALUES		(@ProductConfigurationID, @Term, @IsActive, @LowerTerm, @UpperTerm)
		    
			SET		@OfferActivationID = @@IDENTITY
		    
			EXEC usp_OfferActivationHistoryInsert @OfferActivationID, @UserID, @IsActive, @TimeStamp
		   
			SELECT	OfferActivationID, ProductConfigurationID, Term, IsActive, LowerTerm, UpperTerm
			FROM	OfferActivation WITH (NOLOCK)
			WHERE	OfferActivationID = @OfferActivationID
		END
	ELSE
		BEGIN
			SELECT	OfferActivationID, ProductConfigurationID, Term, IsActive, LowerTerm, UpperTerm
			FROM	OfferActivation WITH (NOLOCK)
			WHERE	ProductConfigurationID	= @ProductConfigurationID
			AND		Term					= @Term
			AND		IsActive				= @IsActive	
			AND		LowerTerm				= @LowerTerm
			AND		UpperTerm				= @UpperTerm			
		END
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_OfferActivationInsert';

