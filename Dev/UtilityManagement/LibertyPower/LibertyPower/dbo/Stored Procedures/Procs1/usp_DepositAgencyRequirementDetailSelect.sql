-- ==========================================================================
-- Author:		Antonio Jr
-- Create date: April, 23, 2009
-- Description:	Gets the DepositAgencyRequirements Details by ID
-- ==========================================================================

CREATE proc [dbo].[usp_DepositAgencyRequirementDetailSelect] 
   	@p_depositAgencyRequirementID int 
	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT  DepositAgencyRequirementDetailID, LowScore, HighScore, Deposit, DepositAgencyRequirementID, AccountTypeGroup
	FROM DepositAgencyRequirementDetail
	WHERE DepositAgencyRequirementID = @p_depositAgencyRequirementID

    
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositAgencyRequirementDetailSelect';

