
CREATE PROCEDURE [dbo].[usp_CreditScoreCriteriaDetailInsert]
(
	@CreditScoreCriteriaHeaderID INT,
	@AccountTypeGroup nvarchar(50),
	@LowUsage INT,
	@HighUsage INT,
	@LowRange INT,
	@HighRange INT
)
AS
	SET NOCOUNT ON 
	
	INSERT INTO  CreditScoreCriteriaDetail
	(
		CreditScoreCriteriaHeaderID,
		AccountTypeGroup,
		LowUsage,
		HighUsage,
		LowRange,
		HighRange
	 )
	 VALUES
	 (
		@CreditScoreCriteriaHeaderID,
		@AccountTypeGroup,
		@LowUsage,
		@HighUsage,
		@LowRange,
		@HighRange
	 )
	 
RETURN @@IDENTITY



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreCriteriaDetailInsert';

