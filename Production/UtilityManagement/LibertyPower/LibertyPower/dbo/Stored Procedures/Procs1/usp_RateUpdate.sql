



/*******************************************************************************
 * usp_RateUpdate
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].[usp_RateUpdate]  
	@ID						int,
	@Rate					decimal(18,10),
	@EffectiveDate		datetime,
	@ExpirationDate datetime,
	@ModifiedBy			int
AS


UPDATE Rate SET  Price = @Rate, EffectiveDate = @EffectiveDate, ExpirationDate = @ExpirationDate, ModifiedBy = @ModifiedBy, DateModified = GetDate() 
WHERE ID = @ID


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
 

                                                                                                                             
-- Copyright 2009 Liberty Power



