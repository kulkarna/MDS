
CREATE PROCEDURE [dbo].[usp_CreditScoreCriteriaHeaderUpdate]
(
    @CreditScoreCriteriaHeaderID INT,
	@ExpirationDate DATETIME,
	@ModifiedBy VARCHAR(50)
)
AS
	SET NOCOUNT ON 
	
	update  CreditScoreCriteriaHeader
	set
		ExpirationDate = @ExpirationDate,
		ModifiedBy = @ModifiedBy
	 WHERE CreditScoreCriteriaHeaderID = @CreditScoreCriteriaHeaderID



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreCriteriaHeaderUpdate';

