



/*******************************************************************************
 * usp_RateInsert
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateInsert]  
	@RateCodeID		int,
	@Rate					decimal(18,10),
	@EffectiveDate		datetime,
	@ExpirationDate datetime,
	@CreatedBy			int
AS


INSERT INTO Rate( RateCodeID, Price, EffectiveDate, ExpirationDate, CreatedBy, ModifiedBy)
VALUES( @RateCodeID, @Rate, @EffectiveDate, @ExpirationDate, @CreatedBy, @CreatedBy)

DECLARE @ID int
SET @ID = SCOPE_IDENTITY()

IF @ID IS NOT NULL
BEGIN
	SELECT		Rate.ID, 
						Rate.RateCodeID, 
						Rate.Price,
						Rate.EffectiveDate,
						Rate.ExpirationDate,
						Rate.DateCreated,
						Rate.CreatedBy,
						Rate.DateModified,
						Rate.ModifiedBy
	FROM	 Rate
	WHERE Rate.ID = @ID
END 

                                                                                                                              
-- Copyright 2009 Liberty Power



