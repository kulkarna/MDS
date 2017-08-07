
CREATE PROCEDURE [dbo].[usp_DepositAgencyRequirementHeaderUpdate]
(
    @DepositAgencyRequirementID INT,
	@DateExpired DATETIME,
	@ExpiredBy VARCHAR(50)
)
AS
	SET NOCOUNT ON 
	
	update  DepositAgencyRequirementHeader
	set
		DateExpired = @DateExpired,
		ExpiredBy = @ExpiredBy
	 WHERE DepositAgencyRequirementID = @DepositAgencyRequirementID



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositAgencyRequirementHeaderUpdate';

