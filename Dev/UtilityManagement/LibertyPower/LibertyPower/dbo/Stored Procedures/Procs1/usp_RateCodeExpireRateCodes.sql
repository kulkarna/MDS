
/*******************************************************************************
 * usp_RateCodeDeleteRateCodes
 *
 *
 ********************************************************************************/
CREATE PROCEDURE [dbo].usp_RateCodeExpireRateCodes  
	@Utility					varchar(32),
	@LoggedInUser				 int
AS
BEGIN TRANSACTION
	
	UPDATE RATE SET ExpirationDate = GETDATE() - 1, DateModified = GETDATE(), ModifiedBy = @LoggedInUser 
	WHERE (ExpirationDate = NULL OR ExpirationDate > GETDATE() - 1 ) 
	   AND RateCodeID IN ( SELECT ID FROM RateCode  WHERE Utility = @Utility)
     
     UPDATE RATE SET EffectiveDate = ExpirationDate WHERE EffectiveDate > ExpirationDate AND @Utility = @Utility

if @@ERROR = 0 
	COMMIT                                                                                                                                       
ELSE
	ROLLBACK  
GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'RateCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RateCodeExpireRateCodes';

