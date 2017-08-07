
CREATE PROCEDURE [dbo].[usp_CreditScoreCriteriaHeaderInsert]
(
	@CreditAgencyID INT,
	@EffectiveDate DATETIME,
	@CreatedBy VARCHAR(50),
	@CriteriaSetId INT
)
AS
	SET NOCOUNT ON 
	
	INSERT INTO  CreditScoreCriteriaHeader
	(
		CreditAgencyID,
		EffectiveDate,
		CreatedBy,
		CriteriaSetId
	 )
	 VALUES
	 (
		@CreditAgencyID,
		@EffectiveDate,
		@CreatedBy,
		@CriteriaSetId
	 )
	 
RETURN @@IDENTITY



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreCriteriaHeaderInsert';

