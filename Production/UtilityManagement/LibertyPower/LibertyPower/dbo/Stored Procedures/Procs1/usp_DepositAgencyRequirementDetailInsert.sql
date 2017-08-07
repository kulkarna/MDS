
-- =============================================
-- Author:		Antonio Jr
-- Create date: 4/22/2009
-- Description:	Inserts a new record 
-- =============================================
CREATE PROCEDURE [dbo].[usp_DepositAgencyRequirementDetailInsert] 
	@p_DepositAgencyRequirementID INT,
	@p_lowScore INT,
	@p_highScore INT,
	@p_deposit NUMERIC (18,2),
	@p_AccountTypeGroup nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert INTO dbo.DepositAgencyRequirementDetail (LowScore, HighScore, Deposit, DepositAgencyRequirementID, AccountTypeGroup)
                                   VALUES(@p_lowScore, @p_highScore, @p_deposit, @p_DepositAgencyRequirementID, @p_AccountTypeGroup)
	RETURN @@IDENTITY
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositAgencyRequirementDetailInsert';

